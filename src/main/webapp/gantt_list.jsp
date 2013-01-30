<%@ page import="com.ggs.util.DateUtil" %>
<%--
  Created by IntelliJ IDEA.
  User: ggs
  Date: 12-8-21
  Time: 上午10:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="topSelected" value="3"></c:set>
<html>
<head>
<title><%=Config.SOFT_NAME%> - 工作进程列表</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<%@include file="inc.jsp"%>
<script type="text/javascript">

/**
 * 获取文章
 * */
function f_getArticles(){

    var myUrl="progress/getProgessList<%=Config.EXT%>?q=1";
    if(vData.startdate !=undefined){
        myUrl+="&startdate="+vData.startdate;
    }
    if(vData.prjid !=undefined){
        myUrl+="&prjid="+vData.prjid;
    }
    if(vData.userid !=undefined){
        myUrl+="&userid="+vData.userid;

    }
    if(vData.creatid !=undefined){
        myUrl+="&creatid="+vData.creatid;

    }
    if(vData.cname !=undefined){
        myUrl+="&cname="+vData.cname;

    }

    myUrl=encodeURI(myUrl);


    $('#gridTable').datagrid({
        //title:"工作进程",
        url:myUrl,
        pageSize:20,
        frozenColumns:[[

        ]],
        columns:[[
            {field:'status',title:'状态',width:60,align:"center",
                formatter:function(value,row,index){
                    var str="<img src='images/denied.png' title='未处理'>";
                    if(row.pc>0 && row.pc<100){
                        str="<img src='images/shortkey.png' title='已处理'>"
                    }
                    if(row.pc==100){
                        str="<img src='images/ok.png' title='已完成'>"
                    }
                    return str;
                }
            },
            {field:'priority',title:'优先级',width:60,align:"center",
                formatter:function(value,row,index){
                    if (row.priority==1){
                        return "<span style='background-color: gray;color: white'>低</span>";
                    } else if(row.priority==2){
                        return "<span style='background-color: #ff8c00;color: white;'>中</span>";
                    } else if(row.priority==3){
                        return "<span style='background-color: red;color: white;'>高</span>";
                    }
                }
            },
            {field:'difficulty',title:'难度',width:80,align:"center",
                formatter:function(value,row,index){
                    if (row.difficulty==1){
                        return "<span style='background-color: gray;color: white'>非常容易</span>";
                    } else if(row.difficulty==2){
                        return "<span style='background-color: #ff8c00;color: white;'>容易</span>";
                    } else if(row.difficulty==3){
                        return "<span>中等</span>";
                    } else if(row.difficulty==4){
                        return "<span style='background-color: red;color: white;'>困难</span>";
                    }else if(row.difficulty==5){
                        return "<span style='background-color: #8b008b;color: white;'>非常困难</span>";
                    }
                }
            },
            {field:'prjname',title:"项目名称",width:150},
            {field:'cname',title:'进程名称',width:250,
                formatter:function(value,row,index){
                    var title="";
                    var color="";
                    var curdate = "<%=DateUtil.getDate("yyyy-MM-dd")%>";
                    if(curdate>=row.startdate && curdate<=row.enddate ){
                        color="color:red;";
                        title="当前进程（计划周期内的进程）";
                    }
                    return "<span style='"+color+"' title='"+title+"'>"+row.cname+"</span>";
                }},

            {field:'realname',title:'负责人',width:80 },
            {field:'pc',title:'完成进度',width:150, sortable:true,
                formatter:function(value,row,index){
                    var str=" <div style=\"color:Silver;border-width:1px;border-style:Solid;width:140;\">";
                    var fcolor="";
                    var ftext="";
                    if(row.pc==0){
                        fcolor="color:red;";
                    }else{
                        ftext=row.pc+"%";
                    }
                    str+="<div style=\""+fcolor+"background-color:#06F; height:21px; width:"+row.pc+"%;text-align:center;\">"+ftext+"</div>";
                    str+="</div>";
                    return str;
                }
            },

            {field:'startdate',title:'计划起始日期',width:100,align:"center",sortable:true},
            {field:'enddate',title:'计划完成日期',width:100,align:"center",sortable:true},

            {field:'realdate',title:'实际完成日期',width:100,align:"center",sortable:true},
            {field:'finishStatus',title:'完成情况',width:100,  align:"center",
                formatter:function(value,row,index){
                var color="";
                var text="";
                if(row.pc<100 && row.enddate<"<%=DateUtil.getDate("yyyy-MM-dd")%>")  {
                    color="color:red;";
                    text="超时未完成";
                }
                else if(row.pc==100 && row.realdate!="" && row.realdate>row.enddate)  {
                    color="color:red;";
                    text="延迟完成";
                }
                else if(row.pc==100 && row.realdate!="" &&  row.realdate<row.enddate)  {
                    color="color:blue;";
                    text="超前完成";
                }
                else if(row.pc==100 && row.realdate==row.enddate){
                    color="color:green;";
                    text="正常完成";
                }
                else if(row.pc<100 && row.pc>0){
                    color="color:red;";
                    text="未完成";
                }
                else if(row.pc==0){
                    color="color:black;";
                    text="未开始";
                }

                return "<span style='"+color+"'>"+text+"</span>";

            }

            } ,
            {field:'memo',title:'工作进展情况',width:300,
                formatter:function(value,row,index){
                    return "<div title='"+row.memo+"'>"+row.memo+"</div>";
                }
            },
            {field:'creatname',title:'创建人',width:80 },
            {field:'creattime',title:'创建时间',width:100 }


        ]],
        toolbar:'#tb',
        striped: true,
        singleSelect:true,
        onClickRow:function(rowIndex, rowData){
            f_openGanttDialog(rowData.id);
        }
    });
}

