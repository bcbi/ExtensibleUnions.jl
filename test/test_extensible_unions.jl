using ExtensibleUnions
using Test

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

struct S4 <: ExtensibleUnion end
@test !isextensibleunion(S4)
extensibleunion!(S4)
@test isextensibleunion(S4)
extensibleunion!(S4)
@test isextensibleunion(S4)
extensibleunion!(S4)
@test isextensibleunion(S4)

@ExtensibleUnion S6
@test !ExtensibleUnions.unioncurrentlycontains(S6, String)
addtounion!(S6, String)
@test ExtensibleUnions.unioncurrentlycontains(S6, String)

@ExtensibleUnion S7
@test !ExtensibleUnions.unioncurrentlycontains(S7, String)
addtounion!(S7, String)
@test ExtensibleUnions.unioncurrentlycontains(S7, String)

struct S8 end
@test_throws ArgumentError addtounion!(S8)
@test_throws ArgumentError ExtensibleUnions.unioncurrentlycontains(S8, String)

let
    @ExtensibleUnion S9
    
    struct S10 end
    addtounion!(S9, S10)

    foo(x::Tuple{Int, T}) where {T} = x[1]

    @extensible foo(::S9) = "boo!" with S9

    @test foo(S10())  == "boo!"
    @test members(S9) == [S10]
    @test repr(S9)   == "Extensible Union S9 with members: S10."
end

let
    a = Vector{T} where T
    ExtensibleUnions._replace_types(a)
    ExtensibleUnions._replace_types(a.var)
    ExtensibleUnions._replace_types(a, nothing => nothing)
    ExtensibleUnions._replace_types(a.var, nothing => nothing)
end
