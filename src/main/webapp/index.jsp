<%@ page import="com.ggs.comm.Config" %>
<%@ page import="com.ggs.util.DateUtil" %>
<%--
  Created by IntelliJ IDEA.
  User: ggs
  Date: 12-8-21
  Time: 上午10:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page pageEncoding="UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="isCheckLogin" value="1"></c:set>
<html>
<head>
<title><%=Config.SOFT_NAME%></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<%@include file="inc.jsp"%>

</head>
<body>
<div class="easyui-layout" style="width:100%;height:100%;">
    <div data-options="region:'north'" style="height:110px">
        <table cellpadding="5" border="0" cellspacing="0" style="width:100%" align="center" class="normalFont">
            <tr>
                <td valign="top" width="48px">
                    <a href="<%=Config.INDEX_PAGE%>"><img src="images/logo.jpg" border="0"/></a>
                </td>
                <td valign="middle" width="120px" >
                    <span style="font-size: 18pt;font-weight: bold;"><%=Config.SOFT_NAME%></span>
                </td>
                <td align="center" width="250px">
                    <div><%=DateUtil.getDate("MM月dd日 E 第ww周")%>(<span style="color: red;"><%=DateUtil.getWeekOfYear()%2==0?"双周":"单周"%></span>)</div>
                    <div><iframe src="http://m.weather.com.cn/m/pn6/weather.htm?id=101230101T " width="140" height="20" marginwidth="0" marginheight="0" hspace="0" vspace="0" frameborder="0" scrolling="no"></iframe></div>
                </td>
                <td align="right">
                    <div id="loginDiv">
                        <a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_showOnlineDialog();return false;">在线人员（<span style="color: red;" id="onlineCountSpan"></span>）</a>&nbsp;
                        <c:choose>
                            <c:when test="${sessionScope.adminModel!=null}">
                                <a href="#" class="easyui-linkbutton" data-options="plain:true">
                                    <span id="topGradeSpan"></span>
                                </a>&nbsp;
                                <a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_openUserWindow();;return false;" >修改资料</a>&nbsp;
                                <a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_showPwdDialog();;return false;" >修改密码</a>&nbsp;
                                <a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_logout();return false;">退出</a>
                            </c:when>
                            <c:otherwise>
                                <a href="login.jsp" class="easyui-linkbutton" data-options="plain:true">登录</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </td>
            </tr>
        </table>
        <div style="padding:5px;border:1px solid #ddd">

            <a id="homeLink"  href="#" onclick="f_addTab('首页','main.jsp',false);" class="easyui-linkbutton" data-options="plain:true"><img src="images/home.png"> 首页<span id='topCounterSpan1'></span></a>
            <a id="editorLink"   href="#" onclick="f_addTab('撰写笔记','editor.jsp',true);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-edit'">撰写笔记</a>
            <a id="ganttLink"  href="#" onclick="f_addTab('工作进程','gantt_list.jsp',true);"  class="easyui-linkbutton" data-options="plain:true"><img src="images/issue.png"width="16" height="16"> 工作进程<span id='topCounterSpan2'></span></a>
            <a id="bugLink" href="#" onclick="f_addTab('问题反馈','bug.jsp',true);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-help'">问题反馈<span id='topCounterSpan3'></span></a>
            <a id="addrLink" href="#" onclick="f_addTab('通讯录','addr.jsp',true);"  class="easyui-linkbutton" data-options="plain:true"><img src="images/stateie.gif">&nbsp;通讯录</a>
            <c:if test="${sessionScope.adminModel.username=='admin'}">
                <a  href="#" onclick="f_addTab('用户管理','user.jsp',true);"  class="easyui-linkbutton" data-options="plain:true"><img src="images/stateie.gif">&nbsp;用户管理</a>
            </c:if>
            <a href="javascript:void(0)" class="easyui-menubutton" data-options="menu:'#topMenuDiv',iconCls:'icon-tip',plain:true" >工具</a>

        </div>


    </div>
    <div data-options="region:'south'" style="height:35px;">
        <div  align="center">
            <span  class="normalFont"><%=Config.COPY%></span>
        </div>
    </div>
    <div data-options="region:'center',title:'Main Title',iconCls:'icon-ok'">
        <div id="tabs" class="easyui-tabs" data-options="fit:true,border:false,plain:true">
        </div>
    </div>
