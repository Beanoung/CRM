package com.beanoung.crm.workbench.mapper;

import com.beanoung.crm.workbench.pojo.ActivityRemark;
import com.beanoung.crm.workbench.pojo.ActivityRemarkExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface ActivityRemarkMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Tue Nov 22 12:18:07 CST 2022
     */
    int countByExample(ActivityRemarkExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Tue Nov 22 12:18:07 CST 2022
     */
    int deleteByExample(ActivityRemarkExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Tue Nov 22 12:18:07 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Tue Nov 22 12:18:07 CST 2022
     */
    int insert(ActivityRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Tue Nov 22 12:18:07 CST 2022
     */
    int insertSelective(ActivityRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Tue Nov 22 12:18:07 CST 2022
     */
    List<ActivityRemark> selectByExample(ActivityRemarkExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Tue Nov 22 12:18:07 CST 2022
     */
    ActivityRemark selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Tue Nov 22 12:18:07 CST 2022
     */
    int updateByExampleSelective(@Param("record") ActivityRemark record, @Param("example") ActivityRemarkExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Tue Nov 22 12:18:07 CST 2022
     */
    int updateByExample(@Param("record") ActivityRemark record, @Param("example") ActivityRemarkExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Tue Nov 22 12:18:07 CST 2022
     */
    int updateByPrimaryKeySelective(ActivityRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Tue Nov 22 12:18:07 CST 2022
     */
    int updateByPrimaryKey(ActivityRemark record);

    /**
     * 根据活动id查询活动的所有评论
     */
    List<ActivityRemark> selectActivityRemarkForDetailByActivityId(String activityId);

    /**
     * 保存新发表的评论
     */
    int insertActivityRemark(ActivityRemark activityRemark);

    /**
     * 根据评论id删除评论
     */
    int deleteActivityRemarkByRemarkId(String remarkId);

    /**
     * 修改评论
     */
    int updateActivityRemarkByRemarkId(ActivityRemark activityRemark);

    /**
     * 根据评论id查询评论
     */
    ActivityRemark selectActivityRemarkByRemarkId(String remarkId);
}