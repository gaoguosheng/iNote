package com.ggs.dao;

import com.ggs.model.AddrbookModel;
import com.ggs.model.PageModel;
import com.ggs.util.NullUtil;
import com.ggs.util.PinYinUtil;
import com.ggs.util.SQLiteUtil;

import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 12-8-16
 * Time: 下午2:34
 * To change this template use File | Settings | File Templates.
 */
public class AddrDao {
    private SQLiteUtil sqLiteUtil = new SQLiteUtil();
    private List<Map<String,String>> treeList;
    private StringBuilder addrTree;

    /**
     * 递归文件夹
     * */
    private void getAddrs(String upid){
        for(Map<String,String>item:treeList){
            if(item.get("upid").equals(upid)){
                String id = item.get("id");
                addrTree.append(id);
                addrTree.append(",");
                getAddrs(id);
            }
        }
    }

    /**
     * 获取通讯录类别列表
     * */
    public List getClassList(){
        return sqLiteUtil.queryForList("select * from t_addrclass");
    }

    /**
     * 获取通讯录列表
     * */
    public PageModel getAddrList(AddrbookModel model){

        StringBuilder sql= new StringBuilder("select *,upper(substr(fspell,1,1))upfspell from (" +
                "select a.*,b.realname,c.cname addrclassname from t_addrbook a left join t_user b on a.userid=b.id" +
                " left join t_addrclass c on a.addrclassid=c.id" +
                ") where 1=1");
        //过滤保密通讯录
        sql.append(" and (isvisable=1 or (isvisable=0 and userid="+model.getAdminId()+"))");

        //分类
        if(NullUtil.isNotNull(model.getAddrclassid())){
            sql.append(" and Addrclassid="+model.getAddrclassid());
            treeList = this.sqLiteUtil.queryForList("select * from t_addrclass");
            addrTree  =new StringBuilder();
            this.getAddrs(model.getAddrclassid());
            if(addrTree.length()>0){
                sql.append(" or Addrclassid in ("+addrTree.substring(0,addrTree.length()-1)+")");
            }

        }
        //姓名
        if(NullUtil.isNotNull(model.getName())){
            sql.append(" and name like '%"+model.getName()+"%'");
        }
        //电话
        if(NullUtil.isNotNull(model.getMobile())){
            sql.append(" and mobile like '"+model.getMobile()+"%'");
        }
        //我的笔记
        if(NullUtil.isNotNull(model.getUserid())){
            sql.append(" and userid="+model.getUserid());
        }

        //默认获取正常的通讯录
        if(NullUtil.isNotNull(model.getFlag())){
            sql.append(" and flag="+model.getFlag());
        }else{
            sql.append(" and flag=0") ;
        }

        //首拼
        if(NullUtil.isNotNull(model.getFspell())){
            sql.append(" and fspell like '"+model.getFspell()+"%'");
        }

        //备注
        if(NullUtil.isNotNull(model.getMemo())){
            sql.append(" and memo like '%"+model.getMemo()+"%'");
        }

        //qq
        if(NullUtil.isNotNull(model.getQq())){
            sql.append(" and qq like '"+model.getQq()+"%'");
        }

        //email
        if(NullUtil.isNotNull(model.getEmail())){
            sql.append(" and email like '%"+model.getEmail()+"%'");
        }

        //排序
        if(NullUtil.isNotNull(model.getSort())){
            sql.append(" order by "+model.getSort()+" "+model.getOrder());
        } else{
            sql.append(" order by fspell");
        }
        List rows = this.sqLiteUtil.queryForList("select * from ("+sql+") limit "+model.getRows()+" offset "+(model.getPage()-1)*model.getRows());
        int total = this.sqLiteUtil.queryForInt("select count(*) from ("+sql+")");
        PageModel pageModel = new PageModel();
        pageModel.setRows(rows);
        pageModel.setTotal(total);
        return pageModel;
    }

    /**
     * 保存通讯录
     * */
    public void saveAddr(AddrbookModel model){
        String sql = "insert into t_addrbook (name,sex,mobile,qq,email,memo,fspell,addrclassid,isvisable,userid) values(?,?,?,?,?,?,?,?,?,?)";
        this.sqLiteUtil.update(sql,new Object[]{
                model.getName(),
                model.getSex(),
                model.getMobile(),
                model.getQq(),
                model.getEmail(),
                model.getMemo(),
                PinYinUtil.cn2FirstSpell(model.getName()).toLowerCase(),
                model.getAddrclassid(),
                model.getIsvisable(),
                model.getAdminId()
        });
    }

    /**
     * 修改通讯录
     * */
        public void updateAddr(AddrbookModel model){
            String sql ="update t_addrbook set name=?,sex=?,mobile=?,qq=?,email=?,memo=?,fspell=?,isvisable=? where id=?";
            this.sqLiteUtil.update(sql,new Object[]{
                    model.getName(),
                    model.getSex(),
                    model.getMobile(),
                    model.getQq(),
                    model.getEmail(),
                    model.getMemo(),
                    PinYinUtil.cn2FirstSpell(model.getName()).toLowerCase(),
                    model.getIsvisable(),
                    model.getId()
            });
        }

    /**
     * 获取通讯录
     * */
    public Map getAddr(String addrid) {
        return sqLiteUtil.queryForMap("select * from t_addrbook where id=?",new Object[]{addrid});
    }

    /**
     * 删除通讯录
     * */
    public void delAddr(String addrid){
        sqLiteUtil.update("update t_addrbook set flag=1 where id=?",new Object[]{addrid});
    }

    /**
     * 恢复通讯录
     * */
    public void restoreAddr(String addrid){
        sqLiteUtil.update("update t_addrbook set flag=0 where id=?",new Object[]{addrid});
    }

    /**
     * 添加类别
     * */
    public void addClass(String cname,String upid){
        sqLiteUtil.update("insert into t_addrclass (cname,upid) values(?,?)",new Object[]{cname,upid});
    }

    /**
     * 检查类别是重名
     * */
    public boolean checkExistClass(String cname){
        int counter = sqLiteUtil.queryForInt("select count(*) from t_addrclass where cname=?",new Object[]{cname});
        return counter>0?true:false;
    }

    /**
     * 获取通讯录存在的字母列表
     * */
    public List getLetters(){
        return sqLiteUtil.queryForList("SELECT distinct substr(fspell,1,1) letter FROM t_addrbook");
    }

}
