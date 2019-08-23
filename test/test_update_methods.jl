using ExtensibleUnions
using Test

function f1 end
ExtensibleUnions._update_all_methods_for_extensiblefunction!(f1)

b = Type{Vector{T} where T}
@test_throws MethodError ExtensibleUnions._update_single_method!(f1, b, Set())
@test_throws MethodError ExtensibleUnions._replace_types(b)

@test ExtensibleUnions._replace_types(Union{}) == Union{}
@test ExtensibleUnions._replace_types(Union{}, Union{} => Union{Float32, String}) == Union{Float32, String}
@test ExtensibleUnions._replace_types(Union{Int32}) == Union{Int32}
@test ExtensibleUnions._replace_types(Union{Int32}, Int32 => Float32) == Union{Float32}
@test ExtensibleUnions._replace_types(Union{Int32, Float32}) == Union{Int32, Float32}
@test ExtensibleUnions._replace_types(Union{Int32, Float32}, Union{Int32, Float32} => Union{String, Symbol}) == Union{String, Symbol}
@test ExtensibleUnions._replace_types(Union{Int32, Float32}, Float32 => String) == Union{Int32, String}
@test ExtensibleUnions._replace_types(Union{Int32, Float32, AbstractString}) == Union{Int32, Float32, AbstractString}
@test ExtensibleUnions._replace_types(Union{Int32, Float32, AbstractString}, Float32 => Symbol) == Union{Int32, Symbol, AbstractString}
@test ExtensibleUnions._replace_types(Union{Int32, Float32, AbstractString}, Union{Int32, Float32, AbstractString} => Symbol) == Symbol
@test ExtensibleUnions._replace_types(Union{Int32, Float32, AbstractString, Symbol}) == Union{Int32, Float32, AbstractString, Symbol}
@test ExtensibleUnions._replace_types(Union{Int32, Float32, AbstractString, Symbol}, Float32 => Char) == Union{Int32, Char, AbstractString, Symbol}
@test ExtensibleUnions._replace_types(Union{Int32, Float32, AbstractString, Symbol}, Union{Int32, Float32, AbstractString, Symbol} => Union{Int32, Float32, AbstractString, Symbol, Char}) == Union{Int32, Float32, AbstractString, Symbol, Char}
