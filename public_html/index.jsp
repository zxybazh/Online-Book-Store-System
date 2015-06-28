<%--
    Created by IntelliJ IDEA.
    User: zxybazh
    Date: 6/12/15
    Time: 10:35 PM
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
        <div class="navbar-header">
            <a class="navbar-brand" href="customer.jsp">Customer</a>
            <a class="navbar-brand" href="manager.jsp">Manager</a>
        </div>

        <%
            request.setCharacterEncoding("UTF-8");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String token = null;
            Integer cid = null;
            if (username != null && password != null) {
                request.removeAttribute("username");
                request.removeAttribute("password");
                token = myapi.login(username, password);

                if (token == null) {
        %>
        <script>
            alert("Wrong Password or Username!");
        </script>
        <%
                }

                if (token != null) {

                    cid = myapi.GetCidByToken(token);

                    Cookie c = new Cookie("username", username);
                    c.setMaxAge(60 * 60 * 24);
                    response.addCookie(c);

                    c = new Cookie("token", token);
                    c.setMaxAge(60 * 60 * 24);
                    response.addCookie(c);

                    c = new Cookie("cid", Integer.toString(cid));
                    c.setMaxAge(60 * 60 * 24);
                    response.addCookie(c);
                }
            }
            if (token == null || cid == null) {
                Cookie Cookies[] = request.getCookies();
                if (Cookies != null) {
                    String temp = null;
                    for (int i = 0; i < Cookies.length; ++i) {
                        if (Cookies[i].getName().equals("token"))
                            token = Cookies[i].getValue();
                        if (Cookies[i].getName().equals("cid"))
                            temp = Cookies[i].getValue();
                        if (Cookies[i].getName().equals("username"))
                            username = Cookies[i].getValue();
                    }
                    //token = request.getParameter("token");
                    //temp = request.getParameter("cid");
                    if (temp == null) cid = null;
                    else cid = Integer.parseInt(temp);
                }
            }

            Boolean tmp;
            boolean flag = false;
            if (token != null && cid != null) {
                tmp = myapi.checkmytoken(cid, token);
                if (tmp != null && tmp == true) {
                    myapi.renew(cid);
                    flag = true;
        %>
        <div class=navbar-right>
            <a class="navbar-text" href="see_profile.jsp">Welcome, <%=username%>
            </a>
            <a class="navbar-text" href="logout.jsp">Log out</a>
        </div>
        <%
                }
            }
            if (!flag) {
        %>
        <div id="navbar" class="navbar-collapse collapse">
            <form class="navbar-form navbar-right" action="./index.jsp" method="post">
                <div class="form-group">
                    <input name="username" type="text" placeholder="Username" class="form-control">
                </div>
                <div class="form-group">
                    <input name="password" type="password" placeholder="Password" class="form-control">
                </div>
                <button type="submit" class="btn btn-success">Sign in</button>
            </form>
        </div>
        <!--/.navbar-collapse -->
        <%
            }
        %>
    </div>
</nav>

<!-- Main jumbotron for a primary marketing message or call to action -->
<div class="jumbotron">
    <div class="container">
        <h1>May the BOOKs be with you</h1>

        <p>This is an online book store system based on JSP and MySQL for DataBase Project.</br>
            Welcome and hope you enjoy the books here.</p>

        <p>Now enter the promo code FeiFei for 30% discount! (More promo code available:-)</p>

        <p><a class="btn btn-primary btn-lg" href="register.jsp" role="button">Register Now &raquo;</a></p>
    </div>
</div>

<div class="container">
    <!-- Example row of columns -->
    <div class="row">
        <div class="col-md-4">
            <h2>Book Recommendation</h2>

            <p>Based on what you bought and what your are interested in, make intelligent recommendations.</p>

            <p><a class="btn btn-default" href="recommend.jsp" role="button">高到不知哪里去 &raquo;</a></p>
        </div>
        <div class="col-md-4">
            <h2>Book Browse System</h2>

            <p>Combination of deep specific search together with simple naive search!</p>

            <p><a class="btn btn-default" href="#" role="button">找的比谁都快 &raquo;</a></p>
        </div>
        <div class="col-md-4">
            <h2>Buy Buy Buy </h2>

            <p>Make your purchase RIGHT NOW!</br>30% Discount for purchase code FeiFei</p>

            <p><a class="btn btn-default" href="purchase.jsp" role="button">我今天是作为一个买家 &raquo;</a></p>
        </div>
    </div>

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

