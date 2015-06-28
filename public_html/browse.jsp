<%--
  Created by IntelliJ IDEA.
  User: zxybazh
  Date: 6/28/15
  Time: 7:02 PM
  To change this template use File | Settings | File Templates.
--%>


<%@ page contentType="text/html;charset=UTF-8" language="java" import="workspace.myapi" %>
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
    situation = true;
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
    String ss_keyword = request.getParameter("ss_keyword");

    String sort_way = request.getParameter("bb_sortway");
    Vector<String> way = new Vector<>();
    Vector<String> option = new Vector<>();
    Vector<String> limit = new Vector<>();
    String temp;
    int n = 0;

    for (int i = 0; ; i++) {
        temp = request.getParameter("bb_way" + Integer.toString(i));
        if (temp == null) break;
        way.add(temp);
        temp = request.getParameter("bb_option" + Integer.toString(i));
        if (temp == null) break;
        option.add(temp);
        temp = request.getParameter("bb_limit" + Integer.toString(i));
        if (temp == null) break;
        limit.add(temp);
        ++n;
    }
    String t1, t2, tt1, tt2;
    if (n > 0) {
        t2 = " class=\"active\"";
        t1 = "";
        tt2 = "active";
        tt1 = "";
    } else {
        t1 = " class=\"active\"";
        t2 = "";
        tt1 = "active";
        tt2 = "";
    }

%>

