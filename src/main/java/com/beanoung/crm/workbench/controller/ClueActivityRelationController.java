package com.beanoung.crm.workbench.controller;

import com.beanoung.crm.commons.constants.Constants;
import com.beanoung.crm.commons.pojo.ReturnObject;
import com.beanoung.crm.commons.utils.UUIDUtils;
import com.beanoung.crm.workbench.pojo.Activity;
import com.beanoung.crm.workbench.pojo.ClueActivityRelation;
import com.beanoung.crm.workbench.service.ActivityService;
import com.beanoung.crm.workbench.service.ClueActivityRelationService;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ClueActivityRelationController {

    @Autowired
    private ClueActivityRelationService clueActivityRelationService;

    @Autowired
    private ActivityService activityService;

    /**
     * 创建关系
     */
    @RequestMapping("/workbench/clue/saveCreateClueActivityRelation.do")
    @ResponseBody
    public Object saveCreateClueActivityRelation(String[] activityId, String clueId) {
        ClueActivityRelation car = null;
        List<ClueActivityRelation> relationList = new ArrayList<>();
        for (String ai : activityId) {
            System.out.println("activityId"+ai);        //测试
            car = new ClueActivityRelation();
            car.setActivityId(ai);
            car.setClueId(clueId);
            car.setId(UUIDUtils.getUUID());
            relationList.add(car);
        }

        ReturnObject returnObject = new ReturnObject();
        try {
            //调用service方法，批量保存线索和市场活动的关联关系
            int ret = clueActivityRelationService.createClueActivityRelation(relationList);

            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_CODE_SUCCESS);

                List<Activity> activityList = activityService.queryActivityForDetailByIds(activityId);
                returnObject.setRetData(activityList);
            } else {
                returnObject.setCode(Constants.RETURN_CODE_FAILED);
                returnObject.setMessage("系统忙，请稍后重试....");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_CODE_FAILED);
            returnObject.setMessage("系统忙，请稍后重试....");
        }
        return returnObject;
    }

    /**
     * 解除关系
     */
    @RequestMapping("/workbench/clue/saveRemoveClueActivityRelation.do")
    @ResponseBody
    public Object saveRemoveClueActivityRelation(String activityId, String clueId) {
        ReturnObject returnObject = new ReturnObject();
        Map<String,Object> map=new HashMap<>();
        map.put("activityId",activityId);
        map.put("clueId",clueId);
        try {
            int ret = clueActivityRelationService.removeClueActivityRelation(map);

            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_CODE_SUCCESS);
            } else {
                returnObject.setCode(Constants.RETURN_CODE_FAILED);
                returnObject.setMessage("系统忙，请稍后重试....");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_CODE_FAILED);
            returnObject.setMessage("系统忙，请稍后重试....");
        }
        return returnObject;
    }
}
