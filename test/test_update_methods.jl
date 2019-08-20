using ExtensibleUnions
using Test

function f1 end
ExtensibleUnions._update_all_methods_for_extensiblefunction!(f1)

b = Type{Vector{T} where T}
@test_throws MethodError ExtensibleUnions._update_single_method!(f1, b, Set())
@test_throws MethodError ExtensibleUnions._replace_types(b)
