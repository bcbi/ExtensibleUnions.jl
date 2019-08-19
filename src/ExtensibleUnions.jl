module ExtensibleUnions

export addtounion!,
       extensiblefunction!,
       extensibleunion!,
       isextensiblefunction,
       isextensibleunion,
       unioncontains

const _registry_extensibleunion_to_genericfunctions = Dict{Any, Any}()
const _registry_extensibleunion_to_members = Dict{Any, Any}()
const _registry_genericfunctions_to_extensibleunions = Dict{Any, Any}()

function __init__()
    global _registry_extensibleunion_to_genericfunctions
    global _registry_extensibleunion_to_members
    global _registry_genericfunctions_to_extensibleunions
    empty!(_registry_extensibleunion_to_genericfunctions)
    empty!(_registry_extensibleunion_to_members)
    empty!(_registry_genericfunctions_to_extensibleunions)
    return nothing
end

end # module
