package Controlador;

import Entidad.Usuario;
import Modelo.UsuarioModelo;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginControlador", urlPatterns = {"/LoginControlador"})
public class LoginControlador extends HttpServlet {

    private UsuarioModelo usuMod = new UsuarioModelo();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String user = request.getParameter("txtUsuario");
        String pass = request.getParameter("txtPassword");

        Usuario usu = usuMod.validarLogin(user, pass);

        if (usu != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogueado", usu);
            response.sendRedirect("dashboard.jsp");
        } else {
            request.setAttribute("error", "Credenciales incorrectas. Intente nuevamente.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}