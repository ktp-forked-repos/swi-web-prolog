/** A simple pengine */

pengine(Goal, Pid) :-
    self(Self),
    spawn(query(Goal, Pid, Self), Pid, [
        monitor(true),
        src_predicates([query/3])
    ]).
    
query(Goal, Self, Parent) :-
    call_cleanup(Goal, Det=true),
    (   var(Det)
    ->  Parent ! success(Self, Goal, true),
        receive({
            next -> fail;
            stop ->
                Parent ! stop(Self)
        })
    ;   Parent ! success(Self, Goal, false)
    ).


/** Examples

?- pengine(member(X, [a,b,c]), Pid).
    
?- flush.
    
?- $Pid ! next.
    
?- flush.
    
?- $Pid ! stop.
    
?- flush.

*/