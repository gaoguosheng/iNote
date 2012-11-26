package com.ggs.model;

/**
 * Created with IntelliJ IDEA.
 * User: ggs
 * Date: 12-6-21
 * Time: 下午5:00
 * To change this template use File | Settings | File Templates.
 */
public class UserModel {
    private String userid;
    private String username;
    private String password;
    private String realname;
    private String flag;
    private String  onlinetimes;

    public String getOnlinetimes() {
        return onlinetimes;
    }

    public void setOnlinetimes(String onlinetimes) {
        this.onlinetimes = onlinetimes;
    }

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

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRealname() {
        return realname;
    }

    public void setRealname(String realname) {
        this.realname = realname;
    }
}
