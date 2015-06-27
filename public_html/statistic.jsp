<%--
  Created by IntelliJ IDEA.
  User: zxybazh
  Date: 6/27/15
  Time: 12:38 PM
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
    String k1 = request.getParameter("m1");
    String k2 = request.getParameter("m2");
    String k3 = request.getParameter("m3");

    int m1, m2, m3;

    try {
        m1 = Integer.parseInt(k1);
    } catch (Exception e) {
        m1 = -1;
    }
    try {
        m2 = Integer.parseInt(k2);
    } catch (Exception e) {
        m2 = -1;
    }
    try {
        m3 = Integer.parseInt(k3);
    } catch (Exception e) {
        m3 = -1;
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
    String ss1 = "", ss2 = "", ss3 = "";
    if (m3 > 0) ss3 = " class=\"active\"";
    else if (m2 > 0) ss2 = " class=\"active\"";
    else ss1 = " class=\"active\"";
    String ts1 = "", ts2 = "", ts3 = "";
    if (m3 > 0) ts3 = " active";
    else if (m2 > 0) ts2 = " active";
    else ts1 = " active";
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
            <legend class="">Show Statistics (This Semester)</legend>
        </div>
    </fieldset>


    <div class="tabbable"> <!-- Only required for left/right tabs -->
        <ul class="nav nav-tabs">
            <li <%=ss1%>><a href="#tab1" data-toggle="tab">Most popular books</a></li>
            <li <%=ss2%>><a href="#tab2" data-toggle="tab">Most popular authors</a></li>
            <li <%=ss3%>><a href="#tab3" data-toggle="tab">Most popular publishers</a></li>
        </ul>
        <div class="tab-content">
            <div class="tab-pane<%=ts1%>" id="tab1" style="padding-top: 10px">
                <form action="statistic.jsp" method="post" onsubmit="return forward()">
                    <div class="control-group">
                        <label class="control-label" for="m1">The number of books to show</label>

                        <div class="form-inline">
                            <input type="number" id="m1" name="m1" placeholder="default as 10"
                                   class="form-control" value="">
                            <button id="submit1" type="submit" class="btn btn-success">Confirm</button>
                        </div>
                    </div>
                </form>
                <%
                    Vector<Vector<String>> a = myapi.StatisticOfBooks(m1);
                    if (a != null && a.size() > 0) {
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
                        <td><%=a.get(1).get(i)%>
                        </td>
                        <td><%=a.get(2).get(i)%>
                        </td>
                        <td><%=a.get(3).get(i)%>
                        </td>
                        <td><%=(a.get(4).get(i) == null ? "0" : a.get(4).get(i))%>
                        </td>
                    </tr>
                    <%
                        }

                    %>
                    </tbody>
                </table>
                <%
                    }
                %>
            </div>

            <div class="tab-pane<%=ts2%>" id="tab2" style="padding-top: 10px">
                <form action="statistic.jsp" method="post" onsubmit="return forward()">
                    <div class="control-group">
                        <label class="control-label" for="m2">The number of authors to show</label>

                        <div class="form-inline">
                            <input type="number" id="m2" name="m2" placeholder="default as 10"
                                   class="form-control" value="">
                            <button id="submit2" type="submit" class="btn btn-success">Confirm</button>
                        </div>
                    </div>
                </form>
                <%
                    a = myapi.StatisticOfAuthors(m2);
                    if (a != null && a.size() > 0) {
                %>
                <table class="table table-striped">
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
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
                        <td><%=a.get(1).get(i)%>
                        </td>
                        <td><%=(a.get(2).get(i) == null ? "0" : a.get(2).get(i))%>
                        </td>
                    </tr>
                    <%
                        }

                    %>
                    </tbody>
                </table>
                <%
                    }
                %>
            </div>

            <div class="tab-pane<%=ts3%>" id="tab3" style="padding-top: 10px">
                <form action="statistic.jsp" method="post" onsubmit="return forward()">
                    <div class="control-group">
                        <label class="control-label" for="m3">The number of publishers to show</label>

                        <div class="form-inline">
                            <input type="number" id="m3" name="m3" placeholder="default as 10"
                                   class="form-control" value="">
                            <button id="submit3" type="submit" class="btn btn-success">Confirm</button>
                        </div>
                    </div>
                </form>
                <%
                    a = myapi.StatisticOfPublishers(m3);
                    if (a != null && a.size() > 0) {
                %>
                <table class="table table-striped">
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Publisher</th>
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
                        <td><%=a.get(1).get(i)%>
                        </td>
                        <td><%=(a.get(2).get(i) == null ? "0" : a.get(2).get(i))%>
                        </td>
                    </tr>
                    <%
                        }

                    %>
                    </tbody>
                </table>
                <%
                    }
                %>
            </div>
        </div>
    </div>

    <script>
        function forward() {
            var k1 = m1.value;
            var k2 = m2.value;
            var k3 = m3.value;
            if (k1 != "" && k1 < 1) {
                alert("The number of books can't be less than one");
            } else if (k2 != "" && k2 < 1) {
                alert("The number of authors can't be less than one");
            } else if (k3 != "" && k3 < 1) {
                alert("The number of publishers can't be less than one");
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
