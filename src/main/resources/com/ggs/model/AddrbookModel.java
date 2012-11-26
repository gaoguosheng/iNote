package com.ggs.model;

/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 12-8-16
 * Time: 下午2:10
 * To change this template use File | Settings | File Templates.
 */
public class AddrbookModel extends BaseModel {
    private String id;
    private String name;
    private String sex;
    private String mobile;
    private String qq;
    private String email;
    private String memo;
    private String isvisable;
    private String fspell;
    private String addrclassid;
    private String userid;
    private String flag;

    public String getFlag() {
        return flag;
    }

    public void setFlag(String flag) {
        this.flag = flag;
    }

    public String getUserid() {
        return userid;
    }

    public void setUserid(String userid) {
        this.userid = userid;
    }

    public String getAddrclassid() {
        return addrclassid;
    }

    public void setAddrclassid(String addrclassid) {
        this.addrclassid = addrclassid;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getQq() {
        return qq;
    }

    public void setQq(String qq) {
        this.qq = qq;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public String getIsvisable() {
        return isvisable;
    }

    public void setIsvisable(String isvisable) {
        this.isvisable = isvisable;
    }

    public String getFspell() {
        return fspell;
    }

    public void setFspell(String fspell) {
        this.fspell = fspell;
    }
}
