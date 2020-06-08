package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.exception.LoginException;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.settings.service.impl.UserServiceImpl;
import com.bjpowernode.crm.utils.MD5Util;
import com.bjpowernode.crm.utils.PrintJson;
import com.bjpowernode.crm.utils.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Author: 动力节点
 * 2019/7/13
 */
public class UserController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        /*

            处理字符编码都需要处理：
            1.get请求参数的字符编码
                经过我们第三阶段的实验，get请求参数不会出现中文乱码，是因为我们使用的是版本比较高的tomcat服务器
                如果我们在企业中使用的是版本比较低的tomcat，我们就需要处理get请求的中文乱码问题
                tomcat/conf/server.xml 63/69
                配置端口号的这一行新增 URIEncoding="UTF-8"

            2.post请求参数的字符编码
                request.setCharacterEncoding("UTF-8");

            3.响应流的字符编码
                response.setContentType("text/html;charset=utf-8");
         */



        System.out.println("进入到用户控制器");

        String path = request.getServletPath();

        if("/settings/user/login.do".equals(path)){

            login(request,response);

        }else if("/settings/user/xxx.do".equals(path)){

            //xxx(request,response);

        }


    }

    private void login(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("进入到验证登录的操作");

        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        loginPwd = MD5Util.getMD5(loginPwd);
        //取得浏览器端的ip地址
        /*

            注意：
                此处不能使用localhost，如果使用localhost，那么我们得到的ip是000000001
                可以使用127.0.0.1来代替自身主机ip

         */
        String ip = request.getRemoteAddr();

        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());

        try {

            User user = us.login(loginAct,loginPwd,ip);

            request.getSession().setAttribute("user", user);

            //如果程序能够顺利的走到该行，说明登录成功
            /*

                需要为前端提供：
                    {"success":true}

             */

            /*String str = "{\"success\":true}";
            response.getWriter().print(str);*/

            PrintJson.printJsonFlag(response, true);

        } catch (Exception e) {

            e.printStackTrace();

            //一旦程序走到了该行，说明业务层为我们抛出了异常，说明登录失败

            //取得错误消息
            String msg = e.getMessage();

            /*

                需要为前端提供：
                    {"success":false,"msg":?}

                    同时为上一层提供多个值
                    使用
                    map
                    vo

             */
            Map<String,Object> map = new HashMap<>();
            map.put("success", false);
            map.put("msg", msg);

            PrintJson.printJsonObj(response, map);


        }




    }
}































