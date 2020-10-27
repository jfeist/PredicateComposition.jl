module PredicateComposition

"""```julia
AND(f1,f2) = (args...) -> f1(args...) && f2(args...)
```"""
AND(f1,f2) = (args...) -> f1(args...) && f2(args...)

"""```julia
OR(f1,f2) = (args...) -> f1(args...) || f2(args...)
```"""
OR(f1,f2) = (args...) -> f1(args...) || f2(args...)

"```julia
f1 ⩓ f2 = AND(f1,f2)
```"
const ⩓ = AND

"```julia
f1 ⩔ f2 = OR(f1,f2)
```"
const ⩔ = OR

export AND, OR, ⩓, ⩔

for (op,name,name2) in ((==,:ISEQUAL,:≣),
                        (<,:ISLESS,:≺),
                        (≤,:ISLESSEQ,:⪯),
                        (>,:ISGREATER,:≻),
                        (≥,:ISGREATEREQ,:⪰))
    @eval begin
        """```julia
        $($name)(f1,f2) = (args...) -> f1(args...) $($op) f2(args...)
        $($name)(f1,n::Number) = (args...) -> f1(args...) $($op) n
        ```"""
        $name(f1,f2) = (args...) -> $op(f1(args...),f2(args...))
        $name(f1,x::Number) = (args...) -> $op(f1(args...),x)

        """```julia
        f1 $($(Meta.quot(name2))) f2 = $($name)(f1,f2)
        ```"""
        const $name2 = $name
        export $name, $name2
    end
end

for (op,name) in ((max,:MAX),(min,:MIN),(+,:SUM))
    @eval begin
        """```julia
        $($name)(fs...) = (args...) -> $($op)((f(args...) for f in fs)...)
        ```"""
        $name(fs...) = (args...) -> $op((f(args...) for f in fs)...)
        export $name
    end
end

end
