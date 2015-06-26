<%--
  Created by IntelliJ IDEA.
  User: zxybazh
  Date: 6/26/15
  Time: 21:42 PM
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
            <legend class="">Recommendations for you</legend>
        </div>
    </fieldset>

    <div class="tabbable"> <!-- Only required for left/right tabs -->
        <ul class="nav nav-tabs">
            <li class="active"><a href="#tab1" data-toggle="tab">From Specific Book</a></li>
            <li><a href="#tab2" data-toggle="tab">From My Orders</a></li>
        </ul>
        <div class="tab-content">

            <div class="tab-pane active" id="tab1" style="padding-top: 22px">
                <%
                    String isbn = request.getParameter("rec_isbn");
                    String bookid = request.getParameter("rec_bookid");
                    if (bookid != null && bookid.length() == 0) bookid = null;
                    if (isbn != null && isbn.length() == 0) isbn = null;
                    Integer bid = null;
                    boolean flag = false;
                    if (bookid != null) {
                        try {
                            bid = Integer.parseInt(bookid);
                        } catch (Exception e) {
                            bid = null;
                            e.printStackTrace();
                        }
                        if (bid != null) {
                            Boolean valid = myapi.CheckBid(bid);
                            if (valid != null) {
                                if (valid) flag = true;
                                else {
                %>
                <script>alert("Book ID doesn't exists >_<");</script>
                <%
                            }
                        }
                    }
                } else if (isbn != null) {
                    bid = myapi.GetBidByISBN(isbn);
                    if (bid != null) {
                        flag = true;
                    } else {
                %>
                <script>alert("ISBN doesn't exists >_<");</script>
                <%
                        }
                    }

                    if (flag) {
                        Vector<Vector<String>> a = myapi.RecommendationFromBid(cid, bid);
                        System.out.println(isbn);
                        System.out.println(bid);
                        if (a.size() > 0) {
                %>
                <table class="table table-striped">
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>ISBN</th>
                        <th>Price</th>
                        <th>Title</th>
                        <th>Sold Amount</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        for (int i = 0; i < a.get(0).size(); i++) {
                    %>
                    <tr>
                        <th scope="row"><%=a.get(0).get(i)%>
                        </th>
                        <th><%=a.get(1).get(i)%>
                        </th>
                        <th><%=a.get(2).get(i)%>
                        </th>
                        <th><%=a.get(3).get(i)%>
                        </th>
                        <th><%=(a.get(4).get(i) == null ? "0" : a.get(4).get(i))%>
                        </th>
                    </tr>
                    <%
                        }

                    %>
                    </tbody>
                </table>
                <%
                } else {
                %>
                <p>No result available</p>
                <%
                        }
                    }
                %>
                <p>Please Input the Book ID or ISBN:</p>

                <form action="recommend.jsp" method="post" onsubmit="return forward()">
                    <div class="control-group">
                        <label class="control-label" for="bookid">Book ID here</label>

                        <div class="form-inline">
                            <input type="number" id="bookid" name="rec_bookid" placeholder=""
                                   class="form-control" value="">
                        </div>
                    </div>

                    <div class="control-group">
                        <label class="control-label" for="isbn">ISBN here</label>

                        <div class="form-inline">
                            <input type="text" id="isbn" name="rec_isbn" placeholder=""
                                   class="form-control" value="">
                        </div>
                    </div>

                    <div class="control-group" style="padding-top: 22px">
                        <!-- Button -->
                        <div class="controls">
                            <button id="submit" type="submit" class="btn btn-success">Confirm</button>
                        </div>
                    </div>
                </form>
                <script>
                    function forward() {
                        var bi = $('#bookid').val();
                        var isbn = $('#isbn').val();
                        if ((bi != null) && (bi != "")) {
                            if (bi < 1) {
                                alert("Book ID illegal");
                            }
                            else return true;
                        } else if (isbn.length != 10) {
                            alert("Book ISBN length illegal");
                        } else if (!(new RegExp("^[Xx0-9]+$").test(isbn)) || !(new RegExp("^[0-9]+$").test(isbn.substr(0, 9))) || !(new RegExp("^[Xx0-9]+$").test(isbn.substr(9, 1)))) {
                            alert("Book ISBN contains illegal characters or format illegal");
                        } else return true;
                        return false;
                    }
                </script>
            </div>

            <div class="tab-pane" id="tab2" style="padding-top: 22px">
                <%
                    Vector<Vector<String>> a = myapi.RecommendationFromOrder(cid);
                    if (a.size() == 0) {
                %>
                <p>No result available based on your orders but you can still view these_(:з」∠)_</p>
                <%
                        a = myapi.RecommendationFromPopular();
                    }
                %>
                <table class="table table-striped">
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>ISBN</th>
                        <th>Price</th>
                        <th>Title</th>
                        <th>Sold Amount</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%

                        if (a.size() > 0)
                            for (int i = 0; i < a.get(0).size(); i++) {
                    %>
                    <tr>
                        <th scope="row"><%=a.get(0).get(i)%>
                        </th>
                        <th><%=a.get(1).get(i)%>
                        </th>
                        <th><%=a.get(2).get(i)%>
                        </th>
                        <th><%=a.get(3).get(i)%>
                        </th>
                        <th><%=(a.get(4).get(i) == null ? "0" : a.get(4).get(i))%>
                        </th>
                    </tr>
                    <%
                            }
                    %>
                    </tbody>
                </table>
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
