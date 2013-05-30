<%@page language="java" pageEncoding="UTF-8" %>
<%@ page import="com.ggs.comm.Config" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.ggs.util.DateUtil" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="isCheckLogin" value="1"></c:set>
<c:set var="topSelected" value="2"></c:set>
<html>
<head>
    <title><%=Config.SOFT_NAME%> - 撰写笔记</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <%@include file="inc.jsp"%>
    <script type="text/javascript">

        //ue编辑器
        var ue;

        /**
         * 获取文件夹
         * */
        function f_getFolders(){
            //初始化按钮状态
            f_initBtnStatus();
            var seluserid =document.all.useridSel.value;
            var folderNodes = $GGS.getJSON("main/getFolders<%=Config.EXT%>",{userid:seluserid});
            var isSelf=true;
            if("${sessionScope.adminModel.userid}"!=$("#useridSel").val()){
                isSelf=false;
            }
            $.fn.zTree.init($("#folderTree"),
                    {
                        edit: {
                            enable: isSelf,
                            removeTitle: "删除文件夹",
                            renameTitle: "重命名文件夹",
                            drag: {
                                prev: true,
                                next: false,
                                inner: true
                            }
                        },
                        data: {
                            simpleData: {
                                enable: true
                            }
                        },
                        view: {
                            selectedMulti: false,
                            showIcon:true,
                            showTitle: false,
                            addDiyDom:function(treeId, treeNode){
                                if("${sessionScope.adminModel.userid}"!=$("#useridSel").val()){
                                    return;
                                }
                                //if(treeNode.isParent)return;
                                var aObj = $("#" + treeNode.tId + "_a");
                                var icon="";
                                var title="";
                                if(treeNode.isvisable=="1"){
                                    icon="shipping.png";
                                    title="共享显示，点击切换到仅自己可见";
                                }else{
                                    icon="user.png";
                                    title="仅自己可见，点击切换共享显示";
                                }

                                var editStr = "<img width='16' height='16' style='cursor:hand' title='"+title+"' src='images/"+icon+"' onclick='f_changeFolderVisable("+treeNode.id+");'/>";
                                aObj.after(editStr);

                            }
                        },
                        callback: {
                            onClick: function(event, treeId, treeNode, clickFlag){
                                //获取文章
                                f_getArticles();
                            },
                            beforeRename: function(treeId, treeNode, newName){
                                //重命名
                                f_updateFolder(treeNode.id,newName);
                            },
                            beforeRemove:function(treeId, treeNode){
                                //删除文件夹

                                if(!confirm("删除该文件夹同时会删除子文件夹及下面所有笔记，是否确认？")){
                                    return false;
                                }
                                f_delFolder(treeNode.id);
                                f_clearFolderSelect();
                                f_getArticles();
                            },
                            beforeDrop: function (treeId, treeNodes, targetNode, moveType) {
                                //拖拽文件夹
                                var msg="是否确定把【"+treeNodes[0].name+"】放在【"+targetNode.name+"】下级节点？";
                                var id=treeNodes[0].id;
                                var upid = targetNode.id;
                                if(moveType=='prev'){
                                    upid=targetNode.upid;
                                    msg="是否让【"+treeNodes[0].name+"】与【"+targetNode.name+"】成为同级节点？";
                                }
                                if(confirm(msg)){
                                    $GGS.ajax("main/changeFolderParent<%=Config.EXT%>",{id:id,upid:upid});
                                }
                                return targetNode ? targetNode.drop !== false : true;
                            }
                        }
                    }
                    , folderNodes);

            <c:if test="${param.folderid!=null}">
                 var folderTree = $.fn.zTree.getZTreeObj("folderTree");
                var node = folderTree.getNodeByParam("id", ${param.folderid}, null);
                //选中节点
                 folderTree.selectNode(node);

            </c:if>

        }

        /**
         * 获取文章
         * */
        function f_getArticles(){
            //初始化按钮状态
            f_initBtnStatus();
            f_clearData();
            var folderid = f_getCurrentFolderid();
            var data="title="+$("#searchKey").val();
            data+="&userid="+document.all.useridSel.value;
            if(folderid){
                data+="&folderid="+folderid;
            }
            var articleNodes =$GGS.getJSON("main/getArticles<%=Config.EXT%>",data);
            $("#articleSpan").html("共有 <font color='red'>"+articleNodes.length+"</font> 个笔记");
            var isSelf=true;
            if("${sessionScope.adminModel.userid}"!=$("#useridSel").val()){
                isSelf=false;
            }
            $.fn.zTree.init($("#articleTree"),
                    {
                        edit: {
                            enable: isSelf,
                            showRenameBtn: false ,
                            removeTitle: "删除笔记"
                        },
                        data: {
                            simpleData: {
                                enable: true
                            }
                        } ,
                        view: {
                            selectedMulti: false,
                            showIcon:true,
                            showTitle: false,
                            addDiyDom:function(treeId, treeNode){
                                if("${sessionScope.adminModel.userid}"!=$("#useridSel").val()){
                                    return;
                                }
                                var aObj = $("#" + treeNode.tId + "_a");
                                var icon="";
                                var title="";
                                if(treeNode.isvisable=="1"){
                                    icon="shipping.png";
                                    title="共享显示，点击切换到仅自己可见";
                                }else{
                                    icon="user.png";
                                    title="仅自己可见，点击切换到共享显示";
                                }

                                 var editStr = "<img width='16' height='16' style='cursor:hand' title='"+title+"' src='images/"+icon+"' onclick='f_changeArticleVisable("+treeNode.id+");'/>";
                                 aObj.after(editStr);

                            }
                        },
                        callback: {
                            onClick: function(event, treeId, treeNode, clickFlag){
                                //单击事件：获取内容
                                f_getArticleContent(treeNode.id);
                            },
                            beforeRemove:function(treeId, treeNode){
                                //点击删除按钮
                                if(!confirm("是否确认删除该笔记？")){
                                    return false;
                                }
                                //删除笔记
                                f_delArticle(treeNode.id);
                            } ,
                            beforeDrop: function (treeId, treeNodes, targetNode, moveType) {
                                var id =treeNodes[0].id;
                                var folderid =targetNode.id;
                                $GGS.ajax("main/changeArticleParent<%=Config.EXT%>",{id:id,folderid:folderid}) ;
                                //获取文章
                                f_getArticles();
                                return false;
                            },
                            onDblClick:function (event, treeId, treeNode) {
                               window.open("show<%=Config.EXT%>?id="+treeNode.id,treeNode.id);
                            }
                        }
                    }
                    , articleNodes);
            //默认选中第一篇笔记
            f_defaultSelectArticle();
        }
        /**
         * 获取内容
         * */
        function f_getArticleContent(articleid){
            var json =$GGS.getJSON("main/getContent<%=Config.EXT%>",{id:articleid});

            ue.setContent(json.content);
            $("#articleTitle").val(json.title);
            $("#articleTag").val(json.tag);
            $("#articleid").val(json.id);
            $("#priority").val(json.priority);
            $("#assignid").val(json.assignid);
            $("#buglevel").val(json.buglevel);
            if(json.csort==2){
                $("#bugTr").css("display","");
            }else{
                $("#bugTr").css("display","none");
            }

        }

        /**
         * 新建笔记
         * */

        function f_createArticle(){
            var folderTree = $.fn.zTree.getZTreeObj("folderTree");
            var nodes = folderTree.getSelectedNodes();
            if(nodes.length==0){
                f_alertError("您还未选择文件夹");
                return false;
            }
            //清空数据
            f_clearData();
            var treeNode = nodes[0];
            var articleTree = $.fn.zTree.getZTreeObj("articleTree");
            var folderid=treeNode.id;
            var json=$GGS.getJSON("main/getMaxId<%=Config.EXT%>",{tbName:'t_article'});

            var id=json.maxid+1;
            var title="未命名";
            var newNode = {id:id, pId:folderid, name:title};
            articleTree.addNodes(null, newNode);
            var node = articleTree.getNodeByParam("id",id, null);
            //选中节点
            articleTree.selectNode(node);
            //为内容赋值
            $("#articleTitle").val(title);
            return true;
        }

        /**
         * 保存笔记
         * */
        function f_saveArticle() {

            var folderid = f_getCurrentFolderid();

            if(!folderid && $("#articleid").val()==""){
                f_alertError("您还未选择文件夹");

                return false;
            }

            if($("#articleTitle").val()==""){
                f_alertError("标题不能为空！");

                return false;
            }

            if(!ue.hasContents()){
                f_alertError("笔记内容不能为空！");
                return false;
            }

            $GGS.ajax("main/saveArticle<%=Config.EXT%>",
                    {   title:$("#articleTitle").val(),
                        content:ue.getContent(),
                        tag:$("#articleTag").val() ,
                        folderid:folderid,
                        id:$("#articleid").val(),
                        assignid:$("#assignid").val(),
                        priority:$("#priority").val(),
                        csort:$("#csort").val(),
                        buglevel:$("#buglevel").val()
            });

            //保存成功
            f_showTips("恭喜你，保存成功！");


            //当前id
            var curid = $("#articleid").val();

            f_getArticles();
            //选中刚才保存id
            var articleTree = $.fn.zTree.getZTreeObj("articleTree");

            var id=0;
            if(curid==""){
                //新增操作
                var json =$GGS.getJSON("main/getMaxId<%=Config.EXT%>",{tbName:'t_article'});
                id =json.maxid;
            }else{
                //修改操作
                id=curid;
            }
            if(id!=0){
                var node = articleTree.getNodeByParam("id", id, null);
                //选中节点
                articleTree.selectNode(node);
                f_getArticleContent(id);
            }

        }

        /**
         * 删除笔记
         * */
        function f_delArticle(id){
            $GGS.ajax("main/delArticle<%=Config.EXT%>",{id:id});
            f_getArticles();
        }


        /**
         * 获取当前文件夹id
         * */
        function f_getCurrentFolderid(){
            var tree = $.fn.zTree.getZTreeObj("folderTree");
            var nodes = tree.getSelectedNodes();
            if(nodes.length==0){
                return;
            }
            var node = nodes[0];
            return node.id;
        }

        /**
         * 获取当前文章id
         * */
        function f_getCurrentArticleid(){
            var tree = $.fn.zTree.getZTreeObj("articleTree");
            var nodes = tree.getSelectedNodes();
            if(nodes.length==0){
                return;
            }
            var node = nodes[0];
            return node.id;
        }

        /**
         * 清空文件夹选择
         * */
        function f_clearFolderSelect(){
            var folderTree = $.fn.zTree.getZTreeObj("folderTree");
            var nodes = folderTree.getSelectedNodes();
            if(nodes.length==0){
                return;
            }
            var node = nodes[0];
            folderTree.cancelSelectedNode(node);
        }

        /**
         *清空数据
         * */
        function f_clearData(){

            ue.setContent("");
            $("#articleTitle").val("");
            $("#articleTag").val("");
            $("#articleid").val("");
            $("#priority").val("1");
            $("#assignid").val("");
            $("#csort").val("0");
            $("#buglevel").val("0");
            $("#bugTr").css("display","none");
        }

        /**
         * 去空格
         * */
        function f_trim(o){
            o.value= $.trim(o.value);
        }

        /**
         * 回车事件
         * */

        function f_enter_search(){
            if(event.keyCode==13){
                //加载文章
                f_getArticles();
            }
        }

        /**
         * 重命名文件夹
         * */
        function f_updateFolder(id,cname){
            $GGS.ajax("main/updateFolder<%=Config.EXT%>",{folderid:id,foldername:cname});
        }

        /**
         * 删除文件夹
         * */
        function f_delFolder(id){
            $GGS.ajax("main/delFolder<%=Config.EXT%>",{folderid:id});
        }

        /**
         * 保存文件夹
         * */
        function f_saveFolder(cname,upid){
            $GGS.ajax("main/saveFolder<%=Config.EXT%>",{foldername:cname,upid:upid});
        }


        /**
         * 新建文件夹
         * */
        function f_createFolder(){
            var isCreaSubFolder=false;
            var folderTree = $.fn.zTree.getZTreeObj("folderTree");
            var nodes = folderTree.getSelectedNodes();
            var node;
            if(nodes.length>0){
                isCreaSubFolder=true;
                node = nodes[0];
            }
            var id=folderTree.getNodes().length+1;
            var cname="未命名";
            var upid=isCreaSubFolder?node.id:0;
            var newNode = {id:id, pId:upid, name:cname};
            folderTree.addNodes(node?node:null, newNode);
            var node = folderTree.getNodeByParam("id", id, null);
            //选中节点
            folderTree.selectNode(node);
            f_saveFolder(cname,upid);
            //刷新文件夹
            f_getFolders();
            var json =    $GGS.getJSON("main/getMaxId<%=Config.EXT%>",{tbName:'t_folder'});
            var maxid = json.maxid;
            f_selectFolder(maxid);
        }

        /**
         * 默认选中第一篇文章
         * */
        function f_defaultSelectArticle(){
            var treeObj = $.fn.zTree.getZTreeObj("articleTree");
            var nodes = treeObj.getNodes();
            if (nodes.length>0) {
                treeObj.selectNode(nodes[0]);
                f_getArticleContent(nodes[0].id);
            }

        }



        /**
         * 获取用户
         * */

        function f_getUsers(){
            var sel =document.all.useridSel;
            var users = $GGS.getJSON("main/getUsers<%=Config.EXT%>",{});
            for(var i=0;i<users.length;i++){
                sel.options[sel.length]=new Option(users[i].realname,users[i].id);
                document.all.assignid.options[document.all.assignid.length]=new Option(users[i].realname,users[i].id);
            }
        }
        //更改文件夹是否显示
        function f_changeFolderVisable(id){
            $GGS.ajax("main/changeFolderVisable<%=Config.EXT%>",{folderid:id});
            //加载文件夹
            f_getFolders();
            f_selectFolder(id);
        }
        //更改文章是否显示
        function f_changeArticleVisable(id){
            $GGS.ajax("main/changeArticleVisable<%=Config.EXT%>",{articleid:id});
            //加载文章
            f_getArticles();
            f_selectArticle(id);
        }

        //选中文件夹
        function f_selectFolder(id){
            var tree = $.fn.zTree.getZTreeObj("folderTree");
            var node = tree.getNodeByParam("id", id, null);
            //选中节点
            tree.selectNode(node);
        }

        //选中文件夹
        function f_selectArticle(id){
            var tree = $.fn.zTree.getZTreeObj("articleTree");
            var node = tree.getNodeByParam("id", id, null);
            //选中节点
            tree.selectNode(node);
        }

        //初始化按钮状态
        function f_initBtnStatus(){
            if("${sessionScope.adminModel.userid}"!=$("#useridSel").val()){
                $("#createFolderBtn").css("display","none");
                $("#createNoteBtn").css("display","none");
                $("#saveNoteBtn").css("display","none");
                return false;
            }
            $("#createFolderBtn").css("display","");
            $("#createNoteBtn").css("display","");
            $("#saveNoteBtn").css("display","");
            return true;
        }

        /**
         * 获取模板内容
         * */
        function f_getArticleTemplate(articleid,title){
            var json =$GGS.getJSON("main/getContent<%=Config.EXT%>",{id:articleid});
            ue.setContent(json.content);
            $("#articleTitle").val(title);
        }



        //初始化
        $(function(){
            //ue编辑器
            var editorOption;
            //已登陆
            editorOption = {
                //这里可以选择自己需要的工具按钮名称
                toolbars:[['FullScreen', 'Source','Undo','Redo','Bold','Italic', 'Underline','FontFamily','FontSize','ForeColor', 'BackColor', '|',
                    'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyJustify','|',
                    'Link','InsertTable','InsertImage','Emotion','attachment','Attachment','HighlightCode','|']],
                minFrameHeight:screen.availHeight-330,
                //关闭字数统计
                wordCount:false,
                //关闭elementPath
                elementPathEnabled:false
            };
            ue = new baidu.editor.ui.Editor(editorOption);
            ue.render('editor');
            //加载用户列表
            f_getUsers();
            //选择当前登陆用户
            $("#useridSel").val("${sessionScope.adminModel.userid}");
            //加载文件夹
            f_getFolders();
            //加载文章
            f_getArticles();

        });
    </script>
