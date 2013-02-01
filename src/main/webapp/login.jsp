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
            var isautologin=$("#isautologin").val();
            if(isautologin==1){
                //自动登录
                $.cookie("userpwd", pwd, { expires: 30 });
            }else{
                $.cookie("userpwd", null);
            }
            if(uname=="" || pwd==""){
                f_alertError("用户名或者密码不能为空！");
                return false;
            }

            //md5加密
            pwd=hex_md5(pwd);
            var json = $GGS.getJSON("login<%=Config.EXT%>",{username:uname,password:pwd,isautologin:isautologin});
            if(json.flag=="-1"){
                f_alertError("对不起，您的账号不存在或已停用！");
                return false;
            }
            if(json.flag=="0"){
                f_alertError("对不起，用户名或密码不正确！");
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
            <c:if test="${param.r==null}">
                var cookieusername = $.cookie("username");
                var cookieuserpwd = $.cookie("userpwd");
                if(cookieusername && cookieuserpwd){
                    $("#username").val(cookieusername);
                    $("#password").val(cookieuserpwd);
                    f_login();
                }
            </c:if>
        }) ;

    </script>
</head>
<body>
<div id="dlg" class="easyui-dialog" title="用户登录" resizable="false" draggable="false" closable="false" data-options="iconCls:'icon-user'" style="width:550px;height:330px;padding:10px">
    <div align="center" style="font-size: 20pt;font-weight: bold;"><%=Config.SOFT_NAME%></div>
    <br/>
    <form id="loginForm">
        <table align="center" width="100%" border="0"  cellpadding="5" class="normalFont">
            <tr>
                <td rowspan="4" align="center"><img src="images/logo-m.jpg"></td>
                <td align="right">帐号/手机/QQ：</td>
                <td><input type="text" name="username" id="username" class="text" style="width: 180px;" value="${cookie.username.value}"></td>
            </tr>
            <tr>
                <td align="right">密码：</td>
                <td><input type="password" name="password" id="password"  class="text" style="width: 180px;"></td>
            </tr>
            <tr>
                <td align="right">自动登录：</td>
                <td><input type="checkbox" value="1" id="isautologin" name="isautologin"></td>
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
    <div  align="center">
        <span  class="normalFont"><%=Config.COPY%></span>
    </div>
</div>






</body>
</html>