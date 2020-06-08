package com.bjpowernode.crm.web.filter;

import com.bjpowernode.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Author: 动力节点
 * 2019/7/15
 */
public class LoginFilter implements Filter {
    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {

        System.out.println("进入到用来判断是否已经登录过的过滤器");

        /*

            我们现在有的是ServletRequest req和ServletResponse resp 父

            我们现在要用的是HttpServletRequest request和HttpServletResponse response 子

         */

        /*

            request取得session对象
            session对象中取得User user对象
            判断user对象
            如果user为null，说明没有登录过
            如果user不为null，说明已经登录过

         */

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;

        String path = request.getServletPath();

        //如果请求资源为以下两个，那么不需要判断是否已经登录过，直接放行即可
        if("/login.jsp".equals(path) || "/settings/user/login.do".equals(path)){

            chain.doFilter(req, resp);


        //如果访问的是其他资源，必须判断有没有登录过
        }else{

            User user = (User)request.getSession().getAttribute("user");

            //如果user不为null，说明已经登录过了
            if(user!=null){

                //将请求放行
                chain.doFilter(req, resp);

                //user为null，说明没登录过
            }else{

                //重定向到登录页

            /*

                对于我们开发中使用的路径，肯定使用的绝对路径
                不论是转发，还是重定向，对于路径，使用的也必须是绝对路径
                后台java代码中的绝对路径：/项目名/具体资源路径...

                转发：
                    对于转发路径的写法，是一种特殊的绝对路径的用法，前面不加/项目名，这种路径在开发中也叫做内部路径
                    /login.jsp

                重定向：
                    重定向的路径的写法，就是传统的绝对路径的写法，前面必须加/项目名
                    /crm/login.jsp
                    使用request.getContextPath()将路径写活，该代码会为我们返回/当前的项目名

             */

                response.sendRedirect(request.getContextPath() + "/login.jsp");

            }

        }





    }
}






