/**
 * 获取日期列表
 * */
function f_getDateList(){

    var sel = document.all.dateListSel;
    var json = $GGS.getJSON("progress/getProgressDateList<%=Config.EXT%>",{});

    for(var i=0;i<json.length;i++){
        sel.options[sel.length]=new Option(json[i].yearmonth,json[i].yearmonth);
    }
    sel.onchange=function(){


        vData.startdate=this.value;
        f_getArticles();
    }
}

/**
 * 获取项目列表
 * */
function f_getProjectList(){

    var sel =document.all.prjid;
    var sel2 = document.all.projectListSel;
    var json = $GGS.getJSON("progress/getProjectList<%=Config.EXT%>",{});
    for(var i=0;i<json.length;i++){
        sel.options[sel.length]=new Option(json[i].cname,json[i].id);
        sel2.options[sel2.length]=new Option(json[i].cname,json[i].id);
    }

    sel2.onchange=function(){



        vData.prjid=this.value;
        f_getArticles();
    }
}


/**
 * 刷新表格
 * */
function f_refreshGrid(){
    $('#gridTable').datagrid('reload');
}

/**
 * 清空参数
 * */
function f_clearVData(){
    vData.startdate=undefined;
    vData.prjid=undefined;
    vData.prjname=undefined;
    vData.userid=undefined;
    vData.creatid=undefined;
    vData.cname=undefined;
    $("#dateListSel").val("");
    $("#projectListSel").val("");
}


/**
 * 获取用户
 * */

function f_getUsers(){
    var sel =document.all.userid;
    var users = $GGS.getJSON("main/getUsers<%=Config.EXT%>",{});
    for(var i=0;i<users.length;i++){
        sel.options[sel.length]=new Option(users[i].realname,users[i].id);
    }
}

/**
 * 打开编辑窗口
 * */
