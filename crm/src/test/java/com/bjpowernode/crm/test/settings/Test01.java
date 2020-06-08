package com.bjpowernode.crm.test.settings;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.MD5Util;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Author: 动力节点
 * 2019/7/15
 */
public class Test01 {

    public static void main(String[] args) {

        /*

            关于登录验证：
            （1）验证账号密码 loginAct  loginPwd

                  xxx验证方式1：
                  int count = select count(*) from tbl_user where loginAct=? and loginPwd=?

                  ***验证方式2：
                  User user = select * from tbl_user where loginAct=? and loginPwd=?

                  我们使用的是验证方式2，因为我们需要得到user对象
                  使用user对象：
                  a.从user对象中取出其他验证信息，需要继续验证
                  b.如果登录成功，需要将user对象保存到session域对象中


            （2）验证失效时间 expireTime
            （3）验证锁定状态 lockState 0：锁定  1：启用
            （4）允许访问的ip地址 allowIps

         */

        //取得失效时间
        /*String expireTime = "2019-05-10 10:10:10";
        //取得当前系统时间
        Date date = new Date();
        //将当前系统时间格式化为与失效时间相同的字符串格式，才能够进行比较
        *//*SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String currentTime = sdf.format(date);*//*
        String currentTime = DateTimeUtil.getSysTime();
        //System.out.println(currentTime);
        int count = expireTime.compareTo(currentTime);
        //System.out.println(count);
        if(count<0){

            System.out.println("账号已实效");

        }*/

        /*String lockState = "0";
        if("0".equals(lockState)){

            System.out.println("账号已锁定");

        }*/

        /*String ip = "192.168.1.6";
        String allowIps = "192.168.1.1,192.168.1.2,192.168.1.2";
        if(!allowIps.contains(ip)){

            System.out.println("ip地址受限");

        }*/

        //明文   --->  密文

        /*String str = "Yanmingjie123@bj.com";
        str = MD5Util.getMD5(str);
        System.out.println(str);*/

    }

}
























































