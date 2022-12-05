package com.beanoung.crm.workbench.controller;

import com.beanoung.crm.commons.constants.Constants;
import com.beanoung.crm.commons.pojo.ReturnObject;
import com.beanoung.crm.commons.utils.DateUtils;
import com.beanoung.crm.commons.utils.UUIDUtils;
import com.beanoung.crm.settings.pojo.User;
import com.beanoung.crm.workbench.pojo.ActivityRemark;
import com.beanoung.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ActivityRemarkController {

    @Autowired
    private ActivityRemarkService activityRemarkService;

    /**
     * 创建评论
     */
    @RequestMapping("/workbench/activity/saveCreateActivityRemark.do")
    @ResponseBody
    public Object saveCreateActivityRemark(ActivityRemark activityRemark, HttpSession session) {
        ReturnObject returnObject = new ReturnObject();

        User user = (User) session.getAttribute(Constants.SESSION_USER);
        activityRemark.setId(UUIDUtils.getUUID());
        activityRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        activityRemark.setCreateBy(user.getId());
        try {
            int i = activityRemarkService.saveCreateActivityRemark(activityRemark);
            if (i == 1) {
                returnObject.setCode(Constants.RETURN_CODE_SUCCESS);
            } else {
                returnObject.setCode(Constants.RETURN_CODE_FAILED);
                returnObject.setMessage("系统忙,请稍后重试...");
            }
        } catch (Exception e) {
            returnObject.setCode(Constants.RETURN_CODE_FAILED);
            returnObject.setMessage("系统忙,请稍后重试...");
            e.printStackTrace();
        }
        return returnObject;
    }

    /**
     * 删除评论
     */
    @RequestMapping("/workbench/activity/saveDeleteActivityRemark.do")
    @ResponseBody
    public Object saveDeleteActivityRemark(String remarkId) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = activityRemarkService.saveDeleteActivityRemark(remarkId);
            if (i == 1) {
                returnObject.setCode(Constants.RETURN_CODE_SUCCESS);
            } else {
                returnObject.setCode(Constants.RETURN_CODE_FAILED);
                returnObject.setMessage("系统忙,请稍后重试...");
            }
        } catch (Exception e) {
            returnObject.setCode(Constants.RETURN_CODE_FAILED);
            returnObject.setMessage("系统忙,请稍后重试...");
            e.printStackTrace();
        }
        return returnObject;
    }

    /**
     * 修改评论
     */
    @RequestMapping("/workbench/activity/saveEditActivityRemark.do")
    @ResponseBody
    public Object saveEditActivityRemark(ActivityRemark activityRemark,HttpSession session) {
        ReturnObject returnObject = new ReturnObject();

        User user = (User) session.getAttribute(Constants.SESSION_USER);
        activityRemark.setEditBy(user.getId());
        activityRemark.setEditTime(DateUtils.formatDateTime(new Date()));
        try {
            int i = activityRemarkService.saveEditActivityRemark(activityRemark);
            if (i == 1) {
                returnObject.setCode(Constants.RETURN_CODE_SUCCESS);
                returnObject.setRetData(activityRemarkService.queryActivityRemarkByRemarkId(activityRemark.getId()));
            } else {
                returnObject.setCode(Constants.RETURN_CODE_FAILED);
                returnObject.setMessage("系统忙,请稍后重试...");
            }
        } catch (Exception e) {
            returnObject.setCode(Constants.RETURN_CODE_FAILED);
            returnObject.setMessage("系统忙,请稍后重试...");
            e.printStackTrace();
        }
        return returnObject;
    }
}
