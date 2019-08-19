module ExtensibleUnions

export extensibleunion!, extensiblefunction!, addtounion!

const extensibleunionregistry = Dict{Any, Any}()
const extensiblefunctionregistry = Dict{Any, Any}()

function extensibleunion!(@nospecialize(u))
    global extensibleunionregistry
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
    if !haskey(extensibleunionregistry, u)
        extensibleunionregistry[u] = Set{Any}()
    end
    return u
end

function isextensibleunion(@nospecialize(u))
    global extensibleunionregistry
    return haskey(extensibleunionregistry, u)
end

function extensiblefunction!(@nospecialize(f::Function), varargs...)
    return extensiblefunction(f, varargs)
end

function extensiblefunction!(@nospecialize(f::Function), @nospecialize(varargs::Tuple))
    global extensiblefunctionregistry
    if !haskey(extensiblefunctionregistry, f)
        extensiblefunctionregistry[f] = Set{Any}()
    end
    for i = 1:length(varargs)
        if isextensibleunion(varargs[i])
            push!(extensiblefunctionregistry[f], varargs[i])
        else
            throw(ArgumentError("Argument is not a registered extensible union."))
        end
    end
    return f
end

function isextensiblefunction(@nospecialize(f::Function))
    global extensiblefunctionregistry
    return haskey(extensiblefunctionregistry, f)
end

function addtounion!(@nospecialize(u), varargs...)
    return addtounion!(f, varargs)
end

function addtounion!(@nospecialize(u), @nospecialize(varargs::Tuple))
    global extensibleunionregistry
    if isextensibleunion(u)
        for i = 1:length(varargs)
            push!(extensibleunionregistry[u], varargs[i])
        end
    else
        throw(ArgumentError("First argument must be a registered extensible union."))
    end
end

function unioncontains(@nospecialize(u), @nospecialize(t))
    global extensibleunionregistry
    if isextensibleunion(u)
        return t in extensibleunionregistry[u]
    else
        throw(ArgumentError("First argument must be a registered extensible union."))
    end
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
