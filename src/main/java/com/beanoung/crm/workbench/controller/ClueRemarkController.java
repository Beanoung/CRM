package com.beanoung.crm.workbench.controller;

import com.beanoung.crm.commons.constants.Constants;
import com.beanoung.crm.commons.pojo.ReturnObject;
import com.beanoung.crm.commons.utils.DateUtils;
import com.beanoung.crm.commons.utils.UUIDUtils;
import com.beanoung.crm.settings.pojo.User;
import com.beanoung.crm.workbench.pojo.ClueRemark;
import com.beanoung.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ClueRemarkController {

    @Autowired
    private ClueRemarkService clueRemarkService;

    /**
     * 创建评论
     */
    @RequestMapping("/workbench/clue/saveCreateClueRemark.do")
    @ResponseBody
    public Object saveCreateClueRemark(ClueRemark clueRemark, HttpSession session) {
        ReturnObject returnObject = new ReturnObject();

        User user = (User) session.getAttribute(Constants.SESSION_USER);
        clueRemark.setId(UUIDUtils.getUUID());
        clueRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        clueRemark.setCreateBy(user.getId());
        try {
            int i = clueRemarkService.saveCreateClueRemark(clueRemark);
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
}
