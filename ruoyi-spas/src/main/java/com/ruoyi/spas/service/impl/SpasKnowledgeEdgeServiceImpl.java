package com.ruoyi.spas.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.spas.domain.SpasKnowledge;
import com.ruoyi.spas.domain.SpasKnowledgeEdge;
import com.ruoyi.spas.domain.SpasStudentKnowledgeStat;
import com.ruoyi.spas.mapper.SpasAnalysisMapper;
import com.ruoyi.spas.mapper.SpasKnowledgeEdgeMapper;
import com.ruoyi.spas.mapper.SpasKnowledgeMapper;
import com.ruoyi.spas.service.ISpasKnowledgeEdgeService;

/**
 * Knowledge prerequisite edge service impl
 */
@Service
public class SpasKnowledgeEdgeServiceImpl implements ISpasKnowledgeEdgeService
{
    private static final String RELATION_PREREQUISITE = "prerequisite";

    /** node_type = knowledge leaf */
    private static final String NODE_TYPE_LEAF = "2";

    @Autowired
    private SpasKnowledgeEdgeMapper edgeMapper;

    @Autowired
    private SpasKnowledgeMapper knowledgeMapper;

    @Autowired
    private SpasAnalysisMapper analysisMapper;

    @Value("${spas.analysis.weak-thresholds.weak:0.60}")
    private double weakThreshold;

    @Override
    public List<SpasKnowledgeEdge> selectBySubjectId(Long subjectId)
    {
        if (subjectId == null)
        {
            return java.util.Collections.emptyList();
        }
        return edgeMapper.selectBySubjectId(subjectId);
    }

    @Override
    public List<SpasKnowledgeEdge> selectByToKnowledgeId(Long toKnowledgeId)
    {
        if (toKnowledgeId == null)
        {
            return java.util.Collections.emptyList();
        }
        return edgeMapper.selectByToKnowledgeId(toKnowledgeId);
    }

    @Override
    public List<SpasKnowledgeEdge> selectByFromKnowledgeId(Long fromKnowledgeId)
    {
        if (fromKnowledgeId == null)
        {
            return java.util.Collections.emptyList();
        }
        return edgeMapper.selectByFromKnowledgeId(fromKnowledgeId);
    }

    @Override
    public SpasKnowledgeEdge selectById(Long edgeId)
    {
        return edgeMapper.selectById(edgeId);
    }

    @Override
    public int insertSpasKnowledgeEdge(SpasKnowledgeEdge edge)
    {
        if (edge == null || edge.getFromKnowledgeId() == null || edge.getToKnowledgeId() == null)
        {
            throw new ServiceException("\u524d\u7f6e\u4e0e\u76ee\u6807\u77e5\u8bc6\u70b9\u4e0d\u80fd\u4e3a\u7a7a");
        }
        if (edge.getFromKnowledgeId().equals(edge.getToKnowledgeId()))
        {
            throw new ServiceException("\u524d\u7f6e\u4e0e\u76ee\u6807\u4e0d\u80fd\u662f\u540c\u4e00\u77e5\u8bc6\u70b9");
        }
        if (StringUtils.isEmpty(edge.getRelation()))
        {
            edge.setRelation(RELATION_PREREQUISITE);
        }
        if (StringUtils.isEmpty(edge.getStatus()))
        {
            edge.setStatus("0");
        }
        if (edge.getWeight() == null)
        {
            edge.setWeight(BigDecimal.ONE);
        }

        SpasKnowledge from = knowledgeMapper.selectSpasKnowledgeById(edge.getFromKnowledgeId());
        SpasKnowledge to = knowledgeMapper.selectSpasKnowledgeById(edge.getToKnowledgeId());
        if (from == null || to == null)
        {
            throw new ServiceException("\u77e5\u8bc6\u70b9\u4e0d\u5b58\u5728");
        }
        if (!NODE_TYPE_LEAF.equals(from.getNodeType()) || !NODE_TYPE_LEAF.equals(to.getNodeType()))
        {
            throw new ServiceException("\u4f9d\u8d56\u8fb9\u4ec5\u652f\u6301\u53f6\u5b50\u77e5\u8bc6\u70b9");
        }
        if (from.getSubjectId() == null || to.getSubjectId() == null
            || !from.getSubjectId().equals(to.getSubjectId()))
        {
            throw new ServiceException("\u524d\u7f6e\u4e0e\u76ee\u6807\u987b\u5c5e\u4e8e\u540c\u4e00\u5b66\u79d1");
        }
        if (edge.getSubjectId() == null)
        {
            edge.setSubjectId(from.getSubjectId());
        }
        else if (!edge.getSubjectId().equals(from.getSubjectId()))
        {
            throw new ServiceException("\u5b66\u79d1\u4e0e\u77e5\u8bc6\u70b9\u4e0d\u4e00\u81f4");
        }

        SpasKnowledgeEdge existing = edgeMapper.selectUnique(edge.getFromKnowledgeId(), edge.getToKnowledgeId(),
            edge.getRelation());
        if (existing != null)
        {
            throw new ServiceException("\u8be5\u4f9d\u8d56\u8fb9\u5df2\u5b58\u5728");
        }

        List<SpasKnowledgeEdge> subjectEdges = edgeMapper.selectBySubjectId(edge.getSubjectId());
        if (wouldCreateCycle(edge.getFromKnowledgeId(), edge.getToKnowledgeId(), subjectEdges))
        {
            throw new ServiceException("\u6dfb\u52a0\u8be5\u4f9d\u8d56\u8fb9\u4f1a\u5f62\u6210\u73af");
        }

        return edgeMapper.insertSpasKnowledgeEdge(edge);
    }

    @Override
    public int deleteById(Long edgeId)
    {
        if (edgeId == null)
        {
            return 0;
        }
        return edgeMapper.deleteById(edgeId);
    }

    @Override
    public void buildDependencyHints(Long studentId, Long subjectId, List<Map<String, Object>> weakList)
    {
        buildDependencyHints(studentId, subjectId, weakList, null);
    }

    public void buildDependencyHints(Long studentId, Long subjectId, List<Map<String, Object>> weakList,
        Map<Long, BigDecimal> externalRates)
    {
        if (weakList == null || weakList.isEmpty() || subjectId == null)
        {
            return;
        }

        List<SpasKnowledgeEdge> edges = edgeMapper.selectBySubjectId(subjectId);
        if (edges == null || edges.isEmpty())
        {
            applyChapterCohortHints(weakList, subjectId);
            return;
        }

        // toKnowledgeId -> incoming prerequisite edges
        Map<Long, List<SpasKnowledgeEdge>> incoming = new HashMap<Long, List<SpasKnowledgeEdge>>();
        for (SpasKnowledgeEdge e : edges)
        {
            if (e.getToKnowledgeId() == null || e.getFromKnowledgeId() == null)
            {
                continue;
            }
            List<SpasKnowledgeEdge> list = incoming.get(e.getToKnowledgeId());
            if (list == null)
            {
                list = new ArrayList<SpasKnowledgeEdge>();
                incoming.put(e.getToKnowledgeId(), list);
            }
            list.add(e);
        }

        Set<Long> weakIds = new HashSet<Long>();
        for (Map<String, Object> row : weakList)
        {
            Long kid = toLong(row.get("knowledgeId"));
            if (kid != null)
            {
                weakIds.add(kid);
            }
        }

        Map<Long, BigDecimal> rateByKid = new HashMap<Long, BigDecimal>();
        Map<Long, String> weakLevelByKid = new HashMap<Long, String>();
        if (externalRates != null)
        {
            rateByKid.putAll(externalRates);
        }
        // Seed from weak rows themselves (class avg / student rate already on the list)
        for (Map<String, Object> row : weakList)
        {
            Long kid = toLong(row.get("knowledgeId"));
            if (kid == null || rateByKid.containsKey(kid))
            {
                continue;
            }
            BigDecimal r = toBigDecimal(row.get("rate"));
            if (r == null)
            {
                r = toBigDecimal(row.get("avgRate"));
            }
            if (r == null)
            {
                r = toBigDecimal(row.get("weightedRate"));
            }
            if (r != null)
            {
                rateByKid.put(kid, r);
            }
        }
        if (studentId != null)
        {
            List<SpasStudentKnowledgeStat> stats = analysisMapper.selectStudentKnowledgeStats(studentId, subjectId);
            if (stats != null)
            {
                for (SpasStudentKnowledgeStat st : stats)
                {
                    if (st.getKnowledgeId() == null)
                    {
                        continue;
                    }
                    BigDecimal rate = resolveRate(st);
                    if (rate != null)
                    {
                        rateByKid.put(st.getKnowledgeId(), rate);
                    }
                    if (st.getWeakLevel() != null)
                    {
                        weakLevelByKid.put(st.getKnowledgeId(), st.getWeakLevel());
                    }
                }
            }
        }

        int edged = 0;
        for (Map<String, Object> row : weakList)
        {
            Long kid = toLong(row.get("knowledgeId"));
            if (kid == null)
            {
                continue;
            }
            List<SpasKnowledgeEdge> prereqs = incoming.get(kid);
            if (prereqs == null || prereqs.isEmpty())
            {
                continue;
            }

            List<Map<String, Object>> hints = new ArrayList<Map<String, Object>>();
            Map<String, Object> bestRoot = null;
            BigDecimal bestRate = null;

            for (SpasKnowledgeEdge e : prereqs)
            {
                Long fromId = e.getFromKnowledgeId();
                boolean inWeak = weakIds.contains(fromId);
                BigDecimal rate = rateByKid.get(fromId);
                boolean rateWeak = rate != null && rate.doubleValue() < weakThreshold;
                if (!inWeak && !rateWeak)
                {
                    continue;
                }

                Map<String, Object> hint = new LinkedHashMap<String, Object>();
                hint.put("fromKnowledgeId", fromId);
                hint.put("fromKnowledgeName", e.getFromKnowledgeName());
                hint.put("toKnowledgeId", kid);
                hint.put("relation", e.getRelation());
                hint.put("source", "edge");
                hint.put("inWeakList", Boolean.valueOf(inWeak));
                if (rate != null)
                {
                    hint.put("rate", rate);
                }
                String wl = weakLevelByKid.get(fromId);
                if (wl != null)
                {
                    hint.put("weakLevel", wl);
                }
                hints.add(hint);

                if (bestRoot == null || (rate != null && (bestRate == null || rate.compareTo(bestRate) < 0)))
                {
                    bestRoot = hint;
                    bestRate = rate;
                }
            }

            if (!hints.isEmpty())
            {
                edged++;
                row.put("dependencyHints", hints);
                Object rootName = bestRoot == null ? null : bestRoot.get("fromKnowledgeName");
                if (rootName == null && bestRoot != null)
                {
                    rootName = bestRoot.get("fromKnowledgeId");
                }
                row.put("rootHint", rootName == null ? null
                    : ("\u524d\u7f6e\u8584\u5f31\uff1a" + rootName));
                row.put("rootHintDetail", bestRoot);
            }
        }

        // Rows without edge hits: soft L1 same-chapter cohort fallback
        if (edged < weakList.size())
        {
            applyChapterCohortHints(weakList, subjectId);
        }
    }

