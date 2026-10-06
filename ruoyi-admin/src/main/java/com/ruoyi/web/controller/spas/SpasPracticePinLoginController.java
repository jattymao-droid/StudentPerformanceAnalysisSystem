package com.ruoyi.web.controller.spas;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.enums.UserStatus;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.framework.manager.AsyncManager;
import com.ruoyi.framework.manager.factory.AsyncFactory;
import com.ruoyi.framework.web.service.SysLoginService;
import com.ruoyi.framework.web.service.SysPermissionService;
import com.ruoyi.framework.web.service.TokenService;
import com.ruoyi.spas.domain.SpasStudent;
import com.ruoyi.spas.service.ISpasStudentPinService;
import com.ruoyi.system.service.ISysUserService;

/**
 * Kiosk PIN login (anonymous, rate-limited in pin service).
 */
@RestController
public class SpasPracticePinLoginController
{
    @Autowired
    private ISpasStudentPinService pinService;

    @Autowired
    private ISysUserService userService;

    @Autowired
    private SysPermissionService permissionService;

    @Autowired
    private TokenService tokenService;

    @Autowired
    private SysLoginService loginService;

    @Anonymous
    @PostMapping("/spas/practice/pin/login")
    public AjaxResult pinLogin(@RequestBody Map<String, Object> body)
    {
        String studentNo = body == null || body.get("studentNo") == null ? null : String.valueOf(body.get("studentNo"));
        String pin = body == null || body.get("pin") == null ? null : String.valueOf(body.get("pin"));
        if (StringUtils.isEmpty(studentNo))
        {
            studentNo = body == null || body.get("username") == null ? null : String.valueOf(body.get("username"));
        }
        SpasStudent student = pinService.verifyPinLogin(studentNo, pin);
        SysUser user = userService.selectUserById(student.getUserId());
        if (user == null || UserStatus.DELETED.getCode().equals(user.getDelFlag()))
        {
            throw new ServiceException("登录账号不存在");
        }
        if (UserStatus.DISABLE.getCode().equals(user.getStatus()))
        {
            throw new ServiceException("账号已停用");
        }
        LoginUser loginUser = new LoginUser(user.getUserId(), user.getDeptId(), user,
            permissionService.getMenuPermission(user));
        AsyncManager.me().execute(AsyncFactory.recordLogininfor(user.getUserName(), Constants.LOGIN_SUCCESS, "PIN登录成功"));
        loginService.recordLoginInfo(user.getUserId());
        String token = tokenService.createToken(loginUser);
        AjaxResult ajax = AjaxResult.success();
        ajax.put(Constants.TOKEN, token);
        return ajax;
    }
}
