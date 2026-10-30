package Modelo;

import Entidad.ClienteDTO;
import Utils.MysqlDBConexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

public class AccesoModelo {

    public ClienteDTO consultarVigenciaPorDNI(String dni) {
        return buscarPorDni(dni);
    }

    public ClienteDTO buscarPorDni(String dni) {
        ClienteDTO dto = null;
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        if (dni == null || dni.trim().isEmpty()) {
            return null;
        }

        try {
            cn = MysqlDBConexion.getConnection();
            String sql = "SELECT c.id, c.nombre_completo, c.dni, c.telefono, c.correo, c.fecha_vencimiento, c.estado, "
                       + "u.nombre AS nombre_entrenador "
                       + "FROM cliente c "
                       + "LEFT JOIN usuario u ON c.id_entrenador = u.id "
                       + "WHERE TRIM(c.dni) = TRIM(?)";
            ps = cn.prepareStatement(sql);
            ps.setString(1, dni.trim());
            rs = ps.executeQuery();

            if (rs.next()) {
                dto = new ClienteDTO();
                dto.setId(rs.getInt("id"));
                dto.setNombreCompleto(rs.getString("nombre_completo"));
                dto.setDni(rs.getString("dni"));
                dto.setTelefono(rs.getString("telefono") != null ? rs.getString("telefono") : "-");
                dto.setEmail(rs.getString("correo") != null ? rs.getString("correo") : "-");

                Timestamp ts = rs.getTimestamp("fecha_vencimiento");
                java.util.Date hoy = new java.util.Date();

                if (ts != null) {
                    dto.setFechaVencimiento(new java.sql.Date(ts.getTime()));
                    if (ts.before(hoy)) {
                        dto.setEstado("MOROSO");
                    } else {
                        String est = rs.getString("estado");
                        dto.setEstado(est != null ? est.toUpperCase() : "ACTIVO");
                    }
                } else {
                    dto.setFechaVencimiento(null);
                    dto.setEstado("INACTIVO");
                }

                dto.setNombreEntrenador(rs.getString("nombre_entrenador"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (Exception ignored) {}
        }
        return dto;
    }

    public boolean registrarIngreso(int idCliente) {
        return true;
    }
}