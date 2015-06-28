<%--
  Created by IntelliJ IDEA.
  User: zxybazh
  Date: 6/28/15
  Time: 11:48 PM
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
            <li class="active"><a href="#tab1" data-toggle="tab">Show feedback</a></li>
            <li><a href="#tab2" data-toggle="tab">Rate Feedback</a></li>
        </ul>
        <div class="tab-content">

            <div class="tab-pane active" id="tab1" style="padding-top: 22px">
                <form action="show_feedback.jsp" method="post" onsubmit="return forward()">
                    <div class="control-group">
                        <label class="control-label" for="bookid">Book ID here</label>

                        <div class="form-inline">
                            <input type="number" id="bookid" name="sf_bookid" placeholder=""
                                   class="form-control" value="" min="1">
                        </div>
                    </div>

                    <div class="control-group">
                        <label class="control-label" for="isbn">ISBN here</label>

                        <div class="form-inline">
                            <input type="text" id="isbn" name="sf_isbn" placeholder=""
                                   class="form-control" value="">
                        </div>
                    </div>

                    <div class="control-group">
                        <label class="control-label" for="number">Number Of feedbacks to show</label>

                        <div class="form-inline">
                            <input type="text" id="number" name="sf_number" placeholder=""
                                   class="form-control" value="" min="1">
                        </div>
                        <p class="help-block">default number is 5.</p>
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
                <form action="show_feedback.jsp" method="post" onsubmit="return forward2()">
                    <div class="control-group">
                        <label class="control-label" for="fid">Feedback ID here</label>

                        <div class="form-inline">
                            <input type="number" id="fid" name="sf_fid" placeholder=""
                                   class="form-control" value="" min="1">
                        </div>
                    </div>

                    <div class="control-group">
                        <label class="control-label" for="rate">Number Of feedbacks to show</label>

                        <div class="form-inline">
                            <input type="number" id="rate" name="sf_rate" placeholder=""
                                   class="form-control" value="" min="0" max="2">
                        </div>
                        <p class="help-block">[0-2] ('useless','useful', 'very useful' respectively</p>
                    </div>

                    <div class="control-group" style="padding-top: 22px">
                        <!-- Button -->
                        <div class="controls">
                            <button id="submit2" type="submit" class="btn btn-success">Rate</button>
                        </div>
                    </div>
                </form>
                <script>
                    function forward2() {
                        var fi = $('#fid').val();
                        var num = $('#rate').val();
                        if (fi == "") {
                            alert("Feedback ID can't be empty >_<");
                        } else if (num == "") {
                            alert("Rate can't be empty >_<");
                        } else return true;
                        return false;
                    }
                </script>
            </div>
        </div>
    </div>
    <%
        String bookid = request.getParameter("sf_bookid");
        String isbn = request.getParameter("sf_isbn");
        String number = request.getParameter("sf_number");
        boolean stop = false;
        while ((bookid != null || isbn != null) && number != null && !stop) {
            if (number.length() == 0) number = "5";
            stop = true;
            int num;
            try {
                num = Integer.parseInt(number);
            } catch (Exception e) {
                e.printStackTrace();
                break;
            }
            Integer bid;
            if (bookid != null && bookid.length() > 0) {
                try {
                    bid = Integer.parseInt(bookid);
                } catch (Exception e) {
                    e.printStackTrace();
                    break;
                }
            } else {
                bid = myapi.GetBidByISBN(isbn);
                if (bid == null || bid < 1) break;
            }
            Vector<Vector<String>> a = myapi.GetFeedbackByBid(bid, num);
            if (a.size() > 0) {
    %>
    <div class="group-control">
        <table class="table table-striped">
            <thead>
            <tr>
                <th>#</th>
                <th>Username</th>
                <th>Date</th>
                <th>Rate</th>
                <th>Comment</th>
            </tr>
            </thead>
            <tbody>
            <%
                for (int i = 0; i < a.size(); i++) {
            %>
            <tr>
                <th scope="row"><%=a.get(i).get(0)%>
                </th>
                <td><%=a.get(i).get(1)%>
                </td>
                <td><%=a.get(i).get(2)%>
                </td>
                <td><%=a.get(i).get(3)%>
                </td>
                <td><%=a.get(i).get(4)%>
                </td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
    <%
            }
        }

        String fid = request.getParameter("sf_fid");
        String rate = request.getParameter("sf_rate");
        boolean flag = false;
        if (fid != null || rate != null) {
            int id = 0, score = 0;
            try {
                id = Integer.parseInt(fid);
                score = Integer.parseInt(rate);
            } catch (Exception e) {
                e.printStackTrace();
                flag = true;
            }
            if (!flag) {
                String ans = myapi.Rate(cid, id, score);
    %>
    <script>
        alert("<%=ans%>");
    </script>
    <%
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
