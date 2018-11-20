# Common functions
#

# TODO: add more case
const KNLONG = Clonglong


"A macro to make calling KNITRO's KN_* C API a little cleaner"
macro kn_ccall(func, args...)
    f = Base.Meta.quot(Symbol("KN_$(func)"))
    args = [esc(a) for a in args]
    quote
        ccall(($f, libknitro), $(args...))
    end
end

"Check if return value is valid."
function _checkraise(ret::Cint)
    if ret != 0
        error("Fail to use specified function: $ret")
    end
end

"Return the current KNITRO version."
function get_release()
    len = 15
    out = zeros(Cchar,len)

    @kn_ccall(get_release, Cvoid, (Cint, Ptr{Cchar}), len, out)
    return String(strip(String(convert(Vector{UInt8},out)),'\0'))
end
