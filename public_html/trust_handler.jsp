<%--
  Created by IntelliJ IDEA.
  User: zxybazh
  Date: 6/28/15
  Time: 1:40 PM
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
    alert("Please log in first >_<");
    setTimeout(location.href = "index.jsp", 5000);
</script>
</body>
</html>
<%
        return;
    }

    String tr_username = request.getParameter("tr_username");
    String tr_userid = request.getParameter("tr_userid");
    String trway = request.getParameter("trway");

    boolean flag = false;
    Integer tr_cid;
    if (tr_username != null && (trway.equals("trust") || trway.equals("untrust"))) {
        tr_cid = myapi.GetCidByUsername(tr_username);
        if (tr_cid != null) {
            Boolean tmp = myapi.TrustOrUntrustSomeone(cid, tr_cid, trway.equals("trust"));
            if (tmp != null && tmp == false) {
%>
<script>
    alert("You have trust or untrusted him(her) >_<");
    setTimeout(location.href = "trust.jsp", 5000);
</script>
</body>
</html>
<%
        return;
    } else if (tmp != null) flag = true;
} else {
%>
<script>
    alert("Username doesn\'t exists >_<");
    setTimeout(location.href = "trust.jsp", 5000);
</script>
</body>
</html>
<%
            return;
        }
    }

    if (!flag && tr_userid != null && (trway.equals("trust") || trway.equals("untrust"))) {
        try {
            tr_cid = Integer.parseInt(tr_userid);
        } catch (Exception e) {
            tr_cid = null;
            e.printStackTrace();
        }
        if (tr_cid != null && myapi.checkCid(tr_cid)) {
            Boolean tmp = myapi.TrustOrUntrustSomeone(cid, tr_cid, trway.equals("trust"));
            if (tmp != null && tmp == false) {
%>
<script>
    alert("You have trust or untrusted him(her) >_<");
    setTimeout(location.href = "trust.jsp", 5000);
</script>
</body>
</html>
<%
        return;
    } else if (tmp != null) flag = true;
} else {
%>
<script>
    alert("User ID doesn\'t exists >_<");
    setTimeout(location.href = "trust.jsp", 5000);
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
    alert("0w0 Trust or untrust Successfully");
    setTimeout(location.href = "trust.jsp", 5000);
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
