package com.bjpowernode.crm.settings.dao;

import com.bjpowernode.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

/**
 * Author: 动力节点
 * 2019/7/13
 */
public interface UserDao {
    User login(Map<String, String> map);

    List<User> getUserList();
}
