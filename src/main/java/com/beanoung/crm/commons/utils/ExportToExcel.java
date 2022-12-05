package com.beanoung.crm.commons.utils;

import com.beanoung.crm.workbench.pojo.Activity;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import java.util.List;

public class ExportToExcel {

    /**
     * 根据活动列表生成一个excel
     * @param activityList 活动列表
     * @return 返回一个excel
     */
    public static HSSFWorkbook exportToExcel(List<Activity> activityList){
        String[] firstRow = new String[]{
                "id", "所有者", "活动名", "开始日期", "结束日期", "花销", "描述", "创建日期", "创建者", "编辑日期", "编辑者"};
        //excel文档
        HSSFWorkbook wb = new HSSFWorkbook();
        //表
        HSSFSheet sheet = wb.createSheet("选中的市场活动");
        //行
        HSSFRow row = sheet.createRow(0);
        //列
        HSSFCell cell;
        //第一行,标题
        for (int i = 0; i < 11; i++) {
            cell = row.createCell(i);
            cell.setCellValue(firstRow[i]);
        }
        //其余行,数据
        if (activityList != null && activityList.size() > 0) {
            Activity activity = null;
            for (int i = 0; i < activityList.size(); i++) {
                row = sheet.createRow(1 + i);
                activity = activityList.get(i);

                //11列
                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell = row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell = row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell = row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell = row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }
        return wb;
    }
}
