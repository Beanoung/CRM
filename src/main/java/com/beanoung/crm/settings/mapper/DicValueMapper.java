package com.beanoung.crm.settings.mapper;

import com.beanoung.crm.settings.pojo.DicValue;
import com.beanoung.crm.settings.pojo.DicValueExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface DicValueMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sat Nov 26 14:13:16 CST 2022
     */
    int countByExample(DicValueExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sat Nov 26 14:13:16 CST 2022
     */
    int deleteByExample(DicValueExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sat Nov 26 14:13:16 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sat Nov 26 14:13:16 CST 2022
     */
    int insert(DicValue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sat Nov 26 14:13:16 CST 2022
     */
    int insertSelective(DicValue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sat Nov 26 14:13:16 CST 2022
     */
    List<DicValue> selectByExample(DicValueExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sat Nov 26 14:13:16 CST 2022
     */
    DicValue selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sat Nov 26 14:13:16 CST 2022
     */
    int updateByExampleSelective(@Param("record") DicValue record, @Param("example") DicValueExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sat Nov 26 14:13:16 CST 2022
     */
    int updateByExample(@Param("record") DicValue record, @Param("example") DicValueExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sat Nov 26 14:13:16 CST 2022
     */
    int updateByPrimaryKeySelective(DicValue record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_value
     *
     * @mbggenerated Sat Nov 26 14:13:16 CST 2022
     */
    int updateByPrimaryKey(DicValue record);

    /**
     * 根据TypeCode查询字典值
     */
    List<DicValue> selectDicValueByTypeCode(String typeCode);
}