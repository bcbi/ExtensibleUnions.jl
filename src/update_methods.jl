function _update_all_methods_for_extensibleunion!(@nospecialize(u),
                                                  p::Pair=nothing=>nothing)
    global _registry_extensibleunion_to_genericfunctions
    for f in _registry_extensibleunion_to_genericfunctions[u]
        _update_all_methods_for_extensiblefunction(f, p)
    end
    return u
end

function _update_all_methods_for_extensiblefunction!(@nospecialize(f),
                                                     p::Pair=nothing=>nothing)
    global _registry_genericfunctions_to_extensibleunions
    extensibleunions_for_this_genericfunction =
        _registry_genericfunctions_to_extensibleunions[f]
    for met in methods(f).ms
        _update_single_method!(met,
                               met.sig,
                               extensibleunions_for_this_genericfunction,
                               p)
    end
    return f
end

function _update_single_method!(@nospecialize(met::Method),
                                @nospecialize(oldsig::Type{<:Tuple}),
                                @nospecialize(unions::Set),
                                p::Pair=nothing=>nothing)
    global _registry_extensibleunion_to_members
    for u in unions
        _update_single_method!(met,
                               oldsig,
                               p,
                               u=>_set_to_union(
                                   _registry_extensibleunion_to_members[u]))
    end
    return met
end

function _update_single_method!(@nospecialize(met::Method),
                                @nospecialize(oldsig::Type{<:Tuple}),
                                p_x::Pair=nothing=>nothing,
                                p_y::Pair=nothing=>nothing)
    new_sig = _replace_types(oldsig, p_x, p_y)
    return met
end

# using ExtensibleUnions
# foo(x::Float64) = "float 64"
# ci = code_lowered(foo, (Float64,))[1]
# met = methods(foo, (Float64,)).ms[1]
# Base.delete_method(met)
# ExtensibleUnions.CodeTransformation.addmethod!(foo, (String,), ci)

function _update_single_method!(@nospecialize(met::Method),
                                @nospecialize(oldsig::Type{<:UnionAll}),
                                @nospecialize(unions::Set),
                                p::Pair=nothing=>nothing)
    throw(MethodError("Not yet defined when sig is a UnionAll"))
end

function _replace_types(sig::Type{<:UnionAll},
                        p_x::Pair=nothing=>nothing,
                        p_y::Pair=nothing=>nothing)
    throw(MethodError("Not yet defined when sig is a UnionAll"))
end

function _replace_types(sig::Type{<:Tuple},
                        p_x::Pair=nothing=>nothing,
                        p_y::Pair=nothing=>nothing)
    a = [sig.types...]
    for i = 2:length(a)
        a[i] = _replace_types(a[i], p_x, p_y)
    end
    return Core.svec(a...)
end

function _replace_types(sig::Type,
                        p_x::Pair=nothing=>nothing,
                        p_y::Pair=nothing=>nothing)
    if sig == p_x[1]
        return p_x[2]
    elseif sig == p_y[1]
        return p_y[2]
    else
        return sig
    end
end

function _set_to_union(s::Set)
    result = Union{}
    for member in s
        result = Union{result, member}
    end
    return result
end
