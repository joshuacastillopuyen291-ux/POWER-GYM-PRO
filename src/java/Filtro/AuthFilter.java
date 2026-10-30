package Filtro;

import Entidad.Usuario;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String uri = req.getRequestURI();
        boolean isLogin = uri.endsWith("login.jsp") || uri.endsWith("LoginControlador");
        boolean isStatic = uri.contains("/css/") || uri.contains("/js/") || uri.contains("/img/") || uri.contains(".ico");

        Usuario user = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        if (isLogin || isStatic) {
            chain.doFilter(request, response);
            return;
        }

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Restricciones para ENTRENADOR: No tiene acceso a caja, historial, acceso ni gestión de personal
        if ("ENTRENADOR".equalsIgnoreCase(user.getRol())) {
            if (uri.endsWith("caja.jsp") || uri.endsWith("CajaControlador")
             || uri.endsWith("historial_caja.jsp") || uri.endsWith("HistorialCajaControlador")
             || uri.endsWith("acceso.jsp") || uri.endsWith("AccesoControlador")
             || uri.endsWith("usuarios.jsp") || uri.endsWith("UsuarioControlador")) {
                res.sendRedirect(req.getContextPath() + "/dashboard.jsp");
                return;
            }
        }

        // Restricciones para CAJERO: No entra a gestión personal
        if ("CAJERO".equalsIgnoreCase(user.getRol())) {
            if (uri.endsWith("usuarios.jsp") || uri.endsWith("UsuarioControlador")) {
                res.sendRedirect(req.getContextPath() + "/dashboard.jsp");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}