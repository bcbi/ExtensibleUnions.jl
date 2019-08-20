using ExtensibleUnions
using Test

abstract type AbstractCar end
abstract type AbstractFireEngine end

struct RedCar <: AbstractCar
end
struct BlueCar <: AbstractCar
    x
end

struct LadderTruck{T} <: AbstractFireEngine
    x::T
end
mutable struct WaterTender{T} <: AbstractFireEngine
    x::T
    y::T
end

struct RedColorTrait end
struct BlueColorTrait end

extensibleunion!(RedColorTrait)
extensibleunion!(BlueColorTrait)

describe(x) = "I don't know anything about this object"

methods(describe)
@test length(methods(describe)) == 1
@test describe(RedCar()) == "I don't know anything about this object"
@test describe(BlueCar(1)) == "I don't know anything about this object"
@test describe(LadderTruck{Int}(2)) == "I don't know anything about this object"
@test describe(WaterTender{Int}(3,4)) == "I don't know anything about this object"

describe(x::RedColorTrait) = "The color of this object is red"
extensiblefunction!(describe, RedColorTrait)
@test length(methods(describe)) == 2

describe(x::BlueColorTrait) = "The color of this object is blue"
extensiblefunction!(describe, BlueColorTrait)
@test length(methods(describe)) == 3

methods(describe)
@test length(methods(describe)) == 3
@test describe(RedCar()) == "I don't know anything about this object"
@test describe(BlueCar(1)) == "I don't know anything about this object"
@test describe(LadderTruck{Int}(2)) == "I don't know anything about this object"
@test describe(WaterTender{Int}(3,4)) == "I don't know anything about this object"

addtounion!(RedColorTrait, RedCar)

methods(describe)
@test length(methods(describe)) == 3
@test describe(RedCar()) == "The color of this object is red"
@test describe(BlueCar(1)) == "I don't know anything about this object"
@test describe(LadderTruck{Int}(2)) == "I don't know anything about this object"
@test describe(WaterTender{Int}(3,4)) == "I don't know anything about this object"

addtounion!(BlueColorTrait, BlueCar)

methods(describe)
@test length(methods(describe)) == 3
@test describe(RedCar()) == "The color of this object is red"
@test describe(BlueCar(1)) == "The color of this object is blue"
@test describe(LadderTruck{Int}(2)) == "I don't know anything about this object"
@test describe(WaterTender{Int}(3,4)) == "I don't know anything about this object"

addtounion!(RedColorTrait, AbstractFireEngine)

methods(describe)
@test length(methods(describe)) == 3
@test describe(RedCar()) == "The color of this object is red"
@test describe(BlueCar(1)) == "The color of this object is blue"
@test describe(LadderTruck{Int}(2)) == "The color of this object is red"
@test describe(WaterTender{Int}(3,4)) == "The color of this object is red"
