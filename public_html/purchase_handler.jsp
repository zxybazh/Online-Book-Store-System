<%--
  Created by IntelliJ IDEA.
  User: zxybazh
  Date: 6/28/15
  Time: 3:53 PM
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
    String order_list = null;
    Cookie Cookies[] = request.getCookies();
    if (Cookies != null) {
        for (int i = 0; i < Cookies.length; i++) {
            if (Cookies[i].getName().equals("token"))
                token = Cookies[i].getValue();
            if (Cookies[i].getName().equals("orderlist"))
                order_list = Cookies[i].getValue();
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
            <legend class="">Buy right now</legend>
        </div>
    </fieldset>
    <h2>Current Cart</h2>
    <%
        if (order_list == null) order_list = "";
        String temp[] = order_list.split("s");
        if (temp == null || temp.length == 0 || (temp.length == 1 && temp[0].equals(""))) {
    %>
    <script>
        alert("You haven't added any book to your cart _(:з」∠)_");
        setTimeout(location.href = "index.jsp", 5000);
    </script>
</div>
</body>
</html>
<%
        return;
    }
    double total = 0;
%>
<table class="table table-striped">
    <thead>
    <tr>
        <th>#</th>
        <th>ISBN</th>
        <th>Amount</th>
        <th>Title</th>
        <th>Total Price</th>
        <th>Sufficient</th>
    </tr>
    </thead>
    <tbody>
    <%
        for (int i = 0; i < temp.length; i++) {
            String pair[] = temp[i].split("x");
            //System.out.println("--"+temp[i]+"--");
            int bid = Integer.parseInt(pair[0]);
            int num = Integer.parseInt(pair[1]);
            //System.out.println("--"+bid+"--"+num+"--");
            Vector<String> a = myapi.GetInformationFromBid(bid);
            if (a != null) {
    %>
    <tr>
        <th scope="row"><%=a.get(0)%>
        </th>
        <th><%=a.get(1)%>
        </th>
        <th><%=num%>
        <th><%=a.get(2)%>
        </th>
        <th><%=Double.parseDouble(a.get(3)) * num%>
        </th>
        <%
            total += Double.parseDouble(a.get(3)) * num;
            Boolean tmp = myapi.QuesSufficient(bid, num);
            String suff;
            if (tmp == null || !tmp) suff = "No";
            else suff = "Yes";
        %>
        <th><%=suff%>
        </th>
    </tr>
    <%
            }
        }
    %>
    </tbody>
</table>
<%
    String promo = request.getParameter("mp_promo");
    if (promo != null && !promo.equals("")) {
        Vector<String> a = myapi.QuesPromo(promo);
        if (a != null) {
            total = total * (100 - Integer.parseInt(a.get(1))) / 100.0;

%>
<h2>Discount of <%=a.get(1)%>%</h2>

<h2><%=a.get(0)%>
</h2>
<%
        }
    }
%>
<h3>Total Price : <%=total%>
</h3>

<form action="buy.jsp" method="post">

    <div class="control-group" style="padding-top:10px">
        <!-- Button -->
        <div class="controls">
            <button id="submit2" type="submit" class="btn btn-success">Pay at once</button>
        </div>
    </div>
</form>

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
