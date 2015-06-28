<%--
  Created by IntelliJ IDEA.
  User: zxybazh
  Date: 6/28/15
  Time: 4:28 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" import="workspace.*" %>
<%@ page import="javax.servlet.http.Cookie" %>
<%@ page import="java.util.Vector" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="A new online book store based on jsp and mysql">
    <meta name="author" content="zxybazh">

    <title>Wexley's Book Store</title>

    <!-- Bootstrap core CSS -->
    <link href="./css/bootstrap.min.css" rel="stylesheet">
    <link href="./css/docs.min.css" rel="stylesheet">
</head>

<body>
<%
    request.setCharacterEncoding("UTF-8");
    String token = null, username = null;
    Integer cid = null;
    String order_list = null;
    Cookie Cookies[] = request.getCookies();
    if (Cookies != null) {
        for (int i = 0; i < Cookies.length; i++) {
            if (Cookies[i].getName().equals("token"))
                token = Cookies[i].getValue();
            if (Cookies[i].getName().equals("orderlist")) {
                order_list = Cookies[i].getValue();
            }
            if (Cookies[i].getName().equals("username"))
                username = Cookies[i].getValue();
            if (Cookies[i].getName().equals("cid")) {
                String temp = Cookies[i].getValue();
                cid = Integer.parseInt(temp);
            }

        }
    }
    Boolean situation = null;
    if (cid != null && token != null) situation = myapi.checkmytoken(cid, token);
    if (token == null || username == null || cid == null || situation == null || situation == false) {
        Cookie c = new Cookie("token", "");
        c.setMaxAge(0);
        response.addCookie(c);
        c = new Cookie("cid", "");
        c.setMaxAge(0);
        response.addCookie(c);
        c = new Cookie("username", "");
        c.setMaxAge(0);
        response.addCookie(c);
%>
<script>
    alert("Please log in first");
    setTimeout(location.href = "index.jsp", 5000);
</script>
</body>
</html>
<%
        return;
    }
%>
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar"
                    aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="index.jsp">Wexley's Book Store</a>

            <div class="navbar-header">
                <a class="navbar-brand" href="customer.jsp">Customer</a>
                <a class="navbar-brand" href="manager.jsp">Manager</a>
            </div>
        </div>
        <div class=navbar-right>
            <a class="navbar-text" href="see_profile.jsp">Welcome, <%=username%>
            </a>
            <a class="navbar-text" href="logout.jsp">Log out</a>
        </div>
    </div>
</nav>
<div class="jumbotron">
</div>
<div class="container">
    <%
        if (order_list == null) order_list = "";
        String temp[] = order_list.split("s");
        boolean flag = true;
        if (!(temp == null || temp.length == 0 || (temp.length == 1 && temp[0].equals("")))) {
            for (int i = 0; i < temp.length; i++) {
                String pair[] = temp[i].split("x");
                int bid = Integer.parseInt(pair[0]);
                int num = Integer.parseInt(pair[1]);

                Boolean tmp = myapi.QuesSufficient(bid, num);
                if (tmp == null || tmp == false) {
                    for (int j = 0; j < i; i++) {
                        String tt[] = temp[j].split("x");
                        int bb = Integer.parseInt(pair[0]);
                        int nn = Integer.parseInt(pair[1]);
                        myapi.Addcopy(bb, nn);
                    }
                    flag = false;
                    break;
                }
                myapi.Addcopy(bid, -num);
            }
            if (flag) {
    %>
    <script>
        alert("0w0 Purchase Successfully");
        setTimeout(location.href = "index.jsp", 5000);
    </script>
    <%
        Cookie c = new Cookie("orderlist", "");
        c.setMaxAge(0);
        response.addCookie(c);
    } else {
    %>
    <script>
        alert("Purchase Failed >_<");
        setTimeout(location.href = "purchase.jsp", 5000);
    </script>
    <%
        }
    } else {
    %>
    <script>
        alert("Nothing to buy >_<");
        setTimeout(location.href = "purchase.jsp", 5000);
    </script>
    <%
        }
    %>

</div>

<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="./js/jquery.min.js"></script>
<script src="./js/bootstrap.min.js"></script>
</body>
</html>