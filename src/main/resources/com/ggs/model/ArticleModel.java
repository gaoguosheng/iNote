package com.ggs.model;

/**
 * Created with IntelliJ IDEA.
 * User: ggs
 * Date: 12-5-26
 * Time: 上午10:54
 * To change this template use File | Settings | File Templates.
 */
public class ArticleModel extends  BaseModel{
    private String id;
    private String title;
    private String tag;
    private String creattime;
    private String folderid;
    private String content;
    private String creattime1;
    private String creattime2;
    private String foldertree;
    private String userid;
    private String assignid;
    private String priority;
    private String status;
    private String assigninfo;
    private String finishinfo;
    private String isread;
    private String hascomment;
    private String hasmycomment;
    private String csort;
    private String buglevel;
    private String isfavorites;

    public String getIsfavorites() {
        return isfavorites;
    }

    public void setIsfavorites(String isfavorites) {
        this.isfavorites = isfavorites;
    }

    public String getBuglevel() {
        return buglevel;
    }

    public void setBuglevel(String buglevel) {
        this.buglevel = buglevel;
    }

    public String getCsort() {
        return csort;
    }

    public void setCsort(String csort) {
        this.csort = csort;
    }

    public String getHasmycomment() {
        return hasmycomment;
    }

    public void setHasmycomment(String hasmycomment) {
        this.hasmycomment = hasmycomment;
    }

    public String getHascomment() {
        return hascomment;
    }

    public void setHascomment(String hascomment) {
        this.hascomment = hascomment;
    }

    public String getIsread() {
        return isread;
    }

    public void setIsread(String isread) {
        this.isread = isread;
    }

    public String getAssigninfo() {
        return assigninfo;
    }

    public void setAssigninfo(String assigninfo) {
        this.assigninfo = assigninfo;
    }

    public String getFinishinfo() {
        return finishinfo;
    }

    public void setFinishinfo(String finishinfo) {
        this.finishinfo = finishinfo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getAssignid() {
        return assignid;
    }

    public void setAssignid(String assignid) {
        this.assignid = assignid;
    }

    public String getUserid() {
        return userid;
    }

    public void setUserid(String userid) {
        this.userid = userid;
    }

    public String getFoldertree() {
        return foldertree;
    }

    public void setFoldertree(String foldertree) {
        this.foldertree = foldertree;
    }

    public String getCreattime2() {
        return creattime2;
    }

    public void setCreattime2(String creattime2) {
        this.creattime2 = creattime2;
    }

    public String getCreattime1() {
        return creattime1;
    }

    public void setCreattime1(String creattime1) {
        this.creattime1 = creattime1;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getTag() {
        return tag;
    }

    public void setTag(String tag) {
        this.tag = tag;
    }

    public String getCreattime() {
        return creattime;
    }

    public void setCreattime(String creattime) {
        this.creattime = creattime;
    }

    public String getFolderid() {
        return folderid;
    }

    public void setFolderid(String folderid) {
        this.folderid = folderid;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