function f_openGanttDialog(proid){
    $("#startEndDateBody").css("display","");
    $("#startEndDateSpanBody").css("display","none");
    $("#ganttWindow").css("display","");
    $("#okBtn").css("display","");
    $("#delBtn").css("display","");

    $("#cname").attr("disabled","");
    $("#userid").attr("disabled","");
    $("#startdate").attr("disabled","");
    $("#enddate").attr("disabled","");
    $("#prjid").attr("disabled","");
    $("#priority").attr("disabled","");
    $("#difficulty").attr("disabled","");

    $("#realdate").attr("disabled","");
    $("#pc").attr("disabled","");
    $("#memo").attr("disabled","");

    if(proid!=undefined){
        $("#optionalBody").css("display","");
        var json =$GGS.getJSON("progress/getProgressById<%=Config.EXT%>",{proid:proid});
        $("#proid").val(json.id);
        $("#cname").val(json.cname);
        $("#userid").val(json.userid);
        $('#startdate').datebox('setValue',json.startdate);
        $("#startdateSpan").html(json.startdate);
        $('#enddate').datebox('setValue',json.enddate);
        $("#enddateSpan").html(json.enddate);
        $("#pc").val(json.pc);
        $("#prjid").val(json.prjid);
        $("#memo").val(json.memo);
        $('#realdate').val(json.realdate);
        $('#realdateSpan').html(json.realdate);

        $("#priority").val(json.priority);
        $("#difficulty").val(json.difficulty);



        if(json.creatid=="${sessionScope.adminModel.userid}" && json.userid!="${sessionScope.adminModel.userid}"){
            //创建人
            $("#realdate").attr("disabled","disabled");
            $("#pc").attr("disabled","disabled");

        }
        else if(json.userid=="${sessionScope.adminModel.userid}" && json.creatid!="${sessionScope.adminModel.userid}"){
            //负责人
            $("#cname").attr("disabled","disabled");
            $("#userid").attr("disabled","disabled");
            $("#startdate").attr("disabled","disabled");
            $("#enddate").attr("disabled","disabled");
            $("#prjid").attr("disabled","disabled");
            $("#priority").attr("disabled","disabled");
            $("#difficulty").attr("disabled","disabled");
            $("#delBtn").css("display","none");
        }else if((json.userid!="${sessionScope.adminModel.userid}" && json.creatid!="${sessionScope.adminModel.userid}")){
            $("#okBtn").css("display","none");
            $("#delBtn").css("display","none");
            $("#cname").attr("disabled","disabled");
            $("#userid").attr("disabled","disabled");
            $("#startdate").attr("disabled","disabled");
            $("#enddate").attr("disabled","disabled");
            $("#prjid").attr("disabled","disabled");
            $("#priority").attr("disabled","disabled");
            $("#difficulty").attr("disabled","disabled");
            $("#realdate").attr("disabled","disabled");
            $("#pc").attr("disabled","disabled");

        }

        //只要进度大于0，计划日期等信息不能修改，而且不能删除
       if(json.pc>0 && json.pc<100){
           $("#delBtn").css("display","none");
           $("#cname").attr("disabled","disabled");
           $("#userid").attr("disabled","disabled");
           $("#startEndDateBody").css("display","none");
           $("#startEndDateSpanBody").css("display","");
           $("#prjid").attr("disabled","disabled");
           $("#priority").attr("disabled","disabled");
           $("#difficulty").attr("disabled","disabled");
           if(json.creatid=="${sessionScope.adminModel.userid}" && json.userid!="${sessionScope.adminModel.userid}"){
               $("#okBtn").css("display","none");
           }
       }else if (json.pc==100){
           $("#pc").attr("disabled","disabled");
           $("#delBtn").css("display","none");
           $("#startEndDateBody").css("display","none");
           $("#startEndDateSpanBody").css("display","");
           $("#priority").attr("disabled","disabled");
           $("#difficulty").attr("disabled","disabled");
           $("#userid").attr("disabled","disabled");

       }


    }else{
        $("#optionalBody").css("display","none");
        $("#cname").val("新工作进程");
        $("#userid").val(${sessionScope.adminModel.userid});
        $('#startdate').datebox('setValue','<%=DateUtil.getDate("yyyy-MM-dd")%>');
        $('#enddate').datebox('setValue','<%=DateUtil.getDate("yyyy-MM-dd")%>');
        $("#pc").attr("selectedIndex","0");
        $("#proid").val("");
        $("#prjid").attr("selectedIndex","0");
        $("#memo").val("");
        $('#realdate').val("");
        $("#priority").attr("selectedIndex","0");
        $("#difficulty").attr("selectedIndex","0");
    }

    $("#ganttWindow").window(
            {
                title:'编辑进程',
                width:700,
                height:450,
                modal:true,
                minimizable:false,
                maximizable:false,
                collapsible:false
            }
    );

}
/**
 * 关闭窗口
 * */
