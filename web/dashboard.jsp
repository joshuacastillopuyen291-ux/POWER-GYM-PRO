<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Entidad.Usuario"%>
<%@page import="Utils.MysqlDBConexion"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%
    Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    boolean esEntrenador = "ENTRENADOR".equalsIgnoreCase(user.getRol());

    int atletasActivos = 0;
    int atletasMorosos = 0;
    double cajaAcumulada = 0.0;

    Connection cn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        cn = MysqlDBConexion.getConnection();

        // 1. Conteo de atletas
        if (esEntrenador) {
            // Contar únicamente los atletas asignados a este entrenador
            ps = cn.prepareStatement("SELECT estado, COUNT(*) FROM cliente WHERE id_entrenador = ? GROUP BY estado");
            ps.setInt(1, user.getId());
        } else {
            ps = cn.prepareStatement("SELECT estado, COUNT(*) FROM cliente GROUP BY estado");
        }
        rs = ps.executeQuery();
        while (rs.next()) {
            String est = rs.getString(1);
            int cant = rs.getInt(2);
            if ("ACTIVO".equalsIgnoreCase(est)) {
                atletasActivos = cant;
            } else if ("MOROSO".equalsIgnoreCase(est)) {
                atletasMorosos = cant;
            }
        }
        rs.close();
        ps.close();

        // 2. Caja acumulada (solo visible/calculable si no es entrenador)
        if (!esEntrenador) {
            ps = cn.prepareStatement("SELECT COALESCE(SUM(monto), 0.0) FROM pago");
            rs = ps.executeQuery();
            if (rs.next()) {
                cajaAcumulada = rs.getDouble(1);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (cn != null) cn.close();
        } catch (Exception ignored) {}
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>POWER GYM - Panel de Control</title>
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; }
        body { background-color: #f1f5f9; display: flex; min-height: 100vh; }

        /* BARRA LATERAL */
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
        .btn-logout { display: flex; align-items: center; gap: 8px; color: #ef4444; text-decoration: none; font-size: 13px; font-weight: 600; padding: 8px 12px; border-radius: 8px; background: rgba(239, 68, 68, 0.1); }
        .btn-logout:hover { background: rgba(239, 68, 68, 0.2); }

        /* CONTENIDO PRINCIPAL */
        .main-content { flex: 1; padding: 40px 48px; overflow-y: auto; }
        .header-title h1 { font-size: 26px; font-weight: 800; color: #0f172a; margin-bottom: 4px; }
        .header-title p { color: #64748b; font-size: 14px; margin-bottom: 28px; }

        /* KPI METRICS */
        .kpi-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; margin-bottom: 35px; }
        .kpi-card { background: white; border-radius: 16px; padding: 22px 24px; border: 1px solid #e2e8f0; box-shadow: 0 4px 12px rgba(0,0,0,0.03); display: flex; justify-content: space-between; align-items: center; }
        .kpi-info span { font-size: 12px; font-weight: 800; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px; }
        .kpi-info h2 { font-size: 32px; font-weight: 800; color: #0f172a; margin-top: 6px; }
        .kpi-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 24px; }
        .kpi-green { background: #dcfce7; color: #10b981; }
        .kpi-red { background: #fee2e2; color: #ef4444; }
        .kpi-yellow { background: #fef3c7; color: #f59e0b; }

        /* MÓDULOS OPERATIVOS */
        .section-title { font-size: 18px; font-weight: 800; color: #0f172a; margin-bottom: 16px; }
        .modules-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 20px; }
        .module-card { background: white; border-radius: 16px; padding: 24px; border: 1px solid #e2e8f0; text-decoration: none; color: inherit; transition: all 0.2s ease; box-shadow: 0 4px 12px rgba(0,0,0,0.03); display: flex; flex-direction: column; gap: 12px; }
        .module-card:hover { transform: translateY(-3px); box-shadow: 0 10px 25px -5px rgba(0,0,0,0.08); border-color: #cbd5e1; }
        .mod-icon { width: 42px; height: 42px; border-radius: 10px; background: #eef2ff; color: #4f46e5; display: flex; align-items: center; justify-content: center; font-size: 22px; }
        .module-card h3 { font-size: 16px; font-weight: 700; color: #0f172a; }
        .module-card p { font-size: 13px; color: #64748b; line-height: 1.4; }
    </style>
</head>
<body>

    <!-- MENÚ LATERAL SEGREGADO POR ROLES -->
    <div class="sidebar">
        <div>
            <div class="brand">
                <i class="ph-bold ph-barbell"></i>
                <span>POWER GYM</span>
            </div>
            <ul class="nav-list">
                <li class="nav-item active">
                    <a href="dashboard.jsp"><i class="ph-fill ph-clock"></i><span>Dashboard</span></a>
                </li>
                
                <li class="nav-item">
                    <a href="ClienteControlador">
                        <i class="ph-bold ph-users"></i>
                        <span><%= esEntrenador ? "Mis Atletas" : "Padrón Atletas" %></span>
                    </a>
                </li>

                <%-- Control Acceso, Caja e Historial solo para ADMIN y CAJERO --%>
                <% if (!esEntrenador) { %>
                    <li class="nav-item">
                        <a href="acceso.jsp"><i class="ph-bold ph-user-focus"></i><span>Control Acceso</span></a>
                    </li>
                    <li class="nav-item">
                        <a href="caja.jsp"><i class="ph-bold ph-credit-card"></i><span>Caja Cobranza</span></a>
                    </li>
                    <li class="nav-item">
                        <a href="HistorialCajaControlador"><i class="ph-bold ph-wallet"></i><span>Historial de Caja</span></a>
                    </li>
                <% } %>

                <%-- Gestión de personal solo para ADMIN --%>
                <% if ("ADMIN".equalsIgnoreCase(user.getRol())) { %>
                    <li class="nav-item">
                        <a href="UsuarioControlador"><i class="ph-bold ph-shield-check"></i><span>Gestión Personal</span></a>
                    </li>
                <% } %>
            </ul>
        </div>

        <div>
            <div class="user-card">
                <div class="avatar-box"><%= user.getNombre().substring(0, 1).toUpperCase() %></div>
                <div style="overflow: hidden;">
                    <div style="font-size: 13px; font-weight: 700;"><%= user.getNombre() %></div>
                    <div style="font-size: 11px; color: #10b981;"><%= user.getRol() %></div>
                </div>
            </div>
            <a href="login.jsp" class="btn-logout">
                <i class="ph-bold ph-sign-out"></i>
                <span>Cerrar Sesión</span>
            </a>
        </div>
    </div>

    <!-- CUERPO PRINCIPAL -->
    <div class="main-content">
        <div class="header-title">
            <h1>Panel de Control Operativo</h1>
            <p>
                <%= esEntrenador 
                    ? "Bienvenido al área técnica deportiva de POWER GYM PRO." 
                    : "Bienvenido al sistema de gestión comercial de POWER GYM PRO." %>
            </p>
        </div>

        <!-- TARJETAS SUPERIORES (KPI) -->
        <div class="kpi-grid">
            <div class="kpi-card">
                <div class="kpi-info">
                    <span><%= esEntrenador ? "Mis Atletas Activos" : "Atletas Activos" %></span>
                    <h2><%= atletasActivos %></h2>
                </div>
                <div class="kpi-icon kpi-green"><i class="ph-bold ph-user-check"></i></div>
            </div>

            <div class="kpi-card">
                <div class="kpi-info">
                    <span><%= esEntrenador ? "Mis Atletas Morosos" : "Atletas Morosos" %></span>
                    <h2><%= atletasMorosos %></h2>
                </div>
                <div class="kpi-icon kpi-red"><i class="ph-bold ph-user-minus"></i></div>
            </div>

            <% if (!esEntrenador) { %>
                <div class="kpi-card">
                    <div class="kpi-info">
                        <span>Caja Acumulada</span>
                        <h2>S/. <%= String.format("%.0f", cajaAcumulada) %></h2>
                    </div>
                    <div class="kpi-icon kpi-yellow"><i class="ph-bold ph-money"></i></div>
                </div>
            <% } %>
        </div>

        <!-- ACCESOS RÁPIDOS ADAPTADOS SEGÚN EL ROL -->
        <h2 class="section-title">Módulos de Gestión</h2>
        <div class="modules-grid">
            <a href="ClienteControlador" class="module-card">
                <div class="mod-icon"><i class="ph-bold ph-users"></i></div>
                <h3><%= esEntrenador ? "Mis Atletas Asignados" : "Padrón General" %></h3>
                <p><%= esEntrenador 
                        ? "Consulta tus atletas de entrenamiento personalizado y contáctalos vía WhatsApp." 
                        : "Consulta estados, exporta a PDF/Excel y gestiona las membresías vigentes." %></p>
            </a>

            <% if (!esEntrenador) { %>
                <a href="acceso.jsp" class="module-card">
                    <div class="mod-icon"><i class="ph-bold ph-user-focus"></i></div>
                    <h3>Control Acceso</h3>
                    <p>Verificación instantánea por documento de identidad para el ingreso a sala.</p>
                </a>

                <a href="caja.jsp" class="module-card">
                    <div class="mod-icon"><i class="ph-bold ph-credit-card"></i></div>
                    <h3>Caja Cobranza</h3>
                    <p>Renueva membresías, procesa pagos inmediatos y emite tickets de cobro.</p>
                </a>

                <a href="HistorialCajaControlador" class="module-card">
                    <div class="mod-icon"><i class="ph-bold ph-wallet"></i></div>
                    <h3>Historial de Caja</h3>
                    <p>Audita cada transacción registrada con reportes detallados y trazabilidad.</p>
                </a>
            <% } %>
        </div>
    </div>

</body>
</html>