-module(blobby_dumb_storage_test).
-include_lib("eunit/include/eunit.hrl").

-define(setup(F), {setup, fun start/0, fun stop/1, F}).

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% TESTS DESCRIPTIONS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

basic_files_test_() ->
	{"Testing with simple files first.",
	 ?setup(fun store_a_file/1)}.

%%%%%%%%%%%%%%%%%%%%%%%
%%% SETUP FUNCTIONS %%%
%%%%%%%%%%%%%%%%%%%%%%%

start() ->
	{ok, Pid} = blobby_dumb_storage:start_link(),
	Pid.

stop(_) ->
	blobby_dumb_storage:stop().

%%%%%%%%%%%%%%%%%%%%
%%% ACTUAL TESTS %%%
%%%%%%%%%%%%%%%%%%%%

store_a_file(_) ->
	Content = <<"Hello World!">>,
	ContentHash = blobby_util:content_hash(Content),
	
	Res = blobby_dumb_storage:store_blob(ContentHash, Content),
	[?_assert({ok, ContentHash} =:= Res)].

%%%%%%%%%%%%%%%%%%%%%%%%
%%% HELPER FUNCTIONS %%%
%%%%%%%%%%%%%%%%%%%%%%%%
%% nothing here yet