function f_closeGanttWindow(){
    $("#ganttWindow").window("close");
}

/**
 * 保存进程
 * */
function f_saveProgress(){
    if($("#cname").val()==""){
        f_alertError("工作进程名称不能为空！");
        return false;
    }
    if($("#prjid").val()=="-1"){
        f_alertError("请选择进程所属项目！");
        return false;
    }

    if($("#proid").val()){
        if($.trim($("#memo").val())==""  || $.trim($("#memo").val()).length<10){
            f_alertError("工作进展情况不能为空或者小于10个字符！<br/>格式如下：<br/>12.4 需求整理及ER图设计<br/>12.5 创建数据库及软件工程");
            return false;
        }
    }


    if($("#pc").val()==100){
        $("#realdate").val("<%=DateUtil.getDate("yyyy-MM-dd")%>");
    }

    $GGS.ajax("progress/saveProgress<%=Config.EXT%>",{
        proid:$("#proid").val(),
        cname:$("#cname").val(),
        userid:$("#userid").val(),
        startdate:$('#startdate').datebox('getValue'),
        enddate:$('#enddate').datebox('getValue'),
        pc:$("#pc").val(),
        memo:$("#memo").val(),
        prjid:$("#prjid").val(),
        realdate:$('#realdate').val() ,
        priority:$("#priority").val(),
        difficulty:$("#difficulty").val()
    });
    f_getArticles();
    f_closeGanttWindow();
}

/**
 * 删除进程
 * */
function f_delProgress(){
    $.messager.confirm('提示', '是否确定删除此任务?', function(r){
        if (r){
            $GGS.ajax("progress/delProgress<%=Config.EXT%>",{proid:$("#proid").val()});
            f_getArticles();
            f_closeGanttWindow();
        }
    });

}

/**
 * 我负责的进程
 * */
function f_getMyProgress(){

    f_clearVData();
    vData.userid="${sessionScope.adminModel.userid}";
    f_getArticles();
}

/**
 * 全部进程
 * */
function f_getAllProgress(){

    f_clearVData();
    f_getArticles();

}

/**
 * 我创建的进程
 * */
function f_getMyCreaProgress(){
    f_clearVData();
    vData.creatid="${sessionScope.adminModel.userid}";
    f_getArticles();
}






var vData = new Object();
$(function(){
    $("#okBtn").click(function(){f_saveProgress();});
    $("#closeBtn").click(function(){f_closeGanttWindow();});
    $("#delBtn").click(function(){f_delProgress();});
    f_getDateList();
    f_getProjectList();
    window.setTimeout(function(){
        f_getArticles();

    },500);
    f_getUsers();
});
</script>
</head>
<body>
<%@include file="top.jsp"%>
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="borderTable normalFont">
    <tr>

        <td>
            <!-- 列表-->
            <table id="gridTable" class="easyui-datagrid"   iconCls="icon-search"
                   rownumbers="true" pagination="true">
            </table>
        </td>
     </tr>

  </table>

<script type="text/javascript">
    var myHeight=230;
    $("#gridTable").css("height",screen.availHeight-260);
    $("#userProgTable").css("height",screen.availHeight-440);
</script>

