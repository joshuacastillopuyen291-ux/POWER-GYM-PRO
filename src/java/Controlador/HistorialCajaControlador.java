package Controlador;

import Entidad.PagoDTO;
import Entidad.Usuario;
import Modelo.CajaModelo;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "HistorialCajaControlador", urlPatterns = {"/HistorialCajaControlador"})
public class HistorialCajaControlador extends HttpServlet {

    private CajaModelo cajaMod = new CajaModelo();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario user = (Usuario) session.getAttribute("usuarioLogueado");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Obtener historial y mandar a la vista
        List lista = cajaMod.listarHistorialPagos();
        request.setAttribute("listaPagos", lista);
        request.getRequestDispatcher("historial_caja.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}