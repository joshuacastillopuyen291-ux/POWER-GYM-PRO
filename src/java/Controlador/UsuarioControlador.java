package Controlador;

import Entidad.Usuario;
import Modelo.UsuarioModelo;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "UsuarioControlador", urlPatterns = {"/UsuarioControlador"})
public class UsuarioControlador extends HttpServlet {

    private UsuarioModelo usuMod = new UsuarioModelo();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuarioLogueado");

        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRol())) {
            response.sendRedirect("login.jsp");
            return;
        }

        List lista = usuMod.listarUsuarios();
        request.setAttribute("listaUsuarios", lista);
        request.getRequestDispatcher("usuarios.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuarioLogueado");

        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRol())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String accion = request.getParameter("accion");
        if (accion == null) accion = "crear";

        try {
            if ("crear".equals(accion)) {
                String nombre = request.getParameter("txtNombre");
                String usuario = request.getParameter("txtUsuario");
                String pass = request.getParameter("txtPassword");
                String rol = request.getParameter("cboRol");

                Usuario nuevo = new Usuario();
                nuevo.setNombre(nombre);
                nuevo.setUsuario(usuario);
                nuevo.setPassword(pass);
                nuevo.setRol(rol);

                boolean ok = usuMod.registrarUsuario(nuevo);
                if (ok) request.setAttribute("exito", "Usuario registrado exitosamente.");
                else request.setAttribute("error", "No se pudo registrar el usuario. Verifique los datos.");

            } else if ("editar_datos".equals(accion)) {
                int id = Integer.parseInt(request.getParameter("txtId"));
                String nombre = request.getParameter("txtNombre");
                String usuario = request.getParameter("txtUsuario");
                String rol = request.getParameter("cboRol");

                boolean ok = usuMod.actualizarDatosUsuario(id, nombre, usuario, rol);
                if (ok) request.setAttribute("exito", "Datos de usuario actualizados correctamente.");
                else request.setAttribute("error", "Error al actualizar los datos del usuario.");

            } else if ("editar_pass".equals(accion)) {
                int id = Integer.parseInt(request.getParameter("txtId"));
                String nuevaPass = request.getParameter("txtNuevaPassword");

                boolean ok = usuMod.actualizarPassword(id, nuevaPass);
                if (ok) request.setAttribute("exito", "Contraseña cambiada exitosamente.");
                else request.setAttribute("error", "Error al cambiar la contraseña.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error procesando la solicitud: " + e.getMessage());
            e.printStackTrace();
        }

        doGet(request, response);
    }
}