<div id="ganttWindow" style="display: none;">
    <input type="hidden" id="proid">
    <table width="100%" align="center" border="0" cellpadding="5" class="normalFont">
        <c:if test="${sessionScope.adminModel!=null}">
        <tr>
            <td colspan="4">
                <a id="delBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-no'">删除</a>
            </td>
        </tr>
            </c:if>


        <tr>
            <td align="right" valign="top">进程名称</td>
            <td colspan="3"><input type="text" id="cname" style="width: 400px;"></td>
        </tr>
        <tr>
            <td align="right" valign="top">所属项目</td>
            <td colspan="3">
            <select id="prjid" style="width: 200px;">
                <option value="-1">==请选择==</option>
            </select></td>
        </tr>
        <tr>
            <td align="right" valign="top">负责人</td>
            <td colspan="3">
                <select id="userid"></select>
            </td>
        </tr>
        <tr>
            <td align="right" valign="top">优先级</td>
            <td>
                <select id="priority" >
                    <option value="1">低</option>
                    <option value="2">中</option>
                    <option value="3">高</option>
                </select>
            </td>
            <td align="right" valign="top">难度</td>
            <td>
                <select id="difficulty" >
                    <option value="1">非常容易</option>
                    <option value="2">容易</option>
                    <option value="3">中等</option>
                    <option value="4">困难</option>
                    <option value="5">非常困难</option>
                </select>
            </td>
        </tr>

        <tr id="startEndDateBody">
            <td align="right" valign="top">计划起始日期</td>
            <td><input id="startdate" class="easyui-datebox" data-options="formatter:myformatter"></td>
            <td align="right" valign="top">计划结束日期</td>
            <td><input id="enddate" class="easyui-datebox" data-options="formatter:myformatter"></td>
        </tr>


        <tr  id="startEndDateSpanBody">
            <td align="right" valign="top">计划起始日期</td>
            <td><span id="startdateSpan"></span></td>
            <td align="right" valign="top">计划结束日期</td>
            <td><span id="enddateSpan"></span></td>
        </tr>


            <tr id="optionalBody">
                <td align="right" valign="top">完成百份比</td>
                <td>
                    <select id="pc">
                        <c:forEach var="i" begin="0" end="100" step="10">
                            <option value="${i}">${i}%</option>
                        </c:forEach>
                    </select>
                </td>
                <td align="right" valign="top">实际完成日期</td>
                <td>
                    <input id="realdate" type="hidden">
                    <span id="realdateSpan"></span>
                    </td>
            </tr>

        <tr>
            <td align="right" valign="top">工作进展情况</td>
            <td colspan="3"><textarea rows="5" cols="60" id="memo"></textarea></td>
        </tr>
        <c:if test="${sessionScope.adminModel!=null}">
            <tr>
                <td align="center" colspan="4">
                    <a id="okBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">保存</a>
                    <a id="closeBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'">关闭</a>
                </td>
            </tr>
        </c:if>
    </table>
</div>




<div id="tb">
    <a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-reload'" onclick="f_refreshGrid();" >刷新</a>
    <c:if test="${sessionScope.adminModel!=null}">
        <a href='#' onclick='f_openGanttDialog(undefined);' class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">新增进程</a>
     </c:if>
    <c:if test="${sessionScope.adminModel!=null}">
        <a href="#"  class="easyui-menubutton" data-options="menu:'#myprocessDiv'" >我的进程</a>
    </c:if>
    <a  href="#"  class="easyui-linkbutton" data-options="plain:true" onclick="f_getAllProgress();" >全部进程</a>
    月份：<select id="dateListSel"  >
        <option value="">全部</option>
    </select>
    项目：<select id="projectListSel"   >
    <option value="">全部</option>
    </select>
    <input class="easyui-searchbox" data-options="prompt:'请输入关键字',menu:'#mm',
			searcher:function(value,name){
			    if(name==0){
			        vData.cname=value;
                    f_getArticles();
			    }
			}" style="width:200px"/>
    <div id="mm" style="width:120px">
        <div data-options="name:'0'">进程名称</div>
    </div>

</div>
<c:if test="${sessionScope.adminModel!=null}">
<div id="myprocessDiv" style="width: 150px;">
    <div onclick="f_getMyProgress();">我负责的进程</div>
    <div onclick="f_getMyCreaProgress();" >我创建的进程</div>
</div>
</c:if>

<script type="text/javascript">
    function myformatter(date){
        var y = date.getFullYear();
        var m = date.getMonth()+1;
        var d = date.getDate();
        return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
    }
    function f_query(){
        var d1=$('#creattime1').datebox('getValue');
        var d2=$('#creattime2').datebox('getValue');
        f_getArticles({creattime1:d1,creattime2:d2});
    }

</script>


<%@include file="foot.jsp"%>
</body>
</html>