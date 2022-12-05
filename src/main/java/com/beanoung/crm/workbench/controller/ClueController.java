package com.beanoung.crm.workbench.controller;

import com.beanoung.crm.commons.constants.Constants;
import com.beanoung.crm.commons.pojo.ReturnObject;
import com.beanoung.crm.commons.utils.DateUtils;
import com.beanoung.crm.commons.utils.UUIDUtils;
import com.beanoung.crm.settings.pojo.DicValue;
import com.beanoung.crm.settings.pojo.User;
import com.beanoung.crm.settings.service.DicValueService;
import com.beanoung.crm.settings.service.UserService;
import com.beanoung.crm.workbench.pojo.Activity;
import com.beanoung.crm.workbench.pojo.Clue;
import com.beanoung.crm.workbench.pojo.ClueActivityRelation;
import com.beanoung.crm.workbench.pojo.ClueRemark;
import com.beanoung.crm.workbench.service.ActivityService;
import com.beanoung.crm.workbench.service.ClueRemarkService;
import com.beanoung.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class ClueController {

    @Autowired
    private ClueService clueService;

    @Autowired
    private UserService userService;

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private ClueRemarkService clueRemarkService;

    @Autowired
    private ActivityService activityService;

    /**
     * 跳转线索主页面并获取字典数据
     */
    @RequestMapping("/workbench/clue/index.do")
    public String index(HttpServletRequest request) {
        //下拉列表1: user
        List<User> userList = userService.queryAllUser();
        request.setAttribute("userList", userList);

        //下拉列表2: appellation 称呼
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        request.setAttribute("appellationList", appellationList);

        //下拉列表3: clueState 线索状态
        List<DicValue> clueStateList = dicValueService.queryDicValueByTypeCode("clueState");
        request.setAttribute("clueStateList", clueStateList);

        //下拉列表4: source 线索来源
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        request.setAttribute("sourceList", sourceList);

        return "workbench/clue/index";
    }

    /**
     * 新增线索
     */
    @RequestMapping("/workbench/clue/saveCreateClue.do")
    @ResponseBody
    public Object saveCreateClue(Clue clue, HttpSession session) {
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Constants.SESSION_USER);

        clue.setId(UUIDUtils.getUUID());
        clue.setCreateBy(user.getId());
        clue.setCreateTime(DateUtils.formatDateTime(new Date()));

        try {
            int i = clueService.saveCreateClue(clue);
            if (i == 1) {
                returnObject.setCode(Constants.RETURN_CODE_SUCCESS);
            } else {
                returnObject.setCode(Constants.RETURN_CODE_FAILED);
                returnObject.setMessage("系统忙...");
            }
        } catch (Exception e) {
            returnObject.setCode(Constants.RETURN_CODE_FAILED);
            returnObject.setMessage("系统忙...");
            e.printStackTrace();
        }
        return returnObject;
    }

    /**
     * 根据条件查询线索列表并分页
     */
    @RequestMapping("/workbench/clue/queryClueByConditionForPage.do")
    @ResponseBody
    public Object queryClueByConditionForPage(String fullname, String company, String phone, String source,
                                              String owner, String mphone, String state, int pageNo, int pageSize) {
        Map<String, Object> map = new HashMap<>();
        map.put("fullname", fullname);
        map.put("company", company);
        map.put("phone", phone);
        map.put("source", source);
        map.put("owner", owner);
        map.put("mphone", mphone);
        map.put("state", state);
        map.put("beginNo", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);

        List<Clue> clueList = clueService.queryClueByConditionForPage(map);
        int count = clueService.queryCountOfClueByCondition(map);

        Map<String, Object> retMap = new HashMap<>();
        retMap.put("clueList", clueList);
        retMap.put("count", count);

        return retMap;
    }

    /**
     * 批量删除
     */
    @RequestMapping("/workbench/clue/saveDeleteClueByIds.do")
    @ResponseBody
    public Object saveDeleteClueByIds(String[] id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int count = clueService.deleteClueByIds(id);
            if (count > 0) {
                returnObject.setCode(Constants.RETURN_CODE_SUCCESS);
                returnObject.setRetData(count);
            } else {
                returnObject.setCode(Constants.RETURN_CODE_FAILED);
                returnObject.setMessage("系统忙...");
            }
        } catch (Exception e) {
            returnObject.setCode(Constants.RETURN_CODE_FAILED);
            returnObject.setMessage("系统忙...");
            e.printStackTrace();
        }
        return returnObject;
    }

    /**
     * 根据id查询一条线索,用于修改
     */
    @RequestMapping("/workbench/clue/queryClueById.do")
    @ResponseBody
    public Object queryClueById(String id) {
        Clue clue = clueService.queryClueById(id);
        return clue;
    }

    /**
     * 修改线索
     */
    @RequestMapping("/workbench/clue/saveEditClue.do")
    @ResponseBody
    public Object saveEditClue(Clue clue, HttpSession session) {
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Constants.SESSION_USER);

        clue.setEditBy(user.getId());
        clue.setEditTime(DateUtils.formatDateTime(new Date()));

        try {
            int i = clueService.saveEditClue(clue);
            if (i == 1) {
                returnObject.setCode(Constants.RETURN_CODE_SUCCESS);
            } else {
                returnObject.setCode(Constants.RETURN_CODE_FAILED);
                returnObject.setMessage("系统忙...");
            }
        } catch (Exception e) {
            returnObject.setCode(Constants.RETURN_CODE_FAILED);
            returnObject.setMessage("系统忙...");
            e.printStackTrace();
        }
        return returnObject;
    }

    /**
     * 线索详情界面
     */
    @RequestMapping("/workbench/clue/detailOfClue.do")
    public String detailOfClue(String clueId, HttpServletRequest request) {
        Clue clue = clueService.queryClueByIdForDetail(clueId);
        List<ClueRemark> clueRemarkList = clueRemarkService.queryAllClueRemarkByClueId(clueId);
        List<Activity> activityList = activityService.queryActivityForDetailByClueId(clueId);

        request.setAttribute("clue", clue);
        request.setAttribute("clueRemarkList", clueRemarkList);
        request.setAttribute("activityList", activityList);
        return "workbench/clue/detail";
    }

    /**
     * 模糊查询未关联的活动
     */
    @RequestMapping("/workbench/clue/queryActivityForDetailByNameClueId.do")
    @ResponseBody
    public Object queryActivityForDetailByNameClueId(String activityName, String clueId) {
        Map<String, Object> map = new HashMap<>();
        map.put("activityName", activityName);
        map.put("clueId", clueId);

        List<Activity> activityList = activityService.queryActivityByNameAndClueId(map);

        return activityList;
    }

    /**
     * 跳转转换页面
     */
    @RequestMapping("/workbench/clue/toConvert.do")
    public String toConvert(String id, HttpServletRequest request) {
        Clue clue = clueService.queryClueByIdForConvert(id);
        request.setAttribute("clue", clue);

        //字典--阶段stage
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        request.setAttribute("stageList", stageList);

        return "workbench/clue/convert";
    }

    /**
     * 为转换页面市场活动源查询活动
     */
    @RequestMapping("/workbench/clue/queryActivityForConvertByNameClueId.do")
    @ResponseBody
    public Object queryActivityForConvertByNameClueId(String activityName, String clueId) {
        Map<String, Object> map = new HashMap<>();
        map.put("activityName", activityName);
        map.put("clueId", clueId);
        List<Activity> activityList = activityService.queryActivityForConvertByNameClueId(map);

        return activityList;
    }

    /**
     * 转换线索
     */
    @RequestMapping("/workbench/clue/convertClue.do")
    @ResponseBody
    public Object convertClue(String clueId, String money, String name, String expectedDate, String stage,
                              String activityId, String isCreateTran, HttpSession session) {
        Map<String, Object> map = new HashMap<>();
        map.put("clueId", clueId);
        map.put("money", money);
        map.put("name", name);
        map.put("expectedDate", expectedDate);
        map.put("stage", stage);
        map.put("activityId", activityId);
        map.put("isCreateTran", isCreateTran);
        map.put(Constants.SESSION_USER, session.getAttribute(Constants.SESSION_USER));

        ReturnObject returnObject = new ReturnObject();
        try {
            clueService.saveConvertClue(map);
            returnObject.setCode(Constants.RETURN_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_CODE_FAILED);
            returnObject.setMessage("系统忙，请稍后重试....");
        }
        return returnObject;
    }

}
