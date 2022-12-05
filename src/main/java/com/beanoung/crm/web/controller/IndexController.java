package com.beanoung.crm.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;



@Controller
public class IndexController {

    /**
     * 入口首页，登录请求
     */
    @RequestMapping("/")
    public String index(){
        return "index";
    }
}
