package com.beanoung.crm.commons.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 处理Date类型数据的工具类
 */
public class DateUtils {

    /**
     * 对指定的date对象进行格式化: yyyy-MM-dd HH:mm:ss
     */
    public static String formatDateTime(Date date){
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String dateTime= sdf.format(date);
        return dateTime;
    }

}
