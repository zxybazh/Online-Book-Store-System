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

    public static Vector<String> QuesPromo(String promo) throws Exception {
        myconnector con = new myconnector();
        Vector<String> ans = new Vector();

        String sql = "select message, discount from promo where promo_code = \'" + polish(promo) + "\' and chance > 0;";
        ResultSet rs = querysql(con, sql);
        if (rs.next()) {
            ans.add(rs.getString(1));
            ans.add(rs.getString(2));
            sql = "update promo set chance = chance -1 where promo_code = \'" + polish(promo) + "\';";
            runsql(con, sql);
        } else ans = null;

        con.closeConnection();
        return ans;
    }

    public static void Addcopy(int bid, int num) throws Exception {
        myconnector con = new myconnector();

        String sql = "update book set number_of_copies = number_of_copies + " + Integer.toString(num) + " " +
                "where bid = " + Integer.toString(bid) + ";";
        runsql(con, sql);

        con.closeConnection();
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

    public static Boolean QuesSufficient(int bid, int num) throws Exception {
        myconnector con = new myconnector();

        Boolean ans = null;

        String sql = "select number_of_copies from book where bid = " + Integer.toString(bid) + ";";
        ResultSet rs = querysql(con, sql);

        if (rs.next()) {
            ans = (num <= rs.getInt(1));
        }

        con.closeConnection();

        return ans;
    }

    public static String Rate(int cid, int fid, int score) throws Exception {
        myconnector con = new myconnector();
        String ans = null;

        String sql = "select cid from feedback where fid = " + Integer.toString(fid) + ";";
        ResultSet rs = querysql(con, sql);

        if (rs.next()) {
            if (rs.getInt(1) == cid) {
                ans = "You can't rate your own feedback >_<";
            } else {
                sql = "select * from rate where fid = " + Integer.toString(fid) + " and cid =" + Integer.toString(cid) + ";";
                rs = querysql(con, sql);
                if (rs.next()) {
                    ans = "You have rated this feedback >_<";
                } else {
                    sql = "insert into rate values(" + Integer.toString(cid) + "," + Integer.toString(fid) + "," + Integer.toString(score) + ");";
                    runsql(con, sql);
                    ans = "0w0 Rate feedback successfully";
                }
            }
        } else ans = "Can't find the feedback >_<";

        con.closeConnection();
        return ans;
    }

    public static Vector<Vector<String>> GetFeedbackByBid(int bid, int num) throws Exception {
        myconnector con = new myconnector();
        Vector<Vector<String>> ans = new Vector<>();
        String sql = "select fid, login_name, fdate, score, text from feedback, customer where feedback.cid = customer.cid " +
                "and feedback.bid = " + Integer.toString(bid) + " order by (select avg(score) from rate where " +
                "rate.fid = feedback.fid) limit 0, " + Integer.toString(num) + ";";
        ResultSet rs = querysql(con, sql);

        while (rs.next()) {
            Vector<String> temp = new Vector<>();

            for (int i = 1; i <= 5; i++) temp.add(rs.getString(i));

            ans.add(temp);
        }

        con.closeConnection();
        return ans;
    }

    public static Vector<String> GetMoreInformationFromBid(int bid) throws Exception {
        myconnector con = new myconnector();

        Vector<String> ans = new Vector<String>();

        String sql = "select book.bid, isbn, title_words, subjects, key_words, price, cover_format from book" +
                " where bid =" + Integer.toString(bid) + ";";
        ResultSet rs = querysql(con, sql);

        if (!rs.next()) ans = null;
        else {
            for (int i = 1; i <= 7; i++) ans.add(rs.getString(i));
            sql = "select pname, year from publish, publisher where publish.bid = " + Integer.toString(bid) + " and publisher.pid = publish.pid;";
            rs = querysql(con, sql);
            if (!rs.next()) {
                ans.add("");
                ans.add("");
            } else {
                for (int i = 1; i <= 2; i++) ans.add(rs.getString(i));
            }
            sql = "select aname from iwrite, author where iwrite.bid = " + Integer.toString(bid) + " and iwrite.aid = author.aid;";
            rs = querysql(con, sql);
            if (!rs.next()) ans.add("");
            else {
                String author = "";
                do {
                    if (!author.equals("")) author += ";";
                    author += rs.getString(1);
                } while (rs.next());
                ans.add(author);
            }
        }

        con.closeConnection();
        return ans;
    }

    public static Vector<String> GetInformationFromBid(int bid) throws Exception {
        myconnector con = new myconnector();

        Vector<String> ans = new Vector<String>();

        String sql = "select bid, isbn, title_words, price from book where bid =" + Integer.toString(bid) + ";";
        ResultSet rs = querysql(con, sql);

        if (!rs.next()) ans = null;
        else
            for (int i = 1; i <= 4; i++) ans.add(rs.getString(i));

        con.closeConnection();
        return ans;
    }

    public static Boolean TrustOrUntrustSomeone(int cid1, int cid2, boolean trust) throws Exception {
        myconnector con = new myconnector();
        Boolean ans = null;

        String sql = "select * from judge where cid1 = " + Integer.toString(cid1) +
                " and cid2 = " + Integer.toString(cid2) + ";";

        ResultSet rs = querysql(con, sql);

        if (rs.next()) ans = false;
        else {
            sql = "insert into judge values(" + Integer.toString(cid1) + ", " + Integer.toString(cid2);
            sql += ", " + (trust ? "True" : "False") + ");";
            runsql(con, sql);
            ans = true;
        }

        con.closeConnection();
        return ans;
    }

    public static Integer DistanceOfAuthors(int aid1, int aid2) throws Exception {
        if (aid1 == aid2) return 0;

        myconnector con = new myconnector();
        Integer ans = null;

        if (aid1 > aid2) {
            int temp = aid1;
            aid1 = aid2;
            aid2 = temp;
        }

        String sql = "select * from coauthor where aid1 = " + Integer.toString(aid1) + " and aid2 = " +
                Integer.toString(aid2) + "; ";
        ResultSet rs = querysql(con, sql);

        if (rs.next()) {
            ans = 1;
        } else {

            sql = "select max(aid) from author;";
            rs = querysql(con, sql);
            int n = 0;
            if (rs.next()) n = rs.getInt(1);

            for (int i = 1; i <= n; i++) {
                if (i != aid1 && i != aid2) {
                    sql = "select * from coauthor x, coauthor y where x.aid1 = " +
                            Integer.toString(Math.min(aid1, i)) + " and x.aid2 = " +
                            Integer.toString(Math.max(aid1, i)) + " and y.aid1 = " +
                            Integer.toString(Math.min(aid2, i)) + " and y.aid2 = " +
                            Integer.toString(Math.max(aid2, i)) + ";";
                    rs = querysql(con, sql);
                    if (rs.next()) {
                        ans = 2;
                        break;
                    }
                }
            }
        }
        if (ans == null) ans = 3;
        con.closeConnection();
        return ans;
    }

    public static Integer GetAidByAname_NonCreate(String aname) throws Exception {
        myconnector con = new myconnector();

        Integer ans = mywriter.aname_aid(con.stmt, aname);
        if (ans != null && ans < 1) ans = null;

        con.closeConnection();
        return ans;
    }

    public static Integer GetPidByPname(String pname) throws Exception {
        //If not exist then it will creat one
        myconnector con = new myconnector();

        Integer ans = mypublish.get_pid(con.stmt, pname);
        if (ans != null && ans < 1) ans = null;

        con.closeConnection();
        return ans;
    }

    public static Boolean Coauthor(int bid, int aid1, int aid2) throws Exception {
        myconnector con = new myconnector();

        Boolean tmp = mywriter.coauthor(con.stmt, bid, aid1, aid2);

        con.closeConnection();
        return tmp;
    }

    public static Integer GetAidByAname(String aname) throws Exception {
        //If not exist then it will creat one
        myconnector con = new myconnector();

        Integer ans = mywriter.fetch_aid(con.stmt, aname);
        if (ans != null && ans < 1) ans = null;

        con.closeConnection();
        return ans;
    }

    public static Boolean WriteRegister(int aid, int bid) throws Exception {
        myconnector con = new myconnector();

        Boolean tmp = mywriter.iwrite(con.stmt, aid, bid);

        con.closeConnection();
        return tmp;
    }

    public static Boolean PublishRegister(int pid, int bid, int year) throws Exception {
        myconnector con = new myconnector();

        Boolean tmp = mypublish.publish(con.stmt, pid, bid, year);

        con.closeConnection();
        return tmp;
    }

    public static Integer AddNewBook(String title, String subjects, String key_words, String isbn,
                                     double price, int copy_number, String cover_format) throws Exception {
        Integer ans = null;
        myconnector con = new myconnector();

        Integer temp = myapi.GetBidByISBN(isbn);
        if (temp == null) {
            String sql = "insert into book values(null, \'" + isbn + "\', ";
            if (cover_format.equals("unknown")) sql += "null";
            else if (cover_format.equals("soft")) sql += "true";
            else if (cover_format.equals("hard")) sql += "false";

            sql += ", \'" + polish(key_words) + "\', \'" + polish(title) + "\', \'" + polish(subjects);
            sql += "\', " + Double.toString(price);
            sql += ", " + Integer.toString(copy_number) + ");";

            runsql(con, sql);

            ans = myapi.GetBidByISBN(isbn);
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
        if (ans < 1) ans = null;

        con.closeConnection();
        return ans;
    }

    public static Vector<Integer> AdvancedSearch(Vector<String> way, Vector<String> option, Vector<String> limit,
                                                 String sort_way) throws Exception {
        myconnector con = new myconnector();

        Vector<Integer> ans = new Vector<>();
        int n = limit.size();

        String sql = "select distinct book.bid from book, publish, publisher, iwrite, author where (1=1) ";
        for (int i = 0; i < n; i++) {
            String temp = sql;
            sql = "";
            if (way.get(i).equals("OR")) sql += "or ";
            else sql += "and ";
            if (option.get(i).equals("title")) {
                sql += "title_words like \'%" + polish(limit.get(i)) + "%\' ";
            } else if (option.get(i).equals("subject")) {
                sql += "subjects like \'%" + polish(limit.get(i)) + "%\' ";
            } else if (option.get(i).equals("keyword")) {
                sql += "key_words like \'%" + polish(limit.get(i)) + "%\' ";
            } else if (option.get(i).equals("isbn")) {
                sql += "isbn like \'%" + polish(limit.get(i)) + "%\' ";
            } else if (option.get(i).equals("price_sup")) {
                double x;
                try {
                    x = Double.parseDouble(limit.get(i));
                } catch (Exception e) {
                    e.printStackTrace();
                    sql = temp;
                    continue;
                }
                sql += "price <= " + Double.toString(x) + " ";
            } else if (option.get(i).equals("price_inf")) {
                double x;
                try {
                    x = Double.parseDouble(limit.get(i));
                } catch (Exception e) {
                    e.printStackTrace();
                    sql = temp;
                    continue;
                }
                sql += "price >= " + Double.toString(x) + " ";
            } else if (option.get(i).equals("cover_format")) {
                if (limit.get(i).toLowerCase().equals("hard")) {
                    sql += "cover_format = true ";
                } else if (limit.get(i).toLowerCase().equals("soft")) {
                    sql += "cover_format = false ";
                } else {
                    sql = temp;
                    continue;
                }
            } else if (option.get(i).equals("writer")) {
                sql += "(iwrite.bid = book.bid and iwrite.aid = author.aid and author.aname like \'%" + polish(limit.get(i)) + "%\') ";
            } else if (option.get(i).equals("publisher")) {
                sql += "(publish.bid = book.bid and publish.pid = publisher.pid and publisher.pname like \'%" + polish(limit.get(i)) + "%\') ";
            } else if (option.get(i).equals("publish_year")) {
                int x;
                try {
                    x = Integer.parseInt(limit.get(i));
                } catch (Exception e) {
                    e.printStackTrace();
                    sql = temp;
                    continue;
                }
                sql += "(publish.bid = book.bid and publish.pid = publisher.pid and publish.year =" + Integer.toString(x) + ") ";
            } else {
                sql = temp;
                continue;
            }
            temp += sql;
            sql = temp;
        }

        if (sort_way.equals("year")) {
            sql += "order by (select year from publish where publish.bid = book.bid)";
        } else if (sort_way.equals("avgfb")) {
            sql += "order by (select avg(score) from feedback where feedback.bid = book.bid)";
        } else if (sort_way.equals("avgtfb")) {
            sql += "order by (select avg(score) from feedback where feedback.bid = book.bid " +
                    "and feedback.cid in (select cid from customer where (select count(*) from judge where " +
                    "cid2 = cid and trust = true)>=(select count(*) from judge where cid2 = cid and trust = false)))";
        }
        sql += ";";

        ResultSet rs = querysql(con, sql);

        while (rs.next()) ans.add(rs.getInt(1));

        con.closeConnection();
        return ans;
    }

    public static Vector<Integer> SimpleSearch(String s) throws Exception {
        myconnector con = new myconnector();

        Vector<Integer> ans = new Vector<>();
        s = polish(s);

        String sql = "select distinct book.bid from book, publish, publisher, iwrite, author " +
                "where title_words like \'%" + s + "%\' or subjects like \'%" + s + "%\' " +
                "or key_words like \'%" + s + "%\' or (publisher.pid = publish.pid and " +
                "publish.bid = book.bid and publisher.pname like \'%" + s + "%\') or " +
                "(iwrite.aid = author.aid and iwrite.bid = book.bid and author.aname " +
                "like \'%" + s + "%\');";
        ResultSet rs = querysql(con, sql);

        while (rs.next()) ans.add(rs.getInt(1));

        con.closeConnection();
        return ans;
    }

    public static void Purchase(int cid, int bid, int amount) throws Exception {
        myconnector con = new myconnector();

        String sql = "insert into buy values(null, " + Integer.toString(bid) + ", " +
                Integer.toString(cid) + ", " + Integer.toString(amount) + ", now());";

        runsql(con, sql);

        con.closeConnection();
    }

    public static void Feedback(int cid, int bid, int score, String comment) throws Exception {
        myconnector con = new myconnector();

        String sql = "insert into feedback values(null, " + Integer.toString(bid) + ", " + Integer.toString(cid);
        sql += ", now(), " + Integer.toString(score) + ", \'" + polish(comment) + "\');";

        runsql(con, sql);

        con.closeConnection();
    }

    public static Boolean CheckFeedbackBid(int cid, int bid) throws Exception {
        myconnector con = new myconnector();

        Boolean ans = null;

        String sql = "select * from buy where cid = " + Integer.toString(cid) + " and bid = " + Integer.toString(bid) + ";";
        ResultSet rs = querysql(con, sql);

        if (rs.next()) {
            sql = "select * from feedback where cid = " + Integer.toString(cid) + " and bid = " + Integer.toString(bid) + ";";
            rs = querysql(con, sql);
            if (rs.next()) ans = false;
            else ans = true;
        }

        con.closeConnection();

        return ans;
    }

    public static void ChangeAuthority(int cid, boolean admin) throws Exception {
        myconnector con = new myconnector();

        String sql = "update customer set admin = " + (admin ? "true" : "false") + " where cid = " + Integer.toString(cid) + ";";
        runsql(con, sql);

        con.closeConnection();
    }

    public static Vector<Vector<String>> GetOrderList(int cid) throws Exception {

        myconnector con = new myconnector();
        String sql;
        sql = "select buy.oid, buy.buy_date, buy.amount, buy.bid, book.title_words, (select count(*) " +
                "from feedback where feedback.cid = buy.cid and feedback.bid = buy.bid) from buy, book " +
                "where cid = " + Integer.toString(cid) + " and buy.bid = book.bid;";

        ResultSet rs = querysql(con, sql);

        Vector<Vector<String>> ans = new Vector<Vector<String>>();
        Vector<String> oid = new Vector<String>(), buy_date = new Vector<String>(), amount = new Vector<String>(),
                bid = new Vector<String>(), title = new Vector<String>(), fb = new Vector<String>();

        if (rs != null) {
            while (rs.next()) {
                oid.add(rs.getString(1));
                buy_date.add(rs.getString(2));
                amount.add(rs.getString(3));
                bid.add(rs.getString(4));
                title.add(rs.getString(5));
                fb.add(rs.getString(6));
            }
        }

        if (oid.size() > 0) {
            ans.add(oid);
            ans.add(buy_date);
            ans.add(amount);
            ans.add(bid);
            ans.add(title);
            ans.add(fb);
        }

        con.closeConnection();

        return ans;
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
        sql += " and buy.bid = book.bid) and (exists (select * from customer where exists (";
        sql += "select * from buy as x where x.cid = customer.cid and book.bid = x.bid) and ";
        sql += "exists (select * from buy as y where y.cid = customer.cid and y.bid = "
                + Integer.toString(bid) + "))or book.bid = " + Integer.toString(bid) + ") order by amount desc;";

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
