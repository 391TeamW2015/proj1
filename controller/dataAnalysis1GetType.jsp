<HTML>
<HEAD>
<TITLE>Data Analysis Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*" %>
<% 
	if(request.getParameter("doAnalysis") != null && ((Boolean)session.getAttribute("isOracleLogin")) && ((Boolean)session.getAttribute("isUserLogin")))
        {			
			String sqlname = (String)session.getAttribute("SQLUSERID");
			String sqlpwd =  (String)session.getAttribute("SQLPASSWD");
			String name1="off";
			String type="off";
			
			String year="off";
			String month="off";
			String week="off";
	        
			//get the user input from the login page
	        try{
        		name1 = (request.getParameter("name1")).trim();
        	} catch(Exception ex){
	        	name1="off";
	        }
	        
	        try{
				type = (request.getParameter("type")).trim();
    		} catch(Exception ex){
        		type="off";
        	}
	        
	        //set year & month is default date
	        try{
	        	year = (request.getParameter("date")).trim();
        		month= (request.getParameter("date")).trim();
			}
    		catch(Exception ex){
    			year  = "off";
    			month = "off";
    		}
	        
	        session.setAttribute("name1",name1);
	        session.setAttribute("type",type);
	        session.setAttribute("year",year);
	        session.setAttribute("month",month);
	        session.setAttribute("week",week);
	        
	        
	        out.println("<HTML><HEAD><TITLE>Data Analysis Result</TITLE></HEAD><BODY>");
	        out.println("<div id='image' style='background: url(../theme.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
	        
			out.println("<script language=javascript type=text/javascript>");
			out.println("setTimeout("+"\"javascript:location.href='dataAnalysis2GetResult.jsp'\""+", 0);");
			out.println("</script>");
			
			out.println("</div></Body></HTML>");
        }

	else{
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
