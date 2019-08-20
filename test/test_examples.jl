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
describe(RedCar())
describe(BlueCar(1))
describe(LadderTruck{Int}(2))
describe(WaterTender{Int}(3,4))

describe(x::RedColorTrait) = "The color of this object is red"
extensiblefunction!(describe, RedColorTrait)

describe(x::BlueColorTrait) = "The color of this object is blue"
extensiblefunction!(describe, BlueColorTrait)

methods(describe)
describe(RedCar())
describe(BlueCar(1))
describe(LadderTruck{Int}(2))
describe(WaterTender{Int}(3,4))

addtounion!(RedColorTrait, RedCar)

methods(describe)
describe(RedCar())
describe(BlueCar(1))
describe(LadderTruck{Int}(2))
describe(WaterTender{Int}(3,4))

addtounion!(BlueColorTrait, BlueCar)

methods(describe)
describe(RedCar())
describe(BlueCar(1))
describe(LadderTruck{Int}(2))
describe(WaterTender{Int}(3,4))

addtounion!(RedColorTrait, AbstractFireEngine)

methods(describe)
describe(RedCar())
describe(BlueCar(1))
describe(LadderTruck{Int}(2))
describe(WaterTender{Int}(3,4))
