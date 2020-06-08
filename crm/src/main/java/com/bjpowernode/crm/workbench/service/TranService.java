package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.PaginationVo;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

/**
 * Author: 动力节点
 * 2019/7/19
 */
public interface TranService {
    boolean save(Tran t, String customerName);

    Tran detail(String id);

    List<TranHistory> getHistoryListByTranId(String tranId);

    boolean updateStage(Tran t);

    Map<String, Object> getCharts();

    PaginationVo<Tran> pageList(Map<String, Object> map);

    Object getInfo(String id);

    boolean update(Tran t);

    Tran getHidden(String id);


    boolean delete(String[] ids);
}
