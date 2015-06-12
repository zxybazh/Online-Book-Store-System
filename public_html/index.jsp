<%--
    Created by IntelliJ IDEA.
    User: zxybazh
    Date: 6/12/15
    Time: 10:35 PM
    To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" import ="workspace.*"%>
<%@ page import="java.sql.*" %>

<html>
    <head>
        <title>Wexley's Book Store</title>
    </head>
    <body>
        <Bold>
            This is Wexley's Book Store, Welcome!!!
            </br>
            <%
                out.println(bookshop.polish("May th''e f''or''ce be you~")+"</br>");
                Connection con;
                Statement stmt;
                try {
                    String userName = "fudanu35";
                    String password = "onveoj1p";
                    String url = "jdbc:mysql://10.141.208.26/fudandbd35?useUnicode=true&characterEncoding=UTF-8";
                    Class.forName("com.mysql.jdbc.Driver").newInstance();
                    con = DriverManager.getConnection(url, userName, password);

                    //DriverManager.registerDriver (new oracle.jdbc.driver.OracleDriver());
                    //stmt=con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                    stmt = con.createStatement();
                    //stmt=con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                } catch(Exception e) {
                    System.err.println(">_< MySQL connection is broken!!! The error is as follows,\n");
                    e.printStackTrace();
                    throw (e);
                }

                ResultSet rs = stmt.executeQuery("select * from book");
                while (rs.next()) {
                    out.println(rs.getString(1)+" ");
                    out.println(rs.getString(2)+" ");
                    out.println(rs.getString(3)+" ");
                    out.println(rs.getString(4)+"</br>");
                }
                con.close();
			%>
        </Bold>
    </body>
</html>
