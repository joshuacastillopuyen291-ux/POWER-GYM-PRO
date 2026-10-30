package Controlador;

import Entidad.ClienteDTO;
import Entidad.Usuario;
import Modelo.ClienteModelo;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ExportarAtletasControlador", urlPatterns = {"/ExportarAtletasControlador"})
public class ExportarAtletasControlador extends HttpServlet {

    private ClienteModelo clienteMod = new ClienteModelo();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario user = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Si es entrenador, únicamente exporta a los atletas asignados a él
        Integer idFiltro = null;
        if ("ENTRENADOR".equalsIgnoreCase(user.getRol())) {
            idFiltro = user.getId();
        }

        List<ClienteDTO> lista = clienteMod.listarClientes(idFiltro);

        // Configuración de respuesta MIME para generar descarga directa en Excel (.xls)
        String fechaHoy = new SimpleDateFormat("yyyyMMdd_HHmm").format(new Date());
        String nombreArchivo = "Padron_Atletas_PowerGym_" + fechaHoy + ".xls";

        response.setContentType("application/vnd.ms-excel; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + nombreArchivo + "\"");

        PrintWriter out = response.getWriter();

        try {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<meta charset=\"UTF-8\">");
            out.println("<style>");
            out.println("table { border-collapse: collapse; width: 100%; font-family: Arial, sans-serif; }");
            out.println("th { background-color: #0b1329; color: #ffffff; font-weight: bold; border: 1px solid #cbd5e1; padding: 10px; font-size: 12px; }");
            out.println("td { border: 1px solid #cbd5e1; padding: 8px 10px; font-size: 12px; }");
            out.println(".titulo { font-size: 18px; font-weight: bold; color: #0b1329; margin-bottom: 5px; }");
            out.println(".subtitulo { font-size: 12px; color: #64748b; margin-bottom: 15px; }");
            out.println(".badge-activo { color: #15803d; font-weight: bold; }");
            out.println(".badge-moroso { color: #b91c1c; font-weight: bold; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");

            out.println("<div class=\"titulo\">POWER GYM - REPORTE OFICIAL DEL PADRÓN DE ATLETAS</div>");
            out.println("<div class=\"subtitulo\">Generado por: " + user.getNombre() + " (" + user.getRol() + ") | Fecha de emisión: " + new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date()) + "</div>");
            out.println("<br>");

            out.println("<table>");
            out.println("<thead>");
            out.println("<tr>");
            out.println("<th>ID</th>");
            out.println("<th>Nombre Completo</th>");
            out.println("<th>DNI</th>");
            out.println("<th>Teléfono</th>");
            out.println("<th>Correo Electrónico</th>");
            out.println("<th>Entrenador Asignado</th>");
            out.println("<th>Fecha Vencimiento</th>");
            out.println("<th>Estado</th>");
            out.println("</tr>");
            out.println("</thead>");
            out.println("<tbody>");

            if (lista != null && !lista.isEmpty()) {
                for (ClienteDTO c : lista) {
                    out.println("<tr>");
                    out.println("<td style=\"text-align: center;\">" + c.getId() + "</td>");
                    out.println("<td><strong>" + (c.getNombreCompleto() != null ? c.getNombreCompleto() : "") + "</strong></td>");
                    // Formato de texto para preservar ceros a la izquierda en DNI y teléfono en Excel
                    out.println("<td style=\"mso-number-format:'\\@'; text-align: center;\">" + (c.getDni() != null ? c.getDni() : "") + "</td>");
                    out.println("<td style=\"mso-number-format:'\\@';\">" + (c.getTelefono() != null ? c.getTelefono() : "-") + "</td>");
                    out.println("<td>" + (c.getEmail() != null ? c.getEmail() : "-") + "</td>");
                    out.println("<td>" + (c.getNombreEntrenador() != null ? c.getNombreEntrenador() : "Entrenamiento General") + "</td>");
                    out.println("<td style=\"text-align: center;\">" + (c.getFechaVencimiento() != null ? c.getFechaVencimiento().toString() : "Sin fecha") + "</td>");

                    String cssEstado = "ACTIVO".equalsIgnoreCase(c.getEstado()) ? "badge-activo" : "badge-moroso";
                    out.println("<td class=\"" + cssEstado + "\" style=\"text-align: center;\">" + (c.getEstado() != null ? c.getEstado().toUpperCase() : "DESCONOCIDO") + "</td>");
                    out.println("</tr>");
                }
            } else {
                out.println("<tr><td colspan=\"8\" style=\"text-align: center; color: #94a3b8; padding: 20px;\">No se encontraron registros para exportar.</td></tr>");
            }

            out.println("</tbody>");
            out.println("</table>");
            out.println("</body>");
            out.println("</html>");

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            out.flush();
            out.close();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}