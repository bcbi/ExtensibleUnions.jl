using ExtensibleUnions
using Test

@testset "ExtensibleUnions.jl" begin
    @testset "extensibleunion!" begin
        module extensibleunion
        abstract type A end
        @test_throws ArgumentError extensibleunion!(A)
        @test_throws ArgumentError extensibleunion!(Int)
        struct B
            x
        end
        @test_throws ArgumentError extensibleunion!(B)
        mutable struct C end
        @test_throws ArgumentError extensibleunion!(C)
        end
        struct D end
        @test_throws ArgumentError extensibleunion!(D)
    end
end
