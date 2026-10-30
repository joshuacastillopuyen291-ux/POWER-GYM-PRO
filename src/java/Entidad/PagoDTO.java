package Entidad;

import java.sql.Timestamp;

public class PagoDTO {
    private int id;
    private String nombreCliente;
    private String dni;
    private double monto;
    private String metodoPago;
    private Timestamp fechaPago;
    private String nombreUsuario;

    public PagoDTO() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    // Métodos alias para que historial_caja.jsp nunca lance error 500
    public int getIdPago() {
        return id;
    }

    public void setIdPago(int idPago) {
        this.id = idPago;
    }

    public String getNombreCliente() {
        return nombreCliente;
    }

    public void setNombreCliente(String nombreCliente) {
        this.nombreCliente = nombreCliente;
    }

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public String getDniCliente() {
        return dni;
    }

    public void setDniCliente(String dniCliente) {
        this.dni = dniCliente;
    }

    public double getMonto() {
        return monto;
    }

    public void setMonto(double monto) {
        this.monto = monto;
    }

    public String getMetodoPago() {
        return metodoPago;
    }

    public void setMetodoPago(String metodoPago) {
        this.metodoPago = metodoPago;
    }

    public Timestamp getFechaPago() {
        return fechaPago;
    }

    public void setFechaPago(Timestamp fechaPago) {
        this.fechaPago = fechaPago;
    }

    public String getNombreUsuario() {
        return nombreUsuario;
    }

    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }
}