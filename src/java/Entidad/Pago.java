package Entidad;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Pago {
    private int idPago;
    private int idCliente;
    private int idUsuario;
    private BigDecimal monto;
    private String metodoPago;
    private Timestamp fechaPago;

    public Pago() {}

    public int getIdPago() { return idPago; }
    public void setIdPago(int idPago) { this.idPago = idPago; }

    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public BigDecimal getMonto() { return monto; }
    public void setMonto(BigDecimal monto) { this.monto = monto; }

    public String getMetodoPago() { return metodoPago; }
    public void setMetodoPago(String metodoPago) { this.metodoPago = metodoPago; }

    public Timestamp getFechaPago() { return fechaPago; }
    public void setFechaPago(Timestamp fechaPago) { this.fechaPago = fechaPago; }
}