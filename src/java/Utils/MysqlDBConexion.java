package Utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class MysqlDBConexion {

    public static Connection getConnection() {
        Connection con = null;
        try {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
            } catch (ClassNotFoundException e) {
                Class.forName("com.mysql.jdbc.Driver");
            }
            
            String url = "jdbc:mysql://localhost:3306/fitgym?useSSL=false&serverTimezone=UTC&useUnicode=true&characterEncoding=UTF-8&allowPublicKeyRetrieval=true";
            con = DriverManager.getConnection(url, "root", "");
            System.out.println("Conexion exitosa a la base de datos fitgym.");
        } catch (Exception e) {
            System.out.println("Error en MysqlDBConexion: " + e.getMessage());
            e.printStackTrace();
        }
        return con;
    }
}