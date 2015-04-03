<HTML>
<HEAD>
<TITLE>Your Search Result</TITLE>
</HEAD>
<div style='background: url(../theme.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>
<BODY>

<%@page import="java.sql.*" import="java.text.SimpleDateFormat" import= "java.util.*"%>
<%@page import = "java.io.*"%>
<%@page import = "javax.servlet.*"%>
<%@page import = "javax.servlet.http.*" %>
<%!
public String printRowInTable(Integer rec_id, Integer patient_id,
		              Integer doc_id, Integer radio_id, String test_type,
		              String prsr_date, String test_date, String diagnos, String Description,
		              Integer Rank){
	String html = "<tr>";
	html += "<th>"+rec_id+"</th>";
	html += "<th>"+patient_id+"</th>";
	html += "<th>"+doc_id+"</th>";
	html += "<th>"+radio_id+"</th>";
	html += "<th>"+test_type+"</th>";
	html += "<th>"+prsr_date+"</th>";
	html += "<th>"+test_date+"</th>";
	html += "<th>"+diagnos+"</th>";
	html += "<th>"+Description+"</th>";
	html += "<th>"+Rank+"</th>";
	html += "</tr>";
    return html;
}
%>


<% 
	    out.println("<center>");
	    
	    //get oracle account
		String sqlname = (String)session.getAttribute("SQLUSERID");
	    String sqlpwd =  (String)session.getAttribute("SQLPASSWD");
	    
	    String classType =  (String)session.getAttribute("classtype");
	    String userName =(String)session.getAttribute("USERID");
	    
	    //get input information
	    String searchText = (request.getParameter("searchContent")).trim();

	    String sYear      = (request.getParameter("Year")).trim();
	    String sMonth     = (request.getParameter("Month")).trim();
	    String sDay       = (request.getParameter("Day")).trim();
	    
	    String eYear      = (request.getParameter("YEAR")).trim();
	    String eMonth     = (request.getParameter("MONTH")).trim();
	    String eDay       = (request.getParameter("DAY")).trim();
	    
	    
	    // test if I got the right things
	    out.println("classType = " + classType +"<br>");
	    out.println("userName = " + userName +"<br>");

	    out.println("searchText = " + searchText +"<br>");
	    out.println("sYear = " + sYear +"<br>");
	    out.println("sMonth = " + sMonth +"<br>");
	    out.println("sDay = " + sDay +"<br>");
	    out.println("eYear = " + eYear +"<br>");
	    out.println("eMonth = " + eMonth +"<br>");
	    out.println("eDay = " + eDay +"<br>");
	        
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
	    
	    
	    
	    
	    


	    // set some initial value
	    Integer personID = null;
	    Integer patientID = null;
	    
	    String From = "";
	    String To = "";
	    
	    PreparedStatement pstmt = null;
	 	Statement stmt = null;
	 	ResultSet rset = null;
	 	ResultSet findNameResult = null;

	 			
	 	//select person ID of this account
	 	String rid = "select person_id from users where user_name = '"+userName+"'";
	 	
	 	//select * from persons where first_name like '%fei%' or last_name like '%fei%'
	 	String sqlName = "select * from persons where first_name like '%"+searchText+"%' or last_name like '%"+searchText+"%'";
	 			
	    try{
	        stmt = conn.createStatement();
	        findNameResult = stmt.executeQuery(sqlName);
	    } catch(Exception ex){
			out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	    }
	    
	    
	    Integer testing = null;
	    while(findNameResult != null && findNameResult.next()){
    		testing= new Integer(findNameResult.getInt(1));
    		
    		out.println("<hr><center>"+testing+"</center><hr>");
    		
    		String firstName = findNameResult.getString("first_name");
    		String lasstName = findNameResult.getString(3);
    		//didList.add(testing);
    		out.println("<hr><center>"+firstName+" "+lasstName+"</center><hr>");
    	}

	    
		    
		    
		
		    
	 	String getResult = "";

	    
	    
	    
	    if (classType.equals("a")) {
		 	getResult = "select person_id from users where user_name = '"+userName+"'";
	    }
	    else if (classType.equals("r")) {
		 	getResult = "select person_id from users where user_name = '"+userName+"'";
	    }
	    else if (classType.equals("d")) {
		 	getResult = "select person_id from users where user_name = '"+userName+"'";
	    }
	    else {
		 	getResult = "select person_id from users where user_name = '"+userName+"'";
	    }
	    
	    // try the different sql
	    try{
	        stmt = conn.createStatement();
		    rset = stmt.executeQuery(getResult); 

	    }  catch(Exception ex){
			out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	    }
	    
    	rset.next();
    	//out.println("<hr><center>classType = "+ classType +" with ID = "+rset.getInt(1)+" </center><hr>");
	    

    	
    	
    	
    	
    	

	    /*
	    a patient can only view his/her own records; 
	    a doctor can only view records of their patients; 
	    a radiologist can only review records conducted by oneself; 
	    an administrator can view any records.
	    */
	    
		try {			
			// create a table to print result
			out.println("<br><br><br><br><br><br>");
			out.println("<h2><b>Search Result</b></h2>");
			
            out.println("<table border=1>");
            out.println("<tr>");
            out.println("<th>Record ID</th>");
            out.println("<th>Patient ID</th>");
            out.println("<th>Doctor ID</th>");
            out.println("<th>Radiologist ID</th>");
            out.println("<th>Test Type</th>");
            out.println("<th>Prescribing Date</th>");
            out.println("<th>Test Date</th>");
            out.println("<th>Diagnosis</th>");
            out.println("<th>Description</th>");
            out.println("<th>Rank</th>");
            out.println("<th>Medical Pictures</th>");
            out.println("</tr>");
            
            out.println(printRowInTable(testing,1,2,3,"X-ray","X-ray","X-ray","X-ray","X-ray",102));
            
            String recid = "";
        	out.println("</table>");
		} catch(Exception ex){	
	        out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	    	out.println("<script language=javascript type=text/javascript>");
	    	out.println("setTimeout("+"\"javascript:location.href='../view/search.html'\""+", 2500);");
	    	out.println("</script>");
	        out.println("</div>");
	        conn.rollback();
	    }
        	
        out.println("<BR>");
        
		// create the back button and the link
        out.println("<form action='../view/search.html' METHOD='post'>");
        out.println("<input type='submit' name='search_back' value='Back'>");
        out.println("<br><br><a href='userDocumentation.html' target='_blank'>Help</a></form>");

%>

</div>
</BODY>
</HTML>

