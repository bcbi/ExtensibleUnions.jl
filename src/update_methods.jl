function _update_all_methods_for_extensibleunion!(@nospecialize(u),
                                                  p::Pair=nothing=>nothing)
    global _registry_extensibleunion_to_genericfunctions
    for f in _registry_extensibleunion_to_genericfunctions[u]
        _update_all_methods_for_extensiblefunction!(f, p)
    end
    return u
end

function _update_all_methods_for_extensiblefunction!(@nospecialize(f),
                                                     p::Pair=nothing=>nothing)
    global _registry_genericfunctions_to_extensibleunions
    extensibleunions_for_this_genericfunction =
        _registry_genericfunctions_to_extensibleunions[f]
    for met in methods(f).ms
        _update_single_method!(f,
                               met.sig,
                               extensibleunions_for_this_genericfunction,
                               p)
    end
    return f
end

function _update_single_method!(@nospecialize(f::Function),
                                @nospecialize(oldsig::Type{<:Tuple}),
                                @nospecialize(unions::Set),
                                p::Pair=nothing=>nothing)
    global _registry_extensibleunion_to_members
    newsig = _replace_types(oldsig, p)
    for u in unions
        newsig = _replace_types(newsig, u =>
            _set_to_union(_registry_extensibleunion_to_members[u]))
    end
    if oldsig == newsig
    else
        oldsig_tuple = tuple(oldsig.types[2:end]...)
        newsig_tuple = tuple(newsig.types[2:end]...)
        @assert length(code_lowered(f, oldsig_tuple)) == 1
        codeinfo = code_lowered(f, oldsig_tuple)[1]
        @assert length(methods(f, oldsig_tuple).ms) == 1
        oldmet = methods(f, oldsig_tuple).ms[1]
        Base.delete_method(oldmet)
        addmethod!(f, newsig_tuple, codeinfo)
    end
    return f
end

function _update_single_method!(@nospecialize(f::Function),
                                @nospecialize(oldsig::Type{<:UnionAll}),
                                @nospecialize(unions::Set),
                                p::Pair=nothing=>nothing)
    throw(MethodError("Not yet defined when sig is a UnionAll"))
end

function _replace_types(sig::Type{<:UnionAll}, p::Pair=nothing=>nothing)
    throw(MethodError("Not yet defined when sig is a UnionAll"))
end

# function _replace_types(sig::Core.SimpleVector, p::Pair=nothing=>nothing)
#     v = Any[sig.types...]
#     for i = 2:length(v)
#         v[i] = _replace_types(v[i], p)
#     end
#     return Core.svec(v...)
# end

function _replace_types(sig::Type{<:Tuple}, p::Pair=nothing=>nothing)
    v = Any[sig.types...]
    for i = 2:length(v)
        v[i] = _replace_types(v[i], p)
    end
    return Tuple{v...}
end

function _replace_types(sig::Type, p::Pair=nothing=>nothing)
    if sig == p[1]
        return p[2]
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
