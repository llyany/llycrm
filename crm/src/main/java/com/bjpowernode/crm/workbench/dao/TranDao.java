package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {

    int save(Tran t);

    Tran detail(String id);

    int updateStage(Tran t);

    int getTotal();

    List<Map<String, Object>> getCharts();

    int getTranTotal(Map<String, Object> map);

    List<Tran> getTranListByCondition(Map<String, Object> map);

    Object getInfo(String id);

    int update(Tran t);

    Tran getHidden(String id);


    int delete(String[] ids);
}
