package com.beanoung.crm.settings.service.impl;

import com.beanoung.crm.settings.mapper.UserMapper;
import com.beanoung.crm.settings.pojo.User;
import com.beanoung.crm.settings.service.UserService;
import com.beanoung.crm.workbench.mapper.ActivityMapper;
import com.beanoung.crm.workbench.pojo.Activity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public User queryByLoginActAndPwd(Map<String, Object> map) {
        User user = userMapper.selectUserByLoginActAndPwd(map);
        return user;
    }

    @Override
    public List<User> queryAllUser() {
        List<User> userList = userMapper.selectAllUser();
        return userList;
    }
}
