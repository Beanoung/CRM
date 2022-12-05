package com.beanoung.crm.workbench.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.ResourceBundle;

@Controller
public class TransactionController {

    /**
     * 交易首页
     */
    @RequestMapping("/workbench/transaction/index.do")
    public String index(HttpServletRequest request){


        return "workbench/transaction/index";
    }

    /**
     * 新建交易页
     */
    @RequestMapping("/workbench/transaction/toSave.do")
    public String toSave(){
        return "workbench/transaction/save";
    }

    /**
     * 获取配置文件值
     */
    @RequestMapping("/workbench/transaction/getPossibilityByStage.do")
    @ResponseBody
    public Object getPossibilityByStage(String stageValue){
        //解析properties配置文件，根据阶段获取可能性
        ResourceBundle bundle=ResourceBundle.getBundle("possibility");
        String possibility=bundle.getString(stageValue);
        System.out.println("possibility:"+possibility);
        //返回响应信息
        return possibility;
    }
}
