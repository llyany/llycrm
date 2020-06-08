package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.workbench.dao.ContactsDao;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.service.ContactService;

import java.util.ArrayList;
import java.util.List;

/**
 *
 */
public class ContactServiceImpl implements ContactService {
    private ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    @Override
    public List<Contacts> getContactListByName(String cname) {
        List<Contacts> cList = new ArrayList<>();
        cList = contactsDao.getContactListByName(cname);
        return cList;
    }
}
