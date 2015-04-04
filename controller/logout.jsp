<HTML>
<BODY>

<%@page import="java.sql.*" %>
<% 
		if(request.getParameter("LogOut") != null)
        {
			//delete the attributes
			Boolean isUserLogin = false;
			session.setAttribute("isUserLogin",isUserLogin);
					
			out.println("<center><br><br><br><br><br><br><hr><h1>User logged out. </h1></center><hr>");;
			out.println("<script language=javascript type=text/javascript>");
			out.println("setTimeout("+"\"javascript:location.href='../view/login.html'\""+", 50);");
		    out.println("</script>");
        }
%>



</BODY>
</HTML>

