package Controlador;

import Entidad.Usuario;
import Modelo.CajaModelo;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "CajaControlador", urlPatterns = {"/CajaControlador"})
public class CajaControlador extends HttpServlet {

    private CajaModelo cajaMod = new CajaModelo();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("caja.jsp");
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

        try {
            String idStr = request.getParameter("txtIdCliente");
            if (idStr == null || idStr.trim().isEmpty()) {
                idStr = request.getParameter("txtIdSocio");
            }

            if (idStr == null || idStr.trim().isEmpty()) {
                request.setAttribute("error", "No se recibió el identificador del socio a cobrar.");
                request.getRequestDispatcher("caja.jsp").forward(request, response);
                return;
            }

            int idCliente = Integer.parseInt(idStr.trim());
            double monto = Double.parseDouble(request.getParameter("txtMonto"));
            String metodo = request.getParameter("cboMetodo");
            
            // Recibe los meses del plan seleccionado (por defecto 1 si no viene)
            int meses = 1;
            String mesesStr = request.getParameter("txtMesesPlan");
            if (mesesStr != null && !mesesStr.trim().isEmpty()) {
                try {
                    meses = Integer.parseInt(mesesStr.trim());
                } catch (NumberFormatException ignored) {}
            }

            // Llamada con los 5 parámetros requeridos
            boolean ok = cajaMod.procesarPago(idCliente, user.getId(), monto, metodo, meses);

            if (ok) {
                request.setAttribute("exito", "Cobro registrado correctamente. Se ha renovado la vigencia por " + meses + " mes(es).");
            } else {
                request.setAttribute("error", "No se pudo registrar el pago. Revise la base de datos.");
            }

        } catch (Exception e) {
            request.setAttribute("error", "Error en procesamiento de cobro: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("caja.jsp").forward(request, response);
    }
}