package com.beanoung.crm.workbench.mapper;

import com.beanoung.crm.workbench.pojo.ContactsRemark;
import com.beanoung.crm.workbench.pojo.ContactsRemarkExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface ContactsRemarkMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Sat Dec 03 19:14:35 CST 2022
     */
    int countByExample(ContactsRemarkExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Sat Dec 03 19:14:35 CST 2022
     */
    int deleteByExample(ContactsRemarkExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Sat Dec 03 19:14:35 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Sat Dec 03 19:14:35 CST 2022
     */
    int insert(ContactsRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Sat Dec 03 19:14:35 CST 2022
     */
    int insertSelective(ContactsRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Sat Dec 03 19:14:35 CST 2022
     */
    List<ContactsRemark> selectByExample(ContactsRemarkExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Sat Dec 03 19:14:35 CST 2022
     */
    ContactsRemark selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Sat Dec 03 19:14:35 CST 2022
     */
    int updateByExampleSelective(@Param("record") ContactsRemark record, @Param("example") ContactsRemarkExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Sat Dec 03 19:14:35 CST 2022
     */
    int updateByExample(@Param("record") ContactsRemark record, @Param("example") ContactsRemarkExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Sat Dec 03 19:14:35 CST 2022
     */
    int updateByPrimaryKeySelective(ContactsRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Sat Dec 03 19:14:35 CST 2022
     */
    int updateByPrimaryKey(ContactsRemark record);

    /**
     * 增
     */
    int insertContactsRemarkByList(List<ContactsRemark> corList);
}