</head>
<body>
    <%@include file="top.jsp"%>
    <input type="hidden" name="articleid" id="articleid"/>
    <table border="0" cellpadding="0" cellspacing="0" width="100%" class="borderTable normalFont">
        <tr style="display: none">
            <td colspan="3">
                <div class="normalFont" >
           <span >
                <span>
                    用户：
                    <select style="width:100px;" id="useridSel" name="useridSel" onchange="f_getFolders();f_getArticles();" >
                    </select>
                    </span>
                关键字：<input type="text" name="searchKey" id="searchKey" style="width: 200px;"  onblur="f_trim(this);" onkeydown="f_enter_search();">
               <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" title="检索笔记" onclick="f_getArticles();" >检索</a>
               </span>
                </div>
            </td>
        </tr>
        <tr>
            <td style="width:200px;" valign="top">
                <!--文件夹-->
                <div>
                    <span style="background-image: url('images/folder.png');background-repeat: no-repeat;">
                        <span  onclick="f_clearFolderSelect();f_getArticles();" style="cursor: hand;margin-left: 20px;">所有文件夹</span>
                    </span>
                    <a id="createFolderBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="f_createFolder();" title="新建文件夹">新建文件夹</a>
                </div>
                <div id="folderTreeDiv" style="width: 200px;height:450px ;overflow: auto;">
                    <div class="zTreeDemoBackground left">
                        <ul id="folderTree" class="ztree"></ul>
                    </div>
                </div>
            </td>
            <td style="width: 250px;" valign="top">
                <!--笔记列表-->
                <div>
                    <c:if test="${sessionScope.admin!=null}">
                        <a href="javascript:void(0)" id="createNoteBtn" class="easyui-menubutton" data-options="menu:'#createArticleMenuDiv',iconCls:'icon-add',plain:true" title="请选择您要新建的笔记模板">新建笔记</a>
                    </c:if>
                    <span id="articleSpan"></span>
                </div>
                <div id="articleTreeDiv" style="width: 250px;height: 450px;overflow: auto;">
                    <div class="zTreeDemoBackground left">
                        <ul id="articleTree" class="ztree"></ul>
                    </div>
                </div>
                </div>
            </td>
            <td valign="top">
                <!--笔记内容-->
                <input type="hidden" id="csort"/>
                <table cellpadding="0" cellspacing="0" border="0" width="100%" class="normalFont">
                    <tr>
                        <td width="350px">
                            <input type="text" title="标题" name="articleTitle" id="articleTitle" style="width: 400px;color: #1e90ff;font-size: 12pt;font-weight: bold;" onblur="f_trim(this);"/>
                        </td>
                        <td align="right">
                            <c:if test="${sessionScope.admin!=null}">
                                <a id="saveNoteBtn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:false" title="保存笔记" onclick="f_saveArticle();">保存</a>
                            </c:if>
                            <a href="#"  class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:false" title="查看笔记" onclick="window.open('show<%=Config.EXT%>?id='+$('#articleid').val(),'article'+$('#articleid').val());" >查看</a>
                        </td>
                    </tr>
                    <tr id="bugTr" style="display: none">
                        <td>
                            <span style="display: none;">TAG：<input type="text" name="articleTag" id="articleTag" style="width: 100px;" onblur="f_trim(this);" title="标签，多个标签用逗号分隔（可选）"/></span>
                            优先级：
                            <select name="priority" id="priority" style="height: 26px;">
                                <option value="1">低</option>
                                <option value="2">中</option>
                                <option value="3">高</option>
                            </select>
                            指派：
                            <select name="assignid" id="assignid" style="height: 26px;" title="该任务可以指派人处理，默认不需要处理">
                                <option value="">无</option>
                            </select>
                            BUG类型：
                            <select name="buglevel" id="buglevel" style="height: 26px;" title="填写BUG时指定BUG类型">
                                <option value="0">无</option>
                                <option value="1">建议与新增</option>
                                <option value="2">设计改进</option>
                                <option value="3">一般错误</option>
                                <option value="4">严重错误</option>
                                <option value="5">致命错误</option>
                            </select>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                </table>
                <div id="editorDiv">
                    <script type="text/plain" id="editor"></script>
                </div>
            </td>
        </tr>
    </table>
    <div id="createArticleMenuDiv" style="width: 150px;display: none;">
        <div onclick="f_createArticle();">空白</div>
        <div class="menu-sep"></div>
        <div>
            <span>日常工作</span>
            <div style="width: 150px;">
                <div onclick="if(f_createArticle()){$('#articleTitle').val('未命名规章制度');$('#csort').val(8);}">规章制度</div>
                <div onclick="if(f_createArticle()){$('#articleTitle').val('<%=new SimpleDateFormat("yyyy.MM").format(new Date())%>月考勤记录');$('#csort').val(7);}">考勤记录</div>
                <div class="menu-sep"></div>
                <div onclick="if(f_createArticle()){f_getArticleTemplate(87,'<%=new SimpleDateFormat("yyyy.MM").format(new Date())%>月工作计划');$('#csort').val(6);}">工作计划</div>
                <div onclick="if(f_createArticle()){f_getArticleTemplate(86,'<%=new SimpleDateFormat("MM.dd").format(new Date())%>工作日志');$('#csort').val(10);}">工作日志</div>
                <div onclick="if(f_createArticle()){f_getArticleTemplate(89,'<%=DateUtil.getCurrWeekDays()%>周工作总结');$('#csort').val(1);}">工作总结</div>
                <div class="menu-sep"></div>
                <div onclick="if(f_createArticle()){f_getArticleTemplate(261,'<%=new SimpleDateFormat("MM.dd").format(new Date())%>周例会');$('#csort').val(4);}">部门会议</div>
                <div onclick="if(f_createArticle()){f_getArticleTemplate(270,'<%=new SimpleDateFormat("MM.dd").format(new Date())%>学习会《主题》');$('#csort').val(5);}">学习会</div>
            </div>
        </div>

        <div class="menu-sep"></div>
        <div>
            <span>软件开发</span>
            <div style="width: 150px;">
                <div onclick="if(f_createArticle()){f_getArticleTemplate(103,'未命名需求');$('#csort').val(9);}">软件需求</div>
                <div onclick="if(f_createArticle()){f_getArticleTemplate(104,'未命名BUG');$('#csort').val(2);}$('#bugTr').css('display','');">软件BUG</div>
            </div>
        </div>

        <div class="menu-sep"></div>
        <div>
            <span>市场销售</span>
            <div style="width: 150px;">
                <div onclick="if(f_createArticle()){f_getArticleTemplate(456,'<%=new SimpleDateFormat("MM.dd").format(new Date())%>客户拜访报告');$('#csort').val(3);}">客户拜访报告</div>
            </div>
        </div>
        <div class="menu-sep"></div>
        <div>
            <span>模板</span>
            <div style="width: 150px;">
                <div onclick="if(f_createArticle()){$('#articleTitle').val('未命名模板');$('#csort').val(99);}">撰写模板</div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        var myheight=290;
        $("#articleTreeDiv").css("height",screen.availHeight-myheight);
        $("#folderTreeDiv").css("height",screen.availHeight-myheight);
    </script>
    <jsp:include page="/foot.jsp" flush="true"></jsp:include>


</body>

</html>
