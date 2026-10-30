<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>

<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Iniciar Sesión - FIT-GYM</title>

<style>

body {

font-family: Arial, sans-serif;

margin: 0;

padding: 0;

display: flex;

justify-content: center;

align-items: center;

height: 100vh;

background: linear-gradient(rgba(26, 68, 108, 0.75), rgba(20, 30, 48, 0.85)),

url('https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=1920') no-repeat center center fixed;

background-size: cover;

}


.login-container {

background-color: rgba(255, 255, 255, 0.95);

width: 100%;

max-width: 480px;

padding: 50px 40px;

border-radius: 12px;

box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);

box-sizing: border-box;

}


.login-container h2 {

text-align: center;

color: #1a446c;

margin-top: 0;

margin-bottom: 12px;

font-size: 32px;

}


.login-container p {

text-align: center;

color: #555;

font-size: 16px;

margin-bottom: 35px;

}


.form-group {

margin-bottom: 25px;

}


.form-group label {

display: block;

font-weight: bold;

margin-bottom: 10px;

color: #333;

font-size: 15px;

}


.form-group input {

width: 100%;

padding: 15px 12px;

border: 1px solid #dcdcdc;

border-radius: 6px;

box-sizing: border-box;

background-color: #f9fbfd;

font-size: 15px;

}


.btn-login {

width: 100%;

background-color: #1a446c;

color: white;

border: none;

padding: 16px;

border-radius: 6px;

font-weight: bold;

cursor: pointer;

font-size: 18px;

margin-top: 15px;

transition: background 0.2s;

}


.btn-login:hover {

background-color: #133352;

}


.error-msg {

color: #e74c3c;

background-color: #fce4e4;

padding: 12px;

border-radius: 6px;

font-size: 14px;

text-align: center;

margin-bottom: 25px;

font-weight: bold;

}

</style>

</head>

<body>



<div class="login-container">

<h2>FIT-GYM</h2>

<p>Control de Acceso al Sistema</p>



<% if (request.getAttribute("error") != null) { %>

<div class="error-msg">

<%= request.getAttribute("error") %>

</div>

<% } %>



<form action="${pageContext.request.contextPath}/LoginControlador" method="POST">

<div class="form-group">

<label>Usuario:</label>

<input type="text" name="txtUsuario" placeholder="Ingrese su username" required>

</div>



<div class="form-group">

<label>Contraseña:</label>

<input type="password" name="txtPassword" placeholder="Ingrese su contraseña" required>

</div>



<button type="submit" class="btn-login">Iniciar Sesión</button>

</form>

</div>



</body>

</html>