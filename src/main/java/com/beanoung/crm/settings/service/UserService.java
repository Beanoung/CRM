package com.beanoung.crm.settings.service;

import com.beanoung.crm.settings.pojo.User;

import java.util.List;
import java.util.Map;

public interface UserService {

    User queryByLoginActAndPwd(Map<String,Object> map);

    List<User> queryAllUser();

}
