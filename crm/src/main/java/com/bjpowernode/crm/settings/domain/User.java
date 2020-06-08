package com.bjpowernode.crm.settings.domain;

/**
 * Author: 动力节点
 * 2019/7/13
 */
public class User {

    /*

        关于时间：
            日期：yyyy-MM-dd 10位
            时间：yyyy-MM-dd HH:mm:ss 19位

        关于主键：
            id -- UUID

        关于登录验证：
            （1）验证账号密码 loginAct  loginPwd
            （2）验证失效时间 expireTime
            （3）验证锁定状态 lockState 0：锁定  1：启用
            （4）允许访问的ip地址 allowIps



     */

    private String id;  //主键
    private String loginAct;    //登录账号
    private String name;    //用户的真实姓名
    private String loginPwd;    //登录密码
    private String email;   //邮箱
    private String expireTime;  //账号的失效时间  yyyy-MM-dd HH:mm:ss 19位
    private String lockState;   //账号的锁定状态
    private String deptno;  //部门编号
    private String allowIps;    //允许访问的ip地址群
    private String createTime;  //创建时间 yyyy-MM-dd HH:mm:ss 19位
    private String createBy;    //创建人
    private String editTime;    //修改时间 yyyy-MM-dd HH:mm:ss 19位
    private String editBy;  //修改人

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLoginAct() {
        return loginAct;
    }

    public void setLoginAct(String loginAct) {
        this.loginAct = loginAct;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLoginPwd() {
        return loginPwd;
    }

    public void setLoginPwd(String loginPwd) {
        this.loginPwd = loginPwd;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getExpireTime() {
        return expireTime;
    }

    public void setExpireTime(String expireTime) {
        this.expireTime = expireTime;
    }

    public String getLockState() {
        return lockState;
    }

    public void setLockState(String lockState) {
        this.lockState = lockState;
    }

    public String getDeptno() {
        return deptno;
    }

    public void setDeptno(String deptno) {
        this.deptno = deptno;
    }

    public String getAllowIps() {
        return allowIps;
    }

    public void setAllowIps(String allowIps) {
        this.allowIps = allowIps;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getCreateBy() {
        return createBy;
    }

    public void setCreateBy(String createBy) {
        this.createBy = createBy;
    }

    public String getEditTime() {
        return editTime;
    }

    public void setEditTime(String editTime) {
        this.editTime = editTime;
    }

    public String getEditBy() {
        return editBy;
    }

    public void setEditBy(String editBy) {
        this.editBy = editBy;
    }
}
