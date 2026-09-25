package com.ruoyi.spas.warning;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.Test;

/**
 * Channel string parsing contract used by WarningEngine.dispatchNotice.
 */
class WarningNotifyChannelTest
{
    static boolean wantsSystem(String channels)
    {
        return channels != null && channels.contains("system");
    }

    static boolean wantsWebhook(String channels)
    {
        return channels != null && channels.contains("webhook");
    }

    @Test
    void parsesCommaSeparatedChannels()
    {
        assertTrue(wantsSystem("system"));
        assertTrue(wantsSystem("system,webhook"));
        assertTrue(wantsWebhook("system,webhook"));
        assertTrue(wantsWebhook("webhook"));
        assertFalse(wantsWebhook("system"));
        assertFalse(wantsSystem(""));
        assertFalse(wantsWebhook(null));
    }
}
