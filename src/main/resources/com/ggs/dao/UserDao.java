package com.ggs.dao;

import com.ggs.model.PageModel;
import com.ggs.model.UserModel;
import com.ggs.util.NullUtil;
import com.ggs.util.SQLiteUtil;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: ggs
 * Date: 12-12-26
 * Time: 下午2:41
 * To change this template use File | Settings | File Templates.
 */
public class UserDao {
    private SQLiteUtil sqLiteUtil = new SQLiteUtil();
    public PageModel getUserList(UserModel model){
        StringBuilder sql = new StringBuilder();
        sql.append("select * from t_user where 1=1");
        if(NullUtil.isNotNull(model.getRealname())){
            sql.append(" and realname like '%"+model.getRealname()+"%'");
        }
        if(NullUtil.isNotNull(model.getMobile())){
            sql.append(" and mobile like '%"+model.getMobile()+"%'");
        }
        if(NullUtil.isNotNull(model.getQq())){
            sql.append(" and qq like '%"+model.getQq()+"%'");
        }
        //排序
        if(NullUtil.isNotNull(model.getSort())){
            sql.append(" order by "+model.getSort()+" "+model.getOrder());
        }
        List rows = this.sqLiteUtil.queryForList("select * from ("+sql+") limit "+model.getRows()+" offset "+(model.getPage()-1)*model.getRows());
        int total = this.sqLiteUtil.queryForInt("select count(*) from ("+sql+")");
        PageModel pageModel = new PageModel();
        pageModel.setRows(rows);
        pageModel.setTotal(total);
        return pageModel;
    }

    public void saveUser(UserModel model){
        String sql ="insert into t_user (username,password,realname,qq,mobile) values (?,?,?,?,?)";
        this.sqLiteUtil.update(sql,new Object[]{
                model.getUsername(),
                model.getPassword(),
                model.getRealname(),
                model.getQq(),
                model.getMobile()
        });

    }

    public void updateUser(UserModel model){
        String sql ="update t_user set username=?,realname=?,qq=?,mobile=? where id=?";
        this.sqLiteUtil.update(sql,new Object[]{
                model.getUsername(),
                model.getRealname(),
                model.getQq(),
                model.getMobile(),
                model.getUserid()
        });
    }
    public void resetPwd(UserModel model){
        String sql ="update t_user set password=? where id=?";
        this.sqLiteUtil.update(sql,new Object[]{
                model.getPassword(),
                model.getUserid()
        });
    }

    public void updateFlag(UserModel model){
        String sql ="update t_user set flag=? where id=?";
        this.sqLiteUtil.update(sql,new Object[]{
                model.getFlag(),
                model.getUserid()
        });
    }

}
