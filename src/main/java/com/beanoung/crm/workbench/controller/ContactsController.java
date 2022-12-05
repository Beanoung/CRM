package com.beanoung.crm.workbench.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ContactsController {

    @RequestMapping("/workbench/contacts/index.do")
    public String index(){
        return "workbench/contacts/index";
    }
}
