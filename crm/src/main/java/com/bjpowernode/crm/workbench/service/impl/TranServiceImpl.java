package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.vo.PaginationVo;
import com.bjpowernode.crm.workbench.dao.CustomerDao;
import com.bjpowernode.crm.workbench.dao.TranDao;
import com.bjpowernode.crm.workbench.dao.TranHistoryDao;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.domain.TranHistory;
import com.bjpowernode.crm.workbench.service.TranService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Author: 动力节点
 * 2019/7/19
 */
public class TranServiceImpl implements TranService {

    private TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
    private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);

    @Override
    public boolean save(Tran t, String customerName) {

        String createTime = DateTimeUtil.getSysTime();

        boolean flag = true;

        /*

            通过客户名称查询客户，如果有该客户则将客户的id取出，封装到t的customerId属性中
                                如果没有该客户，则新建客户，然后将新建的客户的id取出，封装到t的customerId属性中

         */

        Customer cus = customerDao.getByName(customerName);
        //获取客户id的方法，除了在前端页面直接获取id，还可以间接通过查询customer的存在，使用cus.getId()获取

        if(cus==null){

            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setCreateBy(t.getCreateBy());
            cus.setCreateTime(createTime);
            cus.setName(customerName);

            int count1 = customerDao.save(cus);
            if(count1!=1){
                flag = false;
            }

        }

        String customerId = cus.getId();
        t.setCustomerId(customerId);

        int count2 = tranDao.save(t);
        if(count2!=1){
            flag = false;
        }

        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setTranId(t.getId());
        th.setStage(t.getStage());
        th.setMoney(t.getMoney());
        th.setExpectedDate(t.getExpectedDate());
        th.setCreateTime(createTime);
        th.setCreateBy(t.getCreateBy());

        int count3 = tranHistoryDao.save(th);
        if(count3!=1){
            flag = false;
        }


        return flag;
    }

    @Override
    public Tran detail(String id) {

        Tran t = tranDao.detail(id);

        return t;
    }

    @Override
    public List<TranHistory> getHistoryListByTranId(String tranId) {

        List<TranHistory> thList = tranHistoryDao.getHistoryListByTranId(tranId);

        return thList;
    }

    @Override
    public boolean updateStage(Tran t) {

        boolean flag = true;
        int count1 = tranDao.updateStage(t);
        if(count1!=1){
            flag = false;
        }

        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setCreateBy(t.getEditBy());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setMoney(t.getMoney());
        th.setExpectedDate(t.getExpectedDate());
        th.setStage(t.getStage());
        th.setTranId(t.getId());

        int count2 = tranHistoryDao.save(th);

        if(count2!=1){

            flag = false;

        }


        return flag;
    }

    @Override
    public Map<String, Object> getCharts() {

        //取total
        int total = tranDao.getTotal();

        //取dataList
        List<Map<String,Object>> dataList = tranDao.getCharts();

        //创建一个map对象，将total和dataList保存到map中
        Map<String,Object> map = new HashMap<>();
        map.put("total", total);
        map.put("dataList", dataList);

        //返回map
        return map;
    }

    @Override
    public PaginationVo<Tran> pageList(Map<String, Object> map) {
        PaginationVo<Tran> vo = new PaginationVo<>();
        //获得total
        int total = tranDao.getTranTotal(map);
        //获得datalist
        List<Tran> dataList = tranDao.getTranListByCondition(map);
        vo.setDataList(dataList);
        vo.setTotal(total);
        return vo;
    }

    @Override
    public Object getInfo(String id) {
        Object t = tranDao.getInfo(id);
        return t;
    }

    @Override
    public boolean update(Tran t) {
        boolean flag = false;
        int count = tranDao.update(t);
        if (count == 1) {
            flag = true;
        }
        return flag;
    }

    @Override
    public Tran getHidden(String id) {
        Tran tr = tranDao.getHidden(id);
        return tr;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag = true;
        int count = tranDao.delete(ids);
        if (count == 0){
            flag = false;
        }
        return flag;
    }


}


































