<%--
  Created by IntelliJ IDEA.
  User: ggs
  Date: 12-7-27
  Time: 下午1:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${isCheckLogin!=null}">
    <%
        if(session.getAttribute("adminModel")==null){
           out.print("<script>top.location='login.jsp';</script>;");
        }
    %>
</c:if>
<%
    response.setHeader("Pragma","No-cache");
    response.setHeader("Cache-Control","no-cache");
    response.setDateHeader("Expires", 0);
%>
<script type="text/javascript">
    var CONTEXT_PATH = "<%=request.getContextPath()%>";
</script>
<link rel = "Shortcut Icon" href="images/ggsx.ico">
<link rel="stylesheet" type="text/css" href="js/ueditor/themes/default/ueditor.css"/>
<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css">
<link rel="stylesheet" href="js/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<link rel="stylesheet" type="text/css" href="style/ggs.css"/>

<script type="text/javascript" src="js/jquery/jquery-1.4.4.min.js"></script>
<script type="text/javascript" src="js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="js/easyui/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" charset="utf-8" src="js/ueditor/editor_config.js"></script>
<script type="text/javascript" charset="utf-8" src="js/ueditor/editor_all_min.js"></script>
<script type="text/javascript" src="js/zTree/js/jquery.ztree.all-3.1.min.js"></script>
<script type="text/javascript" src="js/md5.js"></script>
<script type="text/javascript" src="js/ggs.js"></script>
<script type="text/javascript">
    var onlineCount=0;
    var onlineList;


    /**
     * 检查是否登陆
     * */
    function f_checkLogin(){
        var json = $GGS.getJSON("checkLogin<%=Config.EXT%>",{});
        if(json.status==0){
            alert("<%=Config.SOFT_NAME%>服务器超时或服务器正在更新，请您退出后重新登录！");
            window.location="login.jsp";
        }
    }

    /**
     * 获取在线人员div
     * */

    function f_getOnlineListDiv(){
        var json = $GGS.getJSON("main/getOnlineList<%=Config.EXT%>",{});
        var users = $GGS.getJSON("main/getUsers<%=Config.EXT%>",{});
        if( json!=null ){
            //在线人数
            onlineCount=json.length;
            var div=""
            for(var i=0;i<users.length;i++){
                var times =users[i].onlinetimes;
                //当前等级
                var currgrade=1;
                //当前天数
                var currhour=parseInt(times/60);
                var remainhour=0;
                var img="";
                for(var j=0;j<onlinetimes.length;j++){
                    if(times<=onlinetimes[j].miniute){
                        currgrade=onlinetimes[j].grade;
                        remainhour=parseInt(onlinetimes[j].miniute/60-currhour);
                        img = onlinetimes[j].img;
                        break;
                    }
                }
                var gradestr=users[i].realname+" <span title='在线"+currhour+"小时，还要"+remainhour+"小时升级' style='color:#ff8c00;font-weight: bold;'>"+currgrade+"级 "+img+"</span>";
                if(users[i].id=="${sessionScope.adminModel.userid}") $("#topGradeSpan").html(gradestr);
                div+="<div style='padding: 3px;'>";

                //寻找在线人员
                var isFound=false;
                for(var j=0;j<json.length;j++){
                    if(users[i].realname==json[j]){
                        isFound=true;
                        break;
                    }
                }
                if(isFound){
                    //在线
                    div+="<img src='images/stateie.gif' />";
                }else{
                    //离线
                    div+="<img src='images/stateie2.gif' style='FILTER: gray;'/>";
                }
                div+=gradestr;
                div+=" <img src='images/grades/times.png'>"+currhour+"小时";
                div+=" <img src='images/grades/badtimes.png'>"+remainhour+"小时";
                div+="</div> ";
            }
            return div;
        }
    }

    /**
     * 在线人员
     * */
    function f_getOnlineList(){
        var json = $GGS.getJSON("main/getOnlineList<%=Config.EXT%>",{});
        if( json!=null ){
            //在线人数
            onlineCount=json.length;
            //寻找新上线人员
            for(var i=0;i<json.length;i++){
                if(onlineList!=null && onlineList!=undefined){
                    var isFound=false;
                    for(var j=0;j<onlineList.length;j++){
                        if(onlineList[j]==json[i]){
                            isFound=true;
                            break;
                        }
                    }
                    if(!isFound){
                        //新上线人员
                        f_showTips(json[i]+"上线了！");
                    }
                }
            }
            onlineList=json;
        }else{
            onlineCount=0;
        }
        //在线人数
        $("#onlineCountSpan").html(onlineCount);
    }


    /**
     * 信息框
     * */
    function f_alertInfo(msg){
        $.messager.alert("提示",msg,"info");
    }
    /**
     * 信息框
     * */
    function f_alertInfo(msg,fn){
        $.messager.alert("提示",msg,"info",fn);
    }
    /**
     * 错误提示
     * */
    function f_alertError(msg){
        $.messager.alert("提示",msg,"error");
    }
    /**
     * 错误提示
     * */
    function f_alertError(msg,fn){
        $.messager.alert("提示",msg,"error",fn);
    }
    /**
     * 小帖士提示
     * */
    function f_showTips(msg){
        $.messager.show({
            title:'提示',
            msg:msg,
            timeout:3000,
            showType:'slide'
        });
    }
    /**
     * 小帖士提示
     * */
    function f_showTipsAlways(msg){
        $.messager.show({
            title:'提示',
            msg:msg,
            timeout:0,
            showType:'slide'
        });
    }





    /**
     * 用户在线等级
     * */
     var onlinetimes=[
        {grade:1,miniute:2400,img:"<img src='images/grades/star.gif'>"},
        {grade:2,miniute:4800,img:"<img src='images/grades/star.gif'><img src='images/grades/star.gif'>"},
        {grade:3,miniute:9600,img:"<img src='images/grades/star.gif'><img src='images/grades/star.gif'><img src='images/grades/star.gif'>"},
        {grade:4,miniute:19200,img:"<img src='images/grades/moon.gif'>"},
        {grade:5,miniute:38400,img:"<img src='images/grades/moon.gif'><img src='images/grades/star.gif'>"},
        {grade:6,miniute:76800,img:"<img src='images/grades/moon.gif'><img src='images/grades/star.gif'><img src='images/grades/star.gif'>"},
        {grade:7,miniute:153600,img:"<img src='images/grades/moon.gif'><img src='images/grades/star.gif'><img src='images/grades/star.gif'><img src='images/grades/star.gif'>"},
        {grade:8,miniute:307200,img:"<img src='images/grades/moon.gif'><img src='images/grades/moon.gif'>"},
        {grade:9,miniute:614400,img:"<img src='images/grades/moon.gif'><img src='images/grades/moon.gif'><img src='images/grades/star.gif'>"},
        {grade:10,miniute:1228800,img:"<img src='images/grades/moon.gif'><img src='images/grades/moon.gif'><img src='images/grades/star.gif'><img src='images/grades/star.gif'>"},
        {grade:11,miniute:2457600,img:"<img src='images/grades/moon.gif'><img src='images/grades/moon.gif'><img src='images/grades/star.gif'><img src='images/grades/star.gif'><img src='images/grades/star.gif'>"},
        {grade:12,miniute:4915200,img:"<img src='images/grades/sun.gif'>"}
    ];







</script>