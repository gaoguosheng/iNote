<%--
  Created by IntelliJ IDEA.
  User: ggs
  Date: 12-8-21
  Time: 上午10:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page pageEncoding="UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="topSelected" value="4"></c:set>
<html>
<head>
<title><%=Config.SOFT_NAME%> - 用户管理</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<%@include file="inc.jsp"%>
<script type="text/javascript">
    /**
     * 获取公司名称
     * */
    function f_getCompany(id){
        if(id==1){
            str="福州锦昌"
        }else if(id==2){
            str="福建临工";
        }else if(id==3){
            str="淅江临沃";
        }else if(id==4){
            str="福建斗山";
        }
        return str;
    }

/**
 * 获取文章
 * */
function f_getArticles(data){
    var myUrl="user/getUserList<%=Config.EXT%>?q=1";
    if(data.realname !=undefined){
        myUrl+="&realname="+data.realname;
    }
    if(data.mobile !=undefined){
        myUrl+="&mobile="+data.mobile;
    }
    if(data.qq !=undefined){
        myUrl+="&qq="+data.qq;
    }
    myUrl=encodeURI(myUrl);
    $('#gridTable').datagrid({
        //title:"用户管理",
        url:myUrl,
        pageSize:20,
        frozenColumns:[[

        ]],
        columns:[[
            {field:'flag',title:'状态',width:60,align:"center",sortable:true,
                formatter:function(value,row,index){
                    var str="<img src='images/denied.png' title='停用'>";
                    if(row.flag==1){
                        str="<img src='images/ok.png' title='正常'>"
                    }
                    return str;
                }
            },
            {field:'username',title:'用户名',width:80},
            {field:'realname',title:'姓名',width:80},
            {field:'qq',title:'QQ',width:120},
            {field:'mobile',title:'手机',width:120},
            {field:'onlinetimes',title:'在线时长(时)',width:100,sortable:true,
                formatter:function(value,row,index){
                    return parseInt(row.onlinetimes/60);
                }
            }

        ]],
        toolbar:'#tb',
        striped: true,
        singleSelect:true
    });
}
/**
 * 刷新表格
 * */
function f_refreshGrid(){
    $('#gridTable').datagrid('reload');
}

function f_add(){
    f_openUserWindow();
}

function f_edit(){
    var sel =  $('#gridTable').datagrid('getSelected');
    if(sel){
        f_openUserWindow(sel);
    }else{
        f_alertError("请选择一条记录！");
    }

}

/**
 * 弹出窗口
 * */
 function f_openUserWindow(data){
    $("#userWindow").css("display","block");
    $("#username").val("");
    $("#mobile").val("");
    $("#realname").val("");
    $("#qq").val("");
    $("#userid").val("");
    if(data){
        $("#username").val(data.username);
        $("#mobile").val(data.mobile);
        $("#realname").val(data.realname);
        $("#qq").val(data.qq);
        $("#userid").val(data.id);
    }

     $("#userWindow").window(
             {
                 title:'用户管理',
                 width:400,
                 height:300,
                 modal:true,
                 minimizable:false,
                 maximizable:false,
                 collapsible:false
             }
     );
 }

    //保存
    function f_saveUser(){
        if($("#username").val()==""){
            f_alertError("您还未填写姓名！");
            return false;
        }
        $GGS.ajax("user/saveUser<%=Config.EXT%>",{
            username:$("#username").val(),
            mobile:$("#mobile").val(),
            qq:$("#qq").val(),
            realname:$("#realname").val(),
            userid:$("#userid").val()});
        f_refreshGrid();
        $('#userWindow').window('close');

    }

    //重置密码
    function f_resetPwd(){
        var sel =  $('#gridTable').datagrid('getSelected');
        if(sel){
            $.messager.confirm('提示', '是否确认操作?', function(r){
                if (r){
                    //md5加密
                    var pwd=hex_md5("123456");
                    $GGS.ajax("user/resetPwd<%=Config.EXT%>",{userid:sel.id,password:pwd});
                    f_refreshGrid();
                }
            });
        }else{
            f_alertError("请选择一条记录！");
        }
    }

    //更改标识
    function f_updateFlag(){
        var sel =  $('#gridTable').datagrid('getSelected');
        if(sel){
            $.messager.confirm('提示', '是否确认操作?', function(r){
                if (r){
                    $GGS.ajax("user/updateFlag<%=Config.EXT%>",{userid:sel.id,flag:sel.flag==1?0:1});
                    f_refreshGrid();
                }
            });


        } else{
            f_alertError("请选择一条记录！");
        }
    }


$(function(){
    window.setTimeout(function(){
        f_getArticles({});
    },500);

});
</script>
</head>
<body>
<%@include file="top.jsp"%>

<table border="0" cellpadding="0" cellspacing="0" width="100%" class="borderTable normalFont">
    <tr>
        <td valign="top">
            <!-- 列表-->
            <table id="gridTable" class="easyui-datagrid"   iconCls="icon-search"
                   rownumbers="true" pagination="true">
            </table>
            <script type="text/javascript">
                var myHeight=230;
                var myWidth=50;
                $("#gridTable").css("height",screen.availHeight-260);
            </script>
            </div>
        </td>
    </tr>
</table>
<div id="tb">
    <a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'" onclick="f_add();">添加</a>
    <a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-edit'" onclick="f_edit();">修改</a>
    <a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-edit'" onclick="f_updateFlag();">更改状态</a>
    <a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-edit'" onclick="f_resetPwd();">重置密码</a>
    <a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-reload'" onclick="f_refreshGrid();">刷新</a>
    <input class="easyui-searchbox" data-options="prompt:'请输入关键字',menu:'#mm',
			searcher:function(value,name){
			if(name==0){f_getArticles({fspell:value});
			} else if (name==1){f_getArticles({realname:value});}
			else if(name==2){f_getArticles({mobile:value});}
			 else if(name==3){f_getArticles({qq:value});}}" style="width:150px"/>
    <div id="mm" style="width:120px">
        <div data-options="name:'1'">姓名</div>
        <div data-options="name:'2'">手机</div>
        <div data-options="name:'3'">QQ</div>
    </div>
</div>

<%@include file="foot.jsp"%>
<div id="userWindow" style="display: none">
    <input type="hidden" id="userid" name="userid">
    <table width="100%" align="center" border="0" cellpadding="5" class="normalFont">
        <tr>
            <td align="right" valign="top">用户名：</td>
            <td><input name="username" id="username" placeholder="" value="" type="text" style="width: 200px;"/></td>
        </tr>
        <tr>
            <td align="right" valign="top">姓名：</td>
            <td><input name="realname" id="realname" placeholder="" value="" type="text" style="width: 200px;"/></td>
        </tr>
        <tr>
            <td align="right" valign="top">手机：</td>
            <td><input name="mobile" id="mobile" placeholder="" value="" type="tel" style="width: 200px;"/></td>
        </tr>
        <tr>
            <td align="right" valign="top">QQ：</td>
            <td><input name="qq" id="qq" placeholder="" value="" type="tel" style="width: 200px;"/></td>
        </tr>
        <tr>
            <td align="center" valign="top" colspan="2">
                <a id="okBugBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="return  f_saveUser();">保存</a>
                <a id="closeBugBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#userWindow').window('close');">关闭</a>
            </td>
        </tr>

    </table>
</div>
</body>
</html>