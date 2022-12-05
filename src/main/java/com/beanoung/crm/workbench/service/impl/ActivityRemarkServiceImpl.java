package com.beanoung.crm.workbench.service.impl;

import com.beanoung.crm.workbench.mapper.ActivityRemarkMapper;
import com.beanoung.crm.workbench.pojo.ActivityRemark;
import com.beanoung.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;

    @Override
    public List<ActivityRemark> queryActivityRemarkForDetailByActivityId(String activityId) {
        return activityRemarkMapper.selectActivityRemarkForDetailByActivityId(activityId);
    }

    @Override
    public int saveCreateActivityRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.insertActivityRemark(activityRemark);
    }

    @Override
    public int saveDeleteActivityRemark(String remarkId) {
        return activityRemarkMapper.deleteActivityRemarkByRemarkId(remarkId);
    }

    @Override
    public int saveEditActivityRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.updateActivityRemarkByRemarkId(activityRemark);
    }

    @Override
    public ActivityRemark queryActivityRemarkByRemarkId(String remarkId) {
        return activityRemarkMapper.selectActivityRemarkByRemarkId(remarkId);
    }
}
