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
<title><%=Config.SOFT_NAME%> - 问题反馈</title>
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
    var myUrl="bug/getBugList<%=Config.EXT%>?q=1";
    if(data.username !=undefined){
        myUrl+="&username="+data.username;
    }
    if(data.mobile !=undefined){
        myUrl+="&mobile="+data.mobile;
    }
    if(data.memo !=undefined){
        myUrl+="&memo="+data.memo;
    }
    myUrl=encodeURI(myUrl);
    $('#gridTable').datagrid({
        //title:"问题反馈",
        url:myUrl,
        pageSize:20,
        frozenColumns:[[

        ]],
        columns:[[
            {field:'status',title:'状态',width:60,align:"center",sortable:true,
                formatter:function(value,row,index){
                    var str="<img src='images/denied.png' title='未处理'>";
                    if(row.status==1){
                        str="<img src='images/ok.png' title='已处理'>"
                    }
                    return str;
                }
            },
            {field:'creattime',title:'时间',width:80,sortable:true,
                formatter: function(value,row,index){
                    return row.creattime.substr(0,10);
                }
            },
            {field:'company',title:'公司',width:80,
                formatter:function(value,row,index){
                    var str=""
                    str =f_getCompany(row.company);
                    return str;
                }},
            {field:'username',title:'姓名',width:60},
            {field:'mobile',title:'手机',width:120},
            {field:'memo',title:'问题',width:300},
            {field:'creator',title:'创建人',width:60,sortable:true},
            {field:'realname',title:'处理人',width:60},
            {field:'processtime',title:'处理时间',width:120,sortable:true}

        ]],
        toolbar:'#tb',
        striped: true,
        singleSelect:true,
        onClickRow:function(rowIndex, rowData){
            f_openProcessWindow(rowData.id);
        }
    });
}

/**
 * 刷新表格
 * */
function f_refreshGrid(){
    $('#gridTable').datagrid('reload');
}

//处理问题
function f_process(){
    if($("#processinfo").val()==""){
        f_alertError("您还未填写处理信息！");
        return false;
    }
    $GGS.ajax("bug/process<%=Config.EXT%>",{processinfo:$("#processinfo").val(),bugid:$("#bugid").val()});
    f_refreshGrid();
    f_closeProcessWindow();
}

/**
 * 弹出处理信息窗口
 * */
function f_openProcessWindow(id){
    $("#processWindow").css("display","block");
    var json = $GGS.getJSON("bug/getBug<%=Config.EXT%>",{bugid:id});
    if(json.status==1){
        $("#delBtn").css("display","none");
    }else{
        $("#delBtn").css("display","");
    }
    $("#bugid").val(json.id);
    $("#companyDiv").html(f_getCompany(json.company));
    $("#usernameDiv").html(json.username);
    $("#memoDiv").html(json.memo);
    $("#mobileDiv").html(json.mobile);
    if(json.processinfo!="undefined"){
        $("#processinfo").val(json.processinfo);
    }else{
        $("#processinfo").val("");
    }
    $("#processWindow").window(
            {
                title:'问题反馈信息',
                width:700,
                height:480,
                modal:true,
                minimizable:false,
                maximizable:false,
                collapsible:false
            }
    );
}
/**
 * 关闭处理窗口
 * */
function f_closeProcessWindow(){
    $("#processWindow").window("close");
}


    /**
     * 删除bug
     * */
 function f_delBug(){
        $.messager.confirm('提示', '是否确定要删除此Bug?', function(r){
            if (r){
                $GGS.ajax("bug/delBug<%=Config.EXT%>",{bugid:$("#bugid").val()}) ;
                f_refreshGrid();
                f_closeProcessWindow();
            }
        });

 }

/**
 * 添加Bug问题
 * */
 function f_openBugWindow(){
    $("#bugWindow").css("display","block");
    $("#username").val("");
    $("#mobile").val("");
    $("#memo").val("");
    $("#creator").val("");
     $("#bugWindow").window(
             {
                 title:'问题反馈信息',
                 width:500,
                 height:400,
                 modal:true,
                 minimizable:false,
                 maximizable:false,
                 collapsible:false
             }
     );
 }

    //保存问题
    function f_saveBug(){
        if($("#username").val()==""){
            f_alertError("您还未填写姓名！");
            return false;
        }
        if($("#mobile").val()==""){
            f_alertError("您还未填写手机号码！");
            return false;
        }
        if(!/^1[358]\d{9}$/.test($("#mobile").val())){
            f_alertError("手机号码格式不正确");
            return false;
        }
        if($("#memo").val()==""){
            f_alertError("您还未填写问题反馈！");
            return false;
        }
        if($("#creator").val()==""){
            f_alertError("创建人不能为空！");
            return false;
        }
        $GGS.ajax("bug/saveBug<%=Config.EXT%>",{
            username:$("#username").val(),
            mobile:$("#mobile").val(),
            memo:$("#memo").val(),
            company:$("#company").val(),
            creator:$("#creator").val()});
        f_alertInfo("感谢您的反馈，我们会尽快与您确认！");
        f_refreshGrid();
        $('#bugWindow').window('close');

    }


