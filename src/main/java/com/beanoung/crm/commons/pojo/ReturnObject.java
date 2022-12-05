package com.beanoung.crm.commons.pojo;

/**
 * 封装返回给前端的信息
 */
public class ReturnObject {

    //1成功,0失败
    private String code;

    //提示信息
    private String message;

    //预留
    private Object retData;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getRetData() {
        return retData;
    }

    public void setRetData(Object retData) {
        this.retData = retData;
    }
}
