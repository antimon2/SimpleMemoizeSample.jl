module SimpleMemoizeSample

export @simplememoize

macro simplememoize(ex)
    @assert Meta.isexpr(ex, :function)
    fname = ex.args[1].args[1]
    fname_escaped = esc(fname)
    fargs = esc.(ex.args[1].args[2:end])
    fbody = esc(ex.args[2])
    _cache = gensym(Symbol(fname, "_cache"))
    quote
        const $_cache = Dict{NTuple{$(length(fargs))}, Any}()
        function $fname_escaped($(fargs...))
            get!($_cache, ($(Expr(:tuple, fargs...)))) do
                $fbody
            end
        end
    end
end

end # module
