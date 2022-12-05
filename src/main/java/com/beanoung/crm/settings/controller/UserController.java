package com.beanoung.crm.settings.controller;

import com.beanoung.crm.commons.constants.Constants;
import com.beanoung.crm.commons.pojo.ReturnObject;
import com.beanoung.crm.commons.utils.DateUtils;
import com.beanoung.crm.settings.pojo.User;
import com.beanoung.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * 跳转到登录页面
     */
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin() {
        return "settings/qx/user/login";
    }

    /**
     * 登录
     * @return 实体类com.beanoung.crm.commons.pojo.ReturnObject
     */
    @RequestMapping("/settings/qx/user/login.do")
    @ResponseBody
    public Object login(String loginAct, String loginPwd, String isRemPwd,
                        HttpServletRequest request, HttpServletResponse response, HttpSession session) {
        Map<String, Object> map = new HashMap<>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);
        User user = userService.queryByLoginActAndPwd(map);

        ReturnObject returnObject = new ReturnObject();
        if (user == null) {
            //登录失败
            returnObject.setCode(Constants.RETURN_CODE_FAILED);
            returnObject.setMessage("账号和密码不匹配");
        } else {
            //判断是否过期
            String nowTime = DateUtils.formatDateTime(new Date());//现在时间
            if (nowTime.compareTo(user.getExpireTime()) > 0) {
                //过期了
                returnObject.setCode(Constants.RETURN_CODE_FAILED);
                returnObject.setMessage("账号已过期");
            } else if ("0".equals(user.getLockState())) {
                //被锁定了
                returnObject.setCode(Constants.RETURN_CODE_FAILED);
                returnObject.setMessage("账号被锁定");
            } else if (!user.getAllowIps().contains(request.getRemoteAddr())) {
                //IP地址不被允许访问
                returnObject.setCode(Constants.RETURN_CODE_FAILED);
                returnObject.setMessage("IP受限");
            } else {
                //登录成功
                returnObject.setCode(Constants.RETURN_CODE_SUCCESS);
                //放数据
                session.setAttribute(Constants.SESSION_USER, user);

                //记住密码
                if("true".equals(isRemPwd)){
                    Cookie loginAct1 = new Cookie("loginAct", user.getLoginAct());
                    loginAct1.setMaxAge(10*24*60*60);//10天
                    response.addCookie(loginAct1);
                    Cookie loginPwd1 = new Cookie("loginPwd", user.getLoginPwd());
                    loginPwd1.setMaxAge(10*24*60*60);//10天
                    response.addCookie(loginPwd1);
                }else {//删cookie
                    Cookie loginAct1 = new Cookie("loginAct", "1");
                    loginAct1.setMaxAge(0);//0天立即删除
                    response.addCookie(loginAct1);
                    Cookie loginPwd1 = new Cookie("loginPwd", "1");
                    loginPwd1.setMaxAge(0);
                    response.addCookie(loginPwd1);
                }
            }
        }
        return returnObject;
    }

    /**
     * 安全退出
     */
    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpServletResponse response,HttpSession session){
        //清cookie
        Cookie loginAct1 = new Cookie("loginAct", "1");
        loginAct1.setMaxAge(0);//0天立即删除
        response.addCookie(loginAct1);
        Cookie loginPwd1 = new Cookie("loginPwd", "1");
        loginPwd1.setMaxAge(0);
        response.addCookie(loginPwd1);

        //销毁session
        session.invalidate();

        //重定向到主页,自动跳转到登录界面
        return "redirect:/";
    }

}
