package com.ruoyi.spas.config;

import java.util.LinkedHashMap;
import java.util.Map;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * Analysis tuning (spas.analysis allocation / relative-weak / subject-overrides).
 */
@Component
@ConfigurationProperties(prefix = "spas.analysis")
public class SpasAnalysisTuningProperties
{
    /**
     * proportional = weight share (default);
     * primary-full = primary KP gets full rate contribution, secondary only counts exposure.
     */
    private String allocationMode = "proportional";

    private RelativeWeak relativeWeak = new RelativeWeak();

    /** Key = subjectCode (e.g. MATH). */
    private Map<String, ThresholdOverride> subjectOverrides = new LinkedHashMap<String, ThresholdOverride>();

    public String getAllocationMode()
    {
        return allocationMode;
    }

    public void setAllocationMode(String allocationMode)
    {
        this.allocationMode = allocationMode;
    }

    public boolean isPrimaryFullMode()
    {
        return allocationMode != null && "primary-full".equalsIgnoreCase(allocationMode.trim());
    }

    public RelativeWeak getRelativeWeak()
    {
        return relativeWeak;
    }

    public void setRelativeWeak(RelativeWeak relativeWeak)
    {
        this.relativeWeak = relativeWeak == null ? new RelativeWeak() : relativeWeak;
    }

    public Map<String, ThresholdOverride> getSubjectOverrides()
    {
        return subjectOverrides;
    }

    public void setSubjectOverrides(Map<String, ThresholdOverride> subjectOverrides)
    {
        this.subjectOverrides = subjectOverrides == null
            ? new LinkedHashMap<String, ThresholdOverride>() : subjectOverrides;
    }

    public ThresholdOverride overrideFor(String subjectCode)
    {
        if (subjectCode == null || subjectOverrides == null || subjectOverrides.isEmpty())
        {
            return null;
        }
        ThresholdOverride o = subjectOverrides.get(subjectCode);
        if (o != null)
        {
            return o;
        }
        for (Map.Entry<String, ThresholdOverride> e : subjectOverrides.entrySet())
        {
            if (e.getKey() != null && e.getKey().equalsIgnoreCase(subjectCode))
            {
                return e.getValue();
            }
        }
        return null;
    }

    public static class RelativeWeak
    {
        private boolean enabled = true;
        /** Flag relativeWeak when gap &lt; -delta (rate points, e.g. 0.10 = 10%). */
        private double delta = 0.10;

        public boolean isEnabled()
        {
            return enabled;
        }

        public void setEnabled(boolean enabled)
        {
            this.enabled = enabled;
        }

        public double getDelta()
        {
            return delta;
        }

        public void setDelta(double delta)
        {
            this.delta = delta;
        }
    }

    public static class ThresholdOverride
    {
        private Double watch;
        private Double weak;
        private Double severe;
        private Integer minAttempts;
        private Integer severeMinAttempts;

        public Double getWatch()
        {
            return watch;
        }

        public void setWatch(Double watch)
        {
            this.watch = watch;
        }

        public Double getWeak()
        {
            return weak;
        }

        public void setWeak(Double weak)
        {
            this.weak = weak;
        }

        public Double getSevere()
        {
            return severe;
        }

        public void setSevere(Double severe)
        {
            this.severe = severe;
        }

        public Integer getMinAttempts()
        {
            return minAttempts;
        }

        public void setMinAttempts(Integer minAttempts)
        {
            this.minAttempts = minAttempts;
        }

        public Integer getSevereMinAttempts()
        {
            return severeMinAttempts;
        }

        public void setSevereMinAttempts(Integer severeMinAttempts)
        {
            this.severeMinAttempts = severeMinAttempts;
        }
    }
}
