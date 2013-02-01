<%@ page import="com.ggs.comm.Config" %>
<%--
  Created by IntelliJ IDEA.
  User: ggs
  Date: 12-5-26
  Time: 下午4:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="inc.jsp"%>
<%
    session.invalidate();
%>
<script type="text/javascript">
    $.cookie("userpwd", null);
    location='login.jsp?r=1';
</script>