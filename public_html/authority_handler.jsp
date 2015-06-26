<%--
  Created by IntelliJ IDEA.
  User: zxybazh
  Date: 6/26/15
  Time: 7:52 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" import="workspace.*" %>
<%@ page import="javax.servlet.http.Cookie" %>

<html>
<head>
    <title></title>
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

    String ca_username = request.getParameter("ca_username");
    String ca_userid = request.getParameter("ca_userid");
    String caway = request.getParameter("caway");

    boolean flag = false;
    Integer ca_cid;
    if (ca_username != null && (caway.equals("manager") || caway.equals("customer"))) {
        ca_cid = myapi.GetCidByUsername(ca_username);
        if (ca_cid != null) {
            myapi.ChangeAuthority(ca_cid, caway.equals("manager"));
            flag = true;
        } else {
%>
<script>
    alert("Username doesn\'t exists >_<");
    setTimeout(location.href = "authority.jsp", 5000);
</script>
</body>
</html>
<%
            return;
        }
    }

    if (!flag && ca_userid != null && (caway.equals("manager") || caway.equals("customer"))) {
        try {
            ca_cid = Integer.parseInt(ca_userid);
        } catch (Exception e) {
            ca_cid = null;
            e.printStackTrace();
        }
        if (ca_cid != null && myapi.checkCid(ca_cid)) {
            myapi.ChangeAuthority(ca_cid, caway.equals("manager"));
            flag = true;
        } else {
%>
<script>
    alert("User ID doesn\'t exists >_<");
    setTimeout(location.href = "authority.jsp", 5000);
</script>
</body>
</html>
<%
            return;
        }
    }

    if (flag) {
%>
<script>
    alert("0w0 Authority changed Successfully");
    setTimeout(location.href = "authority.jsp", 5000);
</script>
</body>
</html>
<%
        return;
    }

%>
<script>
    setTimeout(location.href = "index.jsp", 5000);
</script>

</body>
</html>
