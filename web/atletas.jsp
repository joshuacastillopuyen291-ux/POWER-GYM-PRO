<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Entidad.Usuario"%>
<%@page import="Entidad.ClienteDTO"%>
<%@page import="Modelo.ClienteModelo"%>
<%@page import="java.util.List"%>
<%
    Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    boolean esEntrenador = "ENTRENADOR".equalsIgnoreCase(user.getRol());
    ClienteModelo cMod = new ClienteModelo();
    Integer idFiltro = esEntrenador ? user.getId() : null;
    List<ClienteDTO> lista = cMod.listarClientes(idFiltro);
    List<Usuario> listaEnt = cMod.listarEntrenadores();

    String exito = (String) request.getAttribute("exito");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>POWER GYM - Padrón de Atletas</title>
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
        .top-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .btn-add { background: #10b981; color: white; padding: 10px 20px; border-radius: 10px; font-weight: 700; border: none; cursor: pointer; display: inline-flex; align-items: center; gap: 8px; text-decoration: none; }
        .btn-add:hover { background: #059669; }
        .btn-excel { background: #0f172a; color: white; padding: 10px 18px; border-radius: 10px; font-weight: 700; border: none; cursor: pointer; display: inline-flex; align-items: center; gap: 8px; text-decoration: none; }
        .btn-excel:hover { background: #1e293b; }

        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 14px 16px; text-align: left; border-bottom: 1px solid #e2e8f0; font-size: 14px; vertical-align: middle; }
        th { background: #0f172a; color: white; font-size: 12px; text-transform: uppercase; font-weight: 800; }
        th:first-child { border-top-left-radius: 10px; }
        th:last-child { border-top-right-radius: 10px; }
        .badge-estado { padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: 800; }
        .badge-activo { background: #dcfce7; color: #15803d; }
        .badge-moroso { background: #fee2e2; color: #b91c1c; }
        .badge-inactivo { background: #e2e8f0; color: #475569; }
        .badge-entrenador { background: #ede9fe; color: #6d28d9; padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: 700; }

        .btn-action { background: #f1f5f9; color: #0f172a; border: 1px solid #cbd5e1; padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 700; cursor: pointer; }
        .btn-action:hover { background: #e2e8f0; }

        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px); align-items: center; justify-content: center; }
        .modal.active { display: flex; }
        .modal-content { background: white; padding: 28px; border-radius: 16px; width: 500px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.2); }
        .form-group { margin-bottom: 14px; }
        label { font-size: 12px; font-weight: 800; color: #475569; text-transform: uppercase; margin-bottom: 4px; display: block; }
        input, select { width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; outline: none; }
        .alert-success { background: #dcfce7; color: #15803d; border: 1px solid #86efac; padding: 12px; border-radius: 8px; font-weight: 700; margin-bottom: 15px; }
        .alert-error { background: #fee2e2; color: #b91c1c; border: 1px solid #fca5a5; padding: 12px; border-radius: 8px; font-weight: 700; margin-bottom: 15px; }
    </style>
</head>
<body>
    <div class="sidebar">
        <div>
            <div class="brand"><i class="ph-bold ph-barbell"></i><span>POWER GYM</span></div>
            <ul class="nav-list">
                <li class="nav-item"><a href="dashboard.jsp"><i class="ph-fill ph-clock"></i><span>Dashboard</span></a></li>
                <li class="nav-item active"><a href="ClienteControlador"><i class="ph-bold ph-users"></i><span><%= esEntrenador ? "Mis Atletas" : "Padrón Atletas" %></span></a></li>
                
                <% if (!esEntrenador) { %>
                    <li class="nav-item"><a href="acceso.jsp"><i class="ph-bold ph-user-focus"></i><span>Control Acceso</span></a></li>
                    <li class="nav-item"><a href="caja.jsp"><i class="ph-bold ph-credit-card"></i><span>Caja Cobranza</span></a></li>
                    <li class="nav-item"><a href="HistorialCajaControlador"><i class="ph-bold ph-wallet"></i><span>Historial de Caja</span></a></li>
                    <li class="nav-item"><a href="planes.jsp"><i class="ph-bold ph-tag"></i><span>Tarifas y Planes</span></a></li>
                <% } %>

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
        <div class="top-bar">
            <div>
                <h1 style="font-size: 26px; font-weight: 800; color: #0f172a;">
                    <%= esEntrenador ? "Mis Atletas Asignados" : "Padrón Oficial de Atletas" %>
                </h1>
                <p style="color: #64748b; font-size: 14px;">
                    <%= esEntrenador ? "Lista de socios bajo su entrenamiento personalizado." : "Administración general de socios, membresías y entrenadores." %>
                </p>
            </div>
            <div style="display: flex; gap: 10px;">
                <a href="ExportarAtletasControlador" class="btn-excel"><i class="ph-bold ph-file-xls"></i> Exportar XLS</a>
                <% if (!esEntrenador) { %>
                    <button type="button" class="btn-add" onclick="abrirModalCrear()"><i class="ph-bold ph-plus-circle"></i> Nuevo Atleta</button>
                <% } %>
            </div>
        </div>

        <% if (exito != null) { %><div class="alert-success"><%= exito %></div><% } %>
        <% if (error != null) { %><div class="alert-error"><%= error %></div><% } %>

        <div class="card-box">
            <table>
                <thead>
                    <tr>
                        <th>Atleta</th>
                        <th>DNI</th>
                        <th>Teléfono / WhatsApp</th>
                        <th>Entrenador Asignado</th>
                        <th>Vencimiento</th>
                        <th>Estado</th>
                        <% if (!esEntrenador) { %><th style="text-align: center;">Acciones</th><% } %>
                    </tr>
                </thead>
                <tbody>
                    <% if (lista != null && !lista.isEmpty()) { 
                        for (ClienteDTO c : lista) {
                            String st = c.getEstado();
                            String badgeClass = "badge-inactivo";
                            if ("ACTIVO".equalsIgnoreCase(st)) badgeClass = "badge-activo";
                            else if ("MOROSO".equalsIgnoreCase(st)) badgeClass = "badge-moroso";
                    %>
                        <tr>
                            <td><strong><%= c.getNombreCompleto() %></strong></td>
                            <td><%= c.getDni() %></td>
                            <td>
                                <% if (c.getTelefono() != null && !c.getTelefono().trim().isEmpty() && !c.getTelefono().equals("-")) { %>
                                    <a href="https://wa.me/51<%= c.getTelefono().trim() %>" target="_blank" style="color: #059669; text-decoration: none; font-weight: 700; display: inline-flex; align-items: center; gap: 4px;">
                                        <i class="ph-bold ph-whatsapp-logo"></i> <%= c.getTelefono() %>
                                    </a>
                                <% } else { %> - <% } %>
                            </td>
                            <td>
                                <% if (c.getNombreEntrenador() != null) { %>
                                    <span class="badge-entrenador"><i class="ph-bold ph-user"></i> <%= c.getNombreEntrenador() %></span>
                                <% } else { %>
                                    <span style="color: #94a3b8; font-size: 13px;">General</span>
                                <% } %>
                            </td>
                            <td><%= (c.getFechaVencimiento() != null) ? c.getFechaVencimiento() : "Sin fecha" %></td>
                            <td>
                                <span class="badge-estado <%= badgeClass %>"><%= c.getEstado() %></span>
                            </td>
                            <% if (!esEntrenador) { %>
                                <td style="text-align: center;">
                                    <button type="button" class="btn-action" onclick="abrirModalEditar(<%= c.getId() %>, '<%= c.getNombreCompleto() %>', '<%= c.getDni() %>', '<%= c.getTelefono() %>', '<%= c.getEmail() %>', '<%= c.getFechaVencimiento() %>', '<%= c.getEstado() %>', '<%= (c.getIdEntrenador() != null) ? c.getIdEntrenador() : "0" %>')">
                                        Editar
                                    </button>
                                </td>
                            <% } %>
                        </tr>
                    <% } } else { %>
                        <tr>
                            <td colspan="<%= esEntrenador ? 6 : 7 %>" style="text-align: center; color: #94a3b8; padding: 30px;">
                                No se encontraron atletas registrados.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- MODAL REGISTRO Y EDICIÓN -->
    <div id="modalCliente" class="modal">
        <div class="modal-content">
            <h3 id="modalTitulo" style="margin-bottom: 16px; font-size: 18px; color: #0f172a;">Registrar Atleta</h3>
            <form action="ClienteControlador" method="POST">
                <input type="hidden" name="accion" id="formAccion" value="crear">
                <input type="hidden" name="txtId" id="formId">

                <div class="form-group">
                    <label>Nombre y Apellidos:</label>
                    <input type="text" name="txtNombre" id="formNombre" required>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                    <div class="form-group">
                        <label>DNI:</label>
                        <input type="text" name="txtDni" id="formDni" required maxlength="8">
                    </div>
                    <div class="form-group">
                        <label>Teléfono:</label>
                        <input type="text" name="txtTelefono" id="formTelefono">
                    </div>
                </div>
                <div class="form-group">
                    <label>Correo Electrónico:</label>
                    <input type="email" name="txtEmail" id="formEmail">
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                    <div class="form-group">
                        <label>Fecha Vencimiento:</label>
                        <input type="date" name="txtFechaVencimiento" id="formVence" required>
                    </div>
                    <div class="form-group">
                        <label>Estado:</label>
                        <select name="cboEstado" id="formEstado">
                            <option value="ACTIVO">ACTIVO</option>
                            <option value="MOROSO">MOROSO</option>
                            <option value="INACTIVO">INACTIVO</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label>Entrenador Personal Asignado:</label>
                    <select name="cboEntrenador" id="formEntrenador">
                        <option value="0">-- Ninguno (Entrenamiento General) --</option>
                        <% if (listaEnt != null) { 
                            for (Usuario u : listaEnt) { 
                        %>
                            <option value="<%= u.getId() %>"><%= u.getNombre() %></option>
                        <% } } %>
                    </select>
                </div>
                <div style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px;">
                    <button type="button" onclick="cerrarModal()" style="padding: 10px 16px; border: 1px solid #cbd5e1; background: #fff; border-radius: 8px; cursor: pointer;">Cancelar</button>
                    <button type="submit" style="padding: 10px 16px; background: #10b981; color: white; border: none; border-radius: 8px; font-weight: 700; cursor: pointer;">Guardar Atleta</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function abrirModalCrear() {
            document.getElementById('modalTitulo').innerText = 'Registrar Nuevo Atleta';
            document.getElementById('formAccion').value = 'crear';
            document.getElementById('formId').value = '';
            document.getElementById('formNombre').value = '';
            document.getElementById('formDni').value = '';
            document.getElementById('formTelefono').value = '';
            document.getElementById('formEmail').value = '';
            document.getElementById('formVence').value = new Date(Date.now() + 30*24*60*60*1000).toISOString().split('T')[0];
            document.getElementById('formEstado').value = 'ACTIVO';
            document.getElementById('formEntrenador').value = '0';
            document.getElementById('modalCliente').classList.add('active');
        }

        function abrirModalEditar(id, nombre, dni, tel, email, vence, estado, entId) {
            document.getElementById('modalTitulo').innerText = 'Editar Datos del Atleta';
            document.getElementById('formAccion').value = 'editar';
            document.getElementById('formId').value = id;
            document.getElementById('formNombre').value = nombre;
            document.getElementById('formDni').value = dni;
            document.getElementById('formTelefono').value = (tel && tel !== 'null' && tel !== '-') ? tel : '';
            document.getElementById('formEmail').value = (email && email !== 'null' && email !== '-') ? email : '';
            document.getElementById('formVence').value = vence;
            document.getElementById('formEstado').value = estado;
            document.getElementById('formEntrenador').value = (entId && entId !== 'null') ? entId : '0';
            document.getElementById('modalCliente').classList.add('active');
        }

        function cerrarModal() {
            document.getElementById('modalCliente').classList.remove('active');
        }
    </script>
</body>
</html>