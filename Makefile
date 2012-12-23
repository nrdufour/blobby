
all: deps compile
	@echo "done!"

deps:
	@rebar get-deps

compile:
	@rebar compile

clean:
	@rebar clean

rel: all
	@rebar generate

test: all
	@(cd apps/blobby; rebar eunit)
