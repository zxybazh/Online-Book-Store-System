<%--
  Created by IntelliJ IDEA.
  User: zxybazh
  Date: 6/21/15
  Time: 10:53 PM
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
    </div>
</nav>
<div class="jumbotron">
</div>
<div class="container">
    <fieldset>
        <div id="legend">
            <legend class="">Register</legend>
        </div>
        <%
            String username = request.getParameter("reg_username");
            String password = request.getParameter("reg_password");
            String full_name = request.getParameter("reg_full_name");
            String phone_number = request.getParameter("reg_phone_number");
            String address = request.getParameter("reg_address");
            boolean flag = false;
            if (username == null || password == null || phone_number == null || full_name == null || address == null) {
                username = "";
                //password = "";
                full_name = "";
                phone_number = "";
                address = "";
            } else {
                Boolean duplicate = myapi.username_duplicate(username);
                if (duplicate != null && duplicate == false) {
                    Boolean register = myapi.register(username, password, full_name, phone_number, address);
                    if (register != null && register) {
                        String token = myapi.login(username, password);
                        if (token != null) {
                            Cookie c = new Cookie("username", username);
                            response.addCookie(c);
                            c = new Cookie("token", token);
                            response.addCookie(c);
                            c = new Cookie("cid", myapi.GetCidByToken(token).toString());
                            response.addCookie(c);
                            flag = true;
                        }
                    }
                }
                if (duplicate != null && duplicate == true) {
        %>
        <script>
            alert("Sorry, your username has been taken ;-)");
        </script>
        <%
                }
            }
            if (!flag) {
        %>
        <form action="register.jsp" method="post" onsubmit="return forward()">
            <div class="control-group">
                <!-- Username -->
                <label class="control-label" for="username">Username</label>

                <div class="form-inline">
                    <input type="text" id="username" name="reg_username" placeholder="" class="form-control"
                           value=<%=username%>>

                    <p class="help-block">Username can contain 3-30 letters or numbers</p>
                </div>
            </div>
            <div class="control-group">
                <!-- Password-->
                <label class="control-label" for="password">Password</label>

                <div class="form-inline">
                    <input type="password" id="password" name="reg_password" placeholder="" class="form-control">

                    <p class="help-block">Password can contain 3-30 letters or numbers</p>
                </div>
            </div>

            <div class="control-group">
                <!-- Password -->
                <label class="control-label" for="password_confirm">Password (Confirm)</label>

                <div class="form-inline">
                    <input type="password" id="password_confirm" name="reg_password_confirm" placeholder=""
                           class="form-control">

                    <p class="help-block">Please confirm your password</p>
                </div>
            </div>

            <div class="control-group">
                <!-- Full Name -->
                <label class="control-label" for="full_name">Full Name</label>

                <div class="form-inline">
                    <input type="text" id="full_name" name="reg_full_name" placeholder="" class="form-control"
                           value=<%=full_name%>>

                    <p class="help-block">Full name should contain less or equal to 30 characters</p>
                </div>
            </div>

            <div class="control-group">
                <!-- Phone Number -->
                <label class="control-label" for="phone_number">Phone Number</label>

                <div class="form-inline">
                    <input type="text" id="phone_number" name="reg_phone_number" placeholder="" class="form-control"
                           value=<%=phone_number%>>

                    <p class="help-block">Phone Number should be 11 bit all numbers</p>
                </div>
            </div>

            <div class="control-group">
                <!-- Address -->
                <label class="control-label" for="address">Address</label>

                <div class="form-control-static">
                    <input type="text" id="address" name="reg_address" placeholder="" class="form-control"
                           value=<%=address%>>

                    <p class="help-block">Address should be less or equal to 100 characters</p>
                </div>
            </div>


            <div class="control-group">
                <!-- Button -->
                <div class="controls">
                    <button id="submit" type="submit" class="btn btn-success">Register</button>
                </div>
            </div>
            <script>
                function forward() {
                    var un = username.value;
                    var pw = password.value;
                    var pw_c = password_confirm.value;
                    var fn = full_name.value;
                    var pn = phone_number.value;
                    var ad = address.value;

                    if (un.length < 3 || un.length > 30) {
                        alert("Username length not legal");
                    } else if (!(new RegExp("^[A-Za-z0-9]+$").test(un))) {
                        alert("Username contain illegal characters");
                    } else if (pw.length < 3 || pw.length > 30) {
                        alert("Password length not legal");
                    } else if (!(new RegExp("^[A-Za-z0-9]+$").test(pw))) {
                        alert("Password contain illegal characters");
                    } else if (pw != pw_c) {
                        alert("The passwords you typed do not match");
                    } else if (fn.length == 0) {
                        alert("Full name should not be empty");
                    } else if (fn.length > 30) {
                        alert("Full name length not legal");
                    } else if (pn.length != 11) {
                        alert("Phone Number length not legal");
                    } else if (!(new RegExp("^[0-9]+$").test(pn))) {
                        alert("Phone Number contains illegal characters");
                    } else if (ad.length > 100) {
                        alert("Address length not legal");
                    } else if (ad.length == 0) {
                        alert("Address should not be empty");
                    } else return true;
                    return false;
                }
            </script>
        </form>
    </fieldset>
    <%
    } else {
    %>
    <script>
        alert("Successfully Registed ;-)");
        setTimeout(location.href = "index.jsp", 5000);
    </script>
    <%
            //response.sendRedirect("index.jsp");
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
