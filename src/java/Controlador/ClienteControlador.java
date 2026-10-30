package Controlador;

import Entidad.ClienteDTO;
import Entidad.Usuario;
import Modelo.ClienteModelo;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ClienteControlador", urlPatterns = {"/ClienteControlador"})
public class ClienteControlador extends HttpServlet {

    private ClienteModelo cMod = new ClienteModelo();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuarioLogueado");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Si es entrenador, solo ve a sus propios atletas
        Integer idFiltro = null;
        if ("ENTRENADOR".equalsIgnoreCase(user.getRol())) {
            idFiltro = user.getId();
        }

        List lista = cMod.listarClientes(idFiltro);
        List entrenadores = cMod.listarEntrenadores();

        request.setAttribute("listaClientes", lista);
        request.setAttribute("listaEntrenadores", entrenadores);
        request.getRequestDispatcher("atletas.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuarioLogueado");

        if (user == null || "ENTRENADOR".equalsIgnoreCase(user.getRol())) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        String accion = request.getParameter("accion");
        if (accion == null) accion = "crear";

        try {
            if ("crear".equals(accion)) {
                ClienteDTO dto = new ClienteDTO();
                dto.setNombreCompleto(request.getParameter("txtNombre"));
                dto.setDni(request.getParameter("txtDni"));
                dto.setTelefono(request.getParameter("txtTelefono"));
                dto.setEmail(request.getParameter("txtEmail"));
                dto.setFechaVencimiento(Date.valueOf(request.getParameter("txtFechaVencimiento")));
                dto.setEstado(request.getParameter("cboEstado"));
                
                String entStr = request.getParameter("cboEntrenador");
                if (entStr != null && !entStr.isEmpty() && !entStr.equals("0")) {
                    dto.setIdEntrenador(Integer.parseInt(entStr));
                }

                boolean ok = cMod.registrarCliente(dto);
                if (ok) request.setAttribute("exito", "Atleta registrado exitosamente.");
                else request.setAttribute("error", "No se pudo registrar al atleta.");

            } else if ("editar".equals(accion)) {
                ClienteDTO dto = new ClienteDTO();
                dto.setId(Integer.parseInt(request.getParameter("txtId")));
                dto.setNombreCompleto(request.getParameter("txtNombre"));
                dto.setDni(request.getParameter("txtDni"));
                dto.setTelefono(request.getParameter("txtTelefono"));
                dto.setEmail(request.getParameter("txtEmail"));
                dto.setFechaVencimiento(Date.valueOf(request.getParameter("txtFechaVencimiento")));
                dto.setEstado(request.getParameter("cboEstado"));

                String entStr = request.getParameter("cboEntrenador");
                if (entStr != null && !entStr.isEmpty() && !entStr.equals("0")) {
                    dto.setIdEntrenador(Integer.parseInt(entStr));
                } else {
                    dto.setIdEntrenador(null);
                }

                boolean ok = cMod.actualizarCliente(dto);
                if (ok) request.setAttribute("exito", "Datos de atleta actualizados.");
                else request.setAttribute("error", "Error al actualizar datos.");

            } else if ("eliminar".equals(accion)) {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean ok = cMod.eliminarCliente(id);
                if (ok) request.setAttribute("exito", "Atleta eliminado del padrón.");
                else request.setAttribute("error", "Error al eliminar atleta.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            e.printStackTrace();
        }

        doGet(request, response);
    }
}