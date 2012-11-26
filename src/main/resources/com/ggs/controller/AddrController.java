package com.ggs.controller;

import com.ggs.dao.AddrDao;
import com.ggs.model.AddrbookModel;
import com.ggs.model.PageModel;
import com.ggs.model.UserModel;
import com.ggs.util.NullUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 * User: ggs
 * Date: 12-10-17
 * Time: 下午3:12
 * To change this template use File | Settings | File Templates.
 */
@Controller
@RequestMapping("/addr")
public class AddrController extends BaseController {
    private AddrDao addrDao = new AddrDao();
    /**
     * 获取类别
     * */
    @RequestMapping("getClassList")
    @ResponseBody
    public Object getClassList(){
        //获取类别列表
        List<Map<String,String>> itemList = addrDao.getClassList();
        List jsonList = new ArrayList();
        for(Map<String,String> item:itemList){
            Map json = new HashMap();
            json.put("id",item.get("id"));
            json.put("name",item.get("cname"));
            json.put("pId",item.get("upid"));
            jsonList.add(json);
        }
        return this.toJson(jsonList);
    }

    /**
     * 获取联系人列表
     * */
    @RequestMapping("getAddrList")
    @ResponseBody
    public Object getAddrList(AddrbookModel model){
        PageModel pageModel = addrDao.getAddrList(model);
        return this.toJson(pageModel);
    }

    /**
     * 保存通讯录
     * */
    @RequestMapping("saveAddr")
    @ResponseBody
    public Object saveAddr(AddrbookModel model,HttpSession session){
        UserModel user = (UserModel)session.getAttribute("adminModel");
        model.setAdminId(user.getUserid());
        boolean issucc = true;
        try{
            if(NullUtil.isNotNull(model.getId())){
                this.addrDao.updateAddr(model);
            }else{
                this.addrDao.saveAddr(model);
            }

        }catch (Exception e){
            issucc=false;
        }
        Map json = new HashMap();
        json.put("success",issucc);
        return this.toJson(json);
    }

    /**
     * 获取联系人
     * */
    @RequestMapping("getAddr")
    @ResponseBody
    public Object getAddr(AddrbookModel model){
        Map json = this.addrDao.getAddr(model.getId());
        return this.toJson(json);
    }

    /**
     * 删除联系人
     * */
    @RequestMapping("delAddr")
    public void delAddr(AddrbookModel model){
        this.addrDao.delAddr(model.getId());
    }

    /**
     * 恢复联系人
     * */
    @RequestMapping("restoreAddr")
    public void restoreAddr(AddrbookModel model){
        this.addrDao.restoreAddr(model.getId());
    }

    /**
     * 获取通讯录存在的字母列表
     * */
    @RequestMapping("getLetters")
    @ResponseBody
    public Object getLetters(){
        List list = this.addrDao.getLetters();
        return this.toJson(list);
    }
}
