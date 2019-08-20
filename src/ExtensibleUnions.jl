module ExtensibleUnions

export addtounion!,
       extensiblefunction!,
       extensibleunion!,
       isextensiblefunction,
       isextensibleunion

const _registry_extensibleunion_to_genericfunctions = Dict{Any, Any}()
const _registry_extensibleunion_to_members = Dict{Any, Any}()
const _registry_genericfunctions_to_extensibleunions = Dict{Any, Any}()

include("code_transformation.jl")
include("extensible_functions.jl")
include("extensible_unions.jl")
include("init.jl")
include("update_methods.jl")

end # module
