<%--
  Created by IntelliJ IDEA.
  User: zxybazh
  Date: 6/28/15
  Time: 12:02 AM
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
<%
    String bookid = request.getParameter("fb_bookid");
    String score = request.getParameter("fb_score");
    String comment = request.getParameter("fb_comment");

    boolean flag = true;
    while (bookid != null && score != null && comment != null && flag) {
        flag = false;

        int bid = 0;

        try {
            bid = Integer.parseInt(bookid);
        } catch (Exception e) {
            bid = 0;
            e.printStackTrace();
        }

        if (bid < 1) {
%>
<script>alert("Parse Book ID error >_<");</script>
<%
        break;
    }

    int sc = -1;

    try {
        sc = Integer.parseInt(score);
    } catch (Exception e) {
        sc = -1;
        e.printStackTrace();
    }
    if (sc < 0) {
%>
<script>alert("Parse score error >_<");</script>
<%
        break;
    }

    Boolean tmp = myapi.CheckFeedbackBid(cid, bid);
    if (tmp == null) {
%>
<script>alert("You haven't make such purchase >_<");</script>
<%
        break;
    }
    if (!tmp) {
%>
<script>alert("You have feedbacked this book >_<");</script>
<%
        break;
    }

    myapi.Feedback(cid, bid, sc, comment);
%>
<script>alert("0w0 Feebback successfully!!!");</script>
<%
    }

%>
<div class="container">
    <fieldset>
        <div id="legend">
            <legend class="">Feedback your Books</legend>
        </div>
    </fieldset>

    <form action="feedback.jsp" method="post" onsubmit="return forward()">
        <div class="control-group">
            <label class="control-label" for="bookid">Book ID here</label>

            <div class="form-inline">
                <input type="number" id="bookid" name="fb_bookid" placeholder="" class="form-control" value="" min="1">
            </div>
            <p class="help-block">Book ID of the book you purchased and want to feedback.</p>
        </div>

        <div class="control-group">
            <label class="control-label" for="score">Score the book</label>

            <div class="form-inline">
                <input type="number" id="score" name="fb_score" placeholder="" class="form-control" value="" min="0"
                       max="10">
            </div>
            <p class="help-block">Please input a score for this book[0 = terrible, 10 = masterpiece]</p>
        </div>

        <div class="control-group">
            <label class="control-label" for="comment">Comment here</label>

            <div class="form-control-static">
                <input type="text" id="comment" name="fb_comment" placeholder="" class="form-control" value=""
                       maxlength="100">
            </div>
            <p class="help-block">Please input a short txt for comment(can be blank, no more than 100 characters)</p>
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
            var bi = $('#bookid').val();
            var score = $('#score').val();
            var comment = $('#comment').val();
            if (bi == "") {
                alert("Book ID can't be empty >_<");
            } else if (score == "") {
                alert("Score can't be empty >_<");
            } else if (comment == "") {
                alert("Comment can't be empty >_<");
            } else return true;
            return false;
        }
    </script>
    <%
        Vector<Vector<String>> a = myapi.GetOrderList(cid);
        if (a == null || a.size() == 0) {
    %>
    <h3>You haven't make any purchase _(:з」∠)_</h3>
    <%
    } else {
    %>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>#</th>
            <th>Date</th>
            <th>Amount</th>
            <th>Book ID</th>
            <th>Title</th>
            <th>Feeback</th>
        </tr>
        </thead>
        <tbody>
        <%

            for (int i = 0; i < a.get(0).size(); i++) {
        %>
        <tr>
            <th scope="row"><%=a.get(0).get(i)%>
            </th>
            <td><%=a.get(1).get(i)%>
            </td>
            <td><%=a.get(2).get(i)%>
            </td>
            <td><%=a.get(3).get(i)%>
            </td>
            <td><%=a.get(4).get(i)%>
            </td>
            <td><%=(a.get(5).get(i).equals("0") ? "No" : "Yes")%>
            </td>
        </tr>
        <%
                //System.out.println(a.get(5).get(i));
            }
        %>
        </tbody>
    </table>
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
