package com.ggs.dao;

import com.ggs.model.PageModel;
import com.ggs.model.ProgressModel;
import com.ggs.util.DateUtil;
import com.ggs.util.NullUtil;
import com.ggs.util.SQLiteUtil;

import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 * User: ggs
 * Date: 12-8-22
 * Time: 上午10:14
 * To change this template use File | Settings | File Templates.
 */
public class ProgressDao {
    private SQLiteUtil sqLiteUtil = new SQLiteUtil();

    /**
     * 进程列表
     * */
    public PageModel getProgressList(ProgressModel model){
        StringBuilder sql = new StringBuilder();
        sql.append(" select * from (");
        sql.append(" select a.*,b.realname,c.cname prjname,d.realname creatname");
        sql.append( " from t_progress a ");
        sql.append(" left join t_user b on a.userid=b.id");
        sql.append(" left join t_project c on a.prjid=c.id");
        sql.append(" left join t_user d on a.creatid=d.id");
        sql.append(" ) where 1=1 ");
        //按周期
        if(NullUtil.isNotNull(model.getStartdate())){
            sql.append(" and (substr(startdate,1,7)='"+model.getStartdate()+"' or (substr(enddate,1,7)>='"+model.getStartdate()+"' and substr(startdate,1,7)<='"+model.getStartdate()+"'))") ;
        }

        //按项目
        if(NullUtil.isNotNull(model.getPrjid())){
            sql.append(" and prjid="+model.getPrjid());
        }
        //我负责的进程
        if(NullUtil.isNotNull(model.getUserid())){
            sql.append(" and userid="+model.getAdminId());
        }

        //我创建的进程
        if(NullUtil.isNotNull(model.getCreatid())){
            sql.append(" and creatid="+model.getCreatid());
        }

        //关键字查询
        if(NullUtil.isNotNull(model.getCname())){
            sql.append(" and cname like '%"+model.getCname()+"%'")  ;
        }




        //排序
        if(NullUtil.isNotNull(model.getSort())){
            sql.append(" order by "+model.getSort()+" "+model.getOrder());
        } else{
            //按周期升序
            sql.append(" order by pc asc,enddate desc,priority desc ");
        }

        List rows = this.sqLiteUtil.queryForList("select * from ("+sql+") limit "+model.getRows()+" offset "+(model.getPage()-1)*model.getRows());
        int total = this.sqLiteUtil.queryForInt("select count(*) from ("+sql+")");
        PageModel pageModel = new PageModel();
        pageModel.setRows(rows);
        pageModel.setTotal(total);
        return pageModel;
    }

    /**
     * 获取一个进程
     * */
    public Map getProgressById(ProgressModel model){
        return sqLiteUtil.queryForMap("select * from t_progress where id="+model.getProid());
    }

    /**
     * 更新进程
     * */
    public void updateProgress(ProgressModel model){
        this.sqLiteUtil.update("update t_progress set cname=?,userid=?,startdate=?,enddate=?,pc=?,memo=?,prjid=?,realdate=?,updatetime=?,priority=?,difficulty=? " +
                "where id=?",new Object[]{
                model.getCname(),
                model.getUserid(),
                model.getStartdate(),
                model.getEnddate(),
                model.getPc(),
                model.getMemo(),
                model.getPrjid(),
                model.getRealdate(),
                DateUtil.getDate("yyyy-MM-dd HH:mm"),
                model.getPriority(),
                model.getDifficulty(),
                model.getProid()
        });
    }

    /**
     * 添加进程
     * */
    public void saveProgress(ProgressModel model){
        this.sqLiteUtil.update("insert into t_progress (cname,userid,startdate,enddate,pc,memo,prjid,realdate,creatid,creattime,priority,difficulty) " +
                "values(?,?,?,?,?,?,?,?,?,?,?,?)",new Object[]{
                model.getCname(),
                model.getUserid(),
                model.getStartdate(),
                model.getEnddate(),
                model.getPc(),
                model.getMemo(),
                model.getPrjid(),
                model.getRealdate(),
                model.getAdminId(),
                DateUtil.getDate("yyyy-MM-dd HH:mm") ,
                model.getPriority(),
                model.getDifficulty()
        });
    }

    /**
     * 获取进程中年月
     * */
    public List getProgressDateList(){
        return sqLiteUtil.queryForList("select distinct substr(startdate,1,7) yearmonth from t_progress order by yearmonth desc");
    }

    /**
     * 获取项目列表
     * */
    public List getProjectList(){
        return sqLiteUtil.queryForList("select * from t_project");
    }

    /**
     * 删除进程
     * */
    public void delProgress(String id){
        this.sqLiteUtil.update("delete from t_progress where id=?",new Object[]{id});
    }


    /**
     * 获取用户进程情况
     * */
    public List getUserProgress(){
        return this.sqLiteUtil.queryForList("select * from v_user_progress");
    }


}
