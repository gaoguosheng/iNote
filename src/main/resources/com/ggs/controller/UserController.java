package com.ggs.controller;

import com.ggs.dao.UserDao;
import com.ggs.model.BugModel;
import com.ggs.model.PageModel;
import com.ggs.model.UserModel;
import com.ggs.util.NullUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Created with IntelliJ IDEA.
 * User: ggs
 * Date: 12-12-26
 * Time: 下午2:41
 * To change this template use File | Settings | File Templates.
 */
@Controller
@RequestMapping("/user")
public class UserController extends BaseController{

    private UserDao userDao = new UserDao();

    /**
     * 列表
     * */
    @ResponseBody
    @RequestMapping("getUserList")
    public Object getUserList(UserModel model){
        PageModel pageModel = this.userDao.getUserList(model);
        return this.toJson(pageModel);
    }

    /**
     * 保存
     * */
    @RequestMapping("saveUser")
    public void saveUser(UserModel model){
        if(NullUtil.isNotNull(model.getUserid())){
            this.userDao.updateUser(model);
        }else{
            this.userDao.saveUser(model);
        }
    }

    /**
     * 重置密码
     * */
    @RequestMapping("resetPwd")
    public void resetPwd(UserModel model){
        this.userDao.resetPwd(model);
    }

    /**
     * 更新标识
     * */
    @RequestMapping("updateFlag")
    public void updateFlag(UserModel model){
        this.userDao.updateFlag(model);
    }

}
