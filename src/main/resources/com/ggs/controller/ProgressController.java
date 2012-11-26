package com.ggs.controller;

import com.ggs.dao.ProgressDao;
import com.ggs.model.BugModel;
import com.ggs.model.PageModel;
import com.ggs.model.ProgressModel;
import com.ggs.model.UserModel;
import com.ggs.util.NullUtil;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 * User: ggs
 * Date: 12-10-17
 * Time: 下午2:16
 * To change this template use File | Settings | File Templates.
 */
@Controller
@RequestMapping("/progress")
public class ProgressController extends  BaseController {
    private ProgressDao progressDao = new ProgressDao();

    /**
     * 进程列表
     * */
    @ResponseBody
    @RequestMapping("getProgessList")
    public Object getProgessList(ProgressModel model,HttpSession session){
        UserModel user = (UserModel)session.getAttribute("adminModel");
        if(NullUtil.isNotNull(user))
        model.setAdminId(user.getUserid());
        PageModel pageModel  = progressDao.getProgressList(model);
        return this.toJson(pageModel);
    }

    /**
     * 获取进程
     * */
    @ResponseBody
    @RequestMapping("getProgressById")
    public Object getProgressById(ProgressModel model){
        Map item = this.progressDao.getProgressById(model);
        return this.toJson(item);
    }

    /**
     * 保存进程
     * */
    @RequestMapping("saveProgress")
    public void saveProgress(ProgressModel model ,HttpSession session){
        UserModel user = (UserModel)session.getAttribute("adminModel");
        model.setAdminId(user.getUserid());
        if(NullUtil.isNotNull(model.getProid())){
            this.progressDao.updateProgress(model);
        } else{
            this.progressDao.saveProgress(model);
        }
    }

    /**
     * 获取进程年月列表
     * */
    @ResponseBody
    @RequestMapping("getProgressDateList")
    public Object getProgressDateList(){
        List itemList = this.progressDao.getProgressDateList();
        return this.toJson(itemList);
    }

    /**
     * 获取进程项目列表
     * */
    @ResponseBody
    @RequestMapping("getProjectList")
    public Object getProjectList(){
        List itemList = this.progressDao.getProjectList();
        return this.toJson(itemList);
    }

    /**
     * 删除进程
     * */
    @RequestMapping("delProgress")
    public void delProgress(ProgressModel model){
        this.progressDao.delProgress(model.getProid());
    }


    /**
     * 获取用户进程情况
     * */
    @ResponseBody
    @RequestMapping("getUserProgress")
    public Object getUserProgress(){
        List itemList = this.progressDao.getUserProgress();
        return this.toJson(itemList);
    }

}
