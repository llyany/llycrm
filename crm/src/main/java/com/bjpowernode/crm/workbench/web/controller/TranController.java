package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.settings.service.impl.UserServiceImpl;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.PrintJson;
import com.bjpowernode.crm.utils.ServiceFactory;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVo;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.*;
import com.bjpowernode.crm.workbench.service.impl.*;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Author: 动力节点
 * 2019/7/13
 */
public class TranController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.println("进入到交易控制器");

        String path = request.getServletPath();

        if("/workbench/transaction/getUserList.do".equals(path)){

            getUserList(request,response);

        }else if("/workbench/transaction/getCustomerNameList.do".equals(path)){

            getCustomerNameList(request,response);

        }else if("/workbench/transaction/save.do".equals(path)){

            save(request,response);

        }else if("/workbench/transaction/detail.do".equals(path)){

            detail(request,response);

        }else if("/workbench/transaction/getHistoryListByTranId.do".equals(path)){

            getHistoryListByTranId(request,response);

        }else if("/workbench/transaction/updateStage.do".equals(path)){

            updateStage(request,response);

        }else if("/workbench/transaction/getCharts.do".equals(path)){

            getCharts(request,response);

        }else if("/workbench/transaction/pageList.do".equals(path)){

            pageList(request,response);

        }else if("/workbench/transaction/getActivityListByName.do".equals(path)){

            getActivityListByName(request,response);

        }else if("/workbench/transaction/getContactListByName.do".equals(path)){

            getContactListByName(request,response);

        }else if("/workbench/transaction/getInfo.do".equals(path)){

            getInfo(request,response);

        }else if("/workbench/transaction/update.do".equals(path)){

            update(request,response);

        }else if("/workbench/transaction/getHidden.do".equals(path)){

            getHidden(request,response);

        }else if("/workbench/transaction/delete.do".equals(path)){

            delete(request,response);

        }
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("删除操作");
        String ids[] = request.getParameterValues("id");
        TranService tran = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean flag = tran.delete(ids);
        PrintJson.printJsonFlag(response, flag);
    }

    private void getHidden(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("隐藏域初始化");
        String id = request.getParameter("id");
        TranService tran = (TranService) ServiceFactory.getService(new TranServiceImpl());
        Tran tr = tran.getHidden(id);
        PrintJson.printJsonObj(response, tr);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("执行修改操作");
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String money = request.getParameter("money");
        String name = request.getParameter("name");
        String expectedDate = request.getParameter("expectedDate");
        String customerId = request.getParameter("customerId"); //对于客户，我们现在只有名字（id还没有）
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String activityId = request.getParameter("activityId");
        String contactsId = request.getParameter("contactsId");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        //System.out.println(id);

        Tran t = new Tran();
        t.setId(id);
        t.setType(type);
        t.setMoney(money);
        t.setName(name);
        t.setExpectedDate(expectedDate);
        t.setStage(stage);
        t.setActivityId(activityId);
        t.setCustomerId(customerId);
        t.setCreateBy(createBy);
        t.setCreateTime(createTime);
        t.setSource(source);
        t.setOwner(owner);
        t.setNextContactTime(nextContactTime);
        t.setDescription(description);
        t.setContactSummary(contactSummary);
        t.setContactsId(contactsId);

        TranService tran = (TranService) ServiceFactory.getService(new TranServiceImpl());

        boolean flag = tran.update(t);

        if (flag) {
            response.sendRedirect(request.getContextPath() + "/workbench/transaction/index.jsp");
        }else {
            response.sendRedirect(request.getContextPath() + "/error_404.jsp");
        }

    }

    private void getInfo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("获取要修改的交易对象");
        String id = request.getParameter("id");

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        Object t =ts.getInfo(id);

        request.setAttribute("t", t);
        request.getRequestDispatcher("/workbench/transaction/edit.jsp").forward(request, response);
