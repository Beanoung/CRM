package com.beanoung.crm.workbench.service;

import com.beanoung.crm.workbench.pojo.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {

    int saveCreateActivity(Activity activity);

    List<Activity> queryActivityByConditionForPage(Map<String,Object> map);

    int queryCountOfActivityByCondition(Map<String,Object> map);

    int deleteActivityByIds(String[] ids);

    Activity queryActivityById(String id);

    int editActivity(Activity activity);

    List<Activity> queryAllActivity();

    List<Activity> queryActivityByIds(String[] id);

    int saveCreateActivityByList(List<Activity> activityList);

    Activity queryActivityForDetailById(String id);

    List<Activity> queryActivityByNameAndClueId(Map<String,Object> map);

    List<Activity> queryActivityForDetailByClueId(String clueId);

    List<Activity> queryActivityForDetailByIds(String[] activityId);

    List<Activity> queryActivityForConvertByNameClueId(Map<String,Object> map);
}
