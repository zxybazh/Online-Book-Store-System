<%--
  Created by IntelliJ IDEA.
  User: zxybazh
  Date: 6/28/15
  Time: 1:29 AM
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
    Cookie Cookies[] = request.getCookies();
    if (Cookies != null) {
        for (int i = 0; i < Cookies.length; i++) {
            if (Cookies[i].getName().equals("token"))
                token = Cookies[i].getValue();
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
    <fieldset>
        <div id="legend">
            <legend class="">Two Degrees of Separation</legend>
        </div>
    </fieldset>

    <%
        String aname1 = request.getParameter("2d_aname1");
        String aname2 = request.getParameter("2d_aname2");
        if (aname1 == null) aname1 = "";
        if (aname2 == null) aname2 = "";

    %>

    <form action="2dseparation.jsp" method="post" onsubmit="return forward()">
        <div class="control-group">
            <label class="control-label" for="aname1">The First Author</label>

            <div class="form-inline">
                <input type="text" id="aname1" name="2d_aname1" placeholder="" class="form-control" value="<%=aname1%>"
                       ,
                       maxlength="40">
            </div>
            <p class="help-block">Please input the name of the first author(no more than 40 characters).</p>
        </div>

        <div class="control-group">
            <label class="control-label" for="aname2">The Second Author</label>

            <div class="form-inline">
                <input type="text" id="aname2" name="2d_aname2" placeholder="" class="form-control" value="<%=aname2%>"
                       ,
                       maxlength="40">
            </div>
            <p class="help-block">Please input the name of the second author(no more than 40 characters).</p>
        </div>

        <div class="control-group">
            <!-- Button -->
            <div class="controls">
                <button id="submit" type="submit" class="btn btn-success">Confirm</button>
            </div>
        </div>
    </form>
    <script>
        function forward() {
            var a1 = $('#aname1').val();
            var a2 = $('#aname2').val();
            if (a1 == "" || a2 == "") {
                alert("Author name can't be empty >_<");
            } else return true;
            return false;
        }
    </script>

    <%
        if (!aname1.equals("") && !aname2.equals("")) {
            Integer a1 = myapi.GetAidByAname_NonCreate(aname1);
            Integer a2 = myapi.GetAidByAname_NonCreate(aname2);
            if (a1 == null || a2 == null) {
    %>
    <script>alert("No such author >_<");</script>
    <%
    } else {
        Integer dist = myapi.DistanceOfAuthors(a1, a2);
        if (dist == null) {
    %>
    <script>alert("Calculate distance error >_<");</script>
    <%
                } else {
                    out.println("<h3>The two authors are " + (dist > 2 ? "more than 2" : dist.toString()) +
                            " degree(s) separated.</h3>");
                }
            }
        }
    %>
    <hr>

    <footer>
        <p>&copy; zxybazh 2015</p>
    </footer>
</div>
<!-- /container -->


<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="./js/jquery.min.js"></script>
<script src="./js/bootstrap.min.js"></script>
</body>
</html>
