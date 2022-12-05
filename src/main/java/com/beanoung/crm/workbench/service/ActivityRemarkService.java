package com.beanoung.crm.workbench.service;

import com.beanoung.crm.workbench.pojo.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {

    List<ActivityRemark> queryActivityRemarkForDetailByActivityId(String activityId);

    int saveCreateActivityRemark(ActivityRemark activityRemark);

    int saveDeleteActivityRemark(String remarkId);

    int saveEditActivityRemark(ActivityRemark activityRemark);

    ActivityRemark queryActivityRemarkByRemarkId(String remarkId);
}
