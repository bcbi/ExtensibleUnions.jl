using ExtensibleUnions
using Test

abstract type AbstractCar end
abstract type AbstractMinivan end
abstract type AbstractSUV end
abstract type AbstractFireEngine end
struct RedCar <: AbstractCar
end
struct BlueCar <: AbstractCar
    x
end
mutable struct RedMinivan <: AbstractMinivan
end
mutable struct BlueMinivan <: AbstractMinivan
    x
end
struct RedSUV{T} <: AbstractSUV
    x::T
end
struct BlueSUV{T} <: AbstractSUV
    x::T
    y::T
end
mutable struct LadderTruck{T} <: AbstractFireEngine
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
describe(x) = "I don't know what this is"
describe(RedCar())
describe(BlueCar(1))
describe(LadderTruck{Int}(1))
describe(x::RedColorTrait) = "The color of this object is red"


extensiblefunction!(describe, RedColorTrait)


describe(x::BlueColorTrait) = "The color of this object is blue"
extensiblefunction!(describe, BlueColorTrait)
describe(RedCar())
describe(BlueCar(1))
describe(LadderTruck{Int}(2))
addtounion!(RedColorTrait, RedCar)
describe(RedCar())
describe(BlueCar(1))
describe(LadderTruck{Int}(2))
addtounion!(RedColorTrait, AbstractFireEngine)
describe(RedCar())
describe(BlueCar(1))
describe(LadderTruck{Int}(2))