//处理下拉框列表，采用session域存放数据，作用域可以扩大
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> uList = us.getUserList();
        request.getSession().setAttribute("userList", uList);

    }

    private void getContactListByName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("模糊查询联系人（根据人名）");
        String cname = request.getParameter("cname");

        ContactService cs = (ContactService) ServiceFactory.getService(new ContactServiceImpl());

        List<Contacts> cList = cs.getContactListByName(cname);

        PrintJson.printJsonObj(response, cList);
    }

    //这里的使用了市场活动业务，但是是属于交易的一部分，并不是市场活动只在市场中进行
    private void getActivityListByName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("模糊查询市场活动");
        String aname = request.getParameter("aname");

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        List<Activity> aList = as.getActivityListByName(aname);

        PrintJson.printJsonObj(response, aList);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("交易界面查询+页面显示");

        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String customerId = request.getParameter("customerId");
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String contactsId = request.getParameter("contactsId");
        String pageNoStr = request.getParameter("pageNo");
        String pageSizeStr = request.getParameter("pageSize");
        //处理页面
        int pageNo = Integer.valueOf(pageNoStr);
        int pageSize = Integer.valueOf(pageSizeStr);
        int skipCount = (pageNo-1)*pageSize;
        //封装，因为页面参数不属于任何一个domain,所以这里使用map传参数
        /*Tran t = new Tran();
        t.setOwner(owner);
        t.setType(type);
        t.setSource(source);
        t.setName(name);
        t.setCustomerId(customerId);
        t.setStage(stage);
        t.setContactsId(contactsId);*/
        Map<String ,Object> map = new HashMap<>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("customerId", customerId);
        map.put("stage", stage);
        map.put("type", type);
        map.put("source", source);
        map.put("contactsId", contactsId);
        map.put("pageSize", pageSize);
        map.put("skipCount",skipCount);
        //业务处理
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        /*
        * 返回：total&list
        * */
         PaginationVo<Tran> vo = ts.pageList(map);
         PrintJson.printJsonObj(response, vo);
    }

    private void getCharts(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("取得交易阶段统计图表数据的操作");

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());

        /*

            total
            dataList

         */
        Map<String,Object> map = ts.getCharts();

        PrintJson.printJsonObj(response, map);

    }

    private void updateStage(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行修改阶段的操作");

        String id = request.getParameter("id");
        String stage = request.getParameter("stage");
        String money = request.getParameter("money");
        String expectedDate = request.getParameter("expectedDate");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();

        Tran t = new Tran();

        t.setId(id);
        t.setStage(stage);
        t.setMoney(money);
        t.setExpectedDate(expectedDate);
        t.setEditBy(editBy);
        t.setEditTime(editTime);

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());

        boolean flag = ts.updateStage(t);

        Map<String,String> pMap = (Map<String, String>) this.getServletContext().getAttribute("pMap");

        t.setPossibility(pMap.get(stage));

        Map<String,Object> map = new HashMap<>();
        map.put("success", flag);
        map.put("t", t);

        PrintJson.printJsonObj(response, map);


    }

    private void getHistoryListByTranId(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("根据交易id，取得相应的历史信息列表");

        String tranId = request.getParameter("tranId");

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());

        List<TranHistory> thList = ts.getHistoryListByTranId(tranId);

        Map<String,String> pMap = (Map<String, String>) this.getServletContext().getAttribute("pMap");

        //将列表遍历，取出每一个阶段，根据每一个阶段取得可能性，将可能性封装到历史对象中
        for(TranHistory th:thList){

            String stage = th.getStage();
            String possibility = pMap.get(stage);
            th.setPossibility(possibility);
        }

        PrintJson.printJsonObj(response, thList);



    }

    private void detail(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

        System.out.println("跳转到详细信息页");

        String id = request.getParameter("id");

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());

        Tran t = ts.detail(id);

        if(t!=null){

            //阶段
            String stage = t.getStage();
            //阶段可能性之间的对应关系
            ServletContext application = this.getServletContext();//申请获取application域
            Map<String,String> pMap = (Map<String, String>) application.getAttribute("pMap");
            //根据以上信息得到可能性
            String possibility = pMap.get(stage);

            //将可能性封装到t中，这个possibility是后面添加进去的属性，为了方便在view页面取值罢了
            t.setPossibility(possibility);

        }

        request.setAttribute("t", t);
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request, response);

    }

    private void save(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.println("执行交易添加操作");

        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String money = request.getParameter("money");
        String name = request.getParameter("name");
        String expectedDate = request.getParameter("expectedDate");
        String customerName = request.getParameter("customerName"); //对于客户，我们现在只有名字（id还没有）
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String activityId = request.getParameter("activityId");
        String contactsId = request.getParameter("contactsId");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");

        Tran t = new Tran();
        t.setId(id);
        t.setType(type);
        t.setMoney(money);
        t.setName(name);
        t.setExpectedDate(expectedDate);
        t.setStage(stage);
        t.setActivityId(activityId);
        t.setCreateBy(createBy);
        t.setCreateTime(createTime);
        t.setSource(source);
        t.setOwner(owner);
        t.setNextContactTime(nextContactTime);
        t.setDescription(description);
        t.setContactSummary(contactSummary);
        t.setContactsId(contactsId);
        //以上信息封装完毕后，t对象还差一个customerId,该信息在业务处理上有特殊需求，需要在业务层添加

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());

        boolean flag = ts.save(t,customerName);

        if(flag){

            response.sendRedirect(request.getContextPath() + "/workbench/transaction/index.jsp");

        }


    }

    private void getCustomerNameList(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("根据客户名称模糊查询客户名称列表");

        String name = request.getParameter("name");

        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());

        List<String> sList = cs.getCustomerNameList(name);

        PrintJson.printJsonObj(response, sList);

    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

        System.out.println("取得用户信息列表，转发到交易添加页");

        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());

        List<User> uList = us.getUserList();

        request.setAttribute("uList", uList);
        request.getRequestDispatcher("/workbench/transaction/save.jsp").forward(request, response);

    }

}































