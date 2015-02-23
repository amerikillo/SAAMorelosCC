<%@page import="java.sql.ResultSet"%>
<%@page import="conn.ConectionDB"%>
<%

    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment;filename=\"ordenNoEntrega.xls\"");
%>
<table border="1">
    <tr>
        <td>Documento</td>
        <td>Proveedor</td>
        <td>Fecha</td>
        <td>Hora</td>
        <td>Clave</td>
        <td>Lote</td>
        <td>Caducidad</td>
        <td>Cant Recibida</td>
        <td>Costo</td>
        <td>IVA</td>
        <td>Importe</td>
        <td>Remision</td>
        <td>O. C.</td>
        <td>Entrega</td>
    </tr>
    <%        try {
            ConectionDB con = new ConectionDB();
            con.conectar();
            ResultSet rset = con.consulta("SELECT c.F_ClaDoc, p.F_NomPro, c.F_FecApl, c.F_Hora, c.F_ClaPro, c.F_CanCom, c.F_Costo, c.F_ImpTo, c.F_ComTot, c.F_FolRemi, c.F_OrdCom, i.F_Priori, l.F_ClaLot, l.F_FecCad from tb_compra c, tb_proveedor p, tb_pedidoisem i, tb_lote l where c.F_Lote = l.F_FolLot and c.F_OrdCom = i.F_NoCompra and c.F_ProVee = p.F_ClaProve group by c.F_IdCom");
            while (rset.next()) {


    %>
    <tr>
        <td><%=rset.getString(1)%></td>
        <td><%=rset.getString(2)%></td>
        <td><%=rset.getString(3)%></td>
        <td><%=rset.getString(4)%></td>
        <td><%=rset.getString(5)%></td>
        <td><%=rset.getString("F_ClaLot")%></td>
        <td><%=rset.getString("F_FecCad")%></td>
        <td><%=rset.getString(6)%></td>
        <td><%=rset.getString(7)%></td>
        <td><%=rset.getString(8)%></td>
        <td><%=rset.getString(9)%></td>
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