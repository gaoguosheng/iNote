<%@ page import="com.ggs.comm.Config" %>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 12-8-16
  Time: 下午2:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page pageEncoding="UTF-8"  language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="isCheckLogin" value="1"></c:set>
<c:set var="topSelected" value="5"></c:set>
<html>
<head>
    <title><%=Config.SOFT_NAME%>  - 通讯录</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <%@include file="inc.jsp"%>
    <script type="text/javascript">
        /**
         * 获取类别列表
         * */
        function f_getAddrClass(){
            var addrNodes = $GGS.getJSON("addr/getClassList<%=Config.EXT%>",{});
            $.fn.zTree.init($("#addrTree"),
                    {
                        data: {
                            simpleData: {
                                enable: true
                            }
                        },
                        view: {
                            selectedMulti: false
                        },
                        callback: {
                            onClick: function(event, treeId, treeNode, clickFlag){
                                f_getArticles({addrclassid:treeNode.id});
                            }
                        }
                    }
                    , addrNodes);
        }

        /**
         * 获取文章
         * */
        function f_getArticles(data){
            var myUrl="addr/getAddrList<%=Config.EXT%>?q=1";
            if(data.addrclassid !=undefined){
                myUrl+="&addrclassid="+data.addrclassid;
            }
            if(data.name !=undefined){
                myUrl+="&name="+data.name;
            }
            if(data.mobile !=undefined){
                myUrl+="&mobile="+data.mobile;
            }
            if(data.userid !=undefined){
                myUrl+="&userid="+data.userid;
            }
            if(data.flag !=undefined){
                myUrl+="&flag="+data.flag;
            }
            if(data.fspell !=undefined){
                myUrl+="&fspell="+data.fspell;
            }
            if(data.memo !=undefined){
                myUrl+="&memo="+data.memo;
            }
            if(data.qq !=undefined){
                myUrl+="&qq="+data.qq;
            }
            if(data.email !=undefined){
                myUrl+="&email="+data.email;
            }
            myUrl=encodeURI(myUrl);
            $('#gridTable').datagrid({
                //title:"通讯录",
                url:myUrl,
                pageSize:20,
                frozenColumns:[[

                ]],
                columns:[[
                    {field:'upfspell',title:'首字母',width:50,align:'center',sortable:true},
                    {field:'name',title:'名称',width:100},
                    {field:'addrclassname',title:'类别',width:80,sortable:true},
                    /*{field:'fspell',title:'首拼',width:80,sortable:true},*/
                    {field:'sex',title:'性别',width:40,align:'center',
                        formatter: function(value,row,index){
                            var img="<img src='images/stateie.gif' title='男'>";
                            if(row.sex=="女"){
                                img="<img src='images/stateie3.gif' title='女'>";
                            }
                            return img;
                        }
                    },
                    {field:'mobile',title:'电话',width:150},
                    {field:'isvisable',title:'共享状态',width:60,align:'center',sortable:true,
                        formatter: function(value,row,index){
                            var str="<img src='images/shipping.png' width='16' height='16' title='共享显示'>";
                            if(row.isvisable==0){
                                str="<img src='images/user.png'  width='16' height='16' title='仅自己可见'>";
                            }
                            return str;
                        }
                    },
                    {field:'email',title:'邮箱',width:150},
                    {field:'qq',title:'QQ',width:120},
                    {field:'memo',title:'备注',width:200},
                    {field:'realname',title:'创建人',width:80 }
                ]],
                toolbar:'#tb',
                striped: true,
                singleSelect:true,
                onClickRow:function(rowIndex, rowData){
                    f_modifyAddr(rowData.id);
                }
            });
        }

        /**
         * 弹出通讯录对话框
         * */
        function f_showAddrDialog(data){

            $("#addrEditDiv").css("display","");
            $("#btnsTr").css("display","");
            //设置分类id
            $("#addrclassid").val(f_getCurrClass());
            $("#addrid").val("");
            $("#name").val("");
            $("#mobile").val("");
            $("#email").val("");
            $("#qq").val("");
            $("#memo").val("");
            $("#delBtn").css("display","none");
            $("#restBtn").css("display","none");
            if(data.id!=undefined){
                $("#addrid").val(data.id);
            }

            if($("#addrid").val()!=""){
                //修改界面初始化
                var json = $GGS.getJSON("addr/getAddr<%=Config.EXT%>",{id:$("#addrid").val()});
                //设置按钮
                if("${sessionScope.adminModel.userid}"==json.userid){
                    $("#btnsTr").css("display","");
                    if(json.flag==1){
                        $("#delBtn").css("display","none");
                        $("#restBtn").css("display","");
                    }else if(json.flag==0){
                        $("#delBtn").css("display","");
                        $("#restBtn").css("display","none");
                    }
                }else{
                    $("#btnsTr").css("display","none");
                }


                $("#name").val(json.name);
                $("#sex").val(json.sex);
                $("#mobile").val(json.mobile);
                $("#email").val(json.email);
                $("#qq").val(json.qq);
                $("#memo").val(json.memo);
                $("#isvisable").val(json.isvisable);
            }
            $("#addrEditDiv").window(
                    {
                        title:'联系人',
                        width:650,
                        height:500,
                        modal:true,
                        minimizable:false,
                        maximizable:false,
                        collapsible:false
                    }
            );

        }

        /**
         * 添加通讯录
         * */
        function f_addAddr(){
            if(f_getCurrClass()==-1){
                f_alertError("请您选择左边的一个类别！");
                return false;
            }
            f_showAddrDialog({});
        }

        /**
         * 修改通讯录
         * */
        function f_modifyAddr(id){
            f_showAddrDialog({id:id});
        }

        /**
         * 关闭录入对话框
         * */
        function f_closeAddrDialog(){
            $("#addrEditDiv").window("close");
        }

        /**
         * 获取当前分类id
         * */
        function f_getCurrClass(){
            var addrTree = $.fn.zTree.getZTreeObj("addrTree");
            var nodes = addrTree.getSelectedNodes();
            if(nodes.length>0){
                return nodes[0].id;
            }else{
                return -1;
            }
        }

        /**
         * 清空树节点选择
         * */
        function f_clearClassSelect(){
            var tree = $.fn.zTree.getZTreeObj("addrTree");
            var nodes = tree.getSelectedNodes();
            if(nodes.length==0){
                return;
            }
            var node = nodes[0];
            tree.cancelSelectedNode(node);
        }

        /**
         * 刷新表格
         * */
        function f_refreshGrid(){
            $('#gridTable').datagrid('reload');
        }






        /**
         * 删除
         * */
        function f_delAddr(id){
            $.messager.confirm('提示', '是否确认删除到回收站?', function(r){
                if (r){
                    $GGS.ajax("addr/delAddr<%=Config.EXT%>",{id:id});
                    f_refreshGrid();
                    f_closeAddrDialog();
                }
            });

        }

        /***
         * 还原
         * */
        function f_restoreAddr(id){
            $GGS.ajax("addr/restoreAddr<%=Config.EXT%>",{id:id});
            f_refreshGrid();
            f_closeAddrDialog();
        }

        /**
         * 获取通讯录存在的字母列表
         * */
        function f_getLetters(){
            var json  =   $GGS.getJSON("addr/getLetters<%=Config.EXT%>",{});
            var str="";
            if(json!=null && json.length>0){
                for(var i=0;i<json.length;i++){
                    var letter=json[i].letter;
                    str+="<a href='#' class='easyui-linkbutton' data-options='plain:true' onclick='f_getArticles({fspell:\""+letter+"\"});'>&nbsp;"+letter.toUpperCase()+"&nbsp;</span></a>";
                }

            }
            $("#lettersDiv").html(str);
        }


        $(function(){


            //获取类别列表
            f_getAddrClass();
            window.setTimeout(function(){
                f_getArticles({});
            },500);

            $('#ff').form({
                url:'addr/saveAddr<%=Config.EXT%>',
                onSubmit:function(){
                    return $(this).form('validate');
                },
                success:function(data){
                    f_closeAddrDialog();
                    f_refreshGrid();
                    f_showTips("保存成功！");
                }
            });
        });
    </script>
