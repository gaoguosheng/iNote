package com.ggs.model;

/**
 * Created with IntelliJ IDEA.
 * User: ggs
 * Date: 12-8-21
 * Time: 上午8:42
 * To change this template use File | Settings | File Templates.
 */
public class BugModel extends BaseModel {
    private String company;
    private String username;
    private String mobile;
    private String memo;
    private String bugid;
    private String processinfo;
    private String creator;

    public String getCreator() {
        return creator;
    }

    public void setCreator(String creator) {
        this.creator = creator;
    }

    public String getProcessinfo() {
        return processinfo;
    }

    public void setProcessinfo(String processinfo) {
        this.processinfo = processinfo;
    }

    public String getBugid() {
        return bugid;
    }

    public void setBugid(String bugid) {
        this.bugid = bugid;
    }

    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }
}
