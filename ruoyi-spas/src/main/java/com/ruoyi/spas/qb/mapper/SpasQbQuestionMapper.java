package com.ruoyi.spas.qb.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.spas.qb.domain.SpasQbQuestion;
import com.ruoyi.spas.qb.domain.SpasQbQuestionKnowledge;

/**
 * Bank question mapper
 */
public interface SpasQbQuestionMapper
{
    List<SpasQbQuestion> selectSpasQbQuestionList(SpasQbQuestion query);

    SpasQbQuestion selectSpasQbQuestionById(Long questionId);

    SpasQbQuestion selectByContentHash(@Param("subjectId") Long subjectId, @Param("contentHash") String contentHash);

    int insertSpasQbQuestion(SpasQbQuestion question);

    int updateSpasQbQuestion(SpasQbQuestion question);

    int deleteSpasQbQuestionByIds(Long[] questionIds);

    List<SpasQbQuestionKnowledge> selectKnowledgeByQuestionId(Long questionId);

    int deleteKnowledgeByQuestionId(Long questionId);

    int batchInsertQuestionKnowledge(List<SpasQbQuestionKnowledge> list);

    int insertAiSuggestLog(@Param("questionId") Long questionId, @Param("requestJson") String requestJson,
            @Param("responseJson") String responseJson, @Param("adopted") String adopted,
            @Param("createBy") String createBy);
}
