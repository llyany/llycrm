package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.settings.dao.DicTypeDao;
import com.bjpowernode.crm.settings.dao.DicValueDao;
import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicService;
import com.bjpowernode.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Author: 动力节点
 * 2019/7/17
 */
public class DicServiceImpl implements DicService {

    private DicTypeDao dicTypeDao = SqlSessionUtil.getSqlSession().getMapper(DicTypeDao.class);
    private DicValueDao dicValueDao = SqlSessionUtil.getSqlSession().getMapper(DicValueDao.class);

    @Override
    public Map<String, List<DicValue>> getAll() {

      /*  Map<String, List<DicValue>> map = new HashMap<>();

        //取得字典类型列表
        List<DicType> dtList = dicTypeDao.getTypeList();

        //遍历字典类型列表
        for(DicType dt:dtList){

            //取得每一种类型的编码
            String code = dt.getCode();

            //根据每一种类型，取得字典值列表
            List<DicValue> dvList = dicValueDao.getValueListByCode(code);

            map.put(code+"List", dvList);

        }*/
        Map<String, List<DicValue>> map = new HashMap<>();
        //这里要获得"xxxList"以及对应的dvList
        //连表查询获得了code和value,所以，只要分别放在map中就可以了
        //复习：注意这里使用连表查询，查询结果中包括t.code和v.*，根据连表的共同元素，进行了封装！！！
        for (DicType dt : dicTypeDao.getTypeList()){
            //封装对象：
            //code+valuelist
            //获得每个封装对象的code
            String code = dt.getCode();
            //获得每个封装对象的valueList
            map.put(code+"List",dt.getValueList());
        }

        return map;
    }

   /* @Override
    public Map<String, List<DicValue>> getValue() {
        Map<String, List<DicValue>> map = new HashMap<>();
        //这里要获得"xxxList"以及对应的dvList
        //连表查询获得了code和value,所以，只要分别放在map中就可以了
        for (DicType dt : dicTypeDao.getValueList()){
            //获得code
            String code = dt.getCode();
                //获得code下的valueList
            map.put(code+"List",dt.getValueList());
        }
        return map;
    }*/

}


























