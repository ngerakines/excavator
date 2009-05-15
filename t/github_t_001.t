#!/usr/local/bin/escript
%% -*- erlang -*-
%%! -pa ../excavator -pa ebin -sasl errlog_type error -boot start_sasl -noshell

main(_) ->
    etap:plan(unknown),
    case (catch start()) of
        {'EXIT', Err} ->
            io:format("# ~p~n", [Err]),
            etap:bail();
        _ ->
            etap:end_tests()
    end,
    ok.
    
start() ->
    error_logger:tty(false),
    application:start(inets),
    test_server:start_link(),

    Instrs = ex_pp:parse("t/github.ex", ["jacobvorreuter"]),
    %io:format("~p~n", [Instrs]),
    ex_engine:run(Instrs),
    
    ok.