package workspace;

import java.sql.ResultSet;

//All your APIs belongs to me !!!
//Suck it, MVC !!!

public class myapi {
    public static ResultSet querysql(myconnector con, String sql) {
        ResultSet rs;
        try {
            rs = con.stmt.executeQuery(sql);
        } catch (Exception e) {
            alert("Error while querying " + sql);
            e.printStackTrace();
            return null;
        }
        return rs;
    }

    public static void alert(String s) {
        System.out.println(">_< " + s + "!!!");
    }

    public static void finish(String s) {
        System.out.println("0w0 " + s + "!!!");
    }

    public static String polish(String a) {
        String b = "";
        for (int i = 0; i < a.length(); i++) {
            if (a.charAt(i) == '\'' || a.charAt(i) == '\"' || a.charAt(i) == '\\') {
                b += '\\';
            }
            b += a.charAt(i);
        }
        return b;
    }

    public static boolean runsql(myconnector con, String sql) {
        try {
            con.stmt.execute(sql);
        } catch (Exception e) {
            alert("Error while executing " + sql);
            return false;
        }
        return true;
    }

    public static Boolean checkmytoken(int cid, String token) throws Exception {
        token = bookshop.polish(token);
        myconnector con = new myconnector();
        String sql = "select now()-time from cookie where " +
                "cid = " + Integer.toString(cid) + " and token = \'" + token + "\';";
        ResultSet rs = querysql(con, sql);
        Boolean ans = null;
        if (rs.next())
            if (rs.getInt(1) <= 60 * 60 * 24) {
                ans = true;
            } else {
                ans = false;
                sql = "delete from cookie where cid = " + Integer.toString(cid) + " and token = \'"
                        + token + "\';";
                runsql(con, sql);
            }
        con.closeConnection();
        return ans;
    }

    public static Integer GetCidByToken(String token) throws Exception {
        if (token == null) return null;
        token = polish(token);
        myconnector con = new myconnector();
        String sql = "select cid from cookie where token = \'" + token + "\';";
        ResultSet rs = querysql(con, sql);
        Integer ans = null;
        if (rs.next()) ans = rs.getInt(1);
        con.closeConnection();
        return ans;
    }

    public static void renew(int cid) throws Exception {
        myconnector con = new myconnector();
        String sql = "update cookie set time = now() where cid = " + Integer.toString(cid) + ";";
        runsql(con, sql);
        con.closeConnection();
    }

    public static String login(String username, String password) throws Exception {

        //alert("Now doing <<LOGIN>>" + username + "@" + password);

        String token = null;
        myconnector con = new myconnector();
        username = polish(username);
        password = mymd5.getMD5(password);
        String sql = "select now(), login_name, cid from customer where login_name = \'" + username + "\' " +
                "and password = \'" + password + "\';";
        ResultSet rs = querysql(con, sql);
        if (rs.next()) {
            String sql1 = "delete from cookie where cid = " + rs.getString(3) + ";";
            token = mymd5.getMD5(rs.getString(1) + rs.getString(2));
            String sql2 = "insert into cookie values(" + rs.getString(3) + ", \'" + token + "\',now());";
            runsql(con, sql1);
            runsql(con, sql2);
        }
        con.closeConnection();
        return token;
    }
}
