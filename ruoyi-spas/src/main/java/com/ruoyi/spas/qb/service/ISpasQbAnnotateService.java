package com.ruoyi.spas.qb.service;

import java.util.Map;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.spas.qb.domain.SpasQbAnnotateCommitRequest;
import com.ruoyi.spas.qb.domain.SpasQbAnnotateRecognizeRequest;
import com.ruoyi.spas.qb.domain.SpasQbAnnotateUploadResult;

/**
 * Visual paper annotate: render pages and commit cropped questions
 */
public interface ISpasQbAnnotateService
{
    SpasQbAnnotateUploadResult uploadAndRender(MultipartFile file, Long subjectId, String operator);

    Map<String, Object> recognizeRegion(SpasQbAnnotateRecognizeRequest request);

    Map<String, Object> commit(SpasQbAnnotateCommitRequest request, String operator);
}
