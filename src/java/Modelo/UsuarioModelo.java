package Modelo;

import Entidad.Usuario;
import Utils.MysqlDBConexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UsuarioModelo {

    public Usuario validarLogin(String user, String pass) {
        Usuario u = null;
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MysqlDBConexion.getConnection();
            String sql = "SELECT id, nombre, username, password, rol FROM usuario WHERE TRIM(username) = TRIM(?) AND TRIM(password) = TRIM(?)";
            ps = cn.prepareStatement(sql);
            ps.setString(1, user);
            ps.setString(2, pass);
            rs = ps.executeQuery();

            if (rs.next()) {
                u = new Usuario();
                u.setId(rs.getInt(1));
                u.setNombre(rs.getString(2));
                u.setUsuario(rs.getString(3));
                u.setPassword(rs.getString(4));
                u.setRol(rs.getString(5));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return u;
    }

    public List listarUsuarios() {
        List lista = new ArrayList<>();
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MysqlDBConexion.getConnection();
            String sql = "SELECT id, nombre, username, password, rol FROM usuario ORDER BY id ASC";
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt(1));
                u.setNombre(rs.getString(2));
                u.setUsuario(rs.getString(3));
                u.setPassword(rs.getString(4));
                u.setRol(rs.getString(5));
                lista.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return lista;
    }

    public boolean registrarUsuario(Usuario u) {
        Connection cn = null;
        PreparedStatement ps = null;
        boolean ok = false;

        try {
            cn = MysqlDBConexion.getConnection();
            String sql = "INSERT INTO usuario (nombre, username, password, rol) VALUES (?, ?, ?, ?)";
            ps = cn.prepareStatement(sql);
            ps.setString(1, u.getNombre());
            ps.setString(2, u.getUsuario());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getRol());
            ok = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return ok;
    }

    public boolean actualizarDatosUsuario(int id, String nombre, String usuario, String rol) {
        Connection cn = null;
        PreparedStatement ps = null;
        boolean ok = false;

        try {
            cn = MysqlDBConexion.getConnection();
            String sql = "UPDATE usuario SET nombre = ?, username = ?, rol = ? WHERE id = ?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, nombre);
            ps.setString(2, usuario);
            ps.setString(3, rol);
            ps.setInt(4, id);
            ok = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return ok;
    }

    public boolean actualizarPassword(int id, String newPass) {
        Connection cn = null;
        PreparedStatement ps = null;
        boolean ok = false;

        try {
            cn = MysqlDBConexion.getConnection();
            String sql = "UPDATE usuario SET password = ? WHERE id = ?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, newPass);
            ps.setInt(2, id);
            ok = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return ok;
    }
}