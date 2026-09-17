package com.ruoyi.spas.open;

/**
 * Thread-local open API auth context
 */
public final class SpasOpenContext
{
    private static final ThreadLocal<SpasOpenToken> HOLDER = new ThreadLocal<>();

    private SpasOpenContext()
    {
    }

    public static void set(SpasOpenToken token)
    {
        HOLDER.set(token);
    }

    public static SpasOpenToken get()
    {
        return HOLDER.get();
    }

    public static Long getParentId()
    {
        SpasOpenToken t = HOLDER.get();
        return t == null ? null : t.getParentId();
    }

    public static void clear()
    {
        HOLDER.remove();
    }
}