    private BigDecimal toBigDecimal(Object v)
    {
        if (v == null)
        {
            return null;
        }
        if (v instanceof BigDecimal)
        {
            return (BigDecimal) v;
        }
        if (v instanceof Number)
        {
            return BigDecimal.valueOf(((Number) v).doubleValue());
        }
        try
        {
            return new BigDecimal(v.toString());
        }
        catch (Exception ignored)
        {
            return null;
        }
    }

    /**
     * When no prerequisite edge hits: hint other weak leaves under the same chapter (L1).
     */
    private void applyChapterCohortHints(List<Map<String, Object>> weakList, Long subjectId)
    {
        List<SpasKnowledge> all = knowledgeMapper.selectSpasKnowledgeBySubjectId(subjectId);
        if (all == null || all.isEmpty())
        {
            return;
        }
        Map<Long, SpasKnowledge> byId = new HashMap<Long, SpasKnowledge>();
        for (SpasKnowledge k : all)
        {
            if (k.getKnowledgeId() != null)
            {
                byId.put(k.getKnowledgeId(), k);
            }
        }
        Map<Long, List<Map<String, Object>>> byParent = new HashMap<Long, List<Map<String, Object>>>();
        for (Map<String, Object> row : weakList)
        {
            Long kid = toLong(row.get("knowledgeId"));
            if (kid == null)
            {
                continue;
            }
            SpasKnowledge kn = byId.get(kid);
            if (kn == null || kn.getParentId() == null)
            {
                continue;
            }
            List<Map<String, Object>> bucket = byParent.get(kn.getParentId());
            if (bucket == null)
            {
                bucket = new ArrayList<Map<String, Object>>();
                byParent.put(kn.getParentId(), bucket);
            }
            bucket.add(row);
        }
        for (Map.Entry<Long, List<Map<String, Object>>> e : byParent.entrySet())
        {
            List<Map<String, Object>> cohort = e.getValue();
            if (cohort == null || cohort.size() < 2)
            {
                continue;
            }
            for (Map<String, Object> row : cohort)
            {
                if (row.get("rootHint") != null)
                {
                    continue;
                }
                Long kid = toLong(row.get("knowledgeId"));
                List<Map<String, Object>> hints = new ArrayList<Map<String, Object>>();
                StringBuilder names = new StringBuilder();
                int shown = 0;
                for (Map<String, Object> other : cohort)
                {
                    Long oid = toLong(other.get("knowledgeId"));
                    if (oid == null || oid.equals(kid))
                    {
                        continue;
                    }
                    Object oname = other.get("name");
                    if (oname == null)
                    {
                        oname = other.get("knowledgeName");
                    }
                    if (oname == null)
                    {
                        SpasKnowledge ok = byId.get(oid);
                        oname = ok == null ? oid : ok.getKnowledgeName();
                    }
                    Map<String, Object> hint = new LinkedHashMap<String, Object>();
                    hint.put("fromKnowledgeId", oid);
                    hint.put("fromKnowledgeName", oname);
                    hint.put("toKnowledgeId", kid);
                    hint.put("relation", "chapter_cohort");
                    hint.put("source", "chapter");
                    hints.add(hint);
                    if (shown < 2)
                    {
                        if (names.length() > 0)
                        {
                            names.append("\u3001");
                        }
                        names.append(oname);
                        shown++;
                    }
                }
                if (!hints.isEmpty())
                {
                    row.put("dependencyHints", hints);
                    row.put("rootHint", "\u540c\u7ae0\u5171\u5f31\uff1a" + names.toString());
                    row.put("rootHintDetail", hints.get(0));
                }
            }
        }
    }

