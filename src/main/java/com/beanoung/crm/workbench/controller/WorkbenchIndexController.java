package com.beanoung.crm.workbench.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class WorkbenchIndexController {

    @RequestMapping("/workbench/toWorkbenchIndex.do")
    public String toWorkbenchIndex(){
        return "workbench/index";
    }
}
