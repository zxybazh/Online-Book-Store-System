<%--
  Created by IntelliJ IDEA.
  User: zxybazh
  Date: 6/27/15
  Time: 4:47 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" import="workspace.*" %>
<%@ page import="javax.servlet.http.Cookie" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.sun.org.apache.xpath.internal.operations.Bool" %>

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
<div class="container">
    <fieldset>
        <div id="legend">
            <legend class="">Add New Book</legend>
        </div>
        <%
            String title = request.getParameter("ab_title");
            String subject = request.getParameter("ab_subject");
            String key_words = request.getParameter("ab_key_words");
            String isbn = request.getParameter("ab_isbn");
            String cover_format = request.getParameter("ab_cover_format");
            String price = request.getParameter("ab_price");
            String copy_number = request.getParameter("ab_copy_number");
            String author = request.getParameter("ab_author");
            String publisher = request.getParameter("ab_publisher");
            String publish_year = request.getParameter("ab_publish_year");

            Boolean flag = null;

            while (!(title == null || subject == null || key_words == null || isbn == null || cover_format == null
                    || price == null || copy_number == null || author == null || publish_year == null || publisher == null)) {
                flag = false;
                Double pr = null;
                try {
                    pr = Double.parseDouble(price);
                } catch (Exception e) {
                    pr = null;
                    e.printStackTrace();
                    break;
                }
                Integer cn = null;
                try {
                    cn = Integer.parseInt(copy_number);
                } catch (Exception e) {
                    cn = null;
                    e.printStackTrace();
                    break;
                }

                Integer bid = null;
                if (pr != null && cn != null)
                    try {
                        bid = myapi.AddNewBook(title, subject, key_words, isbn, pr, cn, cover_format);
                    } catch (Exception e) {
                        e.printStackTrace();
                        break;
                    }
                if (bid == null) break;

                Integer pid = myapi.GetPidByPname(publisher);
                if (pid == null) break;

                Integer year = null;
                try {
                    year = Integer.parseInt(publish_year);
                } catch (Exception e) {
                    e.printStackTrace();
                    year = null;
                    break;
                }
                if (year == null) break;
                Boolean done = myapi.PublishRegister(pid, bid, year);
                if (done == null || done == false) break;

                String authors[] = author.split(";");
                Vector<Integer> aid = new Vector<>();

                boolean stop = false;
                for (int i = 0; i < authors.length; i++) {
                    aid.add(myapi.GetAidByAname(authors[i]));
                    if (aid.get(i) == null) {
                        stop = true;
                        break;
                    }
                    Boolean tmp = myapi.WriteRegister(aid.get(i), bid);
                    if (tmp == null || tmp == false) {
                        stop = true;
                        break;
                    }
                }
                if (stop) break;

                for (int i = 0; i < authors.length; i++) {
                    for (int j = 0; j < i; j++) {
                        Boolean tmp = myapi.Coauthor(bid, aid.get(i), aid.get(j));

                        if (!tmp) {
                            stop = true;
                            break;
                        }
                    }
                    if (stop) break;
                }
                if (stop) break;
                flag = true;
                break;
            }
            if (flag != null && flag == false) {
        %>
        <script>
            alert("Add new book error >_<");
        </script>
        <%
        } else {
            if (flag != null) {
        %>
        <script>
            alert("0w0 Successfully Added new book!");
        </script>
        <%
                }
                title = "";
                subject = "";
                key_words = "";
                price = "";
                isbn = "";
                cover_format = "";
                copy_number = "";
                author = "";
                publish_year = "";
                publisher = "";
            }
        %>
        <form action="addbook.jsp" method="post" onsubmit="return forward()">
            <div class="control-group">
                <!-- Title -->
                <label class="control-label" for="title">Title</label>

                <div class="form-control-static">
                    <input type="text" id="title" name="ab_title" placeholder="" class="form-control"
                           maxlength="100" value="<%=title%>">

                    <p class="help-block">Title contains no more than 100 characters</p>
                </div>
            </div>

            <div class="control-group">
                <!-- Subject -->
                <label class="control-label" for="subject">Subject</label>

                <div class="form-control-static">
                    <input type="text" id="subject" name="ab_subject" placeholder="" class="form-control"
                           maxlength="100" value="<%=subject%>">

                    <p class="help-block">Subject contains no more than 100 characters, split with ";"</p>
                </div>
            </div>

            <div class="control-group">
                <!-- key Words -->
                <label class="control-label" for="key_words">Key Words</label>

                <div class="form-control-static">
                    <input type="text" id="key_words" name="ab_key_words" placeholder="" class="form-control"
                           maxlength="100" value="<%=key_words%>">

                    <p class="help-block">Key words contain no more than 100 characters</p>
                </div>
            </div>

            <div class="control-group">
                <!-- ISBN-->
                <label class="control-label" for="isbn">ISBN</label>

                <div class="form-inline">
                    <input type="text" id="isbn" name="ab_isbn" placeholder="" class="form-control"
                           maxlength="10" value="<%=isbn%>">

                    <p class="help-block">ISBN should be 10 bit and valid</p>
                </div>
            </div>

            <div class="control-group">
                <!-- Cover Format -->
                <label class="control-label" for="cover_format">Cover Format</label>

                <div class="form-inline">
                    <select class="form-control" id="cover_format" name="ab_cover_format">
                        <option value="soft"
                                <%
                                    if (cover_format != null && cover_format.equals("soft"))
                                        out.print(" class=\"active\"");
                                %>
                                >Soft
                        </option>
                        <option value="hard"
                                <%
                                    if (cover_format != null && cover_format.equals("hard"))
                                        out.print("class=\"active\"");
                                %>
                                >Hard
                        </option>
                        <option value="unknown"
                                <%
                                    if (cover_format != null && cover_format.equals("unknown"))
                                        out.print("class=\"active\"");
                                %>
                                >Unknown
                        </option>
                    </select>

                    <p class="help-block">Select the cover format of the book</p>
                </div>
            </div>

            <div class="control-group">
                <!-- Price -->
                <label class="control-label" for="price">Price</label>

                <div class="form-inline">
                    <input type="text" id="price" name="ab_price" placeholder="" class="form-control"
                           value="<%=price%>">

                    <p class="help-block">Price should be a float lager than 0</p>
                </div>
            </div>

            <div class="control-group">
                <!-- Copy Number -->
                <label class="control-label" for="copy_number">Copy Number</label>

                <div class="form-inline">
                    <input type="number" id="copy_number" name="ab_copy_number" placeholder=""
                           class="form-control" min="1" value="<%=copy_number%>">

                    <p class="help-block">Copy number should be larger than 0</p>
                </div>
            </div>

            <div class="control-group">
                <!-- Auhtor(s) -->
                <label class="control-label" for="author">Author(s)</label>

                <div class="form-control-static">
                    <input type="text" id="author" name="ab_author" placeholder="" class="form-control"
                           value="<%=author%>">

                    <p class="help-block">Each name should be no more than 40 characters, separated by ";"</p>
                </div>
            </div>

            <div class="control-group">
                <!-- Publisher -->
                <label class="control-label" for="publisher">Publisher</label>

                <div class="form-control-static">
                    <input type="text" id="publisher" name="ab_publisher" placeholder="" class="form-control"
                           maxlength="40" value="<%=publisher%>">

                    <p class="help-block">Publisher should be less or equal to 40 characters</p>
                </div>
            </div>

            <div class="control-group">
                <!-- Publish Year -->
                <label class="control-label" for="publish_year">Publish Year</label>

                <div class="form-inline">
                    <input type="number" id="publish_year" name="ab_publish_year" placeholder=""
                           class="form-control" min="1000" , max="2015" value="<%=publish_year%>">

                    <p class="help-block">Publish year should be between 1000 and 2015</p>
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
                    var title = $('#title').val();
                    var subject = $('#subject').val();
                    var key_words = $('#key_words').val();
                    var publisher = $('#publisher').val();
                    var cp = $('#copy_number').val();
                    var py = $('#publish_year').val();

                    var isbn = $('#isbn').val();
                    var price = $('#price').val();
                    var author = $('#author').val().split(";");

                    var flag = false;
                    for (var i = 0; i < author.length; i++) {
                        if (author[i].length > 40 || author[i].length == 0) {
                            flag = true;
                            break;
                        }
                    }
                    if (py.length == 0) {
                        alert("publish year can't be empty >_<");
                    } else if (cp.length == 0) {
                        alert("Copy number can't be empty >_<");
                    } else if (publisher.length == 0) {
                        alert("Publisher can't be empty >_<");
                    } else if (title.length == 0) {
                        alert("Title can't be empty >_<");
                    } else if (subject.length == 0) {
                        alert("Subject can't be empty >_<");
                    } else if (key_words.length == 0) {
                        alert("Key words can't be empty >_<");
                    } else if (flag) {
                        alert("Author(s) format error >_<");
                    } else if (isbn.length != 10) {
                        alert("Book ISBN length illegal");
                    } else if (!(new RegExp("^[Xx0-9]+$").test(isbn)) || !(new RegExp("^[0-9]+$").test(isbn.substr(0, 9))) || !(new RegExp("^[Xx0-9]+$").test(isbn.substr(9, 1)))) {
                        alert("Book ISBN contains illegal characters or format illegal");
                    } else if (!(new RegExp("^[-]?([0-9]*\.?[0-9]+|[0-9]+\.?[0-9]*)?$").test(price))) {
                        alert("Price format error");
                    } else return true;
                    return false;
                }
            </script>
        </form>
    </fieldset>

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
