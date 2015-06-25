<%--
  Created by IntelliJ IDEA.
  User: zxybazh
  Date: 6/23/15
  Time: 12:31 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" import="workspace.*" %>
<%@ page import="javax.servlet.http.Cookie" %>

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
        response.sendRedirect("index.jsp");
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
<%
    String full_name = myapi.GetFullNameByToken(token);
    String address = myapi.GetAddressByToken(token);
    Long tmp = myapi.GetPhoneNumberByToken(token);

    if (full_name == null || address == null || tmp == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String phone_number = tmp.toString();
    while (phone_number.length() < 11) phone_number = '0' + phone_number;
%>
<div class="container">
    <fieldset>
        <div id="legend">
            <legend class="">Your profile</legend>
        </div>
        <form action="profile.jsp">

            <div class="control-group">
                <!-- Username -->
                <label class="control-label" for="username">Username</label>

                <div class="form-inline">
                    <legend id="username"><%=username%>
                    </legend>
                </div>
            </div>

            <div class="control-group">
                <!-- Full Name -->
                <label class="control-label" for="full_name">Full Name</label>

                <div class="form-inline">
                    <legend id="full_name"><%=full_name%>
                    </legend>
                </div>
            </div>

            <div class="control-group">
                <!-- Phone Number -->
                <label class="control-label" for="phone_number">Phone Number</label>

                <div class="form-inline">
                    <legend id="phone_number"><%=phone_number%>
                    </legend>
                </div>
            </div>

            <div class="control-group">
                <!-- Address -->
                <label class="control-label" for="address">Address</label>

                <div class="form-control-static">

                    <legend id="address"><%=address%>
                    </legend>
                </div>
            </div>

            <div class="control-group">
                <!-- Button -->
                <div class="controls">
                    <button id="submit" type="submit" class="btn btn-success">Change my profile</button>
                </div>
            </div>
        </form>
    </fieldset>
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
