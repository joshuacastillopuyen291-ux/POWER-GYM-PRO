<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Entidad.Usuario"%>
<%@page import="Entidad.ClienteDTO"%>
<%
    Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    ClienteDTO atleta = (ClienteDTO) request.getAttribute("atleta");
    String error = (String) request.getAttribute("error");
    String dniBuscado = (request.getParameter("txtDni") != null) ? request.getParameter("txtDni") : "";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>POWER GYM - Control de Acceso</title>
    <!-- Iconos Phosphor -->
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        * { 
            box-sizing: border-box; 
            margin: 0; 
            padding: 0; 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; 
        }
        
        body { 
            background: #f1f5f9; 
            display: flex; 
            min-height: 100vh; 
        }

        /* SIDEBAR */
        .sidebar { 
            width: 260px; 
            background: #0b1329; 
            color: white; 
            display: flex; 
            flex-direction: column; 
            justify-content: space-between; 
            padding: 24px 16px; 
            flex-shrink: 0; 
            box-shadow: 4px 0 20px rgba(0,0,0,0.15);
            z-index: 10;
        }

        .brand { 
            display: flex; 
            align-items: center; 
            gap: 12px; 
            padding-left: 12px; 
            margin-bottom: 32px; 
            font-size: 19px; 
            font-weight: 800; 
            color: #ffffff; 
        }

        .brand i { 
            color: #10b981; 
            font-size: 26px; 
        }

        .nav-list { 
            display: flex; 
            flex-direction: column; 
            gap: 8px; 
            list-style: none; 
        }

        .nav-item a { 
            display: flex; 
            align-items: center; 
            gap: 14px; 
            padding: 12px 16px; 
            color: #94a3b8; 
            text-decoration: none; 
            font-size: 14px; 
            font-weight: 600; 
            border-radius: 10px; 
            transition: all 0.2s ease; 
        }

        .nav-item a:hover { 
            color: #ffffff; 
            background-color: #1e293b; 
        }

        .nav-item.active a { 
            background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%); 
            color: #ffffff; 
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.35);
        }

        .nav-item a i { 
            font-size: 20px; 
        }

        .user-card { 
            background-color: #1e293b; 
            padding: 12px 14px; 
            border-radius: 12px; 
            display: flex; 
            align-items: center; 
            gap: 12px; 
            margin-bottom: 10px; 
        }

        .avatar-box { 
            width: 36px; 
            height: 36px; 
            border-radius: 8px; 
            background-color: #10b981; 
            color: #fff; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-weight: bold; 
        }

        /* MAIN CONTENT */
        .main-content { 
            flex: 1; 
            padding: 40px 48px; 
            overflow-y: auto; 
        }

        .page-header {
            margin-bottom: 28px;
        }

        .page-header h1 {
            font-size: 28px;
            font-weight: 800;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .page-header p {
            color: #64748b;
            font-size: 14px;
            margin-top: 4px;
        }

        /* CAJA DE BÚSQUEDA ELEGANTE CON SOMBRA */
        .search-container { 
            background: #ffffff; 
            padding: 24px 28px; 
            border-radius: 18px; 
            border: 1px solid #e2e8f0; 
            box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.06), 0 8px 10px -6px rgba(15, 23, 42, 0.04); 
            margin-bottom: 30px; 
        }

        .search-title { 
            font-size: 13px; 
            font-weight: 800; 
            color: #475569; 
            text-transform: uppercase; 
            letter-spacing: 0.7px; 
            display: flex; 
            align-items: center; 
            gap: 8px; 
            margin-bottom: 12px; 
        }

        .search-bar { 
            display: flex; 
            gap: 12px; 
        }

        .search-bar input { 
            flex: 1; 
            padding: 14px 20px; 
            border: 2px solid #e2e8f0; 
            border-radius: 12px; 
            font-size: 16px; 
            font-weight: 600; 
            color: #0f172a; 
            outline: none; 
            transition: all 0.2s; 
            background: #f8fafc;
        }

        .search-bar input:focus { 
            border-color: #6366f1; 
            background: #ffffff; 
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.12); 
        }

        .btn-search { 
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); 
            color: #ffffff; 
            border: none; 
            padding: 0 28px; 
            font-size: 15px; 
            font-weight: 700; 
            border-radius: 12px; 
            cursor: pointer; 
            transition: all 0.2s ease; 
            display: flex; 
            align-items: center; 
            gap: 8px; 
            box-shadow: 0 4px 14px rgba(15, 23, 42, 0.25); 
        }

        .btn-search:hover { 
            background: #000000; 
            transform: translateY(-2px); 
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.35); 
        }

        /* TARJETA DE RESULTADO PREMIUM */
        .result-card { 
            background: #ffffff; 
            border-radius: 20px; 
            padding: 34px 38px; 
            border: 1px solid #e2e8f0; 
            box-shadow: 0 20px 35px -10px rgba(15, 23, 42, 0.12), 0 10px 15px -3px rgba(15, 23, 42, 0.05); 
            position: relative; 
            overflow: hidden; 
            animation: fadeIn 0.3s ease-out; 
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(12px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* BORDE SUPERIOR DE COLOR SEGÚN ESTADO */
        .result-card::before { 
            content: ""; 
            position: absolute; 
            top: 0; 
            left: 0; 
            right: 0; 
            height: 6px; 
        }

        .card-activo::before { background: linear-gradient(90deg, #10b981, #34d399); }
        .card-moroso::before { background: linear-gradient(90deg, #ef4444, #f87171); }
        .card-inactivo::before { background: linear-gradient(90deg, #64748b, #94a3b8); }

        .result-header { 
            display: flex; 
            justify-content: space-between; 
            align-items: flex-start; 
            margin-bottom: 24px; 
        }

        .athlete-info h2 { 
            font-size: 26px; 
            font-weight: 800; 
            color: #0f172a; 
            letter-spacing: -0.5px; 
        }

        .athlete-info span { 
            display: inline-block; 
            margin-top: 4px; 
            font-size: 13px; 
            color: #64748b; 
            font-weight: 600; 
        }

        /* BADGES DE ESTADO CON GLOW Y SOMBRA */
        .status-badge { 
            display: inline-flex; 
            align-items: center; 
            gap: 8px; 
            padding: 8px 18px; 
            border-radius: 30px; 
            font-size: 13px; 
            font-weight: 800; 
            letter-spacing: 0.5px; 
            text-transform: uppercase; 
        }

        .badge-activo { 
            background: #dcfce7; 
            color: #15803d; 
            border: 1px solid #86efac; 
            box-shadow: 0 4px 12px rgba(22, 163, 74, 0.2); 
        }

        .badge-moroso { 
            background: #fee2e2; 
            color: #b91c1c; 
            border: 1px solid #fca5a5; 
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.2); 
        }

        .badge-inactivo { 
            background: #f1f5f9; 
            color: #475569; 
            border: 1px solid #cbd5e1; 
        }

        /* CUADRICULA DE DETALLES CON CONTRASTE */
        .details-grid { 
            display: grid; 
            grid-template-columns: repeat(4, 1fr); 
            gap: 16px; 
            margin-top: 20px; 
        }

        .detail-box { 
            background: #f8fafc; 
            border: 1px solid #e2e8f0; 
            padding: 18px 20px; 
            border-radius: 14px; 
            display: flex; 
            flex-direction: column; 
            gap: 6px; 
            box-shadow: inset 0 1px 2px rgba(0,0,0,0.02); 
            transition: all 0.2s; 
        }

        .detail-box:hover { 
            background: #ffffff; 
            border-color: #cbd5e1; 
            box-shadow: 0 4px 12px rgba(0,0,0,0.05); 
        }

        .detail-label { 
            font-size: 11px; 
            font-weight: 800; 
            color: #64748b; 
            text-transform: uppercase; 
            letter-spacing: 0.8px; 
            display: flex; 
            align-items: center; 
            gap: 6px; 
        }

        .detail-label i { 
            font-size: 15px; 
            color: #6366f1; 
        }

        .detail-value { 
            font-size: 16px; 
            font-weight: 800; 
            color: #0f172a; 
        }

        /* BOTÓN DE ACCIÓN / COBRANZA */
        .action-row { 
            margin-top: 28px; 
            padding-top: 22px; 
            border-top: 1px dashed #e2e8f0; 
            display: flex; 
            justify-content: flex-end; 
        }

        .btn-caja { 
            display: inline-flex; 
            align-items: center; 
            gap: 10px; 
            background: linear-gradient(135deg, #10b981 0%, #059669 100%); 
            color: white; 
            text-decoration: none; 
            padding: 14px 26px; 
            border-radius: 12px; 
            font-size: 14px; 
            font-weight: 700; 
            box-shadow: 0 6px 18px rgba(16, 185, 129, 0.35); 
            transition: all 0.2s ease; 
        }

        .btn-caja:hover { 
            transform: translateY(-2px); 
            box-shadow: 0 8px 22px rgba(16, 185, 129, 0.5); 
        }

        .alert-box { 
            background: #fef2f2; 
            border-left: 5px solid #ef4444; 
            color: #991b1b; 
            padding: 16px 20px; 
            border-radius: 12px; 
            font-size: 14px; 
            font-weight: 700; 
            display: flex; 
            align-items: center; 
            gap: 10px; 
            box-shadow: 0 4px 14px rgba(239, 68, 68, 0.08); 
        }
    </style>
</head>
<body>

    <!-- SIDEBAR -->
    <div class="sidebar">
        <div>
            <div class="brand">
                <i class="ph-bold ph-barbell"></i>
                <span>POWER GYM</span>
            </div>
            <ul class="nav-list">
                <li class="nav-item"><a href="dashboard.jsp"><i class="ph-fill ph-clock"></i><span>Dashboard</span></a></li>
                <li class="nav-item"><a href="ClienteControlador"><i class="ph-bold ph-users"></i><span>Padrón Atletas</span></a></li>
                <li class="nav-item active"><a href="acceso.jsp"><i class="ph-bold ph-user-focus"></i><span>Control Acceso</span></a></li>
                <% if (!"ENTRENADOR".equalsIgnoreCase(user.getRol())) { %>
                    <li class="nav-item"><a href="caja.jsp"><i class="ph-bold ph-credit-card"></i><span>Caja Cobranza</span></a></li>
                    <li class="nav-item"><a href="HistorialCajaControlador"><i class="ph-bold ph-wallet"></i><span>Historial de Caja</span></a></li>
                <% } %>
                <% if ("ADMIN".equalsIgnoreCase(user.getRol())) { %>
                    <li class="nav-item"><a href="UsuarioControlador"><i class="ph-bold ph-shield-check"></i><span>Gestión Personal</span></a></li>
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
            <a href="login.jsp" style="display: flex; align-items: center; gap: 8px; color: #ef4444; text-decoration: none; font-size: 13px; font-weight: 600; padding: 8px 12px; border-radius: 8px; background: rgba(239, 68, 68, 0.1);">
                <i class="ph-bold ph-sign-out"></i><span>Cerrar Sesión</span>
            </a>
        </div>
    </div>

    <!-- MAIN PANEL -->
    <div class="main-content">
        <div class="page-header">
            <h1><i class="ph-bold ph-identification-card" style="color: #6366f1;"></i> Control de Acceso y Torniquete</h1>
            <p>Verificación inmediata de vigencia y estado de membresía mediante DNI.</p>
        </div>

        <!-- BUSCADOR -->
        <div class="search-container">
            <div class="search-title">
                <i class="ph-bold ph-magnifying-glass"></i> Consulta de Atleta
            </div>
            <form action="AccesoControlador" method="POST">
                <div class="search-bar">
                    <input type="text" name="txtDni" value="<%= dniBuscado %>" placeholder="Ingrese o escanee el número de DNI del atleta..." required autofocus>
                    <button type="submit" class="btn-search">
                        <i class="ph-bold ph-fingerprint"></i>
                        <span>Consultar Estado</span>
                    </button>
                </div>
            </form>
        </div>

        <!-- MENSAJE DE ERROR -->
        <% if (error != null) { %>
            <div class="alert-box">
                <i class="ph-bold ph-warning-circle" style="font-size: 20px;"></i>
                <span><%= error %></span>
            </div>
        <% } %>

        <!-- TARJETA DE RESULTADO -->
        <% if (atleta != null) { 
            String st = (atleta.getEstado() != null) ? atleta.getEstado().toUpperCase() : "INACTIVO";
            String cardClass = "card-inactivo";
            String badgeClass = "badge-inactivo";
            String iconoEstado = "ph-prohibit";

            if ("ACTIVO".equals(st)) {
                cardClass = "card-activo";
                badgeClass = "badge-activo";
                iconoEstado = "ph-check-circle";
            } else if ("MOROSO".equals(st) || "VENCIDO".equals(st)) {
                cardClass = "card-moroso";
                badgeClass = "badge-moroso";
                iconoEstado = "ph-x-circle";
            }
        %>
            <div class="result-card <%= cardClass %>">
                <div class="result-header">
                    <div class="athlete-info">
                        <h2><%= atleta.getNombreCompleto() %></h2>
                        <span>Atleta Registrado en POWER GYM PRO</span>
                    </div>
                    <div>
                        <span class="status-badge <%= badgeClass %>">
                            <i class="ph-fill <%= iconoEstado %>"></i>
                            <%= st %>
                        </span>
                    </div>
                </div>

                <div class="details-grid">
                    <div class="detail-box">
                        <span class="detail-label"><i class="ph-bold ph-id-card"></i> DNI</span>
                        <span class="detail-value"><%= atleta.getDni() %></span>
                    </div>
                    <div class="detail-box">
                        <span class="detail-label"><i class="ph-bold ph-barbell"></i> Membresía</span>
                        <span class="detail-value"><%= atleta.getTipoMembresia() %></span>
                    </div>
                    <div class="detail-box">
                        <span class="detail-label"><i class="ph-bold ph-calendar-plus"></i> Fecha Inicio</span>
                        <span class="detail-value" style="color: #0369a1;"><%= (atleta.getFechaInicio() != null) ? atleta.getFechaInicio().toString() : "-" %></span>
                    </div>
                    <div class="detail-box">
                        <span class="detail-label"><i class="ph-bold ph-calendar-check"></i> Fecha Vencimiento</span>
                        <span class="detail-value" style="color: #047857;"><%= (atleta.getFechaVencimiento() != null) ? atleta.getFechaVencimiento().toString() : "Sin fecha" %></span>
                    </div>
                </div>

                <% if (!"ACTIVO".equals(st) && !"ENTRENADOR".equalsIgnoreCase(user.getRol())) { %>
                    <div class="action-row">
                        <a href="caja.jsp?dni=<%= atleta.getDni() %>" class="btn-caja">
                            <i class="ph-bold ph-credit-card"></i>
                            <span>Cobrar y Regularizar en Caja</span>
                        </a>
                    </div>
                <% } %>
            </div>
        <% } %>

    </div>

</body>
</html>