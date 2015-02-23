<%-- 
    Document   : index
    Created on : 17/02/2014, 03:34:46 PM
    Author     : Americo
--%>

<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="conn.*" %>
<!DOCTYPE html>
<%java.text.DateFormat df = new java.text.SimpleDateFormat("yyyyMMddhhmmss"); %>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("dd/MM/yyyy"); %>
<%

    HttpSession sesion = request.getSession();
    String usua = "";
    String tipo = "";
    if (sesion.getAttribute("nombre") != null) {
        usua = (String) sesion.getAttribute("nombre");
        tipo = (String) sesion.getAttribute("Tipo");
    } else {
        response.sendRedirect("index.jsp");
    }
    ConectionDB con = new ConectionDB();
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Estilos CSS -->
        <link href="css/bootstrap.css" rel="stylesheet">
        <link rel="stylesheet" href="css/cupertino/jquery-ui-1.10.3.custom.css" />
        <link href="css/navbar-fixed-top.css" rel="stylesheet">
        <!---->
        <title>SIALSS</title>
    </head>
    <body>
        <div class="container">
            <h1>SIALSS</h1>
            <h4>Módulo - Sistema de Administración de Almacenes (SAA)</h4>
            
            <%@include file="jspf/menuPrincipal.jspf"%>

            <div class="row">
                <div class="col-sm-12">
                    <h3>Captura de Requerimiento Manual</h3>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    <h4>Seleccione la Punto de Entrega:</h4>
                </div>
                <div class="col-sm-5">
                    <select class="form-control" name="list_provee" onKeyPress="return tabular(event, this)" id="list_provee" onchange="proveedor();">
                        <option value="">Proveedor</option>
                        <%
                            try {
                                con.conectar();
                                ResultSet rset = con.consulta("SELECT F_ClaCli,F_NomCli FROM tb_uniatn");
                                while (rset.next()) {
                        %>
                        <option value="<%=rset.getString("F_ClaCli")%>"><%=rset.getString("F_NomCli")%></option>
                        <%
                                }
                                con.cierraConexion();
                            } catch (Exception e) {
                            }
                        %>
                    </select>
                </div>
            </div>
                    <div class="row">
                        <div class="col-sm-1">
                            <h4>Clave:</h4>
                        </div>
                        <div class="col-sm-2">
                            <input class="form-control" name="Clave" id="Clave" />
                        </div>
                        <div class="col-sm-2">
                            <button >Clave</button>
                        </div>
                    </div>
        </div>
        <br><br><br>
        <div class="navbar navbar-fixed-bottom navbar-inverse">
            <div class="text-center text-muted">
                GNK Logística || Desarrollo de Aplicaciones 2009 - 2014 <span class="glyphicon glyphicon-registration-mark"></span><br />
                Todos los Derechos Reservados
            </div>
        </div>
    </body>
    <!-- 
    ================================================== -->
    <!-- Se coloca al final del documento para que cargue mas rapido -->
    <!-- Se debe de seguir ese orden al momento de llamar los JS -->
    <script src="js/jquery-1.9.1.js"></script>
    <script src="js/bootstrap.js"></script>
    <script src="js/jquery-ui-1.10.3.custom.js"></script>

</html>