<div class="container">
    <fieldset>
        <div id="legend">
            <legend class="">Book Browse</legend>
        </div>
    </fieldset>

    <div class="tabbable"> <!-- Only required for left/right tabs -->
        <ul class="nav nav-tabs">
            <li<%=t1%>><a href="#tab1" data-toggle="tab">Simple Search</a></li>
            <li<%=t2%>><a href="#tab2" data-toggle="tab">Advanced Search</a></li>
        </ul>
        <div class="tab-content">

            <div class="tab-pane <%=tt1%>" id="tab1" style="padding-top: 22px">
                <form action="browse.jsp" method="post">
                    <div class="control-group">
                        <label class="control-label" for="ss_keyword">Input anything</label>

                        <div class="form-control-static">
                            <input type="text" id="ss_keyword" name="ss_keyword" placeholder="西方哪本书我没读过？"
                                   class="form-control" value="">
                        </div>
                    </div>

                    <div class="control-group" style="padding-top: 5px">
                        <!-- Button -->
                        <div class="controls">
                            <button id="submit1" type="submit" class="btn btn-primary">Search Now</button>
                        </div>
                    </div>
                </form>
            </div>

            <div class="tab-pane <%=tt2%>" id="tab2" style="padding-top: 22px">
                <form action="browse.jsp" method="post" id="as_form" onsubmit="return forward()">
                    <div class="control-group" id="xxx0">
                        <label class="control-label" for="limit0">More information here</label>

                        <div class="form-inline">
                            <select class="form-control" name="bb_way0">
                                <option value="AND">AND</option>
                            </select>
                            <select class="form-control" name="bb_option0">
                                <option value="title">Title contains</option>
                                <option value="subject">Subject contains</option>
                                <option value="keyword">Key words contains</option>
                                <option value="isbn">ISBN is</option>
                                <option value="price_sup">Price no more than</option>
                                <option value="price_inf">Price no less than</option>
                                <option value="cover_format">Cover format is</option>
                                <option value="writer">Writer includes</option>
                                <option value="publisher">Publisher is</option>
                                <option value="publish_year">Publish year is</option>
                            </select>
                            <input type="text" id="limit0" name="bb_limit0" class="form-control" style="width : 500px"
                                   placeholder="According to the type of your limitation">
                        </div>
                    </div>

                    <div class="control-group" style="padding-top: 22px">
                        <!-- Button -->
                        <div class="form-inline">
                            <button id="add" class="btn btn-success" style="width: 100px"
                                    onclick="return AddAttribute()">Add
                            </button>
                            <select class="form-control" name="bb_sortway">
                                <option value="year">Sort by year</option>
                                <option value="avgfb">Sort by the average numerical score of the feedbacks</option>
                                <option value="avgtfb">Sort by by the average numerical score of the trusted user
                                    feedbacks
                                </option>
                            </select>
                            <button id="submit2" type="submit" class="btn btn-primary">Search Now</button>
                        </div>
                    </div>

                </form>
                <script>
                    function AddAttribute() {

                        as_form.removeChild(as_form.lastElementChild);

                        var newInput = document.createElement("div");
                        var num = as_form.childNodes.length - 3;

                        newInput.innerHTML =
                                '<div class="control-group" id = xxx' + num + '>\n' +
                                '<label class="control-label" for="limit' + num + '">More information here</label>\n' +
                                '<div class="form-inline">\n' +
                                '<select class="form-control" name = "bb_way' + num + '">\n' +
                                '<option value="AND">AND</option>\n' +
                                '<option value="OR">OR</option>\n' +
                                '</select>\n' +
                                '<select class="form-control" name = "bb_option' + num + '">\n' +
                                '<option value="title">Title contains</option>\n' +
                                '<option value="subject">Subject contains</option>\n' +
                                '<option value="keyword">Key words contains</option>\n' +
                                '<option value="isbn">ISBN is </option>\n' +
                                '<option value="price_sup">Price no more than</option>\n' +
                                '<option value="price_inf">Price no less than</option>\n' +
                                '<option value="cover_format">Cover format is</option>\n' +
                                '<option value="writer">Writer includes</option>\n' +
                                '<option value="publisher">Publisher is</option>\n' +
                                '<option value="publish_year">Publish year is</option>\n' +
                                '</select>\n' +
                                '<input type="text" id="limit' + num + '" name="bb_limit' + num + '" class="form-control" style="width : 500px"\n' +
                                'placeholder="According to the type of your limitation">\n' +
                                '</div>\n' +
                                '</div>'


                        as_form.appendChild(newInput);

                        var button = document.createElement("div");

                        button.innerHTML =
                                '<div class="control-group" style="padding-top: 22px">\n' +
                                '<!-- Button -->\n' +
                                '<div class="form-inline">\n' +
                                '<button id="add" class="btn btn-success" style="width: 100px" onclick="return AddAttribute()">Add</button>\n' +
                                '<select class="form-control" name = "bb_sortway">\n' +
                                '<option value="year">Sort by year</option>\n' +
                                '<option value="avgfb">Sort by the average numerical score of the feedbacks</option>\n' +
                                '<option value="avgtfb">Sort by  by the average numerical score of the trusted user feedbacks</option>\n' +
                                '</select>\n' +
                                '<button id="submit2" type="submit" class="btn btn-primary">Search Now</button>\n' +
                                '</div>\n' +
                                '</div>';
                        as_form.appendChild(button);

                        return false;
                    }
                </script>
            </div>
        </div>
    </div>

    <%
        Vector<Integer> results = null;
        if (n > 0) {
            results = myapi.AdvancedSearch(way, option, limit, sort_way);
        } else if (ss_keyword != null) {
            results = myapi.SimpleSearch(ss_keyword);
        }

        if (results != null) {
            if (results.size() == 0) {
    %>
    <h3>No result available _(:з」∠)_</h3>
    <%
    } else {
    %>
    <div class="group-control">
        <table class="table table-striped">
            <thead>
            <tr>
                <th>#</th>
                <th>ISBN</th>
                <th>Title</th>
                <th>Subject</th>
                <th>Key Word</th>
                <th>Price</th>
                <th>Cover Format</th>
                <th>Publisher</th>
                <th>Publish Year</th>
                <th>Author</th>
            </tr>
            </thead>
            <tbody>
            <%
                for (int i = 0; i < results.size(); i++) {
                    Vector<String> a = myapi.GetMoreInformationFromBid(results.get(i));
                    if (a == null) continue;
            %>
            <tr>
                <th scope="row"><%=a.get(0)%>
                </th>
                <td><%=a.get(1)%>
                </td>
                <td><%=a.get(2)%>
                </td>
                <td><%=a.get(3)%>
                </td>
                <td><%=a.get(4)%>
                </td>
                <td><%=a.get(5)%>
                </td>
                <td><%=(a.get(6) == null ? "" : (a.get(6).equals("1") ? "hard" : "soft"))%>
                </td>
                <td><%=a.get(7)%>
                </td>
                <td><%=a.get(8)%>
                </td>
                <td><%=a.get(9)%>
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
