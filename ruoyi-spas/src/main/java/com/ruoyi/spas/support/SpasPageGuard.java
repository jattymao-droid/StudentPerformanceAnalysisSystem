package com.ruoyi.spas.support;

import java.util.function.Supplier;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;

/**
 * Run a lookup without consuming the current PageHelper ThreadLocal,
 * then restore pagination for the real list query.
 */
public final class SpasPageGuard
{
    private SpasPageGuard()
    {
    }

    public static <T> T withoutPage(Supplier<T> action)
    {
        Page<?> local = PageHelper.getLocalPage();
        PageHelper.clearPage();
        try
        {
            return action.get();
        }
        finally
        {
            if (local != null)
            {
                Page<?> restored = PageHelper.startPage(local.getPageNum(), local.getPageSize(), local.isCount());
                if (local.getReasonable() != null)
                {
                    restored.setReasonable(local.getReasonable());
                }
                if (local.getOrderBy() != null && !local.getOrderBy().isEmpty())
                {
                    restored.setOrderBy(local.getOrderBy());
                }
            }
        }
    }
}
