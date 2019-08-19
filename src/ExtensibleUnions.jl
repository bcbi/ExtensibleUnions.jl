module ExtensibleUnions

export addtounion!,
       extensiblefunction!,
       extensibleunion!,
       isextensiblefunction,
       isextensibleunion,
       unioncontains

const _registry_extensibleunion_to_genericfunctions = Dict{Any, Any}()
const _registry_extensibleunion_to_members = Dict{Any, Any}()
const _registry_genericfunctions_to_extensibleunions = Dict{Any, Any}()

function __init__()
    global _registry_extensibleunion_to_genericfunctions
    global _registry_extensibleunion_to_members
    global _registry_genericfunctions_to_extensibleunions
    empty!(_registry_extensibleunion_to_genericfunctions)
    empty!(_registry_extensibleunion_to_members)
    empty!(_registry_genericfunctions_to_extensibleunions)
    return nothing
end

function extensibleunion!(@nospecialize(u))
    global _registry_extensibleunion_to_genericfunctions
    global _registry_extensibleunion_to_members
    if !isconcretetype(u)
        throw(ArgumentError("The provided type must be a concrete type"))
    end
    if !isstructtype(u)
        throw(ArgumentError("The provided type must be a struct type"))
    end
    if length(fieldnames(u)) > 0
        throw(ArgumentError("The provided type must have no fields"))
    end
    if !isimmutable(u())
        throw(ArgumentError("The provided type must be an immutable type."))
    end
    if !haskey(_registry_extensibleunion_to_members, u)
        _registry_extensibleunion_to_genericfunctions[u] = Set{Any}()
        _registry_extensibleunion_to_members[u] = Set{Any}()
    end
    _update_all_methods_for_extensibleunion!(u)
    return u
end

function isextensibleunion(@nospecialize(u))
    global _registry_extensibleunion_to_members
    return haskey(_registry_extensibleunion_to_members, u)
end

function extensiblefunction!(@nospecialize(f::Function), varargs...)
    return extensiblefunction(f, varargs)
end

function extensiblefunction!(@nospecialize(f::Function), @nospecialize(varargs::Tuple))
    global _registry_extensibleunion_to_genericfunctions
    global _registry_genericfunctions_to_extensibleunions
    if !haskey(_registry_genericfunctions_to_extensibleunions, f)
        _registry_genericfunctions_to_extensibleunions[f] = Set{Any}()
    end
    for i = 1:length(varargs)
        if isextensibleunion(varargs[i])
            push!(_registry_extensibleunion_to_genericfunctions[varargs[i]], f)
            push!(_registry_genericfunctions_to_extensibleunions[f], varargs[i])
        else
            throw(ArgumentError("Argument is not a registered extensible union."))
        end
    end
    _update_all_methods_for_extensiblefunction!(f)
    return f
end

function isextensiblefunction(@nospecialize(f::Function))
    global _registry_genericfunctions_to_extensibleunions
    return haskey(_registry_genericfunctions_to_extensibleunions, f)
end

function addtounion!(@nospecialize(u), varargs...)
    return addtounion!(u, varargs)
end

function addtounion!(@nospecialize(u), @nospecialize(varargs::Tuple))
    global _registry_extensibleunion_to_members
    if isextensibleunion(u)
        for i = 1:length(varargs)
            push!(_registry_extensibleunion_to_members[u], varargs[i])
        end
    else
        throw(ArgumentError("First argument must be a registered extensible union."))
    end
    _update_all_methods_for_extensibleunion!(u)
end

function unioncontains(@nospecialize(u), @nospecialize(t))
    global _registry_extensibleunion_to_members
    if isextensibleunion(u)
        return t in _registry_extensibleunion_to_members[u]
    else
        throw(ArgumentError("First argument must be a registered extensible union."))
    end
end

function _update_all_methods_for_extensiblefunction!(varargs...)
    return nothing
end

function _update_all_methods_for_extensibleunion!(varargs...)
    return nothing
end

# function jl_method_def(argdata::Core.SimpleVector, codeinfo::Core.CodeInfo, mod::Module)
#     ccall(:jl_method_def,
#           Cvoid,
#           (Core.SimpleVector, Any, Ptr{Module}),
#           argdata,
#           codeinfo,
#           pointer_from_objref(mod))
# end

end # module
