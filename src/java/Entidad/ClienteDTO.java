package Entidad;

import java.sql.Date;

public class ClienteDTO {
    private int id;
    private String nombreCompleto;
    private String dni;
    private String telefono;
    private String email;
    private Date fechaInicio;
    private Date fechaVencimiento;
    private String tipoMembresia;
    private String estado;
    private Integer idEntrenador;
    private String nombreEntrenador;

    public ClienteDTO() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombreCompleto() { return nombreCompleto; }
    public void setNombreCompleto(String nombreCompleto) { this.nombreCompleto = nombreCompleto; }

    public String getDni() { return dni; }
    public void setDni(String dni) { this.dni = dni; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public Date getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(Date fechaInicio) { this.fechaInicio = fechaInicio; }

    public Date getFechaVencimiento() { return fechaVencimiento; }
    public void setFechaVencimiento(Date fechaVencimiento) { this.fechaVencimiento = fechaVencimiento; }

    public String getTipoMembresia() { 
        return (tipoMembresia != null && !tipoMembresia.isEmpty()) ? tipoMembresia : "PASE MENSUAL"; 
    }
    public void setTipoMembresia(String tipoMembresia) { this.tipoMembresia = tipoMembresia; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public Integer getIdEntrenador() { return idEntrenador; }
    public void setIdEntrenador(Integer idEntrenador) { this.idEntrenador = idEntrenador; }

    public String getNombreEntrenador() { return nombreEntrenador; }
    public void setNombreEntrenador(String nombreEntrenador) { this.nombreEntrenador = nombreEntrenador; }
}