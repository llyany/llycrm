package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;

/**
 * Author: 动力节点
 * 2019/7/15
 */
public interface ActivityRemarkDao {
    int getCountByIds(String[] ids);

    int deleteRemark(String[] ids);

    List<ActivityRemark> getRemarkListByAid(String activityId);

    int delete(String id);

    int saveRemark(ActivityRemark ar);

    int updateRemark(ActivityRemark ar);
}
