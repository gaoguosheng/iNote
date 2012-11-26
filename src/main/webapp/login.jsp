<%@ page import="com.ggs.comm.Config" %>
<%--
  Created by IntelliJ IDEA.
  User: ggs
  Date: 12-5-26
  Time: 下午4:49
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
         * 检查登陆
         * */
        function f_login(){
            var uname= $("#username").val();
            var pwd=$("#password").val();
            if(uname=="" || pwd==""){
                f_alertError("用户名或者密码不能为空！");
                return false;
            }

            //md5加密
            pwd=hex_md5(pwd);
            var json = $GGS.getJSON("login<%=Config.EXT%>",{username:uname,password:pwd});
            if(json.flag!="1"){
                f_alertError("用户名或者密码不正确！");
                return false;
            }
            //刷新首页
            location='<%=Config.INDEX_PAGE%>';
        }

        /**
         * 回车事件
         * */

        function f_enter_login(){
            if(event.keyCode==13){
                f_login();
            }
        }

        $(function(){
            $("#username").keydown(function(){f_enter_login()});
            $("#password").keydown(function(){f_enter_login()});
            $("#username").focus();
        }) ;

    </script>
</head>
<body>
<%@include file="top.jsp"%>
<h3 align="center">用户登陆</h3>
<form id="loginForm">
<table align="center" width="400" border="0"  cellpadding="5" class="normalFont">
    <tr>
        <td align="right" width="30%">用户：</td>
        <td width="70%"><input type="text" name="username" id="username" class="text" style="width: 180px;" value="${cookie.username.value}"></td>
    </tr>
    <tr>
        <td align="right">密码：</td>
        <td><input type="password" name="password" id="password"  class="text" style="width: 180px;"></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td>
            <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="f_login();">登陆</a>
            <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-reload'" onclick="loginForm.reset();">重置</a>
        </td>
    </tr>
</table>
</form>
<jsp:include page="/foot.jsp" flush="true"></jsp:include>


</body>
</html>