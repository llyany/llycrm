package com.bjpowernode.crm.web.listener;

import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.service.DicService;
import com.bjpowernode.crm.settings.service.impl.DicServiceImpl;
import com.bjpowernode.crm.utils.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

/**
 * Author: 动力节点
 * 2019/7/17
 */
public class SysInitListener implements ServletContextListener {

    /*

        该方法是用来监听application域对象创建的方法
        一旦application域对象创建了，那么该方法马上自动执行

        event：该参数可以取得监听的域对象，比如我们现在监听的是application域对象，
                那么我们就可以通过event来取得该域对象

     */
    @Override
    public void contextInitialized(ServletContextEvent event) {

        //System.out.println("上下文域对象创建了");

        //通过event取得application域对象，可以放共享数据
        //这里在application中放了数据字典

        ServletContext application = event.getServletContext();

        //System.out.println("服务器为我们创建的application对象是："+application);

        System.out.println("在服务器缓存中处理数据字典开始");

        DicService ds = (DicService) ServiceFactory.getService(new DicServiceImpl());

        /*

            业务层应该分门别类的处理数据字典值列表
            应当为我们返回7个List<DicValue> dvList

            我们可以在业务层，使用map将这7个dvList保存， 这样做的好处是方便最终保存到application中

            业务层处理：
                Map<String,Object> map...
                map.put("appellationList",dvList1);
                map.put("xxxList",dvList2);
                map.put("xxxList",dvList3);

                ...7

                将以上处理的map返回到监听器，使用application来代替map保存这些内容就可以了


         */
       /* Map<String, List<DicValue>> map = ds.getAll();

        Set<String> set = map.keySet();

        for(String key:set){

            application.setAttribute(key, map.get(key));

        }*/
        Map<String, List<DicValue>> map = ds.getAll();

        Set<String> set = map.keySet();//获取所有key值

        for(String key:set){
            application.setAttribute(key, map.get(key));

        }

        System.out.println("在服务器缓存中处理数据字典结束");

        System.out.println("在服务器缓存中处理阶段和可能性之间的关系");

        /*

            解析Stage2Possibility.properties
            将以上属性文件中的键值对保存到map中
            将map保存到application中

         */

        Map<String,String> pMap = new HashMap<>();

        ResourceBundle rb = ResourceBundle.getBundle("Stage2Possibility");

        Enumeration<String> e = rb.getKeys();//获取主键（stage）集合

        while(e.hasMoreElements()){

            String stage = e.nextElement();

            String possibility = rb.getString(stage);//获得stage对应value

            System.out.println(stage+":"+possibility);

            pMap.put(stage, possibility);//将遍历出来的建值对放入map

        }
        //循环将所有键值对放入pMap

        application.setAttribute("pMap", pMap);


    }
}



























