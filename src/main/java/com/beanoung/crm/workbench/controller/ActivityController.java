package com.beanoung.crm.workbench.controller;

import com.beanoung.crm.commons.constants.Constants;
import com.beanoung.crm.commons.pojo.ReturnObject;
import com.beanoung.crm.commons.utils.DateUtils;
import com.beanoung.crm.commons.utils.ExportToExcel;
import com.beanoung.crm.commons.utils.HSSFUtils;
import com.beanoung.crm.commons.utils.UUIDUtils;
import com.beanoung.crm.settings.pojo.User;
import com.beanoung.crm.settings.service.UserService;
import com.beanoung.crm.workbench.pojo.Activity;
import com.beanoung.crm.workbench.pojo.ActivityRemark;
import com.beanoung.crm.workbench.service.ActivityRemarkService;
import com.beanoung.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.time.LocalDate;
import java.util.*;

@Controller
public class ActivityController {

    @Autowired
    private UserService userService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ActivityRemarkService activityRemarkService;

    /**
     * 市场活动页面
     */
    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request) {
        List<User> userList = userService.queryAllUser();
        request.setAttribute("userList", userList);
        return "workbench/activity/index";
    }

    /**
     * 保存创建市场活动
     */
    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    @ResponseBody
    public ReturnObject saveCreateActivity(Activity activity, HttpSession session) {
        //3个参数手动获取,id,createTime,createBy
        //id
        activity.setId(UUIDUtils.getUUID());
        //createTime
        activity.setCreateTime(DateUtils.formatDateTime(new Date()));
        //createBy
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        activity.setCreateBy(user.getId());

        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = activityService.saveCreateActivity(activity);
            if (0 < ret) {
                returnObject.setCode(Constants.RETURN_CODE_SUCCESS);
            } else {
                returnObject.setCode(Constants.RETURN_CODE_FAILED);
                returnObject.setMessage("系统忙,请稍候重试...");
            }
        } catch (Exception e) {
            returnObject.setCode(Constants.RETURN_CODE_FAILED);
            returnObject.setMessage("系统忙,请稍候重试...");
            throw new RuntimeException(e);
        }
        return returnObject;
    }

    /**
     * 条件查询活动列表并分页
     */
    @RequestMapping("/workbench/activity/queryActivityByConditionForPage.do")
    @ResponseBody
    public Object queryActivityByConditionForPage(String name, String owner, String startDate, String endDate,
                                                  int pageNo, int pageSize) {
        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        map.put("beginNo", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);

        List<Activity> activityList = activityService.queryActivityByConditionForPage(map);

        int count = activityService.queryCountOfActivityByCondition(map);

        Map<String, Object> retMap = new HashMap<>();
        retMap.put("activityList", activityList);
        retMap.put("count", count);
        return retMap;
    }

    /**
     * 批量删除
     */
    @RequestMapping("/workbench/activity/deleteActivityByIds.do")
    @ResponseBody
    public Object deleteActivityByIds(String[] id) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = activityService.deleteActivityByIds(id);
            if (i > 0) {
                returnObject.setCode(Constants.RETURN_CODE_SUCCESS);
            } else {
                returnObject.setCode(Constants.RETURN_CODE_FAILED);
                returnObject.setMessage("系统忙,请稍候重试...");
            }
        } catch (Exception e) {
            returnObject.setCode(Constants.RETURN_CODE_FAILED);
            returnObject.setMessage("系统忙,请稍候重试...");
            throw new RuntimeException(e);
        }
        return returnObject;
    }

    /**
     * 修改按钮: 根据id查询市场活动
     */
    @RequestMapping("/workbench/activity/queryActivityById.do")
    @ResponseBody
    public Object queryActivityById(String id) {
        Activity activity = activityService.queryActivityById(id);
        return activity;
    }

    /**
     * 修改市场活动
     */
    @RequestMapping("/workbench/activity/editActivity.do")
    @ResponseBody
    public Object editActivity(Activity activity) {
        ReturnObject returnObject = new ReturnObject();
        //new Date()带有时分秒,下面的方式不带有
        activity.setEditTime(LocalDate.now().toString());
        try {
            int i = activityService.editActivity(activity);
            if (i > 0) {
                returnObject.setCode(Constants.RETURN_CODE_SUCCESS);
            } else {
                returnObject.setCode(Constants.RETURN_CODE_FAILED);
                returnObject.setMessage("系统忙,请稍候重试...");
            }
        } catch (Exception e) {
            returnObject.setCode(Constants.RETURN_CODE_FAILED);
            returnObject.setMessage("系统忙,请稍候重试...");
            throw new RuntimeException(e);
        }
        return returnObject;
    }

    /**
     * 导出所有市场活动
     */
    @RequestMapping("/workbench/activity/exportAllActivity.do")
    public void exportAllActivity(HttpServletResponse response) throws IOException {
        List<Activity> activityList = activityService.queryAllActivity();

        HSSFWorkbook wb = ExportToExcel.exportToExcel(activityList);

        //生成excel目标文件
        /* FileOutputStream fileOutputStream = new FileOutputStream("D:\\网站下载项目\\activity.xls");
        wb.write(fileOutputStream);
        fileOutputStream.close();
        wb.close(); */

        //目标文件输出到浏览器
        response.setContentType("application/octet-stream;charset=UTF-8");//二进制流
        response.addHeader("Content-Disposition", "attachment;filename=activity.xls");//头信息,附件
        OutputStream outputStream = response.getOutputStream();
        /* FileInputStream fileInputStream = new FileInputStream("D:\\网站下载项目\\activity.xls");
        byte[] buffer = new byte[256];
        int len = 0;//每次读写字节数
        while ((len = fileInputStream.read(buffer)) != -1) {
            outputStream.write(buffer, 0, len);
        }
        fileInputStream.close(); */
        wb.write(outputStream);//省略写磁盘,读磁盘的步骤,直接从内存到内存
        wb.close();
        outputStream.flush();
    }

    /**
     * 导出选中的市场活动
     */
    @RequestMapping("/workbench/activity/exportActivityByIds.do")
    public void exportActivityByIds(String[] id, HttpServletResponse response) throws IOException {

        List<Activity> activityList = activityService.queryActivityByIds(id);

        HSSFWorkbook wb = ExportToExcel.exportToExcel(activityList);

        response.setContentType("application/octet-stream;charset=UTF-8");//二进制流
        response.addHeader("Content-Disposition", "attachment;filename=selectedActivity.xls");//头信息,附件
        OutputStream outputStream = response.getOutputStream();
        wb.write(outputStream);//省略写磁盘,读磁盘的步骤,直接从内存到内存

        wb.close();
        outputStream.flush();
    }

    /**
     * 导入
     */
    @RequestMapping("/workbench/activity/importActivity.do")
    @ResponseBody
    public Object importActivity(MultipartFile activityFile, HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        try {
            //将上传的文件写入磁盘
            /* String fileName = activityFile.getOriginalFilename();
            File file = new File("D:\\网站下载项目\\2", fileName);
            activityFile.transferTo(file); */
            //解析文件,获取数据,并封装为activityList
            /* FileInputStream fileInputStream = new FileInputStream("D:\\网站下载项目\\2\\" + fileName); */
            InputStream inputStream = activityFile.getInputStream();
            HSSFWorkbook wb = new HSSFWorkbook(inputStream);//fileInputStream
            HSSFSheet sheet = wb.getSheetAt(0);//excel第一张表
            HSSFRow row = null;
            HSSFCell cell = null;
            Activity activity = null;
            List<Activity> activityList = new ArrayList<>();

            for (int i = 1; i <= sheet.getLastRowNum(); i++) {//遍历行,从第二行开始  getLastRowNum():最后一行下标
                row = sheet.getRow(i);
                activity = new Activity();
                activity.setId(UUIDUtils.getUUID());
                activity.setOwner(user.getId());//因为重名问题,所以以当前用户为所有者
                activity.setCreateTime(DateUtils.formatDateTime(new Date()));
                activity.setCreateBy(user.getId());

                for (int j = 0; j < row.getLastCellNum(); j++) {//遍历列  getLastCellNum():最后一列下标+1
                    cell = row.getCell(j);
                    String cellValue = HSSFUtils.getCellValueForStr(cell);
                    switch (j) {
                        case 0:
                            activity.setName(cellValue);
                        case 1:
                            activity.setStartDate(cellValue);
                        case 2:
                            activity.setEndDate(cellValue);
                        case 3:
                            activity.setCost(cellValue);
                        case 4:
                            activity.setDescription(cellValue);
                        default:
                            break;
                    }
                }
                //封装activityList
                activityList.add(activity);
            }
            //保存activityList
            int i = activityService.saveCreateActivityByList(activityList);
            returnObject.setCode(Constants.RETURN_CODE_SUCCESS);
            returnObject.setRetData(i);
        } catch (Exception e) {
            returnObject.setCode(Constants.RETURN_CODE_FAILED);
            returnObject.setMessage("系统忙,请稍候重试...");
            e.printStackTrace();
        }
        return returnObject;
    }

    /**
     * 跳转活动详情页
     */
    @RequestMapping("/workbench/activity/detailOfActivity.do")
    public String detailOfActivity(String activityId,HttpServletRequest request) {
        Activity activity = activityService.queryActivityForDetailById(activityId);
        List<ActivityRemark> activityRemarkList = activityRemarkService.queryActivityRemarkForDetailByActivityId(activityId);
        request.setAttribute("activity",activity);
        request.setAttribute("activityRemarkList",activityRemarkList);

        return "workbench/activity/detail";
    }

}
