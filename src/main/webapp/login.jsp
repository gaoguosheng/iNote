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
            if(json.flag=="-1"){
                f_alertError("对不起，您的账号已停用！");
                return false;
            }
            if(json.flag=="0"){
                f_alertError("对不起，用户名或者密码不正确！");
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
<div id="dlg" class="easyui-dialog" title="用户登录" resizable="false" draggable="false" closable="false" data-options="iconCls:'icon-user'" style="width:580px;height:330px;padding:10px">
    <div align="center" style="font-size: 20pt;font-weight: bold;"><%=Config.SOFT_NAME%></div>
    <form id="loginForm">
        <table align="center" width="100%" border="0"  cellpadding="5" class="normalFont">
            <tr>
                <td colspan="3" align="right" style="font-size: 10pt;color: red;">支持手机、QQ号码快捷登录</td>
            </tr>
            <tr>
                <td rowspan="3" align="center"><img src="images/logo-m.jpg"></td>
                <td align="right">用户：</td>
                <td><input type="text" name="username" id="username" class="text" style="width: 180px;" value="${cookie.username.value}"></td>
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
    <div  align="center">
        <span  class="normalFont"><%=Config.COPY%></span>
    </div>
</div>






</body>
</html>