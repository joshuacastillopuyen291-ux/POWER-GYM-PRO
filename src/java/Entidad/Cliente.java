package Entidad;

import java.sql.Timestamp;

public class Cliente {
    private int id;
    private String nombreCompleto;
    private String dni;
    private String telefono;
    private String correo;
    private int idMembresia;
    private Timestamp fechaVencimiento;
    private String estado;
    private Integer idEntrenador;
    private String nombreEntrenador;

    public Cliente() {}

    public Cliente(String nombreCompleto, String dni, String telefono, String correo, int idMembresia) {
        this.nombreCompleto = nombreCompleto;
        this.dni = dni;
        this.telefono = telefono;
        this.correo = correo;
        this.idMembresia = idMembresia;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombreCompleto() { return nombreCompleto; }
    public void setNombreCompleto(String nombreCompleto) { this.nombreCompleto = nombreCompleto; }

    public String getDni() { return dni; }
    public void setDni(String dni) { this.dni = dni; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }

    public int getIdMembresia() { return idMembresia; }
    public void setIdMembresia(int idMembresia) { this.idMembresia = idMembresia; }

    public Timestamp getFechaVencimiento() { return fechaVencimiento; }
    public void setFechaVencimiento(Timestamp fechaVencimiento) { this.fechaVencimiento = fechaVencimiento; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    
    public Integer getIdEntrenador() { return idEntrenador; }
    public void setIdEntrenador(Integer idEntrenador) { this.idEntrenador = idEntrenador; }

    public String getNombreEntrenador() { return nombreEntrenador; }
    public void setNombreEntrenador(String nombreEntrenador) { this.nombreEntrenador = nombreEntrenador; }
}