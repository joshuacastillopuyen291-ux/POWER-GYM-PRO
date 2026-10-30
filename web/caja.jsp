<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Entidad.Usuario"%>
<%@page import="Entidad.ClienteDTO"%>
<%@page import="Modelo.AccesoModelo"%>
<%
    Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
    if (user == null || "ENTRENADOR".equalsIgnoreCase(user.getRol())) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    String dniParam = request.getParameter("txtDniBusqueda");
    ClienteDTO socio = null;
    if (dniParam != null && !dniParam.trim().isEmpty()) {
        AccesoModelo accMod = new AccesoModelo();
        socio = accMod.buscarPorDni(dniParam.trim());
    }

    String exito = (String) request.getAttribute("exito");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>POWER GYM - Caja y Cobranza</title>
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
        .card-box { background: white; padding: 28px; border-radius: 18px; border: 1px solid #e2e8f0; box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.06); margin-bottom: 25px; }
        label { font-size: 12px; font-weight: 800; color: #475569; text-transform: uppercase; margin-bottom: 6px; display: block; }
        input, select { width: 100%; padding: 12px; border: 1px solid #cbd5e1; border-radius: 10px; font-size: 14px; font-weight: 600; outline: none; background: #f8fafc; }
        input:focus, select:focus { border-color: #6366f1; background: #fff; }
        .search-row { display: flex; gap: 12px; margin-top: 6px; }
        .btn-search { background: #0f172a; color: white; border: none; padding: 12px 24px; font-size: 14px; font-weight: 700; border-radius: 10px; cursor: pointer; }
        .btn-search:hover { background: #1e293b; }
        
        .socio-card { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px; margin-top: 20px; }
        .socio-item span { font-size: 11px; font-weight: 800; color: #64748b; text-transform: uppercase; }
        .socio-item p { font-size: 15px; font-weight: 700; color: #0f172a; margin-top: 4px; }
        
        .btn-pay { background: #10b981; color: white; border: none; padding: 14px; font-size: 14px; font-weight: 800; border-radius: 10px; cursor: pointer; width: 100%; margin-top: 15px; }
        .btn-pay:hover { background: #059669; }
        .alert-success { background: #dcfce7; color: #15803d; border: 1px solid #86efac; padding: 14px 18px; border-radius: 10px; font-weight: 700; margin-bottom: 20px; }
        .alert-error { background: #fee2e2; color: #b91c1c; border: 1px solid #fca5a5; padding: 14px 18px; border-radius: 10px; font-weight: 700; margin-bottom: 20px; }
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
                <li class="nav-item active"><a href="caja.jsp"><i class="ph-bold ph-credit-card"></i><span>Caja Cobranza</span></a></li>
                <li class="nav-item"><a href="HistorialCajaControlador"><i class="ph-bold ph-wallet"></i><span>Historial de Caja</span></a></li>
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
        <h1 style="font-size: 26px; font-weight: 800; color: #0f172a; margin-bottom: 20px;">Caja y Cobranza</h1>

        <% if (exito != null) { %><div class="alert-success"><%= exito %></div><% } %>
        <% if (error != null) { %><div class="alert-error"><%= error %></div><% } %>

        <div class="card-box">
            <label>Buscar Atleta para Cobro:</label>
            <form action="caja.jsp" method="GET" class="search-row">
                <input type="text" name="txtDniBusqueda" placeholder="Ingrese DNI del atleta..." value="<%= (dniParam != null) ? dniParam : "" %>" required>
                <button type="submit" class="btn-search">Buscar</button>
            </form>

            <% if (dniParam != null && socio == null) { %>
                <div class="alert-error" style="margin-top: 15px;">No se encontró ningún atleta registrado con el DNI ingresado.</div>
            <% } %>

            <% if (socio != null) { %>
                <div class="socio-card">
                    <div class="socio-item">
                        <span>Atleta:</span>
                        <p><%= socio.getNombreCompleto() %></p>
                    </div>
                    <div class="socio-item">
                        <span>DNI:</span>
                        <p><%= socio.getDni() %></p>
                    </div>
                    <div class="socio-item">
                        <span>Vencimiento Actual:</span>
                        <p><%= (socio.getFechaVencimiento() != null) ? socio.getFechaVencimiento() : "Sin fecha" %></p>
                    </div>
                    <div class="socio-item">
                        <span>Estado:</span>
                        <p style="color: <%= "ACTIVO".equalsIgnoreCase(socio.getEstado()) ? "#15803d" : "#b91c1c" %>;"><%= socio.getEstado() %></p>
                    </div>
                </div>

                <form action="CajaControlador" method="POST" style="margin-top: 20px;">
                    <input type="hidden" name="accion" value="cobrar">
                    <!-- Envía ambos nombres para que sea imposible que llegue nulo -->
                    <input type="hidden" name="txtIdCliente" value="<%= socio.getId() %>">
                    <input type="hidden" name="txtIdSocio" value="<%= socio.getId() %>">
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div>
                            <label>Monto a Cobrar (S/.):</label>
                            <input type="number" step="0.01" name="txtMonto" value="100.00" required>
                        </div>
                        <div>
                            <label>Método de Pago:</label>
                            <select name="cboMetodo">
                                <option value="EFECTIVO">EFECTIVO</option>
                                <option value="YAPE / PLIN">YAPE / PLIN</option>
                                <option value="TARJETA">TARJETA</option>
                                <option value="TRANSFERENCIA">TRANSFERENCIA</option>
                            </select>
                        </div>
                    </div>
                    <button type="submit" class="btn-pay">Confirmar Cobro y Activar Membresía</button>
                </form>
            <% } %>
        </div>
    </div>
</body>
</html>