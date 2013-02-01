<%@ page import="com.ggs.comm.Config" %>
<%--
  Created by IntelliJ IDEA.
  User: ggs
  Date: 12-5-28
  Time: 下午4:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>${item.title} - <%=Config.SOFT_NAME%></title>
    <%@include file="inc.jsp"%>
    <link rel="stylesheet" href="js/ueditor/third-party/SyntaxHighlighter/shCoreDefault.css" type="text/css">
    <script type="text/javascript" src="js/ueditor/third-party/SyntaxHighlighter/shCore.js"></script>
     <script type="text/javascript">

         var ue;

         /**
          * 刷新父窗口
          * */
         function f_refresh(){
             f_alertInfo("操作成功",function(){
                 if(window.opener.f_refreshGrid)
                    window.opener.f_refreshGrid();
                 window.close();
             })
         }

         /**
          * 显示或者隐藏
          * */
         function f_display(){
             var o =document.all.detailBody;
             if(o.style.display=="none"){
                 o.style.display='';
             }else{
                 o.style.display="none";
             }
         }
         /**
          * 更新状态
          * */
         function f_updateStatus(){
             if(!ue.hasContents()){
                 f_alertError("备注内容不能为空!");
                 return false;
             }
             $.messager.confirm('提示', '是否确认完成?', function(r){
                 if (r){
                     $GGS.ajax("main/updateArticleStatus<%=Config.EXT%>",{id:${item.id},content:ue.getContent()});
                     f_refresh();

                 }
             });
         }

         /**
          * 获取用户
          * */

         function f_getUsers(){
             var sel =document.all.assignid;
             var users = $GGS.getJSON("main/getUsers<%=Config.EXT%>",{});
             for(var i=0;i<users.length;i++){
                 if(users[i].id=="${sessionScope.adminModel.userid}")continue;
                 sel.options[sel.length]=new Option(users[i].realname,users[i].id);
             }
         }

         /**
          * 转派人
          * */
        function f_updateAssign(){
             $.messager.confirm('提示', '是否确定要转派?', function(r){
                 if (r){
                     $GGS.ajax("main/updateAssign<%=Config.EXT%>",{articleid:${item.id},assignid:$("#assignid").val()})
                     f_refresh();
                 }
             });
         }

         /**
          * 退回处理
          * */
         function f_returnAssign(){
             $.messager.confirm('提示', '是否确定要退回处理?', function(r){
                 if (r){
                     $GGS.ajax("main/returnAssign<%=Config.EXT%>",{articleid:${item.id}})
                     f_refresh();
                 }
             });
         }

         /**
          * 我要点评
          * */
         function f_addComment(){
             $.messager.prompt('评论', '请输入您的点评内容：', function(r){
                 if (r){
                     $GGS.ajax("main/addComment<%=Config.EXT%>",{content:r,articleid:${item.id}});
                     //刷新评论数
                     f_getCommentCount();
                 }
             });
         }

         /**
          * 获取点评列表
          * */

        function f_getCommentList(){
             var json = $GGS.getJSON("main/getCommentList<%=Config.EXT%>",{articleid:${item.id}});
             $("#commentCountSpan").html(json.length);
             if(json.length==0){
                 f_alertInfo("暂时还没有评论!");
                 return false;
             }
             var div="";
             for(var i=0;i<json.length;i++){
                div+="<div style='padding: 5px;'><b>"+(i+1)+" 楼</b> <span style='color: #00008b;'>"+json[i].realname+" "+json[i].creattime+"</span></div>";
                 div+="<div style='padding: 5px;margin-left: 30px;'>"+json[i].content+"</div>";
             }
             $("#commentWindow").html(div);
             $("#commentWindow").window({
                 title:'评论列表',
                 width:500,
                 height:400,
                 modal:true,
                 minimizable:false,
                 maximizable:false,
                 collapsible:false
             });
         }
         /**
          * 初始化评论数
          * */
         function f_getCommentCount(){
             var json = $GGS.getJSON("main/getCommentList<%=Config.EXT%>",{articleid:${item.id}});
             $("#commentCountSpan").html(json.length);
         }

         /**
          * 初始化编辑器
          * */
         function f_initEditor(id){
             var editorOption;
             //已登陆
             editorOption = {
                 //这里可以选择自己需要的工具按钮名称
                 toolbars:[['Undo','Redo','Bold','Italic', 'Underline','FontFamily','FontSize','ForeColor']],
                 minFrameHeight:150,
                 //关闭字数统计
                 wordCount:false,
                 //关闭elementPath
                 elementPathEnabled:false
             };
             ue = new baidu.editor.ui.Editor(editorOption);
             ue.render(id);
             ue.setContent("");
         }


         /**
          * 添加至收藏夹
          * */
         function f_addFavorites(){
             $GGS.ajax("main/addFavorites<%=Config.EXT%>",{articleid:${item.id}});
             location.reload();
         }


         /**
          * 初始化
          * */
         $(function(){

             //代码高亮
             SyntaxHighlighter.highlight();
             //获取评论数
             f_getCommentCount();

         })
     </script>
