<%--
  Created by IntelliJ IDEA.
  User: ggs
  Date: 12-5-28
  Time: 下午5:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ggs.comm.Config" %>
<%@ page import="com.ggs.util.DateUtil" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div style="margin-bottom: 5px;">
    <b class="b1"></b><b class="b2 d1"></b><b class="b3 d1"></b><b class="b4 d1"></b>
    <div class="b d1 k" style="height: 60px;">
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
    </div>
    <b class="b4b d1"></b><b class="b3b d1"></b><b class="b2b d1"></b><b class="b1b"></b>
</div>
      <c:if test="${sessionScope.adminModel!=null}">
    <div class="normalFont" style="margin: 5px;">
        <a id="homeLink"  href="<%=Config.INDEX_PAGE%>" class="easyui-linkbutton" data-options="plain:true"><img src="images/home.png"> 综合管理<span id='topCounterSpan1'></span></a>
        <a id="editorLink"  href="editor.jsp" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-edit'">撰写笔记</a>
        <a id="ganttLink"  href="gantt_list.jsp" class="easyui-linkbutton" data-options="plain:true"><img src="images/issue.png"width="16" height="16"> 工作进程<span id='topCounterSpan2'></span></a>
        <a id="bugLink" href="bug.jsp" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-help'">问题反馈<span id='topCounterSpan3'></span></a>
        <a id="addrLink" href="addr.jsp" class="easyui-linkbutton" data-options="plain:true"><img src="images/stateie.gif">&nbsp;通讯录</a>
        <a href="ftp://dj:dj@110.90.112.121" target="_blank" class="easyui-linkbutton" data-options="plain:true"><img src="images/communication.png"width="16" height="16">&nbsp;FTP</a>
        <a href="http://110.90.112.121:8888" target="_blank" class="easyui-linkbutton" data-options="plain:true"><img src="images/order_159.png"width="16" height="16">&nbsp;OA</a>
        <a href="http://mail.ykesoft.com" target="_blank" class="easyui-linkbutton" data-options="plain:true"><img src="images/business_contact.png"width="16" height="16">&nbsp;企业邮箱</a>
        <a id="shuiLink" href="shui.jsp" class="easyui-linkbutton" data-options="plain:true"><img src="images/cash.png"width="16" height="16">&nbsp;个税计算器</a>

    </div>
      </c:if>
<div id="userOnlinetimesDiv">
</div>
<div id="passwordDiv"></div>
<div id="topCounterDiv"></div>
<script type="text/javascript">
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
                    div+="<div style='padding: 8px;'><a href='index.jsp'>您还有 <font color='red'>"+counter+"</font> 个待处理事项</a></div>";
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

    /**
     * 初始化
     * */
    $(function(){
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

            var backColor="#E6EFFE";
            var topSelLink="";
            <c:choose>
                    <c:when test="${topSelected==1}">
                        topSelLink="homeLink";
                    </c:when>
                    <c:when test="${topSelected==2}">
                        topSelLink="editorLink";
                    </c:when>
                    <c:when test="${topSelected==3}">
                        topSelLink="ganttLink";
                    </c:when>
                    <c:when test="${topSelected==4}">
                        topSelLink="bugLink";
                    </c:when>
                    <c:when test="${topSelected==5}">
                        topSelLink="addrLink";
                    </c:when>
                    <c:when test="${topSelected==6}">
                    topSelLink="shuiLink";
                    </c:when>
            </c:choose>
            $("#"+topSelLink).css("background-color",backColor);

        </c:if>

    });
</script>

