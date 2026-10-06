package com.ruoyi.spas.service;

import java.util.Map;
import com.ruoyi.spas.domain.SpasStudent;

public interface ISpasStudentPinService
{
    Map<String, Object> pinStatus();

    int setPin(String pin, String oldPin);

    /** Verify studentNo+PIN; returns bound student (with userId) on success. */
    SpasStudent verifyPinLogin(String studentNo, String pin);
}
