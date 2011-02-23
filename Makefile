all:
	rebar get-deps && rebar compile
	erl -pa ebin -noinput +B -eval 'case make:all() of up_to_date -> halt(0); error -> halt(1) end.'

clean:
	rebar clean

build_plt: all
	rebar skip_deps=true build-plt

analyze: all
	dialyzer --plt ~/.itweet_dialyzer_plt -Wunmatched_returns -Werror_handling -Wbehaviours ebin

update-deps:
	rebar update-deps

doc: all
	rebar skip_deps=true doc

xref: all
	rebar skip_deps=true xref
	
run: all
	if [ -f `hostname`.config ]; then\
		erl  +Bc +K true +W w -smp enable -config `hostname` -name elog -boot start_sasl -pa deps/riak_err/ebin -pa ebin -s crypto -s inets -s elog;\
	else\
		erl  +Bc +K true +W w -smp enable -name elog -boot start_sasl -pa deps/riak_err/ebin -pa ebin -s crypto -s inets -s elog;\
	fi

shell: all
	if [ -f `hostname`.config ]; then\
		erl  +Bc +K true +W w -smp enable -config `hostname` -name elog -boot start_sasl -pa deps/riak_err/ebin -pa ebin -s crypto -s inets;\
	else\
		erl  +Bc +K true +W w -smp enable -name elog -boot start_sasl -pa deps/riak_err/ebin -pa ebin -s crypto -s inets;\
	fi

test: all
	erl -noshell -noinput +Bc +K true -smp enable -name elog -pa ebin -s crypto -s inets -s elog -run elog_tester main
