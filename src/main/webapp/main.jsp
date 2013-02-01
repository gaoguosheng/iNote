

<%--
  Created by IntelliJ IDEA.
  User: ggs
  Date: 12-7-19
  Time: 下午5:12
  To change this template use File | Settings | File Templates.
--%>
<%@page language="java" pageEncoding="UTF-8" %>
<%@ page import="com.ggs.comm.Config" %>
<%@ page import="com.ggs.util.DateUtil" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="isCheckLogin" value="1"></c:set>
<c:set var="topSelected" value="1"></c:set>
<html>
<head>
    <title><%=Config.SOFT_NAME%> - 首页</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <%@include file="inc.jsp"%>
    <script type="text/javascript">
        var noteType={"dayNote":1,"myNote":2};
        var myType;
        var creattime;
        var selName;
        /**
         * 获取文章
         * */
        function f_getArticles(data){
            var myUrl="main/getArticlesByDay<%=Config.EXT%>?q=1";
            if(data.creattime1 !=undefined){
                myUrl+="&creattime1="+data.creattime1;
            }
            if(data.creattime2 !=undefined){
                myUrl+="&creattime2="+data.creattime2;
            }
            if(data.userid !=undefined){
                myUrl+="&userid="+data.userid;
            }
            if(data.assignid !=undefined){
                myUrl+="&assignid="+data.assignid;
            }
            if(data.status !=undefined){
                myUrl+="&status="+data.status;
            }
            if(data.folderid !=undefined){
                myUrl+="&folderid="+data.folderid;
            }
            if(data.isread!=undefined){
                myUrl+="&isread="+data.isread;
            }
            if(data.title!=undefined){
                myUrl+="&title="+data.title;
            }
            if(data.content!=undefined){
                myUrl+="&content="+data.content;
            }
            if(data.hascomment!=undefined){
                myUrl+="&hascomment="+data.hascomment;
            }
            if(data.hasmycomment!=undefined){
                myUrl+="&hasmycomment="+data.hasmycomment;
            }
            if(data.csort!=undefined){
                myUrl+="&csort="+data.csort;
            }
            if(data.isfavorites!=undefined){
                myUrl+="&isfavorites="+data.isfavorites;
            }
            myUrl=encodeURI(myUrl);
            $('#gridTable').datagrid({
                //title:'笔记列表',
                url:myUrl,
                pageSize:20,
                frozenColumns:[[

                ]],
                columns:[[
                    {field:'status',title:'状态',width:40,align:'center',
                        formatter: function(value,row,index){
                            if(row.assignid){
                                if(row.status==0){
                                    return "<img src='images/denied.png' title='未处理'/>";
                                }else if(row.status==1){
                                    return "<img src='images/shortkey.png' title='已处理'/>";
                                }else if(row.status==2){
                                    return "<img src='images/ok.png' title='已完成'/>";
                                }
                            }
                        }
                    },
                    {field:'priority',title:'优先级',width:50,align:'center',sortable:true,
                        formatter: function(value,row,index){
                            if(row.assignid){
                                if (row.priority==1){
                                    return "<span style='background-color: gray;color: white'>低</span>";
                                } else if(row.priority==2){
                                    return "<span style='background-color: #ff8c00;color: white;'>中</span>";
                                } else if(row.priority==3){
                                    return "<span style='background-color: red;color: white;'>高</span>";
                                }
                            }
                        }},

                    {field:'creattime',title:'创建时间',width:80,align:'center',sortable:true,
                        formatter: function(value,row,index){
                            return row.creattime.substr(0,10);
                        }},
                    {field:'title',title:'标题',width:200,
                        formatter: function(value,row,index){
                            var style="";
                            var today="<%=DateUtil.getDate("yyyy-MM-dd")%>";
                            if(row.creattime.substring(0,10)==today || (row.updatetime && row.updatetime.substring(0,10)==today)){
                                style="color:red";
                            }
                            if(row.isread==0){
                                style="color:green";
                            }
                            return "<a href='show<%=Config.EXT%>?id="+row.id+"' target='_blank' title='打开笔记'><span style='"+style+"'>"+row.title+"</span></a>";
                        }
                    },
                    {field:'foldername',title:'文件夹',width:150,
                        formatter: function(value,row,index){
                            return "<a href='#' onclick='f_getFolderArticles("+row.folderid+"); return false;' title='打开"+row.foldername+"文件夹下所有笔记'>"+row.foldername+"</a>";
                        }
                    },

                    {field:'realname',title:'创建人',width:60},
                    {field:'views',title:'查看',width:60,align:'center',sortable:true},


                    {field:'assigname',title:'指派',width:60},
                    {field:'buglevel',title:'BUG等级',width:100,
                        formatter: function(value,row,index){
                            if(row.assignid){
                                if(row.buglevel==1){
                                    return "建议与新增";
                                }else if(row.buglevel==2){
                                    return "设计改进";
                                }else if(row.buglevel==3){
                                    return "一般错误";
                                }else if(row.buglevel==4){
                                    return "严重错误";
                                }else if(row.buglevel==5){
                                    return "致命错误";
                                }

                            }
                        }},
                    {field:'processtime',title:'处理时间',width:120,align:'center',sortable:true},
                    {field:'finishtime',title:'完成时间',width:120,align:'center',sortable:true}


                ]] ,
                toolbar:'#tb',
                striped: true,
                singleSelect:true,
                onClickRow:function(rowIndex, rowData){

                }

            });



        }

        /**
         * 刷新表格
         * */
       function f_refreshGrid(){
            $('#gridTable').datagrid('reload');
            //刷新状态数量
            f_getMyStatusCount();

       }

        /**
         * 我的笔记
         * */
        function f_myNote(){
            //我的笔记类型
            myType=noteType.myNote;
            selName="我的笔记";
            f_getArticles({userid:${sessionScope.adminId}});
        }

        /**
         * 查看其他笔记本
         * */

        function f_otherNote(userid,realname){
            myType=noteType.myNote;
            selName=realname+"的笔记";
            f_getArticles({userid:userid});
        }

        /**
         * 全部笔记
         * */
        function f_allNote(){
            f_getArticles({});
        }


        /**
         * 未读笔记
         * */
        function f_noReadNote(){
            f_getArticles({isread:0});
        }



        /**
         * 获取用户
         * */

        function f_getUsers(){
            var users = $GGS.getJSON("main/getUsers<%=Config.EXT%>",{});
            var div="";
            for(var i=0;i<users.length;i++){
                //if(users[i].id=="${sessionScope.adminId}")continue;
                div+="<div onclick='f_otherNote("+users[i].id+",\""+users[i].realname+"\");'>"+users[i].realname+"</div>";
            }
            $("#OtherUserDiv").html(div);
        }

        /**
         * 查看状态笔记
         * */
        function f_getMyStatusArticle(status){
            myType=noteType.myNote;
            if(status==0){
                selName="我未处理事项";
            }else if(status==1){
                selName="我已处理事项";
            }else if(status==2){
                selName="我发起的事项";
            }
            f_getArticles({assignid:${sessionScope.adminId},status:status});
        }

        /**
         * 查看状态笔记
         * */
        function f_getAllStatusArticle(status){
            myType=noteType.myNote;
            if(status==0){
                selName="未处理事项";
            }else if(status==1){
                selName="已处理事项";
            }else if(status==2){
                selName="已完成事项";
            }
            f_getArticles({status:status});
        }

        /**
         * 显示某个文件夹的笔记
         * */
        function f_getFolderArticles(folderid,title){
            myType=noteType.myNote;
            selName=title+"文件夹";
            f_getArticles({folderid:folderid});
        }




        /**
         * 获取状态数量统计
         * */
        function f_getMyStatusCount(){
            //加载状态数量
            var c = $GGS.getJSON("main/getMyStatusCount<%=Config.EXT%>",{});
            for(var i=0;i< c.length;i++){
                $("#myStatusSpan"+c[i].status).html(c[i].counter);
            }
        }

        /**
         * 全部标为已读
         * */
        function f_updateReadAllFlag(){
            $.messager.confirm('提示', '是否确认将所有未读笔记置为已读?', function(r){
                if (r){
                    $GGS.ajax("main/updateReadAllFlag<%=Config.EXT%>",{});
                    f_refreshGrid();
                }
            });
        }

        /**
         * 获取被评论列表
         * */
        function f_getCommentList(){
            f_getArticles({hascomment:1})    ;
        }

        /**
         * 获取我已评论列表
         * */
        function f_getMyCommentList(){
            f_getArticles({hasmycomment:1})    ;
        }



        /**
         * 获取分类列表
         * */
        function f_getCsortList(csort){
            f_getArticles({csort:csort}) ;
        }

        /**
         * 获取收藏夹列表
         * */
        function f_getFavoritesList(){
            f_getArticles({isfavorites:1}) ;
        }

        /**
         * 初始化
         * */
        $(function(){

            //默认为日历笔记本类型
            myType=noteType.dayNote;



            //加载状态数量统计
            f_getMyStatusCount();



            window.setTimeout(function(){
                //加载文章
                f_getArticles({});
            },500);

        });
    </script>
