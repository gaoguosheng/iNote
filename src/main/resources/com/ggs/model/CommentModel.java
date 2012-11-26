package com.ggs.model;

/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 12-8-18
 * Time: 上午8:48
 * To change this template use File | Settings | File Templates.
 */
public class CommentModel extends  BaseModel{
    private String userid;
    private String content;
    private String articleid;
    private String creattime;

    public String getUserid() {
        return userid;
    }

    public void setUserid(String userid) {
        this.userid = userid;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getArticleid() {
        return articleid;
    }

    public void setArticleid(String articleid) {
        this.articleid = articleid;
    }

    public String getCreattime() {
        return creattime;
    }

    public void setCreattime(String creattime) {
        this.creattime = creattime;
    }
}
