package com.ggs.model;

/**
 * Created with IntelliJ IDEA.
 * User: ggs
 * Date: 12-5-26
 * Time: 下午5:04
 * To change this template use File | Settings | File Templates.
 */
public class FolderModel extends BaseModel {
    private String folderid;
    private String foldername;
    private String upid;
    private String userid;

    public String getFolderid() {
        return folderid;
    }

    public void setFolderid(String folderid) {
        this.folderid = folderid;
    }

    public String getFoldername() {
        return foldername;
    }

    public void setFoldername(String foldername) {
        this.foldername = foldername;
    }

    public String getUpid() {
        return upid;
    }

    public void setUpid(String upid) {
        this.upid = upid;
    }

    public String getUserid() {
        return userid;
    }

    public void setUserid(String userid) {
        this.userid = userid;
    }
}
