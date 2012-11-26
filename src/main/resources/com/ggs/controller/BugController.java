package com.ggs.controller;

import com.ggs.dao.BugDao;
import com.ggs.model.BugModel;
import com.ggs.model.PageModel;
import com.ggs.model.UserModel;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 * User: ggs
 * Date: 12-10-17
 * Time: 下午2:11
 * To change this template use File | Settings | File Templates.
 */
@Controller
@RequestMapping("/bug")
public class BugController extends  BaseController{
    private BugDao bugDao = new BugDao();

    /**
     * 保存bug
     * */
     @RequestMapping("saveBug")
     public void saveBug(BugModel model){
         this.bugDao.saveBug(model);
    }

    /**
     * bug列表
     * */
     @ResponseBody
     @RequestMapping("getBugList")
     public Object getBugList(BugModel model){
         PageModel pageModel = this.bugDao.getBugList(model);
         return this.toJson(pageModel);
    }

    /**
     * 处理bug
     * */
    @RequestMapping("process")
    public void process(BugModel model,HttpSession session){
        UserModel user = (UserModel)session.getAttribute("adminModel");
        model.setAdminId(user.getUserid());
        this.bugDao.process(model);
    }

    /**
     * 获得bug
     * */
    @ResponseBody
    @RequestMapping("getBug")
    public Object getBug(BugModel model){
        Map item  = this.bugDao.getBug(model);
        return this.toJson(item);
    }

    /**
     * 删除bug
     * */
    @RequestMapping("delBug")
    public void delBug(BugModel model){
        this.bugDao.delBug(model);
    }

}
