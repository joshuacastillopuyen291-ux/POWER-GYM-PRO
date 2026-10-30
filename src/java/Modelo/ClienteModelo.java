package Modelo;

import Entidad.ClienteDTO;
import Entidad.Usuario;
import Utils.MysqlDBConexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class ClienteModelo {

    public List listarEntrenadores() {
        List lista = new ArrayList<>();
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            cn = MysqlDBConexion.getConnection();
            String sql = "SELECT id, nombre, username, rol FROM usuario WHERE rol = 'ENTRENADOR' ORDER BY nombre ASC";
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setNombre(rs.getString("nombre"));
                u.setUsuario(rs.getString("username"));
                u.setRol(rs.getString("rol"));
                lista.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (cn != null) cn.close(); } catch (Exception ignored) {}
        }
        return lista;
    }

    public List listarClientes(Integer idEntrenadorFiltro) {
        List lista = new ArrayList<>();
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MysqlDBConexion.getConnection();
            String sql;
            if (idEntrenadorFiltro != null) {
                sql = "SELECT c.id, c.nombre_completo, c.dni, c.telefono, c.correo, c.id_membresia, c.fecha_vencimiento, c.estado, c.id_entrenador, "
                    + "u.nombre AS nombre_entrenador "
                    + "FROM cliente c "
                    + "LEFT JOIN usuario u ON c.id_entrenador = u.id "
                    + "WHERE c.id_entrenador = ? "
                    + "ORDER BY c.id DESC";
                ps = cn.prepareStatement(sql);
                ps.setInt(1, idEntrenadorFiltro);
            } else {
                sql = "SELECT c.id, c.nombre_completo, c.dni, c.telefono, c.correo, c.id_membresia, c.fecha_vencimiento, c.estado, c.id_entrenador, "
                    + "u.nombre AS nombre_entrenador "
                    + "FROM cliente c "
                    + "LEFT JOIN usuario u ON c.id_entrenador = u.id "
                    + "ORDER BY c.id DESC";
                ps = cn.prepareStatement(sql);
            }

            rs = ps.executeQuery();
            while (rs.next()) {
                ClienteDTO dto = new ClienteDTO();
                dto.setId(rs.getInt("id"));
                dto.setNombreCompleto(rs.getString("nombre_completo"));
                dto.setDni(rs.getString("dni"));
                dto.setTelefono(rs.getString("telefono") != null ? rs.getString("telefono") : "-");
                dto.setEmail(rs.getString("correo") != null ? rs.getString("correo") : "-");

                Timestamp ts = rs.getTimestamp("fecha_vencimiento");
                if (ts != null) {
                    dto.setFechaVencimiento(new java.sql.Date(ts.getTime()));
                } else {
                    dto.setFechaVencimiento(null);
                }

                String est = rs.getString("estado");
                dto.setEstado(est != null ? est.toUpperCase() : "INACTIVO");

                int idEnt = rs.getInt("id_entrenador");
                if (rs.wasNull()) {
                    dto.setIdEntrenador(null);
                    dto.setNombreEntrenador(null);
                } else {
                    dto.setIdEntrenador(idEnt);
                    dto.setNombreEntrenador(rs.getString("nombre_entrenador"));
                }

                lista.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (cn != null) cn.close(); } catch (Exception ignored) {}
        }
        return lista;
    }

    public boolean registrarCliente(ClienteDTO c) {
        Connection cn = null;
        PreparedStatement ps = null;
        boolean ok = false;
        try {
            cn = MysqlDBConexion.getConnection();
            String sql = "INSERT INTO cliente (nombre_completo, dni, telefono, correo, id_membresia, fecha_vencimiento, estado, id_entrenador) VALUES (?, ?, ?, ?, 1, ?, ?, ?)";
            ps = cn.prepareStatement(sql);
            ps.setString(1, c.getNombreCompleto());
            ps.setString(2, c.getDni());
            ps.setString(3, c.getTelefono());
            ps.setString(4, c.getEmail());

            if (c.getFechaVencimiento() != null) {
                ps.setTimestamp(5, new Timestamp(c.getFechaVencimiento().getTime()));
            } else {
                ps.setNull(5, Types.TIMESTAMP);
            }

            ps.setString(6, c.getEstado() != null ? c.getEstado() : "ACTIVO");

            if (c.getIdEntrenador() != null && c.getIdEntrenador() > 0) {
                ps.setInt(7, c.getIdEntrenador());
            } else {
                ps.setNull(7, Types.INTEGER);
            }

            ok = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); if (cn != null) cn.close(); } catch (Exception ignored) {}
        }
        return ok;
    }

    public boolean actualizarCliente(ClienteDTO c) {
        Connection cn = null;
        PreparedStatement ps = null;
        boolean ok = false;
        try {
            cn = MysqlDBConexion.getConnection();
            String sql = "UPDATE cliente SET nombre_completo = ?, dni = ?, telefono = ?, correo = ?, fecha_vencimiento = ?, estado = ?, id_entrenador = ? WHERE id = ?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, c.getNombreCompleto());
            ps.setString(2, c.getDni());
            ps.setString(3, c.getTelefono());
            ps.setString(4, c.getEmail());

            if (c.getFechaVencimiento() != null) {
                ps.setTimestamp(5, new Timestamp(c.getFechaVencimiento().getTime()));
            } else {
                ps.setNull(5, Types.TIMESTAMP);
            }

            ps.setString(6, c.getEstado());

            if (c.getIdEntrenador() != null && c.getIdEntrenador() > 0) {
                ps.setInt(7, c.getIdEntrenador());
            } else {
                ps.setNull(7, Types.INTEGER);
            }

            ps.setInt(8, c.getId());
            ok = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); if (cn != null) cn.close(); } catch (Exception ignored) {}
        }
        return ok;
    }

    public boolean eliminarCliente(int id) {
        Connection cn = null;
        PreparedStatement ps = null;
        boolean ok = false;
        try {
            cn = MysqlDBConexion.getConnection();
            String sql = "DELETE FROM cliente WHERE id = ?";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, id);
            ok = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); if (cn != null) cn.close(); } catch (Exception ignored) {}
        }
        return ok;
    }
}