$(function(){
    window.setTimeout(function(){
        f_getArticles({});
    },500);
    $("#processBtn").click(function(){f_process();});
    $("#closeBtn").click(function(){f_closeProcessWindow();});
    $("#delBtn").click(function(){f_delBug();});
    $("#processinfo").blur(function(){
        $('#processinfo').val($.trim($('#processinfo').val()));
    })
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
    <a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-reload'" onclick="f_refreshGrid();">刷新</a>
    <a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'" onclick="f_openBugWindow();">新增问题</a>

    <input class="easyui-searchbox" data-options="prompt:'请输入关键字',menu:'#mm',
			searcher:function(value,name){
			if(name==0){f_getArticles({fspell:value});
			} else if (name==1){f_getArticles({username:value});}
			else if(name==2){f_getArticles({mobile:value});}
			 else if(name==3){f_getArticles({memo:value});}}" style="width:300px"/>
    <div id="mm" style="width:120px">
        <div data-options="name:'1'">姓名</div>
        <div data-options="name:'2'">手机</div>
        <div data-options="name:'3'">问题</div>
    </div>
</div>
<div id="processWindow" style="display: none;">



    <table width="100%" cellpadding="5" border="0" class="normalFont">
        <input type="hidden" id="bugid">
        <c:if test="${sessionScope.adminModel!=null}">
            <tr>
                <td colspan="2"><a id="delBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-no'">删除</a></td>
            </tr>
        </c:if>
        <tr>
            <th valign="top" align="right" width="80">公司：</th>
            <td><div id="companyDiv"></div></td>
        </tr>
        <tr>
            <th valign="top" align="right">姓名：</th>
            <td><div id="usernameDiv"></div></td>
        </tr>
        <tr>
            <th valign="top" align="right">手机：</th>
            <td><div id="mobileDiv"></div></td>
        </tr>
        <tr>
            <th valign="top" align="right">问题：</th>
            <td><div id="memoDiv" style="height: 150px;overflow-y: auto;"></div></td>
        </tr>
        <tr>
            <th valign="top" align="right">处理信息：</th>
            <td>
                <textarea rows="5" style="width: 98%" id="processinfo"></textarea>
            </td>
        </tr>
        <c:if test="${sessionScope.adminModel!=null}">
            <tr>
                <td align="center" colspan="2">
                    <a id="processBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">保存</a>
                    <a id="closeBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'">关闭</a>
                </td>
            </tr>
        </c:if>
    </table>
</div>
<%@include file="foot.jsp"%>
<div id="bugWindow" style="display: none">
    <table width="100%" align="center" border="0" cellpadding="5" class="normalFont">
        <tr>
            <td align="right" valign="top">公司:</td>
            <td>
                <select name="company" id="company" style="width: 200px;">
                    <option value="1">
                        福州锦昌
                    </option>
                    <option value="2">
                        福建临工
                    </option>
                    <option value="3">
                        淅江临沃
                    </option>
                    <option value="4">
                        福建斗山
                    </option>
                </select>
            </td>
        </tr>
        <tr>
            <td align="right" valign="top">姓名：</td>
            <td><input name="username" id="username" placeholder="" value="" type="text" style="width: 200px;"/></td>
        </tr>
        <tr>
            <td align="right" valign="top">手机：</td>
            <td><input name="mobile" id="mobile" placeholder="" value="" type="tel" style="width: 200px;"/></td>
        </tr>
        <tr>
            <td align="right" valign="top">问题反馈：</td>
            <td><textarea name="memo" id="memo" rows="5" placeholder="" style="width: 300px;"></textarea></td>
        </tr>
        <tr>
            <td align="right" valign="top"> 创建人：</td>
            <td><input name="creator" id="creator" placeholder="" value="" type="text" style="width: 200px;"/></td>
        </tr>
        <tr>
            <td align="center" valign="top" colspan="2">
                <a id="okBugBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="return  f_saveBug();">保存</a>
                <a id="closeBugBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#bugWindow').window('close');">关闭</a>
            </td>
        </tr>

    </table>
</div>
</body>
</html>