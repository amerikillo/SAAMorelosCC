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
    String usua = "", tipo = "";
    if (sesion.getAttribute("nombre") != null) {
        usua = (String) sesion.getAttribute("nombre");
        tipo = (String) sesion.getAttribute("Tipo");
    } else {
        response.sendRedirect("../index.jsp");
    }
    ConectionDB con = new ConectionDB();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>SIALSS</title>
        <!-- Estilos CSS -->
        <link href="../css/bootstrap.css" rel="stylesheet">
        <link rel="stylesheet" href="../css/cupertino/jquery-ui-1.10.3.custom.css" />
        <link href="../css/navbar-fixed-top.css" rel="stylesheet">
        <!---->
    </head>
    <body>
        <div class="container">

            <h1>SIALSS</h1>
            <h4>Módulo - Sistema de Administración de Almacenes (SAA)</h4>
            
            <%@include file="jspf/menuPrincipal.jspf"%>

            <div>
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h3 class="panel-title">Carga de Requerimientos - Rurales</h3>
                    </div>
                    <div class="panel-body ">
                        <!-- FileUploadServlet -->
                        <form method="post" class="jumbotron"  action="../CargaExcelRural" enctype="multipart/form-data" name="form1">
                            <div class="form-group">
                                <div class="form-group">
                                    <div class="col-lg-4 text-success">
                                        <h4>Seleccione el Excel a Cargar (.xlsx)</h4>
                                    </div>
                                    <!--label for="Clave" class="col-xs-2 control-label">Clave*</label>
                                    <div class="col-xs-2">
                                        <input type="text" class="form-control" id="Clave" name="Clave" placeholder="Clave" onKeyPress="return tabular(event, this)" autofocus >
                                    </div-->
                                    <label for="Nombre" class="col-xs-2 control-label">Nombre Archivo*</label>
                                    <div class="col-sm-5">
                                        <input class="form-control" type="file" name="file1" id="file1" accept=".xlsx"/>                                    
                                    </div>
                                </div>
                            </div>
                            <button class="btn btn-block btn-primary" type="submit" name="accion" value="guardar" onclick="return valida_alta();"> Cargar Archivo</button>
                        </form>
                        <div style="display: none;" class="text-center" id="Loader">
                            <img src="imagenes/ajax-loader-1.gif" height="150" />
                        </div>
                        <div>
                            <h6>Los campos marcados con * son obligatorios</h6>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
