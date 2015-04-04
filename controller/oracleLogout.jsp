<HTML>
<HEAD>


<TITLE>Ocacle Login Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*" %>
<% 
	if(request.getParameter("oLogOut") != null)
        {
			//delete the attributes
			session.setAttribute("SQLUSERID",null);
			session.setAttribute("SQLPASSWD",null);
			Boolean isOracleLogin = false;
			session.setAttribute("isOracleLogin",isOracleLogin);
					
			out.println("<center><br><br><br><br><br><br><hr><h1>Oracle database Logged out. </h1></center><hr>");;
			out.println("<script language=javascript type=text/javascript>");
			out.println("setTimeout("+"\"javascript:location.href='../index.html'\""+", 2500);");
		    out.println("</script>");
        }
%>

</BODY>
</HTML>

