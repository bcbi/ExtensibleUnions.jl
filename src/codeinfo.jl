# function jl_method_def(argdata::Core.SimpleVector, codeinfo::Core.CodeInfo, mod::Module)
#     ccall(:jl_method_def,
#           Cvoid,
#           (Core.SimpleVector, Any, Ptr{Module}),
#           argdata,
#           codeinfo,
#           pointer_from_objref(mod))
# end
