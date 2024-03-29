-module(blobby_dumb_storage_test).
-include_lib("eunit/include/eunit.hrl").

-define(setup(F), {setup, fun start/0, fun stop/1, F}).

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% TESTS DESCRIPTIONS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

basic_files_test_() ->
	[{"Testing with simple files first.",
	 ?setup(fun store_and_retrieve_a_file/1)},
	 {"Listing a bunch of blobs",
	 ?setup(fun listing_blobs/1)}].

%%%%%%%%%%%%%%%%%%%%%%%
%%% SETUP FUNCTIONS %%%
%%%%%%%%%%%%%%%%%%%%%%%

start() ->
	{ok, Pid} = blobby_dumb_storage:start_link(),
	blobby_dumb_storage:init_storage(),
	Pid.

stop(_) ->
	blobby_dumb_storage:stop().

%%%%%%%%%%%%%%%%%%%%
%%% ACTUAL TESTS %%%
%%%%%%%%%%%%%%%%%%%%

store_and_retrieve_a_file(_) ->
	Content = <<"Hello World!">>,
	ContentHash = blobby_util:content_hash(Content),
	
	Res = blobby_dumb_storage:store_blob(ContentHash, Content),
	
	Res2 = blobby_dumb_storage:get_blob(ContentHash),
	
	[?_assert({ok, ContentHash} =:= Res),
	 ?_assert({ok, Content} =:= Res2)].

listing_blobs(_) ->
	blobby_dumb_storage:store_blob("123", <<"Hello World!">>),
	blobby_dumb_storage:store_blob("456", <<"Hello Foo!">>),
	blobby_dumb_storage:store_blob("789", <<"Hello Bar!">>),
	
	ListingFunc = fun(X, Acc) ->
		[X | Acc]
	end,
	
	Res = blobby_dumb_storage:fold_blobs(ListingFunc, []),
	
	[?_assert(Res =:= ["123", "456", "789"])].

%%%%%%%%%%%%%%%%%%%%%%%%
%%% HELPER FUNCTIONS %%%
%%%%%%%%%%%%%%%%%%%%%%%%
%% nothing here yet
