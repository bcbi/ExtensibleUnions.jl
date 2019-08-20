using ExtensibleUnions
using Test

@testset "ExtensibleUnions.jl" begin
    @testset "Unit tests" begin
        @testset "test_code_transformation.jl" begin
            include("test_code_transformation.jl")
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
    @testset "Integration tests" begin
        @testset "test_examples.jl" begin
            include("test_examples.jl")
        end
    end
end
