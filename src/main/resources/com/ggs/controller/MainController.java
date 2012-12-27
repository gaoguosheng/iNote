package com.ggs.controller;

import com.ggs.dao.NoteDao;
import com.ggs.model.*;
import com.ggs.util.NullUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * Created with IntelliJ IDEA.
 * User: ggs
 * Date: 12-10-17
 * Time: 下午4:31
 * To change this template use File | Settings | File Templates.
 */
@Controller
@RequestMapping("/")
public class MainController extends BaseController {
    private NoteDao noteDao = new NoteDao();
    private StringBuilder folderTree;
    private List<Map<String,String>> treeList;

    /**
     * 获取文件夹
     * */
    @RequestMapping("/main/getFolders")
    @ResponseBody
    public Object getFolders(FolderModel model,HttpSession session){
        UserModel user = (UserModel)session.getAttribute("adminModel");
        model.setAdminId(user.getUserid());
        List<Map<String,String>> itemList = noteDao.getFolders(model);
        List jsonList =new ArrayList();
        for(Map<String,String >item:itemList){
            Map map  = new HashMap();
            map.put("id",item.get("id"));
            map.put("name",item.get("cname"));
            map.put("pId",item.get("upid"));
            map.put("upid",item.get("upid"));
            map.put("username",item.get("username"));
            map.put("icon","images/folder.png");
            map.put("isvisable",item.get("isvisable"));
            jsonList.add(map);
        }
        return toJson(jsonList);
    }


    /**
     * 获取笔记
     * */
    @RequestMapping("/main/getArticles")
    @ResponseBody
    public Object getArticles(ArticleModel model,FolderModel folderModel,HttpSession session){
        UserModel user = (UserModel)session.getAttribute("adminModel");
        model.setAdminId(user.getUserid());
        folderModel.setAdminId(user.getUserid());
        if(NullUtil.isNull(model.getFolderid())){
            folderModel.setUpid("0");
        }else{
            folderModel.setUpid(model.getFolderid());
        }
        String tree  =this.getAllFolders(folderModel);
        model.setFoldertree(tree);

        List<Map<String,String>> itemList = noteDao.getArticles(model);
        List jsonList =new ArrayList();
        for(Map<String,String >item:itemList){
            Map map  = new HashMap();
            map.put("id",item.get("id"));
            map.put("name",this.substr(item.get("title"), 18));
            String icon="images/note.png";
            if(NullUtil.isNotNull(item.get("assignid"))){
                if(item.get("status").equals("0")){
                    icon="images/denied.png";
                }else if(item.get("status").equals("1")){
                    icon="images/shortkey.png";
                }else if(item.get("status").equals("2")){
                    icon="images/ok.png";
                }
            }
            map.put("icon",icon);
            map.put("isvisable",item.get("isvisable"));

            jsonList.add(map);
        }
        return toJson(jsonList);
    }

    /**
     * 获取笔记日历模式
     * */
    @RequestMapping("/main/getArticlesByDay")
    @ResponseBody
    public Object getArticlesByDay(ArticleModel model,FolderModel folderModel,HttpSession session){
        UserModel user = (UserModel)session.getAttribute("adminModel");
        model.setAdminId(user.getUserid());
        folderModel.setAdminId(user.getUserid());
        String tree="";
        if(NullUtil.isNull(model.getFolderid())){
            folderModel.setUpid("0");
        }else{
            folderModel.setUpid(model.getFolderid());
        }
        tree=this.getAllFolders(folderModel);
        model.setFoldertree(tree);
        PageModel pageModel = noteDao.getArticlesGridData(model);
        return toJson(pageModel);
    }

    /**
     * 获取文章内容
     * */
    @RequestMapping("/main/getContent")
    @ResponseBody
    public Object getContent(ArticleModel model,HttpSession session){
        UserModel user = (UserModel)session.getAttribute("adminModel");
        model.setAdminId(user.getUserid());
        Map item = noteDao.getArticle(model);
        return toJson(item);
    }

    /**
     * 保存文章内容
     * */
    @RequestMapping("/main/saveArticle")
    public void saveArticle(ArticleModel model,HttpSession session){
        UserModel user = (UserModel)session.getAttribute("adminModel");
        model.setAdminId(user.getUserid());
        //保存文章
        if(NullUtil.isNotNull(model.getId())){
            noteDao.updateArticle(model);
        }else{
            noteDao.saveArticle(model);
        }
    }
    /**
     * 删除文章内容
     * */
    @RequestMapping("/main/delArticle")
    public void delArticle(ArticleModel model){
        //删除文章
        noteDao.delArticle(model.getId());
    }

    /**
     * 保存文件夹
     * */
    @RequestMapping("/main/saveFolder")
    public void saveFolder(FolderModel model,HttpSession session){
        UserModel user = (UserModel)session.getAttribute("adminModel");
        model.setAdminId(user.getUserid());
        noteDao.saveFolder(model);
    }
    /**
     * 修改文件夹
     * */
    @RequestMapping("/main/updateFolder")
    public void updateFolder(FolderModel model){
        noteDao.updateFolder(model);
    }

    /**
     * 删除文件夹
     * */
    @RequestMapping("/main/delFolder")
    public void delFolder(FolderModel model){
        noteDao.delFolder(model.getFolderid());
    }

    /**
     * 修改密码
     * */
    @RequestMapping("/main/updatePwd")
    public void updatePwd(HttpSession session,String password){
        UserModel user = (UserModel)session.getAttribute("adminModel");
        noteDao.updatePwd(user.getUserid(), password);
    }



    /**
     * 显示文章
     * */
    @RequestMapping("/show")
    public String show(ArticleModel model,HttpServletRequest request,HttpSession session){
        UserModel user = (UserModel)session.getAttribute("adminModel");
        if(NullUtil.isNotNull(user))
            model.setAdminId(user.getUserid());
        Map item = noteDao.getArticle(model);
        request.setAttribute("item",item);
        List articleViews = this.noteDao.getArticleViews(model);
        request.setAttribute("articleViews",articleViews);
     return "show";
    }


    /**
     * 获取用户
     * */
    @RequestMapping("/main/getUsers")
    @ResponseBody
    public Object getUsers(){
        List userList =  this.noteDao.getUsers();
        return toJson(userList);
    }


    /**
     * 获取最大id
     * */
    @RequestMapping("/main/getMaxId")
    @ResponseBody
    public Object getMaxId(String tbName){
        int id = this.noteDao.getMaxId(tbName);
        Map json = new HashMap();
        json.put("maxid",id);
        return toJson(json);
    }


    /**
     * 更改文件夹父亲
     * */
    @RequestMapping("/main/changeFolderParent")
    public void changeFolderParent(String id,String upid){
        this.noteDao.changeFolderParent(id,upid);
    }


    /**
     *    更改文章父亲
     * */
    @RequestMapping("/main/changeArticleParent")
    public void changeArticleParent(String id,String folderid){
        this.noteDao.changeArticleParent(id,folderid);
    }

    /**
     *  更改文件夹是否显示
     * */
    @RequestMapping("/main/changeFolderVisable")
    public void changeFolderVisable(String folderid){
        this.noteDao.changeFolderVisable(folderid);
    }

    /**
     *    更改文章是否显示
     * */
    @RequestMapping("/main/changeArticleVisable")
    public void changeArticleVisable(String articleid){
        this.noteDao.changeArticleVisable(articleid);
    }

    /**
     *   更新笔记状态
     * */
    @RequestMapping("/main/updateArticleStatus")
    public void updateArticleStatus(ArticleModel model){
        this.noteDao.updateArticleStatus(model);
    }

    /**
     *  获取我的状态统计
     * */
    @RequestMapping("/main/getMyStatusCount")
    @ResponseBody
    public Object getMyStatusCount(HttpSession session){
        UserModel user = (UserModel)session.getAttribute("adminModel");
        List list =this.noteDao.getMyStatusCount(user.getUserid());
        return toJson(list);
    }


    /**
     *   转派人
     * */
    @RequestMapping("/main/updateAssign")
    public void updateAssign(String articleid,String assignid){
        this.noteDao.updateAssign(articleid,assignid);
    }


    /**
     *  继续处理
     * */
    @RequestMapping("/main/returnAssign")
    public void returnAssign(String articleid){
        this.noteDao.returnAssign(articleid);
    }

    /**
     *    获取在线人员
     * */
    @RequestMapping("/main/getOnlineList")
    @ResponseBody
    public Object getOnlineList(HttpSession session){
        Set onlineList =(Set) session.getServletContext().getAttribute("onlineList");
        return toJson(onlineList);
    }


    /**
     *     更新全部阅读状态
     * */
    @RequestMapping("/main/updateReadAllFlag")
    public void updateReadAllFlag(HttpSession session){
        UserModel user = (UserModel)session.getAttribute("adminModel");
        this.noteDao.updateReadAllFlag(user.getUserid());
    }


    /**
     *  添加评论
     * */
    @RequestMapping("/main/addComment")
    public void addComment(CommentModel model){
        this.noteDao.addComment(model);
    }

    /**
     *  获取评论列表
     * */
    @RequestMapping("/main/getCommentList")
    @ResponseBody
    public Object getCommentList(String articleid){
        List itemList= this.noteDao.getCommentList(articleid);
        return toJson(itemList);
    }

    /**
     *   获取顶部统计
     * */
    @RequestMapping("/main/getTopCount")
    @ResponseBody
    public Object getTopCount(HttpSession session){
        UserModel user = (UserModel)session.getAttribute("adminModel");
        List itemList = this.noteDao.getTopCount(user.getUserid());
        return toJson(itemList);
    }

    /**
     * 更新文章类型
     * */
    @RequestMapping("/main/updateCsort")
     public void updateCsort(String folderid,String csort){
        folderTree = new StringBuilder();
        treeList=this.noteDao.getAllFolders();
        folderTree.append(folderid);
        folderTree.append(",");
        getFolders(folderid);
        String folderids= folderTree.substring(0,folderTree.length()-1);
        this.noteDao.updateCsort(folderids,csort);
    }


    /**
     * 截取字符串
     * */
    private String substr(String str,int bit){
        String result = "";
        if(bit>str.length()){
            return str;
        }else{
            result=str.substring(0,bit);
        }
        return result;
    }

    /**
     * 递归文件夹
     * */
    private  String getAllFolders(FolderModel model){
        if(NullUtil.isNotNull(model.getUpid())){
            folderTree = new StringBuilder();
            treeList=this.noteDao.getFolders(model);
            folderTree.append(model.getUpid());
            folderTree.append(",");
            getFolders(model.getUpid());
            return folderTree.substring(0,folderTree.length()-1);
        }
        return null;
    }

    /**
     * 递归文件夹
     * */
    private void getFolders(String upid){
        for(Map<String,String>item:treeList){
            if(item.get("upid").equals(upid)){
                String id = item.get("id");
                folderTree.append(id);
                folderTree.append(",");
                getFolders(id);
            }
        }
    }
}