</head>
<body>

    <table cellpadding="5" border="0" cellspacing="0" style="width:100%" align="center" class="normalFont">
        <tr>
            <td valign="top" width="48px">
                <a href="<%=Config.INDEX_PAGE%>"><img src="images/logo.jpg" border="0"/></a>
            </td>
            <td valign="middle" width="120px" >
                <span style="font-size: 18pt;font-weight: bold;"><%=Config.SOFT_NAME%></span>
            </td>
            <td>
                <div align="center" class="normalFont">
                    <span class="titleFont">${item.title}</span><br/>
                    ${item.realname}&nbsp;&nbsp;${item.creattime}<br/>
                    <c:if test="${sessionScope.adminModel!=null}">
                        <a href="#" class="easyui-linkbutton" data-options="plain:true"  onclick="f_addFavorites();return false;"><img src="images/favorites.jpg" border="0">${item.isFavorites==1?'取消收藏':'收藏'}</a>
                        &nbsp;&nbsp;阅读（<span style="color: red;">${item.views}</span>）
                        <a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="f_getCommentList();">评论（<span id="commentCountSpan" style="color: red;" ></span>） </a>
                        <a href="#"  class="easyui-linkbutton" data-options="plain:true" onclick="f_addComment();return false;">点评</a>
                    </c:if>
                </div>
            </td>
            <td width="168px">&nbsp;</td>
        </tr>
    </table>


    <div class="normalFont">
        <div id="contentDiv">${item.content}</div>
        <br/>
        <div style="color: #00008b;text-align: left;">
                <c:if test="${item.processtime!=null}">
                    <div>${item.assignname} ${item.processtime}  已处理</div>
                    <div style="padding:5px;border: solid;border-width: 1px;border:1px dashed #778899;width: 700px;${item.assigninfo==null || item.assigninfo==''?'display:none;':''}">${item.assigninfo}</div>
                </c:if>
                <c:if test="${item.finishtime!=null}">
                    <div>${item.realname} ${item.finishtime}  已完成</div>
                    <div style="padding:5px;border: solid;border-width: 1px;border:1px dashed #778899;width: 700px;${item.finishinfo==null || item.finishinfo==''?'display:none;':''}">${item.finishinfo}</div>
                </c:if>
        </div>
    </div>
    <c:if test="${sessionScope.adminModel!=null}">
        <c:if test="${sessionScope.adminModel.userid==item.assignid && item.status==0}">
            <div class="normalFont">
                <div>不做处理，直接转派给：<select id="assignid" style="height: 26px;width: 100px;"></select>
                    <a  class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="f_updateAssign();">Ok</a>
                  </div>
                <div>处理备注：</div>
                <div><script type="text/plain" id="assignEditor" style="width:700px;"></script></div>
                <script type="text/javascript">
                    f_initEditor("assignEditor");
                    //获取用户
                    f_getUsers();
                </script>
                <div><a  class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="f_updateStatus();">已处理</a></div>
            </div>
        </c:if>

     <c:if test="${sessionScope.adminModel.userid==item.userid && item.status==1}">
            <div class="normalFont">
                <div>
                    <a title="由于指派人未处理完成，或者处理不当，退回重新处理" class="easyui-linkbutton" data-options="iconCls:'icon-back'" onclick="f_returnAssign();">退回处理</a>
                    </div>
                    <div>备注信息：</div>
                <div><script type="text/plain" id="finishEditor" style="width:700px;"></script></div>
                <script type="text/javascript">
                            f_initEditor("finishEditor");
                </script>
                <div>
                    <a  class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="f_updateStatus();">已完成</a>
                </div>
            </div>
     </c:if>
    </c:if>
<div id="commentWindow" style="padding: 8px;"></div>
    <jsp:include page="/foot.jsp" flush="true"></jsp:include>
</body>
</html>
