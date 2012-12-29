package com.ggs.dao;

import com.ggs.comm.Config;
import com.ggs.model.*;
import com.ggs.util.DateUtil;
import com.ggs.util.NullUtil;
import com.ggs.util.PinYinUtil;
import com.ggs.util.SQLiteUtil;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 * User: ggs
 * Date: 12-5-25
 * Time: 下午4:36
 * To change this template use File | Settings | File Templates.
 */
public class NoteDao {

    private SQLiteUtil sqLiteUtil = new SQLiteUtil();

    private List<Map<String,String>> treeList;
    private StringBuilder folderTree;

    /**
     * 更新文章状态
     * */
    public void updateCsort(String folderids,String csort){
        this.sqLiteUtil.update("update t_article set csort="+csort+" where folderid in ("+folderids+")");
    }

    /**
     * 获取所有文件夹
     * */
    public List getAllFolders(){
        return sqLiteUtil.queryForList("select * from t_folder");
    }

    /**
     * 获取文件夹
     * */
    public List getFolders(FolderModel model){
        StringBuilder sql = new StringBuilder();
        sql.append(" select a.*,b.username from t_folder a left join t_user b on a.userid=b.id where 1=1");

        if(NullUtil.isNotNull(model.getAdminId())){
            if(NullUtil.isNotNull(model.getUserid())){
                sql.append(" and userid="+model.getUserid());
                if(!model.getUserid().equals(model.getAdminId())){
                    //他人
                    //只显示可见
                    String folderids=this.getNotVisableFolders();
                    if(NullUtil.isNotNull(folderids)){
                        sql.append(" and a.id not in("+folderids+")");
                    }
                }
            }

        }

        sql.append(" order by fspell");
        return this.sqLiteUtil.queryForList(sql.toString());
    }

    /**
     * 获取文章
     * */

    public List getArticles(ArticleModel model){
        StringBuilder sql = new StringBuilder();
        sql.append(" select id,title,status,assignid,isvisable");
        sql.append(" from t_article where 1=1 ");

        if(NullUtil.isNotNull(model.getAdminId())){
            if(NullUtil.isNotNull(model.getUserid())){
                sql.append(" and folderid in (select id from t_folder where userid="+model.getUserid()+")") ;
                if(!model.getUserid().equals(model.getAdminId())){
                    //他人只显示可见
                    sql.append(" and isvisable=1");
                    String folderids=this.getNotVisableFolders();
                    if(NullUtil.isNotNull(folderids)){
                        sql.append(" and folderid not in("+folderids+")");
                    }
                }
            }
        }



        if(NullUtil.isNotNull(model.getFoldertree())){
            sql.append(" and folderid in ("+model.getFoldertree()+")");
        }

        if(NullUtil.isNotNull(model.getTitle())){
            sql.append(" and title like '%"+model.getTitle()+"%'");
        }
        //创建时间查询
        if(NullUtil.isNotNull(model.getCreattime1())){
            sql.append(" and creattime>='"+model.getCreattime1()+" 00:00'");

        }
        //创建时间查询
        if(NullUtil.isNotNull(model.getCreattime2())){
            sql.append(" and creattime<='"+model.getCreattime2()+" 23:59'");
        }
        sql.append(" order by creattime desc,id desc");
        return this.sqLiteUtil.queryForList(sql.toString());
    }

    /**
     * 获取文章
     * */
    public Map getArticle(ArticleModel model){

         if(NullUtil.isNotNull(model.getAdminId())){
             //如有登陆插入阅读状态
             //检测是否阅读过
             int counter =this.sqLiteUtil.queryForInt("select count(*) from t_article_views where articleid=? and userid=?",new Object[]{model.getId(),model.getAdminId()});
             if(counter==0){
                 this.sqLiteUtil.update("insert into t_article_views (articleid,userid) values(?,?)",new Object[]{model.getId(),model.getAdminId()});
             }
             //自己不记数
             this.sqLiteUtil.update("update t_article set views=views+1 where id=? and id not in (select id from t_article where folderid in (select id from t_folder where userid=?))",new Object[]{model.getId(),model.getAdminId()});
         } else{
             //匿名记数
             this.sqLiteUtil.update("update t_article set views=views+1 where id=? ",new Object[]{model.getId()});
         }

         return this.sqLiteUtil.queryForMap("select a.*,d.realname assignname,b.userid,b.cname foldername,c.username,c.realname from t_article a left join t_folder b on a.folderid=b.id left join t_user c on b.userid=c.id left join t_user d on a.assignid=d.id where a.id=" + model.getId());
    }

    /**
     * 新增文章
     * */
    public void saveArticle(ArticleModel model){
        String sql="insert into t_article (title,tag,content,creattime,folderid,assignid,priority,csort,buglevel) values(?,?,?,?,?,?,?,?,?)";
        this.sqLiteUtil.update(sql,new Object[]{
            model.getTitle(),
            model.getTag(),
            model.getContent(),
            this.getDate(),
            model.getFolderid(),
            NullUtil.isNotNull(model.getAssignid())?model.getAssignid():null ,
            model.getPriority(),
            model.getCsort()    ,
                model.getBuglevel()
        }) ;
    }

    /**
     * 更新文章
     * */
    public void updateArticle(ArticleModel model){
        String sql="update t_article set title=?,tag=?,content=?,updatetime=?,assignid=?,priority=?,buglevel=? where id=?";
        this.sqLiteUtil.update(sql,new Object[]{
                model.getTitle(),
                model.getTag(),
                model.getContent(),
                this.getDate(),
                NullUtil.isNotNull(model.getAssignid())?model.getAssignid():null,
                model.getPriority(),
                model.getBuglevel(),
                model.getId()
        }) ;
    }

    /**
     * 获取当前日期
     * */
    private String getDate(){
        return new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date());
    }

    /**
     * 检查登陆
     * */
    public boolean checkLogin(String username,String password){
        StringBuilder sql = new StringBuilder();
        sql.append(" select count(*) from t_user where flag=1 ");
        sql.append(" and ((username=? and password=?) ");
        sql.append(" or (mobile=? and password=?)");
        sql.append(" or (qq=? and password=?))");
       int counter =this.sqLiteUtil.queryForInt(sql.toString(),new Object[]{
               username,password,
               username,password,
               username,password
       });
       return counter>0?true:false;
    }

    /**
     * 检查登陆
     * */
    public boolean checkLoginFlag(String username){
        int counter =this.sqLiteUtil.queryForInt("select count(*) from t_user where flag=1 and (username=? or mobile=? or qq=?)",new Object[]{
                username ,username,username
        });
        return counter>0?true:false;
    }

   /**
    * 获取用户id
    * */
    public String getUserId(String userName){
        return this.sqLiteUtil.queryForMap("select id from t_user where username=?",new Object[]{userName}).get("id").toString();
    }

    /**
     * 删除文章
     * */
    public void delArticle(String id){
       this.sqLiteUtil.update("delete from t_article where id="+id);
    }

    /**
     * 添加文件夹
     * */
    public void saveFolder(FolderModel model){
       String spell = PinYinUtil.cn2FirstSpell(model.getFoldername()).toLowerCase();
       this.sqLiteUtil.update("insert into t_folder (cname,upid,userid,fspell) values(?,?,?,?)",new Object[]{
               model.getFoldername(),
               model.getUpid(),
               model.getAdminId(),
               spell
       });
    }
    /**
     * 修改文件夹
     * */
    public void updateFolder(FolderModel model){
        String spell = PinYinUtil.cn2FirstSpell(model.getFoldername()).toLowerCase();
        this.sqLiteUtil.update("update t_folder set cname=?,fspell=? where id=?",new Object[]{
                model.getFoldername(),
                spell,
                model.getFolderid()
        });
    }
    /**
     * 删除文件夹
     * */
    public void delFolder(String id){
        String []sqls =new String[]{
                "delete from t_article where folderid="+id,
                "delete from t_folder where upid="+id,
                "delete from t_folder where id="+id
        };
        this.sqLiteUtil.batchUpdate(sqls);
    }

    /**
     * 修改密码
     * */

    public void updatePwd(String userid,String password){
        this.sqLiteUtil.update("update t_user set password=? where id=?",new Object[]{password,userid});
    }

    /**
     * 注册用户
     * */
    public boolean reg(String username,String password,String realname){
        int counter = this.sqLiteUtil.queryForInt("select count(*) from t_user where username=?",
                new Object[]{username});
        if(counter==0){
            this.sqLiteUtil.update("insert into t_user (username,password,realname) values(?,?,?)",
                    new Object[]{username,password,realname});
            return true;
        }else{
            return false;
        }
    }

    /**
     * 获取用户列表
     * */
    public List getUsers(){
       return this.sqLiteUtil.queryForList("select * from t_user where flag=1 and username!='admin'");
    }

    /**
     * 获取最大id
     * @param  name 表名
     *
     * */
    public int getMaxId(String name){
        return this.sqLiteUtil.queryForInt("select max(id) from "+name);
    }

    /**
     * 更改父文件夹
     * */
    public void changeFolderParent(String id,String upid){
        this.sqLiteUtil.update("update t_folder set upid=? where id=?",new Object[]{upid,id});
    }

    /**
     * 更改文章父文件夹
     * */
    public void changeArticleParent(String id,String folderid){
        this.sqLiteUtil.update("update t_article set folderid=? where id=?",new Object[]{folderid,id});
    }
    /**
     * 更改文件夹是否显示
     * */
    public void changeFolderVisable(String id){
        Map<String,String> folder =  this.sqLiteUtil.queryForMap("select isvisable from t_folder where id="+id);
        String isvisable = folder.get("isvisable").equals("1")?"0":"1";
        this.sqLiteUtil.update("update t_folder set isvisable="+isvisable+" where id="+id);
    }
    /**
     * 更改文章是否显示
     * */
    public void changeArticleVisable(String id){
        Map<String,String> folder =  this.sqLiteUtil.queryForMap("select isvisable from t_article where id="+id);
        String isvisable = folder.get("isvisable").equals("1")?"0":"1";
        this.sqLiteUtil.update("update t_article set isvisable="+isvisable+" where id="+id);
    }

   /**
    * 获取用户bean
    * */
    public UserModel getUserModel(String username){
        UserModel model = new UserModel();
        Map<String,String> map = this.sqLiteUtil.queryForMap("select * from t_user where (username=? or mobile=? or qq=?)",new Object[]{username,username,username});
        model.setUserid(map.get("id"));
        model.setRealname(map.get("realname"));
        model.setUsername(map.get("username"));
        model.setPassword(map.get("password"));
        model.setFlag(map.get("flag"));
        model.setOnlinetimes(map.get("onlinetimes"));
        model.setMobile(map.get("mobile"));
        model.setQq(map.get("qq"));
        return model;
    }

    /**
     * 获取不显示的文件夹 递归
     * */
    private  String getNotVisableFolders(){
      folderTree = new StringBuilder();
      List<Map<String,String>>vList = this.sqLiteUtil.queryForList("select * from t_folder where isvisable=0");
      if(vList.size()==0){
          return null;
      }
      treeList=this.sqLiteUtil.queryForList("select * from t_folder");
      for(Map<String,String>item:vList){
          String id =item.get("id");
          folderTree.append(id);
          folderTree.append(",");
          getFolders(id);
      }

      return folderTree.substring(0,folderTree.length()-1);

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


    /**
     * 更新拼音
     * */
    public void updateFolderSpell(){
        List <Map<String,String>> list =  this.sqLiteUtil.queryForList("select * from t_folder");
        for(Map<String,String>map:list){
            String id = map.get("id");
            String cname= map.get("cname");
            String spell = PinYinUtil.cn2FirstSpell(cname).toLowerCase();
            this.sqLiteUtil.update("update t_folder set fspell=? where id=?",new Object[]{spell,id});
        }
    }


    /**
     * 获取模板
     * */
    public List getTemplates(String folderid){
        return this.sqLiteUtil.queryForList("select * from t_article where folderid=?",new Object[]{folderid}) ;
    }

    /**
     * 获取文章  日历模式
     * */
    public PageModel getArticlesGridData(ArticleModel model){
        StringBuilder sql = new StringBuilder();
        //sql.append(" select ifnull(f.commentCount,0)commentCount,ifnull(e.articleid,0) isread ,a.id,a.title,a.creattime,a.updatetime,a.status,a.assignid,a.priority,a.folderid,a.processtime,a.finishtime,a.views,a.buglevel,");
        sql.append(" select ifnull(e.articleid,0) isread,a.id,a.title,a.creattime,a.updatetime,a.status,a.assignid,a.priority,a.folderid,a.processtime,a.finishtime,a.views,a.buglevel,");
        sql.append(" b.userid,b.cname foldername,c.username,c.realname,d.realname assigname  from t_article a left join t_folder b on a.folderid=b.id");
        sql.append(" left join t_user c on b.userid=c.id");
        sql.append(" left join t_user d on a.assignid=d.id");
        sql.append(" left join (select articleid from t_article_views where userid="+model.getAdminId()+")e on a.id=e.articleid");
        //sql.append(" left join (select articleid,count(*)commentCount from t_article_comments group by articleid) f on a.id=f.articleid");
        sql.append(" where 1=1");
        //递归树
        if(NullUtil.isNotNull(model.getFoldertree())){
            sql.append(" and a.folderid in ("+model.getFoldertree()+")");
        }
        //状态
        if(NullUtil.isNotNull(model.getAssignid())&& NullUtil.isNotNull(model.getStatus())){
            if(model.getStatus().equals("2")){
                sql.append(" and b.userid="+model.getAdminId()+" and assignid is not null");
            }else if(model.getStatus().equals("1")){
                sql.append(" and a.assignid="+model.getAssignid()+" and a.status>=1");
            }else{
                sql.append(" and ((a.assignid="+model.getAssignid()+" and a.status=0)");
                sql.append(" or (b.userid="+model.getAdminId()+" and a.status=1))");
            }
        }
        //状态
        if(NullUtil.isNull(model.getAssignid()) && NullUtil.isNotNull(model.getStatus())){
            sql.append(" and a.assignid is not null and  a.status="+model.getStatus());
        }

        //创建时间查询
        if(NullUtil.isNotNull(model.getCreattime1())){
            sql.append(" and creattime>='"+model.getCreattime1()+" 00:00'");

        }
        //创建时间查询
        if(NullUtil.isNotNull(model.getCreattime2())){
            sql.append(" and creattime<='"+model.getCreattime2()+" 23:59'");
        }
        //按用户查询
        if(NullUtil.isNotNull(model.getUserid())){
            sql.append(" and folderid in (select id from t_folder where userid="+model.getUserid()+")");
        }
        //本人可见所有，他人仅见本身及共享的笔记
        if(NullUtil.isNotNull(model.getAdminId())){
                sql.append(" and ((folderid in (select id from t_folder where userid="+model.getAdminId()+")) ") ;
                sql.append(" or ( folderid in (select id from t_folder where userid!="+model.getAdminId()+") ") ;
                    String folderids=this.getNotVisableFolders();
                    if(NullUtil.isNotNull(folderids)){
                        sql.append(" and folderid not in("+folderids+") and a.isvisable=1");
                    }
                sql.append("))");
        }

        //未读
        if(NullUtil.isNotNull(model.getIsread())){
            sql.append(" and isread=0");
        }
        //按标题查询
        if(NullUtil.isNotNull(model.getTitle())){
            sql.append(" and title like '%"+model.getTitle()+"%'");
        }

        //按内容查询
        if(NullUtil.isNotNull(model.getContent())){
            sql.append(" and content like '%"+model.getContent()+"%'");
        }

        //评论我的笔记
        if(NullUtil.isNotNull(model.getHascomment())){
            sql.append(" and (userid="+model.getAdminId()+" and a.id in(select articleid from t_article_comments))");
        }

        //被我评论的笔记
        if(NullUtil.isNotNull(model.getHasmycomment())){
            sql.append(" and a.id in (select articleid from t_article_comments where userid="+model.getAdminId()+")");
        }

        //查出分类笔记
        if(NullUtil.isNotNull(model.getCsort())){
            sql.append(" and a.csort="+model.getCsort());
        }




        //排序
        if(NullUtil.isNotNull(model.getSort())){
            sql.append(" order by "+model.getSort()+" "+model.getOrder());
        } else{
            sql.append(" order by a.creattime desc,a.id desc");
        }


        List rows = this.sqLiteUtil.queryForList("select * from ("+sql+") limit "+model.getRows()+" offset "+(model.getPage()-1)*model.getRows());
        int total = this.sqLiteUtil.queryForInt("select count(*) from ("+sql+")");
        PageModel pageModel = new PageModel();
        pageModel.setRows(rows);
        pageModel.setTotal(total);
        return pageModel;
    }

    /**
     * 更新笔记状态
     * */
    public void updateArticleStatus(ArticleModel model){
        Map <String,String>map = this.sqLiteUtil.queryForMap("select status from t_article where id=?",new Object[]{model.getId()});
        if(map.get("status").equals("0")){
            this.sqLiteUtil.update("update t_article set status=1,processtime=?,assigninfo=? where id=?",new Object[]{this.getDate(),model.getContent(),model.getId()});
        }else if(map.get("status").equals("1")){
            this.sqLiteUtil.update("update t_article set status=2,finishtime=?,finishinfo=? where id=?",new Object[]{this.getDate(),model.getContent(),model.getId()});
        }
    }
    /**
     * 获取我的状态统计
     * */
    public List getMyStatusCount(String adminid){
        StringBuilder filterSql=  new StringBuilder();
        filterSql.append(" and ((folderid in (select id from t_folder where userid="+adminid+")) ") ;
        filterSql.append(" or ( folderid in (select id from t_folder where userid!="+adminid+") ") ;
        String folderids=this.getNotVisableFolders();
        if(NullUtil.isNotNull(folderids)){
            filterSql.append(" and folderid not in("+folderids+") and isvisable=1");
        }
        filterSql.append("))");

        StringBuilder sql = new StringBuilder();
        //默认状态 0：未处理，1：已处理，2：已完成
        sql.append("SELECT status,count(*)counter FROM t_article where assignid is not null group by status");

        //我未处理：包括指牌我未处理，与我指牌已处理待确认
        sql.append(" union");
        sql.append(" SELECT 10 status,count(*)counter  FROM (select a.*,b.userid from t_article a  left join t_folder b on a.folderid=b.id ) t where (t.assignid="+adminid+" and t.status=0) or (t.userid="+adminid+" and t.status=1)");

        //我已处理
        sql.append(" union ");
        sql.append(" select 11 status,count(*)counter from t_article where assignid="+adminid+" and status>=1");
        //我发起的事项                                                                                                                                                     \
        sql.append(" UNION");
        sql.append(" select 12 status,count(*)counter from(");
        sql.append(" select a.*,b.userid from t_article a");
        sql.append(" left join t_folder b on a.folderid=b.id )t where t.userid="+adminid+" and assignid is not null");
        //我的笔记
        sql.append(" union ");
        sql.append(" select 13 status,count(*)counter from (");
        sql.append(" select a.*,b.userid from t_article a");
        sql.append(" left join t_folder b on a.folderid=b.id )t where t.userid="+adminid);
        //今天笔记
        sql.append(" union");
        sql.append(" select 14,count(*)counter from t_article where substr(creattime,0,11)='"+DateUtil.getDate("yyyy-MM-dd")+"'  "+filterSql);
        //全部笔记
        sql.append(" union");
        sql.append(" select 15, count(*) counter from t_article where 1=1 "+filterSql);
        //我未读的笔记
        sql.append(" union");
        sql.append(" select 16,count(*) counter from t_article where id not in(select articleid from t_article_views where userid="+adminid+") "+filterSql);
        //我被评论的笔记
        sql.append(" union");
        sql.append(" select 17 ,count(*)counter from (");
        sql.append(" select a.*,b.userid from t_article a");
        sql.append(" left join t_folder b on a.folderid=b.id )t where t.userid="+adminid+" and t.id in(select articleid from t_article_comments)");
        //被我评论的笔记
        sql.append(" union");
        sql.append(" select 18,count(*) from (select distinct articleid from t_article_comments where userid="+adminid+")");

        return this.sqLiteUtil.queryForList(sql.toString());
    }

    /**
     * 转派人
     * */
    public void updateAssign(String articleid,String assignid){
        StringBuilder sql = new StringBuilder() ;
        sql.append("update t_article set assignid=? where id=?");
        this.sqLiteUtil.update(sql.toString(),new Object[]{assignid,articleid});

    }

    /**
     * 回退继续处理
     * */
    public void returnAssign(String articleid){
        this.sqLiteUtil.update("update t_article set status=0,processtime=null where id=?",new Object[]{articleid});
    }

    /**
     * 更新在线时长
     * */
    public void updateOnlinetimes(String adminid,long times){
        this.sqLiteUtil.update("update t_user set onlinetimes=onlinetimes+"+times+" where id=?",new Object[]{adminid});
    }




    /**
     * 获取文章阅读列表
     * */
    public List getArticleViews(ArticleModel model){
       return this.sqLiteUtil.queryForList("select a.*,b.realname from t_article_views a left join t_user b on a.userid=b.id where a.articleid=?",
               new Object[]{model.getId()});
    }

    /**
     * 更改全部阅读状态
     * */
    public void updateReadAllFlag(String adminid){
        String sql ="insert into t_article_views select id,"+adminid+" from t_article where id not in (select articleid from t_article_views where userid="+adminid+")";
        this.sqLiteUtil.update(sql);
    }

    /**
     * 添加评论
     * */
    public void addComment(CommentModel model){
        String sql="insert into t_article_comments (userid,articleid,content,creattime) values(?,?,?,?)";
        this.sqLiteUtil.update(sql,new Object[]{
                model.getUserid(),
                model.getArticleid(),
                model.getContent(),
                DateUtil.getDate("yyyy-MM-dd HH:mm")
        });
    }

    /**
     * 获取评论列表
     *  */
    public List getCommentList(String articleid){
        String sql = "select a.*,b.realname from t_article_comments a left join t_user b on a.userid=b.id where a.articleid="+articleid;
        return this.sqLiteUtil.queryForList(sql);
    }


    /**
     * 统计数量
     * */
    public List getTopCount(String adminid){
        StringBuilder sql = new StringBuilder();
        //未处理事项
        sql.append(" SELECT 1 status ,count(*) counter FROM (select a.*,b.userid from t_article a  left join t_folder b on a.folderid=b.id ) t where (t.assignid="+adminid+" and t.status=0) or (t.userid="+adminid+" and t.status=1)");
        sql.append(" union");
        //未完成进程
        sql.append(" select 2 status,count(*) counter from t_progress where userid="+adminid+" and pc<100");
        sql.append(" union");
        //未解决反馈问题
        sql.append(" select 3 status,count(*) counter from t_bug where status=0");
        return this.sqLiteUtil.queryForList(sql.toString());
    }

   }
