package com.ruoyi.spas.service;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import com.ruoyi.spas.domain.SpasInterveneAction;
import com.ruoyi.spas.domain.SpasInterveneTask;

public interface ISpasInterveneService
{
    List<SpasInterveneTask> selectSpasInterveneTaskList(SpasInterveneTask task);

    SpasInterveneTask selectSpasInterveneTaskById(Long interveneId);

    /** Create task + required action pack; returns generated interveneId rows affected via task.interveneId. */
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

    Map<String, Object> classSummary(Long deptId, Long subjectId);

    Map<String, Object> batchCreateForWeak(Long deptId, Long subjectId, Long knowledgeId, String title,
        java.math.BigDecimal targetRate);

    /** Progress dashboard for one intervene task. */
    Map<String, Object> progress(Long interveneId);

    SpasInterveneAction addAction(Long interveneId, SpasInterveneAction action);

    SpasInterveneAction updateAction(SpasInterveneAction action);

    /** Quartz: mark open tasks past due_date as overdue. */
    int markOverdue();

    /**
     * Link a saved practice assignment back to an intervene task (marks practice actions done).
     */
    int linkAssignment(Long interveneId, Long assignmentId);

    /**
     * Mark select-补弱 action done after teacher picks questions for this intervene.
     */
    int linkSelect(Long interveneId, Long refId);

    /**
     * When a practice log is written, mark overlapping open intervene practice/select actions done.
     */
    int onPracticeLogged(Long studentId, Long subjectId, Collection<Long> knowledgeIds);

    /** Student/parent facing: open intervene todos (simplified). */
    List<Map<String, Object>> listOpenTodos(Long studentId);
}
