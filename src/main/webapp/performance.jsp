<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 12-12-29
  Time: 下午2:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ggs.comm.Config" %>
<%@ page import="com.ggs.util.DateUtil" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="isCheckLogin" value="1"></c:set>
<%@include file="inc.jsp"%>
<div class="easyui-layout" style="width:100%;height:100%;">
    <div data-options="region:'center',title:'Main Title',iconCls:'icon-ok'" >

        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tbody>
            <tr>


                <td width="50%" valign="top">
                    <table class="easyui-datagrid" title="工作进度" style="height:250px"
                           data-options="singleSelect:true,collapsible:false,url:'main/getUserProgress<%=Config.EXT%>'">
                        <thead>
                        <tr>
                            <th data-options="field:'yearmonth',width:80">月份</th>
                            <th data-options="field:'realname',width:80">姓名</th>
                            <th data-options="field:'counter',width:80">任务数量</th>
                            <th data-options="field:'leadcount',width:80">超前完成</th>
                            <th data-options="field:'delaynotfinishcount',width:80">超时未完成</th>
                            <th data-options="field:'delayfinishcount',width:80">超时完成</th>
                            <th data-options="field:'percent',formatter:formatFinishPercent,width:80">完成百份比</th>
                        </tr>
                        </thead>
                    </table>
                    <table class="easyui-datagrid" title="拜访报告提交情况" style="height:250px"
                           data-options="singleSelect:true,collapsible:false,url:'main/getVisitReport<%=Config.EXT%>'">
                        <thead>
                        <tr>
                            <th data-options="field:'yearmonth',width:80">月份</th>
                            <th data-options="field:'realname',width:80">姓名</th>
                            <th data-options="field:'counter',width:80">提交数量</th>
                        </tr>
                        </thead>
                    </table>

                    <table class="easyui-datagrid" title="周总结提交情况" style="height:250px"
                           data-options="singleSelect:true,collapsible:false,url:'main/getWeekSumm<%=Config.EXT%>'">
                        <thead>
                        <tr>
                            <th data-options="field:'yearmonth',width:80">月份</th>
                            <th data-options="field:'realname',width:80">姓名</th>
                            <th data-options="field:'counter',width:80">提交数量</th>
                        </tr>
                        </thead>
                    </table>

                    <table class="easyui-datagrid" title="学习会组织情况" style="height:250px"
                           data-options="singleSelect:true,collapsible:false,url:'main/getLearnMeet<%=Config.EXT%>'">
                        <thead>
                        <tr>
                            <th data-options="field:'yearmonth',width:80">月份</th>
                            <th data-options="field:'realname',width:80">姓名</th>
                            <th data-options="field:'title',width:200">学习会主题</th>
                        </tr>
                        </thead>
                    </table>




                </td>


                <td width="50%" valign="top">


                    <table class="easyui-datagrid" title="软件BUG提交情况" style="height:250px"
                           data-options="singleSelect:true,collapsible:false,url:'main/getBugs<%=Config.EXT%>'">
                        <thead>
                        <tr>
                            <th data-options="field:'yearmonth',width:80">月份</th>
                            <th data-options="field:'realname',width:80">姓名</th>
                            <th data-options="field:'buglevel',formatter:formatBugLevel,width:80">BUG等级</th>
                            <th data-options="field:'counter',width:80">BUG数量</th>
                            <th data-options="field:'noprocesscounter',width:80">未处理</th>
                            <th data-options="field:'processcounter',formatter:formatProcesscounter,width:80">已处理</th>
                            <th data-options="field:'finishcounter',width:80">已完成</th>
                        </tr>
                        </thead>
                    </table>
                    <table class="easyui-datagrid" title="人员BUG明细" style="height:500px"
                           data-options="singleSelect:true,collapsible:false,url:'main/getUserBug<%=Config.EXT%>'">
                        <thead>
                        <tr>
                            <th data-options="field:'yearmonth',width:80">月份</th>
                            <th data-options="field:'assignname',width:80">姓名</th>
                            <th data-options="field:'buglevel',formatter:formatBugLevel,width:80">BUG等级</th>
                            <th data-options="field:'counter',width:80">BUG数量</th>
                        </tr>
                        </thead>
                    </table>
                    <table class="easyui-datagrid" title="软件BUG解决情况" style="height:250px"
                           data-options="singleSelect:true,collapsible:false,url:'main/getUserAssign<%=Config.EXT%>'">
                        <thead>
                        <tr>
                            <th data-options="field:'yearmonth',width:80">月份</th>
                            <th data-options="field:'assignname',width:80">姓名</th>
                            <th data-options="field:'status',formatter:formatBugStatus,width:80">状态</th>
                            <th data-options="field:'counter',width:80">BUG数量</th>
                        </tr>
                        </thead>
                    </table>
                </td>
            </tr>
            </tbody>
        </table>



    </div>
</div>

<script type="text/javascript">
    //bug等级
    function formatBugLevel(val,row){
        if(row.buglevel==1){
            return "建议与新增";
        }else  if(row.buglevel==2){
            return "设计改进";
        }else  if(row.buglevel==3){
            return "一般错误";
        }else  if(row.buglevel==4){
            return "严重错误";
        } else  if(row.buglevel==5){
            return "致命错误";
        }
    }
     //bug修改状态
    function formatBugStatus(val,row){
        if(row.status==0){
            return "未处理";
        }else  if(row.status==1){
            return "已处理";
        }else  if(row.status==2){
            return "已完成";
        }
    }
   //完成百份比
    function formatFinishPercent(val,row){
        if(row.percent<90){
            return "<span style='color:red;'>"+row.percent+"</span>";
        }else{
            return row.percent;
        }
    }

    //计算已处理
    function formatProcesscounter(val,row){
        return row.counter-row.noprocesscounter-row.finishcounter;
    }

</script>


