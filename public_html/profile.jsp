<%--
  Created by IntelliJ IDEA.
  User: zxybazh
  Date: 6/22/15
  Time: 11:37 PM
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
    String full_name = request.getParameter("cp_full_name");
    if (full_name != null && full_name.length() == 0) full_name = null;
    String password = request.getParameter("cp_password");
    if (password != null && password.length() == 0) password = null;
    String phone_number = request.getParameter("cp_phone_number");
    if (phone_number != null && phone_number.length() == 0) phone_number = null;
    String address = request.getParameter("cp_address");
    if (address != null && address.length() == 0) address = null;
    if (full_name == null && password == null && phone_number == null && address == null) {
%>
<div class="container">
    <fieldset>
        <div id="legend">
            <legend class="">Change your profile(leave blank if unchanged)</legend>
        </div>
        <form action="profile.jsp" method="post" onsubmit="return forward()">
            <div class="control-group">
                <!-- Password-->
                <label class="control-label" for="password">Password</label>

                <div class="form-inline">
                    <input type="password" id="password" name="cp_password" placeholder=""
                           class="form-control">

                    <p class="help-block">Password can contain 3-30 letters or numbers</p>
                </div>
            </div>

            <div class="control-group">
                <!-- Password -->
                <label class="control-label" for="password_confirm">Password (Confirm)</label>

                <div class="form-inline">
                    <input type="password" id="password_confirm" name="cp_password_confirm" placeholder=""
                           class="form-control">

                    <p class="help-block">Please confirm your password</p>
                </div>
            </div>

            <div class="control-group">
                <!-- Full Name -->
                <label class="control-label" for="full_name">Full Name</label>

                <div class="form-inline">
                    <input type="text" id="full_name" name="cp_full_name" placeholder=""
                           class="form-control">


                    <p class="help-block">Full name should contain less or equal to 30 characters</p>
                </div>
            </div>

            <div class="control-group">
                <!-- Phone Number -->
                <label class="control-label" for="phone_number">Phone Number</label>

                <div class="form-inline">
                    <input type="text" id="phone_number" name="cp_phone_number" placeholder=""
                           class="form-control">

                    <p class="help-block">Phone Number should be 11 bit all numbers</p>
                </div>
            </div>

            <div class="control-group">
                <!-- Address -->
                <label class="control-label" for="address">Address</label>

                <div class="form-control-static">
                    <input type="text" id="address" name="cp_address" placeholder=""
                           class="form-control">

                    <p class="help-block">Address should be less or equal to 100 characters</p>
                </div>
            </div>


            <div class="control-group">
                <!-- Button -->
                <div class="controls">
                    <button id="submit" type="submit" class="btn btn-success">Confirm</button>
                </div>
            </div>
            <script>
                function forward() {
                    var pw = password.value;
                    var pw_c = password_confirm.value;
                    var fn = full_name.value;
                    var pn = phone_number.value;
                    var ad = address.value;

                    if (pw.length > 0 && (pw.length < 3 || pw.length > 30)) {
                        alert("Password length not legal");
                    } else if (pw.length > 0 && !(new RegExp("^[A-Za-z0-9]+$").test(pw))) {
                        alert("Password contain illegal characters");
                    } else if (pw != pw_c) {
                        alert("The passwords you typed do not match");
                    } else if (fn.length > 30) {
                        alert("Full name length not legal");
                    } else if (pn.length > 0 && pn.length != 11) {
                        alert("Phone Number length not legal");
                    } else if (pn.length > 0 && !(new RegExp("^[0-9]+$").test(pn))) {
                        alert("Phone Number contains illegal characters");
                    } else if (ad.length > 100) {
                        alert("Address length not legal");
                    } else if (pw.length + fn.length + pn.length + ad.length == 0) {
                        location.href = "see_profile.jsp";
                    } else return true;
                    return false;
                }
            </script>
        </form>
    </fieldset>
    <!--
    <script>
        alert("Successfully Registed ;-)");
        setTimeout(location.href = "index.jsp", 5000);
    </script>

    -->
    <%
    } else {
        if (password != null) myapi.changePassword(cid, password);
        if (full_name != null) myapi.changeFullName(cid, full_name);
        if (address != null) myapi.changeAddress(cid, address);
        if (phone_number != null) myapi.changePhoneNumber(cid, phone_number);
    %>
    <script>
        alert("Profile Changed Successfully ;-)");
        setTimeout(location.href = "see_profile.jsp", 5000);
    </script>
    <%
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
