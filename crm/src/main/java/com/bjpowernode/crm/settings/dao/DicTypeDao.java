package com.bjpowernode.crm.settings.dao;

import com.bjpowernode.crm.settings.domain.DicType;

import java.util.List;

/**
 * Author: 动力节点
 * 2019/7/17
 */
public interface DicTypeDao {
    List<DicType> getTypeList();
    //List<DicType> getValueList();
}
