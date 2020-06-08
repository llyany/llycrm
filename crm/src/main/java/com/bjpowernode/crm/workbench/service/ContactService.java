package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Contacts;

import java.util.List;

/**
 * Athor:lly
 */
public interface ContactService {
    List<Contacts> getContactListByName(String cname);
}
