package com.beanoung.crm.commons.utils;

import java.util.UUID;

public class UUIDUtils {

    /**
     * 生成一个UUID
     * @return
     */
    public static String getUUID(){
        return UUID.randomUUID().toString().replaceAll("-","");
    }
}