</head>
<body>
<%@include file="top.jsp"%>

<table border="0" cellpadding="0" cellspacing="0" width="100%" class="borderTable normalFont">
    <tr>
        <td valign="top" style="width: 220px;padding: 8px;">
            <div><a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_getArticles({userid:${sessionScope.adminModel.userid}});f_clearClassSelect();return false;">我的联系人</a></div>
            <hr width="98%" align="center"/>
            <div>
                <a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_getArticles({});f_clearClassSelect();return false;">全部类别</a>
            </div>

            <div id="addrTreeDiv" style="width: 200px;height:300px ;overflow: auto;">
                <div class="zTreeDemoBackground left">
                    <ul id="addrTree" class="ztree"></ul>
                </div>
            </div>
            <hr width="98%" align="center"/>
            <div><a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_getArticles({flag:1});f_clearClassSelect();return false;">回收站</a></div>
        </td>
        <td valign="top">

            <!-- 列表-->
            <table id="gridTable" class="easyui-datagrid"   iconCls="icon-search"
                   rownumbers="true" pagination="true">
            </table>
            <script type="text/javascript">

                $("#gridTable").css("height",screen.availHeight-260);
            </script>
            </div>
        </td>
    </tr>
</table>

<div id="tb" style="height: 60px;">
    <!--字母首拼查询-->
    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="f_addAddr();">添加联系人</a>
    <input class="easyui-searchbox" data-options="prompt:'请输入关键字',menu:'#mm',
			searcher:function(value,name){
			if(name==0){f_getArticles({fspell:value});
			} else if (name==1){f_getArticles({name:value});}
			else if(name==2){f_getArticles({mobile:value});}
			 else if(name==3){f_getArticles({email:value});}
			 else if(name==4){f_getArticles({qq:value});}
			 else if(name==5){f_getArticles({memo:value});}}" style="width:200px"/>
    <div id="mm" style="width:120px">
        <div data-options="name:'0'">首拼</div>
        <div data-options="name:'1'">名称</div>
        <div data-options="name:'2'">电话</div>
        <div data-options="name:'3'">邮箱</div>
        <div data-options="name:'4'">QQ</div>
        <div data-options="name:'5'">备注</div>
    </div>
    <div id="lettersDiv" style="padding: 5px;"></div>