</div>

<div id="topMenuDiv" style="width: 120px;">
    <div onclick="f_addTab('FTP','ftp://dj:dj@110.90.112.121',true);"><img src="images/communication.png"width="16" height="16">&nbsp;FTP</div>
    <div onclick="f_addTab('OA','http://110.90.112.121:8888',true);"><img src="images/order_159.png"width="16" height="16">&nbsp;OA</div>
    <div onclick="f_addTab('企业邮箱','http://mail.ykesoft.com',true);"><img src="images/business_contact.png"width="16" height="16">&nbsp;企业邮箱</div>
    <div class="menu-sep"></div>
    <div id="shuiLink"  onclick="f_addTab('个税计算器','shui.jsp',true);"><img src="images/cash.png"width="16" height="16">&nbsp;个税计算器</div>
</div>
<div id="userOnlinetimesDiv">
</div>
<div id="passwordDiv"></div>
<div id="topCounterDiv"></div>

<div id="userWindow" style="display: none">
    <input type="hidden" id="userid" name="userid">
    <table width="100%" align="center" border="0" cellpadding="5" class="normalFont">
        <tr>
            <td align="right" valign="top">用户名：</td>
            <td><input name="username" id="username" placeholder="" readonly="" value="" type="text" style="width: 200px;"/></td>
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

<script type="text/javascript">

/**
 * 弹出窗口
 * */
function f_openUserWindow(){
    $("#userWindow").css("display","block");

    $("#username").val("${sessionScope.adminModel.username}");
    $("#mobile").val("${sessionScope.adminModel.mobile}");
    $("#realname").val("${sessionScope.adminModel.realname}");
    $("#qq").val("${sessionScope.adminModel.qq}");
    $("#userid").val("${sessionScope.adminModel.userid}");


    $("#userWindow").window(
            {
                title:'修改个人资料',
                width:400,
                height:280,
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
        f_alertInfo("保存成功！");
        $('#userWindow').window('close');

    }

    /**
     * 弹出在线人员对话框
     * */
    function f_showOnlineDialog(){
        $("#userOnlinetimesDiv").html(f_getOnlineListDiv());
        $("#userOnlinetimesDiv").window({
            title:'在线人员',
            width:350,
            height:400,
            modal:true,
            minimizable:false,
            maximizable:false,
            collapsible:false
        });
    }

    /**
     * 弹出修改密码对话框
     * */
    function f_showPwdDialog(){
        $("#passwordDiv").window(
                {
                    title:'修改密码',
                    width:450,
                    height:220,
                    modal:true,
                    href:"pwd.jsp",
                    minimizable:false,
                    maximizable:false,
                    collapsible:false
                }
        );
    }

    /**
     * 关闭密码对话框
     * */
    function f_closePwdDialog(){
        $("#passwordDiv").window("close");
    }

    /**获取项部统计*/
    function f_getTopCount(){
        var json = $GGS.getJSON("main/getTopCount<%=Config.EXT%>",{});
        var div="";
        $("#homeLink").attr("title","");
        $("#ganttLink").attr("title","");
        $("#bugLink").attr("title","");
        for(var i=0;i<json.length;i++){
            var counter = json[i].counter;
            if(i==0 && counter>0){
                $("#topCounterSpan"+(i+1)).html("（<font color='red'>"+counter+"</font>）");
                $("#homeLink").attr("title","我有"+counter+"个待处理事项");
                div+="<div style='padding: 8px;'><a href='main.jsp'>您还有 <font color='red'>"+counter+"</font> 个待处理事项</a></div>";
            }else if(i==1 && counter>0){
                $("#topCounterSpan"+(i+1)).html("（<font color='red' title='"+counter+"个未完成的工作进程'>"+counter+"</font>）");
                $("#ganttLink").attr("title","我有"+counter+"个未完成的工作进程");
                div+="<div style='padding: 8px;'><a href='gantt_list.jsp'>您还有 <font color='red'>"+counter+"</font> 个未完成的工作进程</a></div>";
            }else if(i==2 && counter>0){
                $("#topCounterSpan"+(i+1)).html("（<font color='red' title='"+counter+"个未处理的反馈问题'>"+counter+"</font>）");
                $("#bugLink").attr("title","我有"+counter+"个未处理的反馈问题");
                div+="<div style='padding: 8px;'><a href='bug.jsp'>您还有 <font color='red'>"+counter+"</font> 个未处理的反馈问题</a></div>";
            }


        }
        <c:if test="${topSelected==1}">
        if(div!=""){
            window.setTimeout(function(){
                $("#topCounterDiv").html(div);
                $("#topCounterDiv").window(
                        {
                            title:'友情提醒',
                            width:250,
                            height:180,
                            modal:false,
                            minimizable:false,
                            maximizable:false,
                            collapsible:false
                        }
                );
                window.setTimeout(function(){
                    $("#topCounterDiv").window("close");
                },5*1000);
            },30*1000);
        }

        </c:if>
    }


    function f_addTab(title, href,closable,icon){
        var tt = $('#tabs');
        if (tt.tabs('exists', title)){//如果tab已经存在,则选中并刷新该tab
            tt.tabs('select', title);
            refreshTab({tabTitle:title,url:href});
        } else {
            if (href){
                var content = '<iframe scrolling="no" frameborder="0"  src="'+href+'" style="width:100%;height:100%;"></iframe>';
            } else {
                var content = '未实现';
            }
            tt.tabs('add',{
                title:title,
                closable:closable,
                content:content,
                iconCls:icon||'icon-default'
            });
        }
    }
    /**
     * 刷新tab
     * @cfg
     *example: {tabTitle:'tabTitle',url:'refreshUrl'}
     *如果tabTitle为空，则默认刷新当前选中的tab
     *如果url为空，则默认以原来的url进行reload
     */
    function f_refreshTab(cfg){
        var refresh_tab = cfg.tabTitle?$('#tabs').tabs('getTab',cfg.tabTitle):$('#tabs').tabs('getSelected');
        if(refresh_tab && refresh_tab.find('iframe').length > 0){
            var _refresh_ifram = refresh_tab.find('iframe')[0];
            var refresh_url = cfg.url?cfg.url:_refresh_ifram.src;
            //_refresh_ifram.src = refresh_url;
            _refresh_ifram.contentWindow.location.href=refresh_url;
        }
    }

    /***
     退出
     *
     */
    function f_logout(){
        $.messager.confirm('提示', '是否确定要退出<%=Config.SOFT_NAME%>?', function(r){
            if (r){
                location.href = 'logout.jsp';
            }
        });
    }

    /**
     * 初始化
     * */
    $(function(){
        f_addTab("首页","main.jsp",false);
        f_getOnlineListDiv();
        f_getOnlineList();
        <c:if test="${sessionScope.adminModel!=null}">
        //顶部统计信息
        f_getTopCount();
        window.setInterval(function(){
            //定时顶部统计信息
            f_getTopCount();
        },5*60*1000);
        window.setInterval(function(){
            //获取在线列表
            f_getOnlineList();
            <c:if test="${isCheckLogin==1}">
            //检查是否登陆
            f_checkLogin();
            </c:if>
        },30*1000);
        </c:if>
    });
</script>
</body>
</html>