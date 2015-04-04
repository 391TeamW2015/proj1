<HTML>
<BODY>

<%@page import="java.sql.*" %>
<% 
		if(request.getParameter("LogOut") != null)
        {
			//delete the attributes
			session.setAttribute("SQLUSERID",null);
			session.setAttribute("SQLPASSWD",null);
			Boolean isOracleLogin = false;
			session.setAttribute("isOracleLogin",isOracleLogin);
					
			out.println("<center><br><br><br><br><br><br><hr><h1>User logged out. </h1></center><hr>");;
			out.println("<script language=javascript type=text/javascript>");
			out.println("setTimeout("+"\"javascript:location.href='../login.html'\""+", 2500);");
		    out.println("</script>");
        }
%>



</BODY>
</HTML>

