<%@ page import="com.ggs.util.SQLiteUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.ggs.util.PinYinUtil" %>
<%--
  Created by IntelliJ IDEA.
  User: ggs
  Date: 12-10-30
  Time: 上午10:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    SQLiteUtil sqLiteUtil = new SQLiteUtil();
    String tableName="t_addrbook";
    String sourceField="name";
    String destField="fspell";
    String pkField="id";

    String sql="select * from "+tableName;
    List<Map<String,String>> itemList = sqLiteUtil.queryForList(sql);
    for(Map<String,String>item:itemList){
        String pinyinValue= (PinYinUtil.cn2FirstSpell(item.get(sourceField))).toLowerCase();
        sqLiteUtil.update("update "+tableName+" set "+destField+"='"+pinyinValue+"' where "+pkField+"="+item.get(pkField));
    }

%>