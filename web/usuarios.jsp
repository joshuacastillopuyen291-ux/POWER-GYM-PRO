<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Entidad.Usuario"%>
<%@page import="Modelo.UsuarioModelo"%>
<%@page import="java.util.List"%>
<%
    Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
    if (user == null || !"ADMIN".equalsIgnoreCase(user.getRol())) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Usuario> lista = (List<Usuario>) request.getAttribute("listaUsuarios");
    if (lista == null) {
        UsuarioModelo uMod = new UsuarioModelo();
        lista = uMod.listarUsuarios();
    }

    String exito = (String) request.getAttribute("exito");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>POWER GYM - Gestión de Personal</title>
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; }
        body { background-color: #f1f5f9; display: flex; min-height: 100vh; }
        
        /* SIDEBAR */
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
        
        /* MAIN CONTENT */
        .main-content { flex: 1; padding: 40px 48px; overflow-y: auto; }
        .card-box { background: white; padding: 28px; border-radius: 18px; border: 1px solid #e2e8f0; box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.06); margin-bottom: 25px; }
        .form-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-top: 15px; }
        label { font-size: 12px; font-weight: 800; color: #475569; text-transform: uppercase; margin-bottom: 6px; display: block; }
        input, select { width: 100%; padding: 12px; border: 1px solid #cbd5e1; border-radius: 10px; font-size: 14px; font-weight: 600; outline: none; background: #f8fafc; }
        input:focus, select:focus { border-color: #6366f1; background: #fff; }
        .btn-submit { background: #0f172a; color: white; border: none; padding: 14px; font-size: 14px; font-weight: 800; border-radius: 10px; cursor: pointer; grid-column: span 4; margin-top: 8px; }
        .btn-submit:hover { background: #1e293b; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 15px; font-size: 14px; }
        th, td { padding: 14px 16px; text-align: left; border-bottom: 1px solid #e2e8f0; vertical-align: middle; }
        th { background: #0f172a; color: #ffffff; font-size: 12px; text-transform: uppercase; font-weight: 800; }
        th:first-child { border-top-left-radius: 10px; }
        th:last-child { border-top-right-radius: 10px; }
        
        .badge-rol { padding: 4px 10px; border-radius: 14px; font-size: 11px; font-weight: 800; background: #e0e7ff; color: #4338ca; }
        .alert-success { background: #dcfce7; color: #15803d; border: 1px solid #86efac; padding: 12px 16px; border-radius: 10px; font-weight: 700; margin-bottom: 20px; }
        .alert-error { background: #fee2e2; color: #b91c1c; border: 1px solid #fca5a5; padding: 12px 16px; border-radius: 10px; font-weight: 700; margin-bottom: 20px; }
        
        /* PASSWORD VIEWER */
        .pass-cell { display: inline-flex; align-items: center; gap: 8px; background: #f8fafc; padding: 6px 12px; border-radius: 8px; border: 1px solid #e2e8f0; }
        .pass-text { font-family: monospace; font-size: 14px; letter-spacing: 2px; font-weight: 800; color: #0f172a; min-width: 90px; }
        .btn-eye { background: none; border: none; cursor: pointer; color: #64748b; font-size: 18px; display: flex; align-items: center; }
        .btn-eye:hover { color: #6366f1; }
        
        /* BOTONES DE ACCIÓN */
        .btn-action-edit { background: #f1f5f9; color: #0f172a; border: 1px solid #cbd5e1; padding: 6px 12px; border-radius: 8px; font-size: 12px; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; }
        .btn-action-edit:hover { background: #e2e8f0; }
        .btn-action-key { background: #fef3c7; color: #b45309; border: 1px solid #fde68a; padding: 6px 12px; border-radius: 8px; font-size: 12px; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; }
        .btn-action-key:hover { background: #fde68a; }

        /* MODALES */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px); align-items: center; justify-content: center; }
        .modal.active { display: flex; }
        .modal-content { background: white; padding: 28px; border-radius: 16px; width: 440px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.2); }
        .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .modal-header h3 { font-size: 18px; font-weight: 800; color: #0f172a; }
        .close-modal { background: none; border: none; font-size: 20px; cursor: pointer; color: #94a3b8; }
        .close-modal:hover { color: #0f172a; }
        .btn-modal-save { background: #10b981; color: white; border: none; padding: 12px; font-size: 14px; font-weight: 700; border-radius: 8px; width: 100%; cursor: pointer; margin-top: 15px; }
        .btn-modal-save:hover { background: #059669; }
    </style>
</head>
<body>

    <!-- SIDEBAR -->
    <div class="sidebar">
        <div>
            <div class="brand"><i class="ph-bold ph-barbell"></i><span>POWER GYM</span></div>
            <ul class="nav-list">
                <li class="nav-item"><a href="dashboard.jsp"><i class="ph-fill ph-clock"></i><span>Dashboard</span></a></li>
                <li class="nav-item"><a href="ClienteControlador"><i class="ph-bold ph-users"></i><span>Padrón Atletas</span></a></li>
                <li class="nav-item"><a href="acceso.jsp"><i class="ph-bold ph-user-focus"></i><span>Control Acceso</span></a></li>
                <li class="nav-item"><a href="caja.jsp"><i class="ph-bold ph-credit-card"></i><span>Caja Cobranza</span></a></li>
                <li class="nav-item"><a href="HistorialCajaControlador"><i class="ph-bold ph-wallet"></i><span>Historial de Caja</span></a></li>
                <li class="nav-item active"><a href="UsuarioControlador"><i class="ph-bold ph-shield-check"></i><span>Gestión Personal</span></a></li>
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

    <!-- MAIN CONTENT -->
    <div class="main-content">
        <h1 style="font-size: 26px; font-weight: 800; color: #0f172a; margin-bottom: 20px;">Gestión de Personal</h1>

        <% if (exito != null) { %><div class="alert-success"><%= exito %></div><% } %>
        <% if (error != null) { %><div class="alert-error"><%= error %></div><% } %>

        <!-- CREAR USUARIO -->
        <div class="card-box">
            <h3 style="font-size: 16px; font-weight: 800; color: #0f172a;">Crear Nuevo Usuario y Asignar Rol</h3>
            <p style="color: #64748b; font-size: 13px; margin-top: 4px;">Registre las credenciales y defina las facultades de acceso del colaborador:</p>
            <form action="UsuarioControlador" method="POST">
                <input type="hidden" name="accion" value="crear">
                <div class="form-grid">
                    <div>
                        <label>Nombre y Apellido:</label>
                        <input type="text" name="txtNombre" placeholder="Ej: Mario Vargas" required>
                    </div>
                    <div>
                        <label>Nombre de Usuario:</label>
                        <input type="text" name="txtUsuario" placeholder="Ej: mvargas" required>
                    </div>
                    <div>
                        <label>Contraseña:</label>
                        <input type="password" name="txtPassword" placeholder="••••••••" required>
                    </div>
                    <div>
                        <label>Rol Asignado:</label>
                        <select name="cboRol">
                            <option value="CAJERO">CAJERO</option>
                            <option value="ENTRENADOR">ENTRENADOR</option>
                            <option value="ADMIN">ADMIN</option>
                        </select>
                    </div>
                    <button type="submit" class="btn-submit">Guardar Nuevo Usuario</button>
                </div>
            </form>
        </div>

        <!-- LISTA DE USUARIOS -->
        <div class="card-box">
            <h3 style="font-size: 16px; font-weight: 800; color: #0f172a; margin-bottom: 12px;">Usuarios Registrados en el Sistema</h3>
            <table>
                <thead>
                    <tr>
                        <th style="width: 50px;">ID</th>
                        <th>Nombre Completo</th>
                        <th>Usuario</th>
                        <th>Contraseña</th>
                        <th>Rol de Acceso</th>
                        <th style="width: 220px; text-align: center;">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (lista != null) { 
                        for (Usuario u : lista) { 
                            String passReal = (u.getPassword() != null) ? u.getPassword() : "";
                    %>
                        <tr>
                            <td><%= u.getId() %></td>
                            <td><strong><%= u.getNombre() %></strong></td>
                            <td><%= u.getUsuario() %></td>
                            <td>
                                <div class="pass-cell">
                                    <span class="pass-text" id="pass-<%= u.getId() %>" data-pass="<%= passReal %>">••••••••</span>
                                    <button type="button" class="btn-eye" onclick="togglePass(<%= u.getId() %>)" title="Mostrar / Ocultar">
                                        <i class="ph-bold ph-eye" id="eye-<%= u.getId() %>"></i>
                                    </button>
                                </div>
                            </td>
                            <td><span class="badge-rol"><%= u.getRol() %></span></td>
                            <td style="text-align: center;">
                                <button type="button" class="btn-action-edit" onclick="abrirModalEditar(<%= u.getId() %>, '<%= u.getNombre() %>', '<%= u.getUsuario() %>', '<%= u.getRol() %>')">
                                    <i class="ph-bold ph-pencil-simple"></i> Editar
                                </button>
                                <button type="button" class="btn-action-key" onclick="abrirModalPass(<%= u.getId() %>, '<%= u.getUsuario() %>')">
                                    <i class="ph-bold ph-key"></i> Clave
                                </button>
                            </td>
                        </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- MODAL EDITAR DATOS USUARIO -->
    <div id="modalEditar" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Editar Usuario</h3>
                <button type="button" class="close-modal" onclick="cerrarModales()">&times;</button>
            </div>
            <form action="UsuarioControlador" method="POST">
                <input type="hidden" name="accion" value="editar_datos">
                <input type="hidden" name="txtId" id="editId">
                <div style="margin-bottom: 12px;">
                    <label>Nombre Completo:</label>
                    <input type="text" name="txtNombre" id="editNombre" required>
                </div>
                <div style="margin-bottom: 12px;">
                    <label>Nombre de Usuario:</label>
                    <input type="text" name="txtUsuario" id="editUsuario" required>
                </div>
                <div style="margin-bottom: 12px;">
                    <label>Rol Asignado:</label>
                    <select name="cboRol" id="editRol">
                        <option value="CAJERO">CAJERO</option>
                        <option value="ENTRENADOR">ENTRENADOR</option>
                        <option value="ADMIN">ADMIN</option>
                    </select>
                </div>
                <button type="submit" class="btn-modal-save">Actualizar Datos</button>
            </form>
        </div>
    </div>

    <!-- MODAL EDITAR PASSWORD -->
    <div id="modalPass" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Cambiar Contraseña</h3>
                <button type="button" class="close-modal" onclick="cerrarModales()">&times;</button>
            </div>
            <form action="UsuarioControlador" method="POST">
                <input type="hidden" name="accion" value="editar_pass">
                <input type="hidden" name="txtId" id="passId">
                <p style="color: #64748b; font-size: 13px; margin-bottom: 12px;">Modificando acceso para: <strong id="passUsuarioLabel" style="color: #0f172a;"></strong></p>
                <div>
                    <label>Nueva Contraseña:</label>
                    <input type="text" name="txtNuevaPassword" placeholder="Ingrese nueva contraseña..." required>
                </div>
                <button type="submit" class="btn-modal-save">Guardar Nueva Contraseña</button>
            </form>
        </div>
    </div>

    <script>
        // Función para mostrar / ocultar contraseña con el ojito
        function togglePass(id) {
            const span = document.getElementById('pass-' + id);
            const icon = document.getElementById('eye-' + id);
            const real = span.getAttribute('data-pass');

            if (span.innerText === '••••••••') {
                span.innerText = real;
                icon.className = 'ph-bold ph-eye-slash';
            } else {
                span.innerText = '••••••••';
                icon.className = 'ph-bold ph-eye';
            }
        }

        // Modales
        function abrirModalEditar(id, nombre, usuario, rol) {
            document.getElementById('editId').value = id;
            document.getElementById('editNombre').value = nombre;
            document.getElementById('editUsuario').value = usuario;
            document.getElementById('editRol').value = rol;
            document.getElementById('modalEditar').classList.add('active');
        }

        function abrirModalPass(id, usuario) {
            document.getElementById('passId').value = id;
            document.getElementById('passUsuarioLabel').innerText = usuario;
            document.getElementById('modalPass').classList.add('active');
        }

        function cerrarModales() {
            document.getElementById('modalEditar').classList.remove('active');
            document.getElementById('modalPass').classList.remove('active');
        }

        window.onclick = function(e) {
            if (e.target.classList.contains('modal')) {
                cerrarModales();
            }
        }
    </script>
</body>
</html>