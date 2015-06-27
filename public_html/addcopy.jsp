<%--
  Created by IntelliJ IDEA.
  User: zxybazh
  Date: 6/27/15
  Time: 3:06 PM
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
<%
    String bookid = request.getParameter("ac_bookid");
    String number = request.getParameter("number");
    String isbn = request.getParameter("ac_isbn");

    int bid = 0, num = 0;
    if (isbn != null) {
        Integer temp = myapi.GetBidByISBN(isbn);
        if (temp != null) bid = temp;
        else {
%>
<script>
    alert("No such ISBN >_<");
</script>
<%
    }
} else if (bookid != null) {
    try {
        bid = Integer.parseInt(bookid);
    } catch (Exception e) {
        bid = 0;
        num = 0;
        e.printStackTrace();
    }
    Boolean temp = myapi.CheckBid(bid);
    if (temp == null || !temp) {
%>
<script>
    alert("No such Book ID >_<");
</script>
<%
            bid = 0;
        }
    }
    if (number != null && (bookid != null || isbn != null) && bid != 0) {
        try {
            num = Integer.parseInt(number);
        } catch (Exception e) {
            num = 0;
%>
<script>
    alert("Parse add copy number error >_<");
</script>
<%
        e.printStackTrace();
    }
    if (num != 0 && bid != 0) {
        System.out.println(bid);
        System.out.println(num);
        System.out.println(isbn);

        myapi.Addcopy(bid, num);
%>
<script>
    alert("0W0 Add copy number successfully");
</script>
<%
        }
    }
%>
<div class="container">
    <fieldset>
        <div id="legend">
            <legend class="">Add Copies of Books</legend>
        </div>
    </fieldset>

    <div class="tabbable"> <!-- Only required for left/right tabs -->
        <ul class="nav nav-tabs">
            <li class="active"><a href="#tab1" data-toggle="tab">By Book ID</a></li>
            <li><a href="#tab2" data-toggle="tab">By ISBN</a></li>
        </ul>
        <div class="tab-content">

            <div class="tab-pane active" id="tab1" style="padding-top: 22px">
                <form action="addcopy.jsp" method="post" onsubmit="return forward1()">
                    <div class="control-group">
                        <label class="control-label" for="bookid">Book ID here</label>

                        <div class="form-inline">
                            <input type="number" id="bookid" name="ac_bookid" placeholder=""
                                   class="form-control" value="">
                        </div>
                    </div>

                    <div class="control-group">
                        <label class="control-label" for="number1">Number here</label>

                        <div class="form-inline">
                            <input type="number" id="number1" name="number" placeholder=""
                                   class="form-control" value="">
                        </div>
                    </div>
                    <!--
                    <div class="control-group">
                        <label class="control-label" for="isbn">ISBN here</label>

                        <div class="form-inline">
                            <input type="text" id="isbn" name="rec_isbn" placeholder=""
                                   class="form-control" value="">
                        </div>
                    </div>
                    -->

                    <div class="control-group" style="padding-top: 22px">
                        <!-- Button -->
                        <div class="controls">
                            <button id="submit1" type="submit" class="btn btn-success">Confirm</button>
                        </div>
                    </div>
                </form>
                <script>
                    function forward1() {
                        var bi = $('#bookid').val();
                        var num = $('#number1').val();
                        if (bi == "") {
                            alert("Book ID can't be empty >_<");
                        } else if (bi < 1) {
                            alert("Book ID should not be less than 1 >_<");
                        } else if (num < 1) {
                            alert("Add copy number should not be less than 1 >_<");
                        } else return true;
                        return false;
                    }
                </script>
            </div>

            <div class="tab-pane" id="tab2" style="padding-top: 22px">
                <form action="addcopy.jsp" method="post" onsubmit="return forward2()">
                    <div class="control-group">
                        <label class="control-label" for="isbn">ISBN here</label>

                        <div class="form-inline">
                            <input type="text" id="isbn" name="ac_isbn" placeholder=""
                                   class="form-control" value="">
                        </div>
                    </div>

                    <div class="control-group">
                        <label class="control-label" for="number2">Number here</label>

                        <div class="form-inline">
                            <input type="number" id="number2" name="number" placeholder=""
                                   class="form-control" value="">
                        </div>
                    </div>

                    <div class="control-group" style="padding-top: 22px">
                        <!-- Button -->
                        <div class="controls">
                            <button id="submit2" type="submit" class="btn btn-success">Confirm</button>
                        </div>
                    </div>
                </form>
                <script>
                    function forward2() {
                        var isbn = $('#isbn').val();
                        var num = $('#number2').val();
                        if (isbn.length != 10) {
                            alert("Book ISBN length illegal");
                        } else if (!(new RegExp("^[Xx0-9]+$").test(isbn)) || !(new RegExp("^[0-9]+$").test(isbn.substr(0, 9))) || !(new RegExp("^[Xx0-9]+$").test(isbn.substr(9, 1)))) {
                            alert("Book ISBN contains illegal characters or format illegal");
                        } else if (num < 1) {
                            alert("Add copy number should not be less than 1 >_<");
                        } else return true;
                        return false;
                    }
                </script>
            </div>
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
