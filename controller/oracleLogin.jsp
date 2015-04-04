<HTML>
<HEAD>


<TITLE>Ocacle Login Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*" %>
<% 
	if(request.getParameter("Submit") != null)
        {
	        //get the user input from the login page	
	    	String sqlname = (request.getParameter("SQLUSERID")).trim();
			String sqlpwd  = (request.getParameter("SQLPASSWD")).trim();
			
			Boolean isOracleLogin = false;
			
			//setAttribute for later use
			session.setAttribute("SQLUSERID",sqlname);
			session.setAttribute("SQLPASSWD",sqlpwd);
			session.setAttribute("isOracleLogin",isOracleLogin);
					

		    //establish the connection to the underlying database
	        Connection conn = null;
		
		    String driverName = "oracle.jdbc.driver.OracleDriver";
	        String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
		
		    try{
			    //load and register the driver
	        	Class drvClass = Class.forName(driverName); 
		        DriverManager.registerDriver((Driver) drvClass.newInstance());
	        }
		    catch(Exception ex){
		        out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
		    }
	
	        try{
		        //establish the connection 
			    conn = DriverManager.getConnection(dbstring,sqlname,sqlpwd);
	        	conn.setAutoCommit(false);
	        	conn.close();
	        	
			    out.println("<script language=javascript type=text/javascript>");
			    out.println("setTimeout("+"\"javascript:location.href='../view/login.html'\""+", 0);");
			    out.println("</script>");
			    
			    // if successfully login database
			    isOracleLogin = true;
			    session.setAttribute("isOracleLogin",isOracleLogin);
		    }
	        catch(Exception ex){
			    out.println("<hr><center>" + (ex.getMessage()).substring(11) + "</center><hr>");;
			    out.println("<script language=javascript type=text/javascript>");
			    out.println("setTimeout("+"\"javascript:location.href='../index.html'\""+", 2500);");
			    out.println("</script>");
			    
			    // if unsuccessfully login database
			    isOracleLogin = false;
			    session.setAttribute("isOracleLogin",isOracleLogin);
			    
	        }
        }
%>

</BODY>
</HTML>