</div>


<script type="text/javascript">
    var myheight=400;
    $("#addrTreeDiv").css("height",screen.availHeight-myheight);
    //加载字母列表
    f_getLetters();
</script>

<%@include file="foot.jsp"%>
<div id="addrEditDiv" style="display: none;">
    <form id="ff" method="post" novalidate>
        <input type="hidden" name="id" id="addrid">
        <input type="hidden" name="addrclassid" id="addrclassid">
        <table cellpadding="5" cellspacing="0" border="0" class="normalFont" width="98%" align="center" >
            <tr>
                <td colspan="2">
                    <a id="delBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-no'" onclick="f_delAddr($('#addrid').val());">删除</a>
                    <a id="restBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-back'" onclick="f_restoreAddr($('#addrid').val());">还原</a>
                </td>
            </tr>
            <tr>
                <td width="100" valign="top" style="text-align: right">个人/企业名称：</td>
                <td><input class="easyui-validatebox" type="text" id="name" name="name" required="true" style="width: 250px;"></td>
            </tr>
            <tr>
                <td valign="top" style="text-align: right">性别：</td>
                <td>
                    <select name="sex" id="sex" style="width: 60px;">
                        <option value="男">男</option>
                        <option value="女">女</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td valign="top" style="text-align: right">电话：</td>
                <td><input class="easyui-validatebox" type="text" id="mobile" name="mobile" required="true" style="width: 250px;">(多个用逗号隔开)</td>
            </tr>
            <tr>
                <td valign="top" style="text-align: right">邮箱：</td>
                <td><input class="easyui-validatebox" type="text" id="email" name="email" validType="email"></td>
            </tr>
            <tr>
                <td valign="top" style="text-align: right">QQ：</td>
                <td><input class="easyui-validatebox" type="text" id="qq" name="qq"></td>
            </tr>
            <tr>
                <td valign="top" style="text-align: right">备注：</td>
                <td><textarea class="easyui-validatebox" rows="8" cols="35" id="memo" name="memo" style="width:400px;"></textarea></td>
            </tr>
            <tr>
                <td valign="top" style="text-align: right">共享状态：</td>
                <td>
                    <select name="isvisable" id="isvisable" style="width: 100px;">
                        <option value="1">共享显示</option>
                        <option value="0">仅自己可见</option>
                    </select>
                </td>
            </tr>
            <tr id="btnsTr">
                <td colspan="2" align="center">
                    <input id="subBtn" type="submit" value="保存" style="display: none">&nbsp;&nbsp;&nbsp;&nbsp;
                    <a id="okBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="subBtn.click();">保存</a>
                    <a id="closeBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="f_closeAddrDialog();">关闭</a>
                </td>
            </tr>
        </table>
    </form>
</div>
</body>
</html>