<%@ page import="com.ggs.comm.Config" %>
<%--
  Created by IntelliJ IDEA.
  User: ggs
  Date: 12-5-28
  Time: 下午2:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<form id="pwdForm">
    <table align="center" width="400" border="0"  cellpadding="5" class="normalFont">
        <tr>
            <td align="right" width="30%">旧密码：</td>
            <td width="70%"><input type="password" name="oldpassword" id="oldpassword" class="text" style="width: 180px;"></td>
        </tr>
        <tr>
            <td align="right" width="30%">新密码：</td>
            <td width="70%"><input type="password" name="password" id="password" class="text" style="width: 180px;"></td>
        </tr>
        <tr>
            <td align="right">密码确认：</td>
            <td><input type="password" name="password2" id="password2" class="text" style="width: 180px;"></td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>
                <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="f_updatePwd();">确认</a>
                <a href="#" onclick="f_closePwdDialog();return false;" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'">取消</a>
            </td>
        </tr>
    </table>
</form>
<script type="text/javascript">
    /**
     * 更新密码
     * */
    function f_updatePwd(){
        var oldpwd=$("#oldpassword").val();
        var pwd=$("#password").val();
        var pwd2=$("#password2").val();
        if(oldpwd=="" || pwd=="" || pwd2==""){
            f_alertError("旧密码、新密码或者密码确认不能为空！");
            return false;
        }
        if(pwd!=pwd2){
            f_alertError("密码或者密码两次不一样!");
            return false;
        }
        //md5加密
        if(hex_md5(oldpwd)!="${sessionScope.adminModel.password}"){
            f_alertError("旧密码不正确!");
            return false;
        }
        pwd=hex_md5(pwd);
        $GGS.ajax("main/updatePwd<%=Config.EXT%>",{password:pwd});
        f_alertInfo("密码修改成功！",function(){
            f_closePwdDialog();
        });

    }

    /**
     * 回车事件
     * */

    function f_enter_pwd(){
        if(event.keyCode==13){
            f_updatePwd();
        }
    }

    $(function(){
        $("#password").keydown(function(){f_enter_pwd()});
        $("#password2").keydown(function(){f_enter_pwd()});
        $("#oldpassword").focus();
    }) ;

</script>