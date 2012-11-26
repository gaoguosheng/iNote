package com.ggs.dao;

import com.ggs.model.BugModel;
import com.ggs.model.PageModel;
import com.ggs.util.DateUtil;
import com.ggs.util.NullUtil;
import com.ggs.util.SQLiteUtil;

import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 * User: ggs
 * Date: 12-8-21
 * Time: 上午8:41
 * To change this template use File | Settings | File Templates.
 */
public class BugDao {
    private SQLiteUtil sqLiteUtil = new SQLiteUtil();

    /**
     * 保存问题
     * */
    public void saveBug(BugModel model){
        sqLiteUtil.update("insert into t_bug (company,username,mobile,memo,creattime,creator)  values(?,?,?,?,?,?)",new Object[]{
                model.getCompany(),
                model.getUsername(),
                model.getMobile(),
                model.getMemo(),
                DateUtil.getDate("yyyy-MM-dd HH:mm")    ,
                model.getCreator()
        });
    }

    public PageModel getBugList(BugModel model){
        StringBuilder sql = new StringBuilder();
        sql.append(" select * from (select a.*,b.realname from t_bug a left join t_user b on a.processid=b.id) where 1=1");

        //姓名
        if(NullUtil.isNotNull(model.getUsername())){
            sql.append(" and username like '%"+model.getUsername()+"%'");
        }

        //手机
        if(NullUtil.isNotNull(model.getMobile())){
            sql.append(" and mobile like '"+model.getMobile()+"%'");
        }

        //内容
        if(NullUtil.isNotNull(model.getMemo())){
            sql.append(" and memo like '%"+model.getMemo()+"%'");
        }

        //排序
        if(NullUtil.isNotNull(model.getSort())){
            sql.append(" order by "+model.getSort()+" "+model.getOrder());
        } else{
            sql.append(" order by creattime desc,id desc");
        }
        List rows = this.sqLiteUtil.queryForList("select * from ("+sql+") limit "+model.getRows()+" offset "+(model.getPage()-1)*model.getRows());
        int total = this.sqLiteUtil.queryForInt("select count(*) from ("+sql+")");
        PageModel pageModel = new PageModel();
        pageModel.setRows(rows);
        pageModel.setTotal(total);
        return pageModel;
    }

    /**
     * 处理
     * */
    public void process(BugModel model){
        this.sqLiteUtil.update("update t_bug set processid=?,processtime=?,processinfo=?,status=1 where id=?",new Object[]{
           model.getAdminId(),
           DateUtil.getDate("yyyy-MM-dd HH:mm"),
           model.getProcessinfo(),
           model.getBugid()
        });
    }

    /**
     * 得到一个bug
     * */
    public Map getBug(BugModel model){
        return sqLiteUtil.queryForMap("select *  from t_bug where id=?",new Object[]{model.getBugid()}) ;
    }


    /**
     * 删除bug
     * */
    public void delBug(BugModel model){
        this.sqLiteUtil.update("delete from t_bug where id=?",new Object[]{model.getBugid()});
    }



}
