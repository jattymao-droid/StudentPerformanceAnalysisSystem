package com.ruoyi.spas.qb.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.spas.qb.domain.SpasQbPaper;
import com.ruoyi.spas.qb.domain.SpasQbPaperItem;

/**
 * Bank paper mapper
 */
public interface SpasQbPaperMapper
{
    List<SpasQbPaper> selectSpasQbPaperList(SpasQbPaper query);

    SpasQbPaper selectSpasQbPaperById(Long paperId);

    int insertSpasQbPaper(SpasQbPaper paper);

    int updateSpasQbPaper(SpasQbPaper paper);

    int deleteSpasQbPaperByIds(Long[] paperIds);

    List<SpasQbPaperItem> selectItemsByPaperId(Long paperId);

    int deleteItemsByPaperId(Long paperId);

    int insertSpasQbPaperItem(SpasQbPaperItem item);

    int batchInsertItems(List<SpasQbPaperItem> items);

    Long selectAnalysisPaperIdByBank(@Param("bankPaperId") Long bankPaperId, @Param("deptId") Long deptId);

    /** Distinct knowledge ids covered by paper items */
    List<Long> selectKnowledgeIdsByPaperId(Long paperId);
}
