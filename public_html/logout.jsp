<%--
  Created by IntelliJ IDEA.
  User: zxybazh
  Date: 6/21/15
  Time: 12:32 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>
</head>
<body>

<%
    Cookie c = new Cookie("username", "");
    c.setMaxAge(0);
    response.addCookie(c);

    c = new Cookie("token", "");
    c.setMaxAge(0);
    response.addCookie(c);

    c = new Cookie("cid", "");
    c.setMaxAge(0);
    response.addCookie(c);

    response.sendRedirect("index.jsp");
%>

</body>
</html>
