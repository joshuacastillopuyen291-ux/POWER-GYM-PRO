package Modelo;

import Entidad.PagoDTO;
import Utils.MysqlDBConexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class CajaModelo {

    // Sobrecarga de compatibilidad: si se llama con 4 parámetros, asume 1 mes por defecto
    public boolean procesarPago(int idCliente, int idUsuario, double monto, String metodoPago) {
        return procesarPago(idCliente, idUsuario, monto, metodoPago, 1);
    }

    public boolean procesarPago(int idCliente, int idUsuario, double monto, String metodoPago, int mesesPlan) {
        Connection cn = null;
        PreparedStatement psPago = null;
        PreparedStatement psCliente = null;
        PreparedStatement psBuscar = null;
        ResultSet rsBuscar = null;
        boolean exito = false;

        if (mesesPlan <= 0) mesesPlan = 1;

        try {
            cn = MysqlDBConexion.getConnection();
            cn.setAutoCommit(false);

            Timestamp fechaActualVence = null;
            String sqlBuscar = "SELECT fecha_vencimiento FROM cliente WHERE id = ?";
            psBuscar = cn.prepareStatement(sqlBuscar);
            psBuscar.setInt(1, idCliente);
            rsBuscar = psBuscar.executeQuery();

            if (rsBuscar.next()) {
                fechaActualVence = rsBuscar.getTimestamp("fecha_vencimiento");
            }

            Calendar cal = Calendar.getInstance();
            java.util.Date hoy = new java.util.Date();

            // Si está vigente se suman los meses al vencimiento; si ya venció, se suman a partir de hoy
            if (fechaActualVence != null && fechaActualVence.after(hoy)) {
                cal.setTime(fechaActualVence);
            } else {
                cal.setTime(hoy);
            }
            cal.add(Calendar.MONTH, mesesPlan);
            Timestamp nuevaFechaVence = new Timestamp(cal.getTimeInMillis());

            // 1. Insertar el pago
            String sqlPago = "INSERT INTO pago (id_cliente, id_usuario, monto, metodo_pago, fecha_pago) VALUES (?, ?, ?, ?, NOW())";
            psPago = cn.prepareStatement(sqlPago);
            psPago.setInt(1, idCliente);
            psPago.setInt(2, idUsuario > 0 ? idUsuario : 1);
            psPago.setDouble(3, monto);
            psPago.setString(4, metodoPago);
            psPago.executeUpdate();

            // 2. Actualizar vencimiento y pasar a ACTIVO
            String sqlCliente = "UPDATE cliente SET fecha_vencimiento = ?, estado = 'ACTIVO' WHERE id = ?";
            psCliente = cn.prepareStatement(sqlCliente);
            psCliente.setTimestamp(1, nuevaFechaVence);
            psCliente.setInt(2, idCliente);
            psCliente.executeUpdate();

            cn.commit();
            exito = true;

        } catch (Exception e) {
            try {
                if (cn != null) cn.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (rsBuscar != null) rsBuscar.close();
                if (psBuscar != null) psBuscar.close();
                if (psPago != null) psPago.close();
                if (psCliente != null) psCliente.close();
                if (cn != null) cn.close();
            } catch (Exception ignored) {}
        }
        return exito;
    }

    public List listarHistorialPagos() {
        List lista = new ArrayList<>();
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MysqlDBConexion.getConnection();
            String sql = "SELECT p.id, c.nombre_completo AS cliente, c.dni, p.monto, p.metodo_pago, p.fecha_pago, u.nombre AS usuario "
                       + "FROM pago p "
                       + "INNER JOIN cliente c ON p.id_cliente = c.id "
                       + "INNER JOIN usuario u ON p.id_usuario = u.id "
                       + "ORDER BY p.id DESC";
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                PagoDTO dto = new PagoDTO();
                dto.setId(rs.getInt("id"));
                dto.setNombreCliente(rs.getString("cliente"));
                dto.setDni(rs.getString("dni"));
                dto.setMonto(rs.getDouble("monto"));
                dto.setMetodoPago(rs.getString("metodo_pago"));
                dto.setFechaPago(rs.getTimestamp("fecha_pago"));
                dto.setNombreUsuario(rs.getString("usuario"));
                lista.add(dto);
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
        return lista;
    }
}