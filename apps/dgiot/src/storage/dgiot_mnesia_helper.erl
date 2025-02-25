%%--------------------------------------------------------------------
%% Copyright (c) 2020-2021 DGIOT Technologies Co., Ltd. All Rights Reserved.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%--------------------------------------------------------------------

-module(dgiot_mnesia_helper).

-behaviour(gen_server).

-include("dgiot.hrl").
-include("logger.hrl").
-include("types.hrl").

-logger_header("[Router Helper]").

%% Mnesia bootstrap
-export([mnesia/1]).

-boot_mnesia({mnesia, [boot]}).
-copy_mnesia({mnesia, [copy]}).

%% API
-export([ start_link/0
        , monitor/1
        ]).

%% Internal export
-export([stats_fun/0]).

%% gen_server callbacks
-export([ init/1
        , handle_call/3
        , handle_cast/2
        , handle_info/2
        , terminate/2
        , code_change/3
        ]).

-record(mnesia_node, {name, const = unused}).

-define(MNESIA, dgiot_mnesia).
-define(MNESIA_NODE, dgiot_mnesia_node).
-define(LOCK, {?MODULE, cleanup_mnesia}).

-dialyzer({nowarn_function, [cleanup_routes/1]}).

%%--------------------------------------------------------------------
%% Mnesia bootstrap
%%--------------------------------------------------------------------

mnesia(boot) ->
    ok = ekka_mnesia:create_table(?MNESIA_NODE, [
                {type, set},
                {ram_copies, [node()]},
                {record_name, mnesia_node},
                {attributes, record_info(fields, mnesia_node)},
                {storage_properties, [{ets, [{read_concurrency, true}]}]}]);

mnesia(copy) ->
    ok = ekka_mnesia:copy_table(?MNESIA_NODE, ram_copies).

%%--------------------------------------------------------------------
%% API
%%--------------------------------------------------------------------

%% @doc Starts the router helper
-spec(start_link() -> startlink_ret()).
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% @doc Monitor routing node
-spec(monitor(node() | {binary(), node()}) -> ok).
monitor({_Group, Node}) ->
    monitor(Node);
monitor(Node) when is_atom(Node) ->
    case ekka:is_member(Node)
         orelse ets:member(?MNESIA_NODE, Node) of
        true  -> ok;
        false -> mnesia:dirty_write(?MNESIA_NODE, #mnesia_node{name = Node})
    end.

%%--------------------------------------------------------------------
%% gen_server callbacks
%%--------------------------------------------------------------------

init([]) ->
    ok = ekka:monitor(membership),
    {ok, _} = mnesia:subscribe({table, ?MNESIA_NODE, simple}),
    Nodes = lists:foldl(
              fun(Node, Acc) ->
                  case ekka:is_member(Node) of
                      true  -> Acc;
                      false -> true = erlang:monitor_node(Node, true),
                               [Node | Acc]
                  end
              end, [], mnesia:dirty_all_keys(?MNESIA_NODE)),
    ok = dgiot_stats:update_interval(mnesia_stats, fun ?MODULE:stats_fun/0),
    {ok, #{nodes => Nodes}, hibernate}.

handle_call(Req, _From, State) ->
    ?LOG(error, "Unexpected call: ~p", [Req]),
    {reply, ignored, State}.

handle_cast(Msg, State) ->
    ?LOG(error, "Unexpected cast: ~p", [Msg]),
    {noreply, State}.

handle_info({mnesia_table_event, {write, {?MNESIA_NODE, Node, _}, _}},
            State = #{nodes := Nodes}) ->
    case ekka:is_member(Node) orelse lists:member(Node, Nodes) of
        true -> {noreply, State};
        false ->
            true = erlang:monitor_node(Node, true),
            {noreply, State#{nodes := [Node | Nodes]}}
    end;

handle_info({mnesia_table_event, {delete, {?MNESIA_NODE, _Node}, _}}, State) ->
    %% ignore
    {noreply, State};

handle_info({mnesia_table_event, Event}, State) ->
    ?LOG(error, "Unexpected mnesia_table_event: ~p", [Event]),
    {noreply, State};

handle_info({nodedown, Node}, State = #{nodes := Nodes}) ->
    global:trans({?LOCK, self()},
                 fun() ->
                     mnesia:transaction(fun cleanup_routes/1, [Node])
                 end),
    ok = mnesia:dirty_delete(?MNESIA_NODE, Node),
    {noreply, State#{nodes := lists:delete(Node, Nodes)}, hibernate};

handle_info({membership, {mnesia, down, Node}}, State) ->
    handle_info({nodedown, Node}, State);

handle_info({membership, _Event}, State) ->
    {noreply, State};

handle_info(Info, State) ->
    ?LOG(error, "Unexpected info: ~p", [Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok = ekka:unmonitor(membership),
    dgiot_stats:cancel_update(mnesia_stats),
    mnesia:unsubscribe({table, ?MNESIA_NODE, simple}).

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%% Internal functions
%%--------------------------------------------------------------------

stats_fun() ->
    case ets:info(?MNESIA, size) of
        undefined -> ok;
        Size ->
            dgiot_stats:setstat('(mnesia.count', '(mnesia.max', Size)
    end.

cleanup_routes(Node) ->
    Patterns = [#mnesia{_ = '_', value  = Node},
                #mnesia{_ = '_', value = {'_', Node}}],
    [mnesia:delete_object(?MNESIA, Mnesia, write)
     || Pat <- Patterns, Mnesia <- mnesia:match_object(?MNESIA, Pat, write)].

