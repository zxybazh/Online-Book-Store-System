<%--
  Created by IntelliJ IDEA.
  User: zxybazh
  Date: 6/26/15
  Time: 5:43 PM
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
    Boolean admin = null;
    if (cid != null && token != null) admin = myapi.checkAdministration(token);
    if (token == null || username == null || cid == null || situation == null || situation == false || admin == null) {
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
    alert("Please log in first >_<");
    setTimeout(location.href = "index.jsp", 5000);
</script>
</body>
</html>
<%
        return;
    }
    if (admin == false) {
%>
<script>
    alert("You are not manager >_<");
    setTimeout(location.href = "index.jsp", 5000);
</script>
</body>
</html>
<%
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
            <legend class="">Change user's authority</legend>
        </div>
    </fieldset>


    <div class="tabbable"> <!-- Only required for left/right tabs -->
        <ul class="nav nav-tabs">
            <li class="active"><a href="#tab1" data-toggle="tab">By username</a></li>
            <li><a href="#tab2" data-toggle="tab">By user id</a></li>
        </ul>
        <div class="tab-content">
            <div class="tab-pane active" id="tab1" style="padding-top: 10px">
                <form action="authority_handler.jsp" method="post" onsubmit="return forward1()">
                    <div class="control-group">
                        <label class="control-label" for="username">Username</label>

                        <div class="form-inline">
                            <input type="text" id="username" name="ca_username" placeholder=""
                                   class="form-control" value="">
                        </div>
                    </div>

                    <div class="control-group" style="padding-top: 22px">
                        <label class="control-label" for="caway1">Select the way you change authority</label>

                        <div class="form-inline">
                            <select class="form-control" id="caway1" name="caway">
                                <option value="manager">Change to Manager</option>
                                <option value="customer">Change to Customer</option>
                            </select>
                        </div>
                    </div>

                    <div class="control-group" style="padding-top: 22px">
                        <!-- Button -->
                        <div class="controls">
                            <button id="submit1" type="submit" class="btn btn-success">Confirm</button>
                        </div>
                    </div>
                </form>
            </div>
            <div class="tab-pane" id="tab2" style="padding-top: 10px">
                <form action="authority_handler.jsp" method="post" onsubmit="return forward2()">
                    <div class="control-group">
                        <label class="control-label" for="userid">User ID</label>

                        <div class="form-inline">
                            <input type="number" id="userid" name="ca_userid" placeholder=""
                                   class="form-control" value="">
                        </div>
                    </div>

                    <div class="control-group" style="padding-top: 22px">
                        <label class="control-label" for="caway2">Select the way you change authority</label>

                        <div class="form-inline">
                            <select class="form-control" id="caway2" name="caway">
                                <option value="manager">Change to Manager</option>
                                <option value="customer">Change to Customer</option>
                            </select>
                        </div>
                    </div>

                    <div class="control-group" style="padding-top: 22px">
                        <!-- Button -->
                        <div class="controls">
                            <button id="submit2" type="submit" class="btn btn-success">Confirm</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function forward1() {
            var un = username.value;
            if (un.length < 3 || un.length > 30) {
                alert("Username length not legal");
            } else if (!(new RegExp("^[A-Za-z0-9]+$").test(un))) {
                alert("Username contain illegal characters");
            } else return true;
            return false;
        }
        function forward2() {
            var cw = userid.value;
            if (cw < 1 || !(new RegExp("^[0-9]+$").test(cw))) {
                alert("User ID illegal");
            } else return true;
            return false;
        }
    </script>

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
