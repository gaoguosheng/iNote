package com.ggs.controller;

import com.ggs.dao.NoteDao;
import com.ggs.model.UserModel;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * Created with IntelliJ IDEA.
 * User: ggs
 * Date: 12-10-17
 * Time: 下午4:17
 * To change this template use File | Settings | File Templates.
 */
@Controller
@RequestMapping("/")
public class LoginController extends  BaseController {
    private NoteDao noteDao = new NoteDao();

    @RequestMapping("login")
    @ResponseBody
    public Object login(UserModel model,HttpSession session,HttpServletResponse response){
        String username = model.getUsername();
        String password = model.getPassword();
        boolean loginFlag= noteDao.checkLoginFlag(username);
        if(!loginFlag){
            Map map = new HashMap();
            map.put("flag",-1);
            return this.toJson(map);
        }
        boolean flag = noteDao.checkLogin(username,password);
        if(flag){
            UserModel userModel = this.noteDao.getUserModel(username);
            session.setAttribute("admin",username);
            session.setAttribute("adminId",userModel.getUserid());
            session.setAttribute("adminModel",userModel);
            Cookie cookie = new Cookie("username",username);
            cookie.setMaxAge(3600*24*30);
            cookie.setPath("/");
            response.addCookie(cookie);
            //登记在线人员
            Set<String> onlineList=(Set)session.getServletContext().getAttribute("onlineList");;
            if(onlineList==null){
                onlineList = new HashSet<String>();
            }
            onlineList.add(userModel.getRealname());
            session.getServletContext().setAttribute("onlineList",onlineList);
        }
        Map map = new HashMap();
        map.put("flag",flag?1:0);
        return this.toJson(map);
    }


    /**
     * 检查是否登陆
     * */
    @RequestMapping("checkLogin")
    @ResponseBody
    public Object checkLogin(HttpSession session){
        int status =0;
        Map json =new HashMap();
        if(session.getAttribute("adminModel")!=null){
            status=1;
        }
        json.put("status",status);
        return this.toJson(json);
    }
}
