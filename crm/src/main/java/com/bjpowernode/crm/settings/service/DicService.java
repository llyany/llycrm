package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

/**
 * Author: 动力节点
 * 2019/7/17
 */
public interface DicService {
    Map<String, List<DicValue>> getAll();

    //Map<String, List<DicValue>> getValue();
}
