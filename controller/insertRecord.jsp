<HTML>
<HEAD>
<TITLE>Your Search Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*" import= "java.util.*"%>
<% 
	if (request.getParameter(".submit") != null && ((Boolean)session.getAttribute("isOracleLogin")) && ((Boolean)session.getAttribute("isUserLogin")))
        {			
		    String sqlname = (String)session.getAttribute("SQLUSERID");
		    String sqlpwd  = (String)session.getAttribute("SQLPASSWD");
			Integer rid    = (Integer)session.getAttribute("rid");
			
			//get the user input from the login page
			String patientId=  (request.getParameter("patientList")).trim();
			Integer patientID =  Integer.parseInt(patientId);
			
			String doctorId =  (request.getParameter("doctorList")).trim();
	        
	        Integer doctorID =   Integer.parseInt(doctorId);
	        String testType =  (request.getParameter("testtype")).trim();
	        String diagnosis=  (request.getParameter("diagnosis")).trim();
	        String description=(request.getParameter("description")).trim();
		    int rec_id;
			
        	
        	java.util.Date myDate = new java.util.Date();
	        java.sql.Date sqlDate = new java.sql.Date(myDate.getTime());
	        
	       
	        
        	out.println("<p><CENTER>patientId = "+patientId+"</CENTER></p>");
        	out.println("<p><CENTER>doctorId = "+doctorId+"</CENTER></p>");

	        
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
	        }
        	catch(Exception ex){
		        out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
        	}
        	
        	PreparedStatement pstmt = null;
	        Statement stmt = null;
	        ResultSet rset = null;      
        	
	        //insert into radiology_record
        	try{
        		stmt = conn.createStatement();
	    	    rset = stmt.executeQuery("select count(*) from radiology_record");
	    	    rset.next();
	    	    rec_id = rset.getInt(1)+1;    	    
	    	    session.setAttribute("rec_id",rec_id);
	    	    
        		pstmt = conn.prepareStatement("INSERT INTO radiology_record (record_id,patient_id,doctor_id,radiologist_id,test_type,prescribing_date,test_date,diagnosis,description)"
        				  +"VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)");
      			pstmt.setInt(1, rec_id);
      			pstmt.setInt(2, patientID);
      			pstmt.setInt(3, doctorID);
      			pstmt.setInt(4, rid);
      			pstmt.setString(5, testType );
      			pstmt.setDate(6, sqlDate );
      			pstmt.setDate(7, sqlDate );
      			pstmt.setString(8, diagnosis);
      			pstmt.setString(9, description);
		    	pstmt.executeQuery();

		    	out.println("<div style='background: url(../theme.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
		    	out.println("<BR><p><CENTER><b>Insert Successful!</b></CENTER></p>");
		    	out.println("<BR><p><CENTER><b>Next, you are going to upload an image!</b></CENTER></p>");
		    	out.println("<script language=javascript type=text/javascript>");
		    	out.println("setTimeout("+"\"javascript:location.href='../view/uploadImg.html'\""+", 1000);");
		    	out.println("</script></div>");
        	}

	        catch(Exception ex){
		        if ((ex.getMessage()).length() > 100) {
		        	out.println("<hr><center>" + (ex.getMessage()).substring(11,12+48) + "</center><hr>");
		        }
	        	else {
	        		out.println("<hr><center>" + ex.getMessage() + "</center><hr>"); 
	        	}
		        conn.rollback();
            }
            try{
                conn.close();
        	}
       		catch(Exception ex){
                if ((ex.getMessage()).length() > 100)
		        	out.println("<hr><center>" + (ex.getMessage()).substring(11,12+48) + "</center><hr>");
	        	else
	        		out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
        	}

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