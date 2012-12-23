-module(blobby_dumb_storage).

-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([start_link/0, stop/0, init_storage/1, get_blob/1, store_blob/2, remove_blob/1, list_blobs/0]).

%%

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
	gen_server:call(?MODULE, {stop}).

init_storage(Options) ->
	gen_server:call(?MODULE, {init, Options}).

get_blob(Id) ->
	gen_server:call(?MODULE, {get, Id}).

store_blob(Id, Bin) when is_binary(Bin) ->
	gen_server:call(?MODULE, {store_binary, Id, Bin});
store_blob(Id, Func) ->
	gen_server:call(?MODULE, {store_stream, Id, Func}).

remove_blob(Id) ->
	gen_server:call(?MODULE, {remove, Id}).

list_blobs() ->
	[].

%%

init(Args) ->
	case file:make_dir("/tmp/blobby_dumb_storage") of
		ok ->
			ok;
		{error, eexist} ->
			%% TODO add here something to scan the directory
			ok;
		Error ->
			throw({error, cant_init_dumb_storage, Error})
	end,

	{ok, Args}.

handle_call({stop}, _From, State) ->
	{stop, normal, ok, State};
handle_call({init, Options}, _From, State) ->
	io:format("Initialising the dumb storage with options: ~p~n", [Options]),
	{reply, ok, State};
handle_call({get, Id}, _From, State) ->
	io:format("getting the blob with id: ~p~n", [Id]),
	{reply, ok, State};
handle_call({store_binary, Id, Bin}, _From, State) ->
	io:format("Storing the blob with id: ~p and Bin: ~p~n", [Id, Bin]),
	{reply, {ok, Id}, State};
handle_call({store_stream, Id, Func}, _From, State) ->
	io:format("Storing the blob with id: ~p and func: ~p~n", [Id, Func]),
	{reply, {ok, Id}, State};
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
