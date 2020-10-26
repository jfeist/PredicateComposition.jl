module PredicateComposition

AND(f1,f2) = (args...) -> f1(args...) && f2(args...)
OR(f1,f2) = (args...) -> f1(args...) || f2(args...)
const ⩓ = AND
const ⩔ = OR

export AND, OR, ⩓, ⩔

for (op,name,name2) in ((==,:ISEQUAL,:≣),
                        (<,:ISLESS,:≺),
                        (≤,:ISLESSEQ,:⪯),
                        (>,:ISGREATER,:≻),
                        (≥,:ISGREATEREQ,:⪰))
    @eval $name(f1,f2) = (args...) -> $op(f1(args...),f2(args...))
    @eval $name(f1,x::Number) = (args...) -> $op(f1(args...),x)
    @eval const $name2 = $name
    @eval export $name, $name2
end

for (op,name) in ((max,:MAX),(min,:MIN),(+,:SUM))
    @eval $name(fs...) = (args...) -> $op((f(args...) for f in fs)...)
    @eval export $name
end

end
