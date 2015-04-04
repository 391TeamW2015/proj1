<HTML>
<HEAD>
<TITLE>Data Analysis Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*" %>
<% 
if (((Boolean)session.getAttribute("isOracleLogin")) && ((Boolean)session.getAttribute("isUserLogin"))){

	String sqlname = (String)session.getAttribute("SQLUSERID");
	String sqlpwd =  (String)session.getAttribute("SQLPASSWD");


    //establish the connection to the underlying database
   	Connection conn = null;
	
	String driverName = "oracle.jdbc.driver.OracleDriver";
	String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
	
	try{
	 //load and register the driver
		Class drvClass = Class.forName(driverName); 
		DriverManager.registerDriver((Driver) drvClass.newInstance());
	} catch(Exception ex){
		out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	}
	
	try{
		//establish the connection 
	 	conn = DriverManager.getConnection(dbstring,sqlname,sqlpwd);
		conn.setAutoCommit(false);
	} catch(Exception ex){
	 	out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	}
	
	//select the user table from the underlying db and validate the user name and password
	Statement stmt = null;
	ResultSet rset = null;
	Statement stmt2 = null;
	ResultSet rset2 = null;
	        
	String sql = "select count(*) from pacs_images pp";

	try{
		stmt = conn.createStatement();
	 	rset = stmt.executeQuery(sql);
	} catch(Exception ex){
	 	out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	}

	String output = "";
	while(rset != null && rset.next())
		output = (rset.getString(1)).trim();
    
	out.println("<HTML><HEAD><TITLE>Data Analysis</TITLE></HEAD><BODY>");
	out.println("<div id='image' style='background: url(../theme.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
	out.println("<br><br><br><br><br><br><br><H1><CENTER>Data Analysis</CENTER></H1><CENTER><P><CENTER>Please Check The Attributes You Want To Group By</CENTER></P>");
			
	out.println("<br><FORM ACTION='dataAnalysis1GetType.jsp' METHOD='post' ><table><tr><td><input type='checkbox' name='name1'></td><td>Name</td></tr><tr><td><input type='checkbox' name='type'></td><td>Test Type</td></tr>");
	
	out.println("<tr><td><input type='checkbox' name='date'></td><td>Date</td></tr></table><br>");
	
	out.println("<INPUT TYPE='submit' NAME='doAnalysis' VALUE='Analysis' style= 'width: 300; height: 30'></FORM>");
			
			
	out.println("<br><br><FORM ACTION='../view/administrator.html' METHOD='post' ><INPUT TYPE='submit' VALUE='BACK' style= 'width: 150; height: 30'></FORM>");
	out.println("<br><a href='../view/userDocumentation.html' target='_blank'>Help</a></FORM></div></BODY></HTML>");
	try{
		conn.close();
	} catch(Exception ex){
		out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	}
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
