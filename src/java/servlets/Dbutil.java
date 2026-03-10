package servlets;

import java.sql.Connection;
import java.sql.DriverManager;

public class Dbutil {

    private static final String URL ="jdbc:mysql://localhost:3306/cosmetic_store";

    private static final String USER = "root";
    private static final String PASSWORD = "root75";

    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
