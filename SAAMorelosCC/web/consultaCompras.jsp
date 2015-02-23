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
        response.sendRedirect("index.jsp");
    }
    ConectionDB con = new ConectionDB();

    String fol_gnkl = "", fol_remi = "", orden_compra = "", fecha = "";
    try {
        if (request.getParameter("accion").equals("buscar")) {
            fol_gnkl = request.getParameter("fol_gnkl");
            fol_remi = request.getParameter("fol_remi");
            orden_compra = request.getParameter("orden_compra");
            fecha = request.getParameter("fecha");
        }
    } catch (Exception e) {

    }
    if (fol_gnkl == null) {
        fol_gnkl = "";
        fol_remi = "";
        orden_compra = "";
        fecha = "";
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Estilos CSS -->
        <link href="css/bootstrap.css" rel="stylesheet">
        <link rel="stylesheet" href="css/cupertino/jquery-ui-1.10.3.custom.css" />
        <link href="css/navbar-fixed-top.css" rel="stylesheet">
        <link href="css/datepicker3.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="css/dataTables.bootstrap.css">
        <!---->
        <title>SAA - SISTEMA DE ADMINISTRACIÓN DE ALMACENES</title>
    </head>
    <body>
        <div class="container">
            <h1>SAA</h1>
            <h4>SISTEMA DE ADMINISTRACIÓN DE ALMACENES</h4>
            
            <%@include file="jspf/menuPrincipal.jspf"%>

            <div>
                <h3>Consulta de folios de Compras</h3>
                <h4>Seleccione el folio a Consultar</h4>

                <br />
                <div class="panel panel-primary">
                    <div class="panel-body">
                        <table class="table table-bordered table-striped" id="datosCompras">
                            <thead>
                                <tr>
                                    <td>No. Folio</td>
                                    <td>Folio Remisión</td>
                                    <td>Orden de Compra</td>
                                    <td>Fecha</td>
                                    <td>Usuario</td>
                                    <td>Proveedor</td>
                                    <td>Consulta</td>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        con.conectar();
                                        try {
                                            ResultSet rset = con.consulta("SELECT c.F_ClaDoc, c.F_FolRemi, c.F_OrdCom, c.F_FecApl, c.F_User, p.F_NomPro FROM tb_compra c, tb_proveedor p where c.F_ProVee = p.F_ClaProve GROUP BY F_ClaDoc; ");
                                            while (rset.next()) {
                                %>
                                <tr>

                                    <td><%=rset.getString(1)%></td>
                                    <td><%=rset.getString(2)%></td>
                                    <td><%=rset.getString(3)%></td>
                                    <td><%=df3.format(df2.parse(rset.getString(4)))%></td>
                                    <td><%=rset.getString(5)%></td>
                                    <td><%=rset.getString(6)%></td>
                                    <td>
                                        <form action="consultaCompras.jsp" method="Post">
                                            <input class="hidden" name="F_ClaDoc" value="<%=rset.getString(1)%>">
                                            <button class="btn btn-block btn-primary">Consultar</button>
                                        </form>
                                    </td>
                                </tr>
                                <%
                                            }
                                        } catch (Exception e) {

                                        }
                                        con.cierraConexion();
                                    } catch (Exception e) {

                                    }
                                %>
                            </tbody>
                        </table>

                    </div>
                </div>
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        Consulta del folio 
                    </div>
                    <div class="panel-body">
                        <table class="table table-striped table-condensed table-bordered">
                            <tr>
                                <td>Clave</td>
                                <td>Descripción</td>
                                <td>Lote</td>
                                <td>Caducidad</td>
                                <td>Tarimas</td>
                                <td>Cajas</td>
                                <td>Cant x Caja</td>
                                <td>Cantidad</td>
                                <td>Costo U.</td>
                                <td>Importe</td>
                            </tr>
                            <%
                                try {
                                    con.conectar();
                                    ResultSet rset = con.consulta("SELECT P.F_NomPro, C.F_ClaDoc, C.F_ClaPro, M.F_DesPro, L.F_ClaLot, DATE_FORMAT(F_FecCad, '%d/%m/%Y') AS F_FecCad, C.F_Pz, C.F_Cajas, C.F_Resto, C.F_CanCom, C.F_Costo, C.F_ComTot, (@csum:= @csum+F_ComTot) AS totales FROM (SELECT @csum := 0) r, tb_compra C INNER JOIN tb_lote L ON C.F_Lote = L.F_FolLot INNER JOIN tb_medica M ON C.F_ClaPro = M.F_ClaPro INNER JOIN tb_proveedor P ON C.F_ProVee = P.F_ClaProve WHERE C.F_ClaDoc = '" + request.getParameter("F_ClaDoc") + "' group by L.F_ClaLot;");
                                    while (rset.next()) {
                                        int cantXCaja = Integer.parseInt(rset.getString(10)) / Integer.parseInt(rset.getString(8));
                            %>
                            <tr>
                                <td><%=rset.getString(3)%></td>
                                <td><%=rset.getString(4)%></td>
                                <td><%=rset.getString(5)%></td>
                                <td><%=rset.getString(6)%></td>
                                <td><%=rset.getString(9)%></td>
                                <td><%=rset.getString(8)%></td>
                                <td><%=cantXCaja%></td>
                                <td><%=rset.getString(10)%></td>
                                <td><%=rset.getString(11)%></td>
                                <td><%=rset.getString(12)%></td>
                            </tr>
                            <%
                                    }
                                    con.cierraConexion();
                                } catch (Exception e) {
                                    System.out.println(e.getMessage());
                                }
                            %>

                        </table>

                    </div>
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
</html>


<!-- 
================================================== -->
<!-- Se coloca al final del documento para que cargue mas rapido -->
<!-- Se debe de seguir ese orden al momento de llamar los JS -->
<script src="js/jquery-1.9.1.js"></script>
<script src="js/bootstrap.js"></script>
<script src="js/jquery-ui-1.10.3.custom.js"></script>
<script src="js/bootstrap-datepicker.js"></script>
<script src="js/jquery.dataTables.js"></script>
<script src="js/dataTables.bootstrap.js"></script>
<script>
    $(document).ready(function() {
        $('#datosCompras').dataTable();
    });
</script>