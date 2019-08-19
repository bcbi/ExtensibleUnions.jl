using ExtensibleUnions
using Test

@testset "ExtensibleUnions.jl" begin
    @testset "test_codeinfo.jl" begin
        include("test_codeinfo.jl")
    end
    @testset "test_extensible_functions.jl" begin
        include("test_extensible_functions.jl")
    end
    @testset "test_extensible_unions.jl" begin
        include("test_extensible_unions.jl")
    end
    @testset "test_update_methods.jl" begin
        include("test_update_methods.jl")
    end
end