    /**
     * Detect cycle if adding from -&gt; to: true when a path already exists from to to from.
     */
    private boolean wouldCreateCycle(Long fromId, Long toId, List<SpasKnowledgeEdge> existing)
    {
        Map<Long, List<Long>> adj = new HashMap<Long, List<Long>>();
        if (existing != null)
        {
            for (SpasKnowledgeEdge e : existing)
            {
                if (e.getFromKnowledgeId() == null || e.getToKnowledgeId() == null)
                {
                    continue;
                }
                List<Long> next = adj.get(e.getFromKnowledgeId());
                if (next == null)
                {
                    next = new ArrayList<Long>();
                    adj.put(e.getFromKnowledgeId(), next);
                }
                next.add(e.getToKnowledgeId());
            }
        }
        Set<Long> visited = new HashSet<Long>();
        return dfsReachable(toId, fromId, adj, visited);
    }

    private boolean dfsReachable(Long current, Long target, Map<Long, List<Long>> adj, Set<Long> visited)
    {
        if (current == null)
        {
            return false;
        }
        if (current.equals(target))
        {
            return true;
        }
        if (!visited.add(current))
        {
            return false;
        }
        List<Long> next = adj.get(current);
        if (next == null)
        {
            return false;
        }
        for (Long n : next)
        {
            if (dfsReachable(n, target, adj, visited))
            {
                return true;
            }
        }
        return false;
    }

    private BigDecimal resolveRate(SpasStudentKnowledgeStat st)
    {
        if (st == null)
        {
            return null;
        }
        if (st.getWeightedRate() != null)
        {
            return st.getWeightedRate();
        }
        return st.getAvgRate();
    }

    private Long toLong(Object v)
    {
        if (v == null)
        {
            return null;
        }
        if (v instanceof Number)
        {
            return Long.valueOf(((Number) v).longValue());
        }
        String s = String.valueOf(v).trim();
        if (s.isEmpty())
        {
            return null;
        }
        try
        {
            return Long.valueOf(s);
        }
        catch (NumberFormatException ex)
        {
            return null;
        }
    }
}
