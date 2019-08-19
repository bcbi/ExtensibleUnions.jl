using ExtensibleUnions
using Test

@testset "ExtensibleUnions.jl" begin
    @testset "extensibleunion!" begin
        abstract type A
        end
        @test_throws ArgumentError extensibleunion!(A)
        @test_throws ArgumentError extensibleunion!(Int)
        struct B
            x
        end
        @test_throws ArgumentError extensibleunion!(B)
        mutable struct C
        end
        @test_throws ArgumentError extensibleunion!(C)
        struct D
        end
        extensibleunion!(D)
        extensibleunion!(D)
        extensibleunion!(D)
    end
end
