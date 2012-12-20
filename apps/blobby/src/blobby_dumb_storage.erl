-module(blobby_dumb_storage).

-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([start_link/0, init_storage/1, get_blob/1, store_blob/2, remove_blob/1]).

%%

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init_storage(Options) ->
	gen_server:call(?MODULE, {init, Options}).

get_blob(Id) ->
	gen_server:call(?MODULE, {get, Id}).

store_blob(Id, Func) ->
	gen_server:call(?MODULE, {store, Id, Func}).

remove_blob(Id) ->
	gen_server:call(?MODULE, {remove, Id}).

%%

init(Args) ->
	{ok, Args}.

handle_call({init, Options}, _From, State) ->
	io:format("Initialising the dumb storage with options: ~p~n", [Options]),
	{reply, ok, State};
handle_call({get, Id}, _From, State) ->
	io:format("getting the blob with id: ~p~n", [Id]),
	{reply, ok, State};
handle_call({store, Id, Func}, _From, State) ->
	io:format("Storing the blob with id: ~p and func: ~p~n", [Id, Func]),
	{reply, ok, State};
handle_call({remove, Id}, _From, State) ->
	io:format("Removing the blob with id: ~p~n", [Id]),
	{reply, ok, State}.

handle_cast(_Request, State) ->
	{noreply, State}.

handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.
