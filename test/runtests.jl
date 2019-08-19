using ExtensibleUnions
using Test

@testset "jl" begin
    @testset "extensibleunion!" begin
        abstract type A1 end
        @test_throws ArgumentError extensibleunion!(A1)
        @test_throws ArgumentError extensibleunion!(Int)
        struct S1
            x
        end
        @test_throws ArgumentError extensibleunion!(S1)
        mutable struct S2 end
        @test_throws ArgumentError extensibleunion!(S2)
        abstract type A2 end
        struct S3 <: A2
        end
        @test_throws ArgumentError extensibleunion!(S3)
        struct S4 end
        @test !isextensibleunion(S4)
        extensibleunion!(S4)
        @test isextensibleunion(S4)
        extensibleunion!(S4)
        @test isextensibleunion(S4)
        extensibleunion!(S4)
        @test isextensibleunion(S4)
    end
    @testset "extensiblefunction!" begin
        struct S5 end
        function f1 end
        @test !isextensibleunion(S5)
        @test !isextensiblefunction(f1)
        @test_throws ArgumentError extensiblefunction!(f1, S5)
        @test !isextensibleunion(S5)
        @test !isextensiblefunction(f1)
        extensibleunion!(S5)
        @test isextensibleunion(S5)
        extensiblefunction!(f1, S5)
        @test isextensiblefunction(f1)
        extensiblefunction!(f1, S5)
        @test isextensiblefunction(f1)
        extensiblefunction!(f1, S5)
        @test isextensiblefunction(f1)
    end
    @testset "addtounion!" begin
        struct S6 end
        extensibleunion!(S6)
        @test !unioncontains(S6, String)
        addtounion!(S6, String)
        @test unioncontains(S6, String)
    end
    @testset "unioncontains" begin
        struct S7 end
        extensibleunion!(S7)
        @test !unioncontains(S7, String)
        addtounion!(S7, String)
        @test unioncontains(S7, String)
    end
end
