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
        struct S3 end
        @test !isextensibleunion(S3)
        extensibleunion!(S3)
        @test isextensibleunion(S3)
        extensibleunion!(S3)
        @test isextensibleunion(S3)
        extensibleunion!(S3)
        @test isextensibleunion(S3)
    end
    @testset "extensiblefunction!" begin
        struct S4 end
        function f1 end
        @test !isextensibleunion(S4)
        @test !isextensiblefunction(f1)
        @test_throws ArgumentError extensiblefunction!(f1, S4)
        @test !isextensibleunion(S4)
        @test !isextensiblefunction(f1)
        extensibleunion!(S4)
        @test isextensibleunion(S4)
        extensiblefunction!(f1, S4)
        @test isextensiblefunction(f1)
        extensiblefunction!(f1, S4)
        @test isextensiblefunction(f1)
        extensiblefunction!(f1, S4)
        @test isextensiblefunction(f1)
    end
    @testset "addtounion!" begin
        struct S5 end
        extensibleunion!(S5)
        @test !unioncontains(S5, String)
        addtounion!(S5, String)
        @test unioncontains(S5, String)
    end
    @testset "unioncontains" begin
        struct S6 end
        extensibleunion!(S6)
        @test !unioncontains(S6, String)
        addtounion!(S6, String)
        @test unioncontains(S6, String)
    end
end
