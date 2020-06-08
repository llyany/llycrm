package com.bjpowernode.crm.test.workbench.activity;

import com.bjpowernode.crm.utils.ServiceFactory;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.impl.ActivityServiceImpl;
import org.junit.Assert;
import org.junit.Test;

import java.util.UUID;

/**
 * Author: 动力节点
 * 2019/7/18
 */
public class ActivityTest {

    @Test
    public void testSave(){

        //System.out.println(123);

        Activity a = new Activity();
        a.setId(UUIDUtil.getUUID());
        a.setName("宣传推广会");

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean flag = as.save(a);

        /*

            使用断言机制，来做单元测试

            我们在程序执行之前，提供一个预判的值，与程序实际执行的返回值，做对比
            如果两个值相等，则测试成功
            如果两个值不等，则测试失败

         */

        //Assert.assertEquals(false,flag);


    }

    /*@Test
    public void testUpdate(){

        System.out.println(234);

        *//*String str = null;

        str.length();*//*

    }

    @Test
    public void testSelect1(){

        System.out.println(234);



    }

    @Test
    public void testSelect2(){

        System.out.println(234);



    }

    @Test
    public void testSelect3(){

        System.out.println(234);



    }
*/
}






































