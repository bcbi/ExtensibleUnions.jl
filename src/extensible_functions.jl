function extensiblefunction!(@nospecialize(f::Function), varargs...)
    return extensiblefunction!(f, varargs)
end

function extensiblefunction!(@nospecialize(f::Function),
                             @nospecialize(varargs::Tuple))
    global _registry_extensibleunion_to_genericfunctions
    global _registry_genericfunctions_to_extensibleunions
    if !haskey(_registry_genericfunctions_to_extensibleunions, f)
        _registry_genericfunctions_to_extensibleunions[f] = Set{Any}()
    end
    for i = 1:length(varargs)
        if isextensibleunion(varargs[i])
            push!(_registry_extensibleunion_to_genericfunctions[varargs[i]],
                  f)
            push!(_registry_genericfunctions_to_extensibleunions[f],
                  varargs[i])
        else
            throw(ArgumentError(
                "Argument is not a registered extensible union."))
        end
    end
    _update_all_methods_for_extensiblefunction!(f)
    return f
end

function isextensiblefunction(@nospecialize(f::Function))
    global _registry_genericfunctions_to_extensibleunions
    return haskey(_registry_genericfunctions_to_extensibleunions, f)
end

macro extensible(fdef)
    ext_unions = Symbol[]
    name  = fdef.args[1].args[1]
    fargs = fdef.args[1].args[2:end]
    for (i, arg) in enumerate(fargs)
        if arg isa Expr && arg.head == :(::)
            T = arg.args[end]
            if T isa Expr && T.head == :braces && length(T.args) == 1
                push!(ext_unions, T.args[1])
                fdef.args[1].args[1+i].args[end] = T.args[1]
            end
        end
    end
    fdef
    quote
        $(fdef)
        extensiblefunction!($name, $(ext_unions...))
    end |> esc
end



