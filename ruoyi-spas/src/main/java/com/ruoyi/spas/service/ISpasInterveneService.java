package com.ruoyi.spas.service;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import com.ruoyi.spas.domain.SpasInterveneTask;

public interface ISpasInterveneService
{
    List<SpasInterveneTask> selectSpasInterveneTaskList(SpasInterveneTask task);

    SpasInterveneTask selectSpasInterveneTaskById(Long interveneId);

    int insertSpasInterveneTask(SpasInterveneTask task);

    int updateSpasInterveneTask(SpasInterveneTask task);

    SpasInterveneTask createFromWarning(Long warningId, SpasInterveneTask form);

    SpasInterveneTask evaluate(Long interveneId);

    int evaluateOpenForStudents(Collection<Long> studentIds);

    /**
     * Queue open-task evaluation on the app scheduler (non-blocking).
     * Falls back to sync when the executor bean is unavailable.
     */
    void evaluateOpenForStudentsAsync(Collection<Long> studentIds);

    List<Map<String, Object>> studentTimeline(Long studentId);
}