</head>
<body>
    <%@include file="top.jsp"%>
    <table border="0" cellpadding="0" cellspacing="0" width="100%" class="borderTable normalFont">
        <tr>
            <td valign="top" width="180">

                <div style="text-align: left;margin: 10px;">
                    <div>
                        <a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_allNote();return false;" title="全部笔记">全部（<span style="color: red;" id="myStatusSpan15"></span>）</a>
                        <a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_getArticles({creattime1:'<%=DateUtil.getDate("yyyy-MM-dd")%>'});return false;" title="今天笔记">今天（<span style="color: red;" id="myStatusSpan14"></span>）</a>

                    </div>
                    <hr/>
                    <div>
                        <a href="#" class="easyui-menubutton" data-options="menu:'#myNoteDiv',plain:true" onclick="f_myNote();return false;" title="我撰写的所有笔记">我的笔记（<span id="myStatusSpan13" style="color: red;"></span>）</a>
                        <a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_getFavoritesList();return false;" title="我收藏的笔记">我的收藏夹（<span style="color: red;"  id="myStatusSpan19"></span>）</a>
                    </div>
                    <hr/>

                    <div>
                        <a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_getMyStatusArticle(0);return false;" title='指派给我或待确认完成的事项'>我待处理事项（<span style="color: red;"  id="myStatusSpan10"></span>）</a>
                    </div>
                    <div>
                        <a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_getMyStatusArticle(2);return false;" title='我发起的所有事项' >我发起的事项（<span style="color: red;" id="myStatusSpan12"></span>）</a>
                    </div>
                    <div>
                        <a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_getMyStatusArticle(1);return false;" title='指派给我已处理完毕的事项'>我已处理事项（<span style="color: red;" id="myStatusSpan11"></span>）</a>
                    </div>
                    <hr/>

                    <div><a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_getCsortList(8);return false;">规章制度</a>
                        <a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_getCsortList(7);return false;">考勤记录</a>
                    </div>
                    <div>
                        <a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_getCsortList(4);return false;">部门会议</a>
                        <a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_getCsortList(5);return false;">学习会</a>
                        </div>
                    <div>
                        <a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_getCsortList(6);return false;">工作计划</a>
                        <a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_getCsortList(1);return false;">工作总结</a>
                        <a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_getCsortList(10);return false;">工作日志</a>
                    </div>
                    <hr/>
                    <div>
                        <a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_getCsortList(9);return false;">软件需求</a>
                        <a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_getCsortList(2);return false;">软件BUG</a></div>
                    <hr/>
                    <div><a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_getCsortList(3);return false;">客户拜访报告</a></div>
                    <hr/>
                    <div><a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_getCsortList(99);return false;">撰写模板</a></div>
                </div>


            </td>
            <td valign="top">
                <!-- 列表-->
                <table id="gridTable" class="easyui-datagrid"   iconCls="icon-search"
                       rownumbers="true" pagination="true">
                </table>
                <script type="text/javascript">
                    var myHeight=260;
                    $("#gridTable").css("height",screen.availHeight-myHeight);
                </script>
                </div>
            </td>
            <td valign="top" width="200px">
                <table id="userListGrid" class="easyui-datagrid" title="用户通讯录"
                       data-options="singleSelect:true,collapsible:false,url:'main/getUsers<%=Config.EXT%>'">
                    <thead>
                    <tr>
                        <th data-options="field:'username',width:40">帐号</th>
                        <th data-options="field:'realname',width:60">姓名</th>
                        <th data-options="field:'mobile',width:100">手机</th>
                        <th data-options="field:'qq',width:100">QQ</th>
                    </tr>
                    </thead>
                </table>
                <script type="text/javascript">
                    var myHeight=260;
                    $("#userListGrid").css("height",screen.availHeight-myHeight);
                </script>
            </td>
        </tr>
    </table>


    <jsp:include page="/foot.jsp" flush="true"></jsp:include>
    <div id="myNoteDiv" style="width: 120px;">
        <div onclick="f_noReadNote();return false;" title="我未读的笔记">我未读的笔记（<span style="color: red;"  id="myStatusSpan16"></span>）</div>
        <div onclick="f_getCommentList();return false;" title="评论我的笔记">评论我的笔记（<span style="color: red;"  id="myStatusSpan17"></span>） </div>
        <div onclick="f_getMyCommentList();return false;" title="我评论的笔记">我评论的笔记（<span style="color: red;"  id="myStatusSpan18"></span>）</div>
    </div>
    <div id="OtherUserDiv" style="width: 120px;">
    </div>

    <div id="statusDiv" style="width: 120px;">
        <div  onclick="f_getAllStatusArticle(0);">未处理（<span style="color: red;" id="myStatusSpan0"></span>）</div>
        <div  onclick="f_getAllStatusArticle(1);">已处理（<span style="color: red;" id="myStatusSpan1"></span>）</div>
        <div   onclick="f_getAllStatusArticle(2);">已完成（<span style="color: red;" id="myStatusSpan2"></span>）</div>
    </div>
    <div id="commentWindow" style="padding: 8px;"></div>
    <script type="text/javascript">
        //加载用户
        f_getUsers();
    </script>
    <div id="tb" style="padding: 5px;">
        <a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-reload'" onclick="f_refreshGrid();" >刷新</a>
        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok',plain:true" onclick="f_updateReadAllFlag();return false;" title="全部标识已读" style="display: none">标识已读</a>
        <span>
                       <input class="easyui-searchbox" data-options="prompt:'请输入关键字',menu:'#mm',
			searcher:function(value,name){if (name==1){f_getArticles({title:value});}else{f_getArticles({content:value});} }" style="width:180px"/>
                        <div id="mm" style="width:120px">
                            <div data-options="name:'1'">标题</div>
                            <div data-options="name:'2'">内容</div>
                        </div>
                       日期
                       <input id="creattime1" class="easyui-datebox" data-options="formatter:myformatter" >
                       -
                       <input id="creattime2" class="easyui-datebox" data-options="formatter:myformatter" >
            <a href="#"  class="easyui-menubutton" data-options="menu:'#statusDiv'" style="display: none">状态</a>
                        <a href="#"  class="easyui-menubutton" data-options="menu:'#OtherUserDiv'" style="display: none">人员</a>
                       <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" title="检索笔记" onclick="f_query();" >检索</a>


                   </span>

    </div>
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
</body>
</html>