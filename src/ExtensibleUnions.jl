module ExtensibleUnions

export extensibleunion!, extensiblefunction!, addtounion!

const extensibleunionregistry = Dict{Any, Any}()

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
end

# function extensiblefunction!()
# end

# function addtounion!()
# end

# function jl_method_def(argdata::Core.SimpleVector, codeinfo::Core.CodeInfo, mod::Module)
#     ccall(:jl_method_def,
#           Cvoid,
#           (Core.SimpleVector, Any, Ptr{Module}),
#           argdata,
#           codeinfo,
#           pointer_from_objref(mod))
# end

end # module
