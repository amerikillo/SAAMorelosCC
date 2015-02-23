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
    String fecha = "", noCompra = "", Proveedor = "";
    try {
        fecha = request.getParameter("Fecha");
    } catch (Exception e) {
    }
    try {
        noCompra = request.getParameter("NoCompra");
    } catch (Exception e) {
    }
    try {
        Proveedor = request.getParameter("Proveedor");
    } catch (Exception e) {
    }
    if (fecha == null) {
        fecha = "";
    }
    if (noCompra == null) {
        noCompra = "";
    }
    if (Proveedor == null) {
        Proveedor = "";
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Estilos CSS -->
        <link href="css/bootstrap.css" rel="stylesheet">
        <link href="css/datepicker3.css" rel="stylesheet">
        <link rel="stylesheet" href="css/cupertino/jquery-ui-1.10.3.custom.css" />
        <link href="css/navbar-fixed-top.css" rel="stylesheet">
        <!---->
        <!---->
        <title>SIALSS</title>
    </head>
    <body>
        <div class="container">
            <h1>SIALSS</h1>
            <h4>Módulo - Sistema de Administración de Almacenes (SAA)</h4>
            
            <%@include file="jspf/menuPrincipal.jspf"%>
            <form action="compraAutomatica.jsp" method="post">
                <div class="row">
                    <label class="col-sm-2 text-right">
                        <h4>Número de Compra</h4>
                    </label>
                    <div class="col-sm-2">
                        <input type="text" class="form-control" id="NoCompra" name="NoCompra" value="<%=noCompra%>" />
                    </div>


                </div>

                <br/>
                <div class="row">
                    <div class="col-xs-12">
                        <button class="btn btn-block btn-primary">Buscar</button>
                    </div>
                </div>
            </form>
            <form action="CompraAutomatica" method="get">
                <br/>
                <%
                    try {
                        con.conectar();
                        ResultSet rset = con.consulta("select i.F_NoCompra, i.F_FecSur, i.F_HorSur, p.F_NomPro from tb_pedidoisem i, tb_proveedor p where i.F_Provee = p.F_ClaProve and F_StsPed = '1' and F_NoCompra = '" + noCompra + "' and F_recibido='0'  group by F_NoCompra");
                        while (rset.next()) {
                %>
                <div class="row">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="row">
                                <h4 class="col-sm-1">Folio:</h4>
                                <div class="col-sm-2"><input class="form-control" value="<%=rset.getString(1)%>" readonly="" name="folio" id="folio" /></div>
                            </div>
                            <div class="row">
                                <h4 class="col-sm-12">Proveedor: <%=rset.getString(4)%></h4>
                            </div>
                            <div class="row">
                                <h4 class="col-sm-12">Fecha y Hora de Entrega: <%=df3.format(df2.parse(rset.getString(2)))%> <%=rset.getString(3)%></h4>
                            </div>
                        </div>
                        <div class="panel-body">

                            <%
                                try {
                                    con.conectar();
                                    ResultSet rset2 = con.consulta("select s.F_Clave, m.F_DesPro, s.F_Lote, DATE_FORMAT(F_Cadu, '%d/%m/%Y'), s.F_Cant, F_IdIsem, F_Obser from tb_pedidoisem s, tb_medica m where s.F_Clave = m.F_ClaPro and F_NoCompra = '" + rset.getString(1) + "' and F_StsPed = '1' ");
                                    while (rset2.next()) {
                            %>
                            <h4 class="bg-primary" style="padding: 5px">Insumo <%out.println(rset2.getRow());%> - <%=rset2.getString(1)%> <%=rset2.getString(2)%></h4>
                            <table class="table table-bordered table-condensed table-striped">
                                <tr>
                                    <td><strong>Clave</strong></td>
                                    <td><strong>Descripción</strong></td>
                                    <td><strong>Cod Bar</strong></td>
                                    <td><strong>Lote</strong></td>
                                    <td><strong>Caducidad</strong></td>
                                    <td><strong>Cantidad</strong></td>
                                </tr>
                                <tr>
                                    <td><%=rset2.getString(1)%></td>
                                    <td><%=rset2.getString(2)%></td>
                                    <td>
                                        <input type="text" value="" class="form-control" name="codbar_<%=rset2.getString("F_IdIsem")%>" id="codbar_<%=rset2.getString("F_IdIsem")%>" onclick="AvisaID(this.id)" />
                                    </td>
                                    <td>
                                        <input type="text" value="<%=rset2.getString(3)%>" class="form-control" name="lot_<%=rset2.getString("F_IdIsem")%>" id="lot_<%=rset2.getString("F_IdIsem")%>" onclick="AvisaID(this.id)"/>
                                    </td>
                                    <td>
                                        <input type="text" value="<%=rset2.getString(4)%>" data-date-format="dd/mm/yyyy" class="form-control" name="cad_<%=rset2.getString("F_IdIsem")%>" id="cad_<%=rset2.getString("F_IdIsem")%>" onclick="AvisaID(this.id)" onKeyPress="
                                                return LP_data(event, this)
                                                anade(this, event);
                                                return tabular(event, this);
                                               " maxlength="10"/>
                                    </td>
                                    <td>
                                        <input type="text" value="<%=rset2.getString(5)%>" class="form-control" name="cant_<%=rset2.getString("F_IdIsem")%>" id="cant_<%=rset2.getString("F_IdIsem")%>" onclick="AvisaID(this.id)" readonly=""/>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6">
                                        <textarea class="form-control" readonly><%=rset2.getString(7)%></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6">
                                        <h5><strong>Tarimas Completas</strong></h5>
                                        <div class="row">

                                            <label for="Cajas" class="col-sm-2 control-label">Tarimas</label>
                                            <div class="col-sm-1">
                                                <input type="Cajas" class="form-control" id="TarimasC_<%=rset2.getString("F_IdIsem")%>" name="TarimasC_<%=rset2.getString("F_IdIsem")%>" placeholder="0" onKeyPress="return justNumbers(event);
                                                        return handleEnter(even);" onkeyup="totalPiezas_<%=rset2.getString("F_IdIsem")%>()" onclick="AvisaID(this.id)" />
                                            </div>
                                            <label for="pzsxcaja" class="col-sm-2 control-label">Cajas x Tarima</label>
                                            <div class="col-sm-1">
                                                <input type="pzsxcaja" class="form-control" id="CajasxTC_<%=rset2.getString("F_IdIsem")%>" name="CajasxTC_<%=rset2.getString("F_IdIsem")%>" placeholder="0" onKeyPress="return justNumbers(event);" onkeyup="totalPiezas_<%=rset2.getString("F_IdIsem")%>()" onclick="AvisaID(this.id)" />
                                            </div>
                                            <label for="Resto" class="col-sm-2 control-label">Piezas x Caja</label>
                                            <div class="col-sm-1">
                                                <input type="Resto" class="form-control" id="PzsxCC_<%=rset2.getString("F_IdIsem")%>" name="PzsxCC_<%=rset2.getString("F_IdIsem")%>" placeholder="0" onKeyPress="return justNumbers(event);" onkeyup="totalPiezas_<%=rset2.getString("F_IdIsem")%>()" onclick="AvisaID(this.id)" />
                                            </div>
                                        </div>
                                        <br/>
                                        <h5><strong>Tarimas Incompletas</strong></h5>
                                        <div class="row">

                                            <label for="Cajas" class="col-sm-2 control-label">Tarimas</label>
                                            <div class="col-sm-1">
                                                <input type="Cajas" class="form-control" id="TarimasI_<%=rset2.getString("F_IdIsem")%>" name="TarimasI_<%=rset2.getString("F_IdIsem")%>" placeholder="0" onKeyPress="return justNumbers(event);
                                                        return handleEnter(even);" onkeyup="totalPiezas_<%=rset2.getString("F_IdIsem")%>();" onclick="AvisaID(this.id)" />
                                            </div>
                                            <label for="pzsxcaja" class="col-sm-2 control-label">Cajas x Tarima</label>
                                            <div class="col-sm-1">
                                                <input type="pzsxcaja" class="form-control" id="CajasxTI_<%=rset2.getString("F_IdIsem")%>" name="CajasxTI_<%=rset2.getString("F_IdIsem")%>" placeholder="0" onKeyPress="return justNumbers(event);" onkeyup="totalPiezas_<%=rset2.getString("F_IdIsem")%>();" onclick="AvisaID(this.id)"/>
                                            </div>
                                            <label for="pzsxcaja" class="col-sm-2 control-label">Resto</label>
                                            <div class="col-sm-1">
                                                <input type="pzsxcaja" class="form-control" id="Resto_<%=rset2.getString("F_IdIsem")%>" name="Resto_<%=rset2.getString("F_IdIsem")%>" placeholder="0" onKeyPress="return justNumbers(event);" onkeyup="totalPiezas_<%=rset2.getString("F_IdIsem")%>();" onclick="AvisaID(this.id)"/>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6">
                                        <h5><strong>Totales</strong></h5>
                                        <div class="row">

                                            <label for="Cajas" class="col-sm-2 control-label">Tarimas</label>
                                            <div class="col-sm-1">
                                                <input type="text" class="form-control" id="Tarimas_<%=rset2.getString("F_IdIsem")%>" name="Tarimas_<%=rset2.getString("F_IdIsem")%>" placeholder="0" readonly="" onKeyPress="return justNumbers(event);
                                                        return handleEnter(even);" onkeyup="totalPiezas_<%=rset2.getString("F_IdIsem")%>();" onclick="AvisaID(this.id)" />
                                            </div>
                                            <label for="pzsxcaja" class="col-sm-2 control-label">Cajas</label>
                                            <div class="col-sm-1">
                                                <input type="text" class="form-control" id="Cajas_<%=rset2.getString("F_IdIsem")%>" name="Cajas_<%=rset2.getString("F_IdIsem")%>" placeholder="0" readonly="" onKeyPress="return justNumbers(event);" onkeyup="totalPiezas_<%=rset2.getString("F_IdIsem")%>();" onclick="AvisaID(this.id)"/>
                                            </div>
                                            <label for="Resto" class="col-sm-2 control-label">Piezas</label>
                                            <div class="col-sm-2">
                                                <input type="text" class="form-control" id="Piezas_<%=rset2.getString("F_IdIsem")%>" name="Piezas_<%=rset2.getString("F_IdIsem")%>" placeholder="0" readonly="" onKeyPress="return justNumbers(event);" onkeyup="totalPiezas_<%=rset2.getString("F_IdIsem")%>();" onclick="AvisaID(this.id)" />
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6">
                                        <textarea class="form-control" id="Obser_<%=rset2.getString("F_IdIsem")%>" name="Obser_<%=rset2.getString("F_IdIsem")%>"></textarea>
                                    </td>
                                </tr>
                            </table>
                            <hr/>
                            <%
                                    }
                                    con.cierraConexion();
                                } catch (Exception e) {
                                    out.println(e.getMessage());
                                }
                            %>
                        </div>
                        <div class="panel-footer">
                            <button class="btn btn-block btn-success btn-lg" name="accion" id="accion" value="confirmar" onclick="return validaCompra();">Confirmar Compra</button>
                        </div>
                    </div>

                </div>
                <%
                        }
                    } catch (Exception e) {

                    }
                %>
            </form>
        </div>


        <br><br><br>
        <div class="navbar navbar-inverse">
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
    <script src="js/bootstrap-datepicker.js"></script>
    <script type="text/javascript">
                                function justNumbers(e)
                                {
                                    var keynum = window.event ? window.event.keyCode : e.which;
                                    if ((keynum == 8) || (keynum == 46))
                                        return true;

                                    return /\d/.test(String.fromCharCode(keynum));
                                }
    </script>

    <script language="javascript">
        otro = 0;
        function LP_data(e, esto) {
            var key = (document.all) ? e.keyCode : e.which;//codigo de tecla. 
            if (key < 48 || key > 57)//si no es numero 
                return false//anula la entrada de texto.
            else
                anade(esto);
        }
        function anade(esto) {

            if (esto.value.length > otro) {
                if (esto.value.length == 2) {
                    esto.value += "/";
                }
            }
            if (esto.value.length > otro) {
                if (esto.value.length == 5) {
                    esto.value += "/";
                }
            }
            if (esto.value.length < otro) {
                if (esto.value.length == 2 || esto.value.length == 5) {
                    esto.value = esto.value.substring(0, esto.value.length - 1);
                }
            }
            otro = esto.value.length
        }

    </script> 
    <script>

        /*$(function() {
         $("#Fecha").datepicker();
         $("#Fecha").datepicker('option', {dateFormat: 'dd/mm/yy'});
         });*/

        function AvisaID(id) {
            //alert(id);
        }
        var formatNumber = {
            separador: ",", // separador para los miles
            sepDecimal: '.', // separador para los decimales
            formatear: function(num) {
                num += '';
                var splitStr = num.split('.');
                var splitLeft = splitStr[0];
                var splitRight = splitStr.length > 1 ? this.sepDecimal + splitStr[1] : '';
                var regx = /(\d+)(\d{3})/;
                while (regx.test(splitLeft)) {
                    splitLeft = splitLeft.replace(regx, '$1' + this.separador + '$2');
                }
                return this.simbol + splitLeft + splitRight;
            },
            new : function(num, simbol) {
                this.simbol = simbol || '';
                return this.formatear(num);
            }
        }

        <%
            try {
                con.conectar();
                ResultSet rset = con.consulta("select F_NoCompra from tb_pedidoisem where F_StsPed = '1' and F_NoCompra = '" + noCompra + "'  group by F_NoCompra");
                while (rset.next()) {
                    try {
                        con.conectar();
                        ResultSet rset2 = con.consulta("select s.F_Clave, m.F_DesPro, s.F_Lote, DATE_FORMAT(F_Cadu, '%d/%m/%Y'), s.F_Cant, F_IdIsem from tb_pedidoisem s, tb_medica m where s.F_Clave = m.F_ClaPro and F_NoCompra = '" + rset.getString(1) + "' and F_StsPed = '1' ");
                        while (rset2.next()) {
        %>





        $(function() {
            $("#cad_<%=rset2.getString("F_IdIsem")%>").datepicker();
            $("#cad_<%=rset2.getString("F_IdIsem")%>").datepicker('option', {dateFormat: 'dd/mm/yy'});
        });
        function totalPiezas_<%=rset2.getString("F_IdIsem")%>() {
            var TarimasC = document.getElementById('TarimasC_<%=rset2.getString("F_IdIsem")%>').value;
            var CajasxTC = document.getElementById('CajasxTC_<%=rset2.getString("F_IdIsem")%>').value;
            var PzsxCC = document.getElementById('PzsxCC_<%=rset2.getString("F_IdIsem")%>').value;
            var TarimasI = document.getElementById('TarimasI_<%=rset2.getString("F_IdIsem")%>').value;
            var CajasxTI = document.getElementById('CajasxTI_<%=rset2.getString("F_IdIsem")%>').value;
            var Resto = document.getElementById('Resto_<%=rset2.getString("F_IdIsem")%>').value;
            if (TarimasC === "") {
                TarimasC = 0;
            }
            if (CajasxTC === "") {
                CajasxTC = 0;
            }
            if (PzsxCC === "") {
                PzsxCC = 0;
            }
            if (TarimasI === "") {
                TarimasI = 0;
            }
            if (CajasxTI === "") {
                CajasxTI = 0;
            }
            if (Resto === "") {
                Resto = 0;
            }
            var totalTarimas = parseInt(TarimasC) + parseInt(TarimasI);
            document.getElementById('Tarimas_<%=rset2.getString("F_IdIsem")%>').value = formatNumber.new(totalTarimas);
            var totalCajas = parseInt(CajasxTC) * parseInt(TarimasC) + parseInt(CajasxTI);
            document.getElementById('Cajas_<%=rset2.getString("F_IdIsem")%>').value = formatNumber.new(totalCajas);
            var totalPiezas = parseInt(PzsxCC) * parseInt(totalCajas);
            document.getElementById('Piezas_<%=rset2.getString("F_IdIsem")%>').value = formatNumber.new(totalPiezas + parseInt(Resto));
        }
        <%
                        }
                        con.cierraConexion();
                    } catch (Exception e) {
                        out.println(e.getMessage());
                    }
                }
            } catch (Exception e) {

            }
        %>

        function validaCompra() {
        <%
            try {
                con.conectar();
                ResultSet rset = con.consulta("select F_NoCompra from tb_pedidoisem where F_StsPed = '1' and F_NoCompra = '" + noCompra + "'  group by F_NoCompra");
                while (rset.next()) {
                    try {
                        con.conectar();
                        ResultSet rset2 = con.consulta("select s.F_Clave, m.F_DesPro, s.F_Lote, DATE_FORMAT(F_Cadu, '%d/%m/%Y'), s.F_Cant, F_IdIsem from tb_pedidoisem s, tb_medica m where s.F_Clave = m.F_ClaPro and F_NoCompra = '" + rset.getString(1) + "' and F_StsPed = '1' ");
                        while (rset2.next()) {
        %>
            var codBar_<%=rset2.getString("F_IdIsem")%> = document.getElementById('codbar_<%=rset2.getString("F_IdIsem")%>').value;
            if (codBar_<%=rset2.getString("F_IdIsem")%> === "") {
                alert("Falta Código de Barras");
                document.getElementById('codbar_<%=rset2.getString("F_IdIsem")%>').focus();
                return false;
            }

            var lot_<%=rset2.getString("F_IdIsem")%> = document.getElementById('lot_<%=rset2.getString("F_IdIsem")%>').value;
            if (lot_<%=rset2.getString("F_IdIsem")%> === "" || lot_<%=rset2.getString("F_IdIsem")%> === "-") {
                alert("Falta Lote");
                document.getElementById('lot_<%=rset2.getString("F_IdIsem")%>').focus();
                return false;
            }

            var cad_<%=rset2.getString("F_IdIsem")%> = document.getElementById('cad_<%=rset2.getString("F_IdIsem")%>').value;
            if (cad_<%=rset2.getString("F_IdIsem")%> === "") {
                alert("Falta Caducidad");
                document.getElementById('lot_<%=rset2.getString("F_IdIsem")%>').focus();
                return false;
            } else {
                var dtFechaActual_<%=rset2.getString("F_IdIsem")%> = new Date();
                var sumarDias_<%=rset2.getString("F_IdIsem")%> = parseInt(276);
                dtFechaActual_<%=rset2.getString("F_IdIsem")%>.setDate(dtFechaActual_<%=rset2.getString("F_IdIsem")%>.getDate() + sumarDias_<%=rset2.getString("F_IdIsem")%>);
                var fechaSpl_<%=rset2.getString("F_IdIsem")%> = cad_<%=rset2.getString("F_IdIsem")%>.split("/");
                var Caducidad_<%=rset2.getString("F_IdIsem")%> = fechaSpl_<%=rset2.getString("F_IdIsem")%>[2] + "-" + fechaSpl_<%=rset2.getString("F_IdIsem")%>[1] + "-" + fechaSpl_<%=rset2.getString("F_IdIsem")%>[0];
                /*alert(Caducidad_<%=rset2.getString("F_IdIsem")%>);*/

                if (Date.parse(dtFechaActual_<%=rset2.getString("F_IdIsem")%>) > Date.parse(Caducidad_<%=rset2.getString("F_IdIsem")%>)) {
                    alert("La fecha de caducidad no puede ser menor a 9 meses próximos");
                    document.getElementById('cad_<%=rset2.getString("F_IdIsem")%>').focus();
                    return false;
                }
            }

            var Piezas_<%=rset2.getString("F_IdIsem")%> = document.getElementById('Piezas_<%=rset2.getString("F_IdIsem")%>').value;
            if (Piezas_<%=rset2.getString("F_IdIsem")%> === "" || Piezas_<%=rset2.getString("F_IdIsem")%> === "0") {
                document.getElementById('Piezas_<%=rset2.getString("F_IdIsem")%>').focus();
                alert("Favor de llenar todos los datos");
                return false;
            }



        <%
                        }
                        con.cierraConexion();
                    } catch (Exception e) {
                        out.println(e.getMessage());
                    }
                }
            } catch (Exception e) {

            }
        %>
        }

    </script>

</html>
