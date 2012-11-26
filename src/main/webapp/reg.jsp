<%@ page import="com.ggs.comm.Config" %>
<%--
  Created by IntelliJ IDEA.
  User: ggs
  Date: 12-5-28
  Time: 下午3:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String path  = request.getContextPath();
%>
<html>
<head>
    <title><%=Config.SOFT_NAME%></title>
    <%@include file="inc.jsp"%>
    <script type="text/javascript">
        /**
         * 更新密码
         * */
        function f_reg(){
            var uname=$("#username").val();
            var pwd=$("#password").val();
            var pwd2=$("#password2").val();
            var rname=$("#realname").val();
            if(uname==""){
                f_alertError("用户名不能为空！");
                return false;
            }
            if(pwd=="" || pwd2==""){
                f_alertError("密码或者密码确认不能为空！");
                return false;
            }
            if(pwd!=pwd2){
                f_alertError("输入两次的密码不一样！");
                return false;
            }
            if(rname==""){
                f_alertError("真实姓名不能为空！");
                return false;
            }

            //md5加密
            pwd=hex_md5(pwd);
            var msg = $GGS.ajax("main/reg<%=Config.EXT%>",{username:uname,password:pwd,realname:rname});
            if(msg=="1"){
                f_alertInfo("注册成功！",function(){
                    $GGS.ajax("login<%=Config.EXT%>",{username:uname,password:pwd});
                    //进入首页
                    location='<%=Config.INDEX_PAGE%>';
                });
            }else{
                f_alertError("注册失败，可能你的用户名已被占用！请重新注册！",function(){
                    location="reg.jsp";
                });

            }
        }

        $(function(){
            $("#username").focus();
        }) ;

    </script>
</head>
<body >
<%@include file="top.jsp"%>
<h3 align="center">用户注册</h3>
<table align="center" width="400" border="0"  cellpadding="5" class="normalFont">
    <tr>
        <td align="right" width="30%">用户：</td>
        <td width="70%"><input type="text" name="username" id="username" class="text"></td>
    </tr>
    <tr>
        <td align="right">密码：</td>
        <td><input type="password" name="password" id="password" class="text"></td>
    </tr>
    <tr>
        <td align="right">密码确认：</td>
        <td><input type="password" name="password2" id="password2" class="text"></td>
    </tr>
    <tr>
        <td align="right" width="30%">真实姓名：</td>
        <td width="70%"><input type="text" name="realname" id="realname" class="text"></td>
    </tr>
    <tr>
        <td colspan="2" align="center">
            <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="f_reg();">确认</a>
            <a href="<%=Config.INDEX_PAGE%>" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'">取消</a>
        </td>
    </tr>
</table>
<jsp:include page="/foot.jsp" flush="true"></jsp:include>


</body>
</html>
