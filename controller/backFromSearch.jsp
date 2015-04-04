<HTML>
<BODY>

<%@page import="java.sql.*" %>
<% 
if(((Boolean)session.getAttribute("isOracleLogin")) && ((Boolean)session.getAttribute("isUserLogin"))){
		String classtype =  (String)session.getAttribute("classtype");
		out.println("<div style='background: url(../theme.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
		out.println("<script language=javascript type=text/javascript>");
		if (classtype.equals("a"))
			out.println("setTimeout("+"\"javascript:location.href='../view/administrator.html'\""+", 0);");
		else if (classtype.equals("d"))
			out.println("setTimeout("+"\"javascript:location.href='../view/doctor.html'\""+", 0);");
		else if (classtype.equals("r"))
			out.println("setTimeout("+"\"javascript:location.href='../view/radiologist.html'\""+", 0);");
		else if (classtype.equals("p"))
			out.println("setTimeout("+"\"javascript:location.href='../view/patient.html'\""+", 0);");
		out.println("</script></div>");
} else {
	if ((Boolean)session.getAttribute("isOracleLogin")){
		out.println("<br><br><br><br><br><p><CENTER><b><b><b><h1>You didn't login RIS!</h1></b><b><b></CENTER></p>");
		out.println("<script language=javascript type=text/javascript>");
		out.println("setTimeout("+"\"javascript:location.href='../view/login.html'\""+", 2500);");
		out.println("</script>");
	}
	
	else{
		out.println("<br><br><br><br><br><p><CENTER><b><b><b><h1>You didn't login the oracle database!</h1></b><b><b></CENTER></p>");
		out.println("<script language=javascript type=text/javascript>");
		out.println("setTimeout("+"\"javascript:location.href='../index.html'\""+", 2500);");
		out.println("</script>");
	}
}
%>



</BODY>
</HTML>

