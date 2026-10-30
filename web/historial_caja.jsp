<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Entidad.Usuario"%>
<%@page import="Entidad.PagoDTO"%>
<%@page import="Modelo.CajaModelo"%>
<%@page import="java.util.List"%>
<%
    Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
    if (user == null || "ENTRENADOR".equalsIgnoreCase(user.getRol())) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    List<PagoDTO> lista = (List<PagoDTO>) request.getAttribute("listaPagos");
    if (lista == null) {
        CajaModelo cMod = new CajaModelo();
        lista = cMod.listarHistorialPagos();
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>POWER GYM - Historial de Caja</title>
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; }
        body { background-color: #f1f5f9; display: flex; min-height: 100vh; }
        .sidebar { width: 260px; background-color: #0b1329; color: white; display: flex; flex-direction: column; justify-content: space-between; padding: 24px 16px; flex-shrink: 0; box-shadow: 4px 0 20px rgba(0,0,0,0.15); }
        .brand { display: flex; align-items: center; gap: 12px; padding-left: 12px; margin-bottom: 32px; font-size: 19px; font-weight: 800; color: #ffffff; }
        .brand i { color: #10b981; font-size: 26px; }
        .nav-list { display: flex; flex-direction: column; gap: 8px; list-style: none; }
        .nav-item a { display: flex; align-items: center; gap: 14px; padding: 12px 16px; color: #94a3b8; text-decoration: none; font-size: 14px; font-weight: 600; border-radius: 10px; transition: all 0.2s; }
        .nav-item a:hover { color: #ffffff; background-color: #1e293b; }
        .nav-item.active a { background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%); color: #ffffff; box-shadow: 0 4px 12px rgba(99, 102, 241, 0.35); }
        .nav-item a i { font-size: 20px; }
        .user-card { background-color: #1e293b; padding: 12px 14px; border-radius: 12px; display: flex; align-items: center; gap: 12px; margin-bottom: 10px; }
        .avatar-box { width: 36px; height: 36px; border-radius: 8px; background-color: #10b981; color: #fff; display: flex; align-items: center; justify-content: center; font-weight: bold; }
        
        .main-content { flex: 1; padding: 40px 48px; overflow-y: auto; }
        .card-box { background: white; padding: 28px; border-radius: 18px; border: 1px solid #e2e8f0; box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.06); }
        h1 { font-size: 26px; font-weight: 800; color: #0f172a; margin-bottom: 24px; }

        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 14px 16px; text-align: left; border-bottom: 1px solid #e2e8f0; font-size: 14px; vertical-align: middle; }
        th { background: #0f172a; color: white; font-size: 12px; text-transform: uppercase; font-weight: 800; }
        th:first-child { border-top-left-radius: 10px; }
        th:last-child { border-top-right-radius: 10px; }
        .monto { color: #10b981; font-weight: 800; font-size: 15px; }
        .badge-pago { background: #e0e7ff; color: #4338ca; padding: 4px 10px; border-radius: 8px; font-size: 11px; font-weight: 800; }
    </style>
</head>
<body>
    <div class="sidebar">
        <div>
            <div class="brand"><i class="ph-bold ph-barbell"></i><span>POWER GYM</span></div>
            <ul class="nav-list">
                <li class="nav-item"><a href="dashboard.jsp"><i class="ph-fill ph-clock"></i><span>Dashboard</span></a></li>
                <li class="nav-item"><a href="ClienteControlador"><i class="ph-bold ph-users"></i><span>Padrón Atletas</span></a></li>
                <li class="nav-item"><a href="acceso.jsp"><i class="ph-bold ph-user-focus"></i><span>Control Acceso</span></a></li>
                <li class="nav-item"><a href="caja.jsp"><i class="ph-bold ph-credit-card"></i><span>Caja Cobranza</span></a></li>
                <li class="nav-item active"><a href="HistorialCajaControlador"><i class="ph-bold ph-wallet"></i><span>Historial de Caja</span></a></li>
                <% if ("ADMIN".equalsIgnoreCase(user.getRol())) { %>
                    <li class="nav-item"><a href="UsuarioControlador"><i class="ph-bold ph-shield-check"></i><span>Gestión Personal</span></a></li>
                <% } %>
            </ul>
        </div>
        <div>
            <div class="user-card">
                <div class="avatar-box"><%= user.getNombre().substring(0, 1).toUpperCase() %></div>
                <div style="overflow: hidden;"><div style="font-size: 13px; font-weight: 700;"><%= user.getNombre() %></div><div style="font-size: 11px; color: #10b981;"><%= user.getRol() %></div></div>
            </div>
            <a href="login.jsp" style="display: flex; align-items: center; gap: 8px; color: #ef4444; text-decoration: none; font-size: 13px; font-weight: 600; padding: 8px 12px; border-radius: 8px; background: rgba(239, 68, 68, 0.1);"><i class="ph-bold ph-sign-out"></i><span>Cerrar Sesión</span></a>
        </div>
    </div>

    <div class="main-content">
        <h1>Historial y Auditoría de Caja</h1>

        <div class="card-box">
            <table>
                <thead>
                    <tr>
                        <th style="width: 80px;">N° Ticket</th>
                        <th>Atleta</th>
                        <th>DNI</th>
                        <th>Monto</th>
                        <th>Método</th>
                        <th>Fecha de Pago</th>
                        <th>Registrado Por</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (lista != null && !lista.isEmpty()) { 
                        for (PagoDTO p : lista) {
                    %>
                        <tr>
                            <td><strong>#<%= p.getIdPago() %></strong></td>
                            <td><strong><%= p.getNombreCliente() %></strong></td>
                            <td><%= p.getDniCliente() %></td>
                            <td class="monto">S/. <%= String.format("%.2f", p.getMonto()) %></td>
                            <td><span class="badge-pago"><%= p.getMetodoPago() %></span></td>
                            <td><%= (p.getFechaPago() != null) ? p.getFechaPago().toString() : "-" %></td>
                            <td><%= p.getNombreUsuario() %></td>
                        </tr>
                    <% } } else { %>
                        <tr>
                            <td colspan="7" style="text-align: center; color: #94a3b8; padding: 30px;">
                                No hay transacciones registradas en el historial de caja.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>