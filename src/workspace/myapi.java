package workspace;

import java.sql.ResultSet;
import java.util.Vector;

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

    public static Boolean CheckBid(int bid) throws Exception {
        myconnector con = new myconnector();

        Boolean ans = mybook.valid(con.stmt, bid);

        con.closeConnection();
        return ans;
    }

    public static Integer GetBidByISBN(String isbn) throws Exception {
        myconnector con = new myconnector();

        Integer ans = mybook.isbn_bid(con.stmt, isbn);

        con.closeConnection();
        return ans;
    }

    public static void ChangeAuthority(int cid, boolean admin) throws Exception {
        myconnector con = new myconnector();

        String sql = "update customer set admin = " + (admin ? "true" : "false") + " where cid = " + Integer.toString(cid) + ";";
        runsql(con, sql);

        con.closeConnection();
    }

    public static Vector<Vector<String>> UserAwardsForHelpfulness(int m) throws Exception {

        if (m < 1) m = 10;

        myconnector con = new myconnector();
        String tmp, sql;

        tmp = "(select sum(rate.score) from rate, feedback where rate.fid = feedback.fid ";
        tmp += "and feedback.cid = customer.cid)";
        sql = "select customer.cid, customer.login_name, " + tmp + " as point from customer ";
        sql += "order by point desc limit 0, " + Integer.toString(m) + ";";

        ResultSet rs = querysql(con, sql);

        Vector<Vector<String>> ans = new Vector<Vector<String>>();
        Vector<String> cid = new Vector<String>(), cname = new Vector<String>(), amount = new Vector<String>();

        if (rs != null) {
            while (rs.next()) {
                cid.add(rs.getString(1));
                cname.add(rs.getString(2));
                amount.add(rs.getString(3));
            }
        }

        if (cid.size() > 0) {
            ans.add(cid);
            ans.add(cname);
            ans.add(amount);
        }

        con.closeConnection();

        return ans;
    }

    public static Vector<Vector<String>> UserAwardsForTrust(int m) throws Exception {

        if (m < 1) m = 10;

        myconnector con = new myconnector();
        String tmp, sql;

        tmp = "((select count(*) from judge where cid2 = customer.cid and trust = true)-(";
        tmp += "select count(*) from judge where cid2 = customer.cid and trust = false))";
        sql = "select customer.cid, customer.login_name, " + tmp + " as trust from customer ";
        sql += "order by trust desc limit 0, " + Integer.toString(m) + ";";

        ResultSet rs = querysql(con, sql);

        Vector<Vector<String>> ans = new Vector<Vector<String>>();
        Vector<String> cid = new Vector<String>(), cname = new Vector<String>(), amount = new Vector<String>();

        if (rs != null) {
            while (rs.next()) {
                cid.add(rs.getString(1));
                cname.add(rs.getString(2));
                amount.add(rs.getString(3));
            }
        }

        if (cid.size() > 0) {
            ans.add(cid);
            ans.add(cname);
            ans.add(amount);
        }

        con.closeConnection();

        return ans;
    }

    public static Vector<Vector<String>> StatisticOfPublishers(int m) throws Exception {

        if (m < 1) m = 10;

        myconnector con = new myconnector();
        String tmp, sql;

        tmp = "(select sum(amount) from buy, publish ";
        tmp += "where buy.bid = publish.bid and publish.pid=publisher.pid ";
        tmp += "and to_days(now())-to_days(buy_date)<=180)";
        sql = "select pid, pname, " + tmp + " as amount from publisher order by amount desc ";
        sql += "limit 0, " + Integer.toString(m) + ";";

        ResultSet rs = querysql(con, sql);

        Vector<Vector<String>> ans = new Vector<Vector<String>>();
        Vector<String> pid = new Vector<String>(), pname = new Vector<String>(), amount = new Vector<String>();

        if (rs != null) {
            while (rs.next()) {
                pid.add(rs.getString(1));
                pname.add(rs.getString(2));
                amount.add(rs.getString(3));
            }
        }

        if (pid.size() > 0) {
            ans.add(pid);
            ans.add(pname);
            ans.add(amount);
        }

        con.closeConnection();

        return ans;
    }

    public static Vector<Vector<String>> StatisticOfAuthors(int m) throws Exception {

        if (m < 1) m = 10;

        myconnector con = new myconnector();
        String tmp, sql;

        tmp = "(select sum(amount) from buy, iwrite ";
        tmp += "where buy.bid = iwrite.bid and iwrite.aid=author.aid ";
        tmp += "and to_days(now())-to_days(buy_date)<=180)";
        sql = "select aid, aname, " + tmp + " as amount from author order by amount desc ";
        sql += "limit 0, " + Integer.toString(m) + ";";

        ResultSet rs = querysql(con, sql);

        Vector<Vector<String>> ans = new Vector<Vector<String>>();
        Vector<String> aid = new Vector<String>(), aname = new Vector<String>(), amount = new Vector<String>();

        if (rs != null) {
            while (rs.next()) {
                aid.add(rs.getString(1));
                aname.add(rs.getString(2));
                amount.add(rs.getString(3));
            }
        }

        if (aid.size() > 0) {
            ans.add(aid);
            ans.add(aname);
            ans.add(amount);
        }

        con.closeConnection();

        return ans;
    }

    public static Vector<Vector<String>> StatisticOfBooks(int m) throws Exception {

        if (m < 1) m = 10;

        myconnector con = new myconnector();
        String tmp, sql;

        tmp = "(select sum(amount) from buy where buy.bid = book.bid ";
        tmp += "and to_days(now())-to_days(buy_date)<=180)";
        sql = "select bid,isbn,price,title_words," + tmp + "as amount from book order by amount desc ";
        sql += "limit 0, " + Integer.toString(m) + ";";

        ResultSet rs = querysql(con, sql);

        Vector<Vector<String>> ans = new Vector<Vector<String>>();
        Vector<String> bbid = new Vector<String>(), isbn = new Vector<String>(),
                price = new Vector<String>(), title_words = new Vector<String>(), amount = new Vector<String>();

        if (rs != null) {
            while (rs.next()) {
                bbid.add(rs.getString(1));
                isbn.add(rs.getString(2));
                price.add(rs.getString(3));
                title_words.add(rs.getString(4));
                amount.add(rs.getString(5));
            }
        }

        if (bbid.size() > 0) {
            ans.add(bbid);
            ans.add(isbn);
            ans.add(price);
            ans.add(title_words);
            ans.add(amount);
        }
        con.closeConnection();

        return ans;
    }

    public static Vector<Vector<String>> RecommendationFromBid(int cid, int bid) throws Exception {

        myconnector con = new myconnector();
        String sql = "select bid,isbn,price,title_words,(select sum(amount) from buy where ";
        sql += "buy.bid = book.bid and buy.cid in(select cid from customer where exists (";
        sql += "select cid from buy as x where x.cid = customer.cid and book.bid = x.bid) and ";
        sql += "exists (select * from buy as y where y.cid = customer.cid and y.bid = "
                + Integer.toString(bid) + "))) as amount from book where not exists ";
        sql += "(select * from buy where buy.cid = " + Integer.toString(cid);
        sql += " and buy.bid = book.bid) and exists (select * from customer where exists (";
        sql += "select * from buy as x where x.cid = customer.cid and book.bid = x.bid) and ";
        sql += "exists (select * from buy as y where y.cid = customer.cid and y.bid = "
                + Integer.toString(bid) + ")) order by amount desc;";

        ResultSet rs = querysql(con, sql);

        Vector<Vector<String>> ans = new Vector<Vector<String>>();
        Vector<String> bbid = new Vector<String>(), isbn = new Vector<String>(),
                price = new Vector<String>(), title_words = new Vector<String>(), amount = new Vector<String>();

        if (rs != null) {
            while (rs.next()) {
                bbid.add(rs.getString(1));
                isbn.add(rs.getString(2));
                price.add(rs.getString(3));
                title_words.add(rs.getString(4));
                amount.add(rs.getString(5));
            }
        }

        if (bbid.size() > 0) {
            ans.add(bbid);
            ans.add(isbn);
            ans.add(price);
            ans.add(title_words);
            ans.add(amount);
        }
        con.closeConnection();

        return ans;
    }

    public static Vector<Vector<String>> RecommendationFromPopular() throws Exception {

        myconnector con = new myconnector();
        String sql = "select bid,isbn,price,title_words, (";
        sql += "select sum(amount) from buy where buy.bid = book.bid) as amount ";
        sql += "from book order by amount desc";
        ResultSet rs = querysql(con, sql);

        Vector<Vector<String>> ans = new Vector<Vector<String>>();
        Vector<String> bid = new Vector<String>(), isbn = new Vector<String>(),
                price = new Vector<String>(), title_words = new Vector<String>(), amount = new Vector<String>();

        if (rs != null) {
            while (rs.next()) {
                bid.add(rs.getString(1));
                isbn.add(rs.getString(2));
                price.add(rs.getString(3));
                title_words.add(rs.getString(4));
                amount.add(rs.getString(5));
            }
        }

        if (bid.size() > 0) {
            ans.add(bid);
            ans.add(isbn);
            ans.add(price);
            ans.add(title_words);
            ans.add(amount);
        }
        con.closeConnection();

        return ans;
    }

    public static Vector<Vector<String>> RecommendationFromOrder(int cid) throws Exception {

        myconnector con = new myconnector();
        String sql = "select bid,isbn,price,title_words, (";
        sql += "select sum(amount) from buy where buy.bid = book.bid and buy.cid in";
        sql += "(select cid from customer where exists (";
        sql += "select * from buy as x where x.cid = customer.cid and book.bid = x.bid) and ";
        sql += "exists (select * from buy as y where y.cid = customer.cid and y.bid in (";
        sql += "select bid from buy as z where z.cid = " + Integer.toString(cid) + ")))) as amount ";
        sql += "from book where not exists ";
        sql += "(select * from buy where buy.cid = " + Integer.toString(cid);
        sql += " and buy.bid = book.bid) and exists (select * from customer where exists (";
        sql += "select * from buy as x where x.cid = customer.cid and book.bid = x.bid) and ";
        sql += "exists (select * from buy as y where y.cid = customer.cid and y.bid in (";
        sql += "select bid from buy as z where z.cid = " + Integer.toString(cid) + "))) order" +
                " by amount desc;";
        ResultSet rs = querysql(con, sql);

        Vector<Vector<String>> ans = new Vector<Vector<String>>();
        Vector<String> bid = new Vector<String>(), isbn = new Vector<String>(),
                price = new Vector<String>(), title_words = new Vector<String>(), amount = new Vector<String>();

        if (rs != null) {
            while (rs.next()) {
                bid.add(rs.getString(1));
                isbn.add(rs.getString(2));
                price.add(rs.getString(3));
                title_words.add(rs.getString(4));
                amount.add(rs.getString(5));
            }
        }

        if (bid.size() > 0) {
            ans.add(bid);
            ans.add(isbn);
            ans.add(price);
            ans.add(title_words);
            ans.add(amount);
        }
        con.closeConnection();

        return ans;
    }

    public static Integer GetCidByUsername(String cname) throws Exception {
        myconnector con = new myconnector();

        Integer ans = null;

        String sql = "select cid from customer where login_name = \'" + polish(cname) + "\';";
        ResultSet rs = querysql(con, sql);

        if (rs.next()) {
            ans = rs.getInt(1);
        }

        con.closeConnection();
        return ans;
    }

    public static Boolean checkCid(int cid) throws Exception {
        myconnector con = new myconnector();

        Boolean ans = null;

        ans = mycustomer.valid(con.stmt, cid);

        con.closeConnection();
        return ans;
    }

    public static Boolean checkAdministration(String token) throws Exception {
        token = bookshop.polish(token);
        myconnector con = new myconnector();

        String sql = "select * from customer, cookie where customer.cid = cookie.cid and " +
                "cookie.token = \'" + token + "\' and customer.admin = true;";
        ResultSet rs = querysql(con, sql);
        Boolean ans;

        if (rs.next()) ans = true;
        else ans = false;

        con.closeConnection();
        return ans;
    }
    public static Long GetPhoneNumberByToken(String token) throws Exception {
        if (token == null) return null;
        token = polish(token);
        myconnector con = new myconnector();
        String sql = "select phone_number from customer, cookie where customer.cid = cookie.cid and token = \'" + token + "\';";
        ResultSet rs = querysql(con, sql);
        Long ans = null;
        if (rs.next()) ans = rs.getLong(1);
        con.closeConnection();
        return ans;
    }

    public static String GetAddressByToken(String token) throws Exception {
        if (token == null) return null;
        token = polish(token);
        myconnector con = new myconnector();
        String sql = "select address from customer, cookie where customer.cid = cookie.cid and token = \'" + token + "\';";
        ResultSet rs = querysql(con, sql);
        String ans = null;
        if (rs.next()) ans = rs.getString(1);
        con.closeConnection();
        return ans;
    }

    public static String GetFullNameByToken(String token) throws Exception {
        if (token == null) return null;
        token = polish(token);
        myconnector con = new myconnector();
        String sql = "select full_name from customer, cookie where customer.cid = cookie.cid and token = \'" + token + "\';";
        ResultSet rs = querysql(con, sql);
        String ans = null;
        if (rs.next()) ans = rs.getString(1);
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

    public static void changePhoneNumber(int cid, String phone_number) throws Exception {
        myconnector con = new myconnector();
        String sql = "update customer set phone_number = " + phone_number + " where cid = " +
                Integer.toString(cid) + ";";
        runsql(con, sql);
        con.closeConnection();
    }

    public static void changeAddress(int cid, String address) throws Exception {
        myconnector con = new myconnector();
        String sql = "update customer set address = \'" + polish(address) + "\' where cid = " +
                Integer.toString(cid) + ";";
        runsql(con, sql);
        con.closeConnection();
    }

    public static void changeFullName(int cid, String full_name) throws Exception {
        myconnector con = new myconnector();
        String sql = "update customer set full_name = \'" + polish(full_name) + "\' where cid = " +
                Integer.toString(cid) + ";";
        runsql(con, sql);
        con.closeConnection();
    }

    public static void changePassword(int cid, String password) throws Exception {
        myconnector con = new myconnector();
        String sql = "update customer set password = \'" + mymd5.getMD5(password) + "\' where cid = " +
                Integer.toString(cid) + ";";
        runsql(con, sql);
        con.closeConnection();
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

    public static Boolean username_duplicate(String username) throws Exception {
        myconnector con = new myconnector();
        username = polish(username);

        Boolean answer;
        String sql = "select * from customer where login_name = \'" + username + "\';";

        ResultSet rs = querysql(con, sql);

        if (rs.next()) {
            answer = true;
        } else answer = false;
        con.closeConnection();
        return answer;
    }

    public static Boolean register(String username, String password, String full_name, String phone_number, String address) throws Exception {
        if (username.length() < 3 || username.length() > 30) return null;
        if (password.length() < 3 || password.length() > 30) return null;
        if (full_name.length() > 30) return null;
        if (phone_number.length() != 11) return null;
        if (address.length() > 100) return null;

        username = polish(username);
        password = mymd5.getMD5(password);
        full_name = polish(full_name);
        phone_number = polish(phone_number);
        address = polish(address);

        myconnector con = new myconnector();

        String sql = "insert into customer values(null, \'" + username + "\', \'" + full_name + "\', \'" +
                password + "\', \'" + address + "\', " + phone_number + ", false);";

        runsql(con, sql);
        con.closeConnection();
        return true;
    }
}
