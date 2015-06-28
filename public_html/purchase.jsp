<%--
  Created by IntelliJ IDEA.
  User: zxybazh
  Date: 6/28/15
  Time: 2:10 PM
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
            <legend class="">Make Purchase</legend>
        </div>
    </fieldset>
    <%

        if (order_list == null) order_list = "";
        String bookid = request.getParameter("mp_bookid");
        if (bookid != null && bookid.length() == 0) bookid = null;
        String isbn = request.getParameter("mp_isbn");
        if (isbn != null && isbn.length() == 0) isbn = null;
        String number = request.getParameter("mp_number");
        if (number != null && number.length() == 0) number = null;

        Boolean flag = null;
        boolean stop = false;
        while ((bookid != null || isbn != null) && number != null && !stop) {
            stop = true;
            flag = false;
            Integer bid = null, num = null;
            try {
                num = Integer.parseInt(number);
            } catch (Exception e) {
                num = null;
                e.printStackTrace();
                break;
            }

            if (bookid != null) {
                try {
                    bid = Integer.parseInt(bookid);
                } catch (Exception e) {
                    bid = null;
                    e.printStackTrace();
                    break;
                }

            } else {
                bid = myapi.GetBidByISBN(isbn);
                if (bid == null) break;
            }
            Boolean temp = myapi.CheckBid(bid);
            if (temp == null || temp == false) {
                bid = null;
                break;
            }

            if (!order_list.equals("")) order_list += "s";
            order_list += (bid.toString()) + "x" + (number.toString());

            Cookie c = new Cookie("orderlist", order_list);
            c.setMaxAge(24 * 60 * 60);
            response.addCookie(c);

            flag = true;
        }

        if (flag != null) {
            if (flag) {
    %>
    <script>
        alert("0w0 Add to cart successfully");
    </script>
    <%
    } else {
    %>
    <script>
        alert("Add to Cart failed >_<");
    </script>
    <%
            }
        }
    %>
    <form action="purchase.jsp" method="post" onsubmit="return forward()">
        <div class="control-group">
            <label class="control-label" for="bookid">Book ID here</label>

            <div class="form-inline">
                <input type="number" id="bookid" name="mp_bookid" placeholder="" class="form-control" value="" min="1">
            </div>
            <p class="help-block">ID of the book that you want to add(optional)</p>
        </div>
        <div class="control-group">
            <label class="control-label" for="isbn">ISBN here</label>

            <div class="form-inline">
                <input type="text" id="isbn" name="mp_isbn" placeholder="" class="form-control" value="" maxlength="10">
            </div>
            <p class="help-block">ISBN of the book that you want to add(optional)</p>
        </div>
        <div class="control-group">
            <label class="control-label" for="number">Amount here</label>

            <div class="form-inline">
                <input type="number" id="number" name="mp_number" placeholder="" class="form-control" value="" min="1">
            </div>
            <p class="help-block">Amount of the book that you want to add</p>
        </div>


        <div class="control-group" style="padding-top:10px">
            <!-- Button -->
            <div class="controls">
                <button id="submit1" type="submit" class="btn btn-success">Add</button>
            </div>
        </div>
    </form>
    <script>
        function forward() {
            var bi = $('#bookid').val();
            var isbn = $('#isbn').val();
            var num = $('#number').val();
            if (num == "") {
                alert("Number can't be empty");
            } else if (bi == "" && isbn == "") {
                alert("Book ID and isbn can't both be empty >_<");
            } else if (bi == "") {
                if (isbn.length != 10) {
                    alert("Book ISBN length illegal");
                } else if (!(new RegExp("^[Xx0-9]+$").test(isbn)) || !(new RegExp("^[0-9]+$").test(isbn.substr(0, 9))) || !(new RegExp("^[Xx0-9]+$").test(isbn.substr(9, 1)))) {
                    alert("Book ISBN contains illegal characters or format illegal");
                } else return true;
            } else return true;
            return false;
        }
    </script>
    <h2>Current Cart</h2>

    <div class="control-group" style="padding-top:10px" onclick="return clearorder()">
        <!-- Button -->
        <div class="controls">
            <button id="submit3" type="submit" class="btn btn-warning">Clear Cart</button>
        </div>
    </div>
    <script>
        function setCookie(cname, cvalue, exdays) {
            var d = new Date();
            d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
            var expires = "expires=" + d.toUTCString();
            document.cookie = cname + "=" + cvalue + "; " + expires;
        }
        function clearorder() {
            setCookie("orderlist", "", -1);
            location.href = "purchase.jsp";
        }
    </script>
    <%
        String temp[] = order_list.split("s");
        if (temp == null || temp.length == 0 || (temp.length == 1 && temp[0].equals(""))) {
    %>
    <h3>You haven't added any book to your cart _(:з」∠)_</h3>
    <%
    } else {
    %>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>#</th>
            <th>ISBN</th>
            <th>Amount</th>
            <th>Title</th>
            <th>Total Price</th>
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
        </tr>
        <%
                }

            }
        %>
        </tbody>
    </table>
    <%
        }
    %>
    <form action="purchase_handler.jsp" method="post">
        <div class="control-group">
            <label class="control-label" for="promo">Promo code here</label>

            <div class="form-inline">
                <input type="text" id="promo" name="mp_promo" placeholder="Like 'FeiFei'" class="form-control" value=""
                       maxlength="30">
            </div>
            <p class="help-block">Enter the promo code if you have one</p>
        </div>

        <div class="control-group" style="padding-top:10px">
            <!-- Button -->
            <div class="controls">
                <button id="submit2" type="submit" class="btn btn-success">Buy Now</button>
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
