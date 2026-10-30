package Controlador;

import Entidad.ClienteDTO;
import Entidad.Usuario;
import Modelo.AccesoModelo;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AccesoControlador", urlPatterns = {"/AccesoControlador"})
public class AccesoControlador extends HttpServlet {

    private AccesoModelo accesoMod = new AccesoModelo();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("acceso.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuarioLogueado");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String dni = request.getParameter("txtDni");

        if (dni != null && !dni.trim().isEmpty()) {
            ClienteDTO atleta = accesoMod.buscarPorDni(dni.trim());
            if (atleta != null) {
                accesoMod.registrarIngreso(atleta.getId());
                request.setAttribute("atleta", atleta);
            } else {
                request.setAttribute("error", "No se encontró ningún atleta registrado con el DNI: " + dni.trim());
            }
        } else {
            request.setAttribute("error", "Por favor, ingrese un número de DNI.");
        }

        request.getRequestDispatcher("acceso.jsp").forward(request, response);
    }
}