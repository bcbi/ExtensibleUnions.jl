using ExtensibleUnions
using Test

@testset "ExtensibleUnions.jl" begin
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
        @test !ExtensibleUnions.isextensibleunion(S3)
        extensibleunion!(S3)
        @test ExtensibleUnions.isextensibleunion(S3)
        extensibleunion!(S3)
        @test ExtensibleUnions.isextensibleunion(S3)
        extensibleunion!(S3)
        @test ExtensibleUnions.isextensibleunion(S3)
    end
    @testset "extensiblefunction!" begin
        struct S4
        function f1 end
        @test !ExtensibleUnions.isextensibleunion(S4)
        @test !ExtensibleUnions.isextensiblefunction(f1)
        @test_throws ArgumentError extensiblefunction!(f1, S4)
        @test !ExtensibleUnions.isextensibleunion(S4)
        @test !ExtensibleUnions.isextensiblefunction(f1)
        extensibleunion!(S4)
        @test ExtensibleUnions.isextensibleunion(S4)
        extensiblefunction!(f1, S4)
        @test ExtensibleUnions.isextensiblefunction(f1)
        extensiblefunction!(f1, S4)
        @test ExtensibleUnions.isextensiblefunction(f1)
        extensiblefunction!(f1, S4)
        @test ExtensibleUnions.isextensiblefunction(f1)
    end
    @testset "addtounion!" begin
    end
    @testset "unioncontains" begin
    end
end
