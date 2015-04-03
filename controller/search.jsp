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
	    
	    String classType = (String)session.getAttribute("classtype");
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
	 	Statement stmt = null;
	 	ResultSet rset = null;
	 	ResultSet findNameResult = null;
	 	

	 	//select * from persons where first_name like '%fei%' or last_name like '%fei%'
	 	String sqlName = "select * from persons where first_name like '%"+searchText+"%' or last_name like '%"+searchText+"%'";
	 			
	    try{
	        findNameResult = conn.createStatement().executeQuery(sqlName);
	    } catch(Exception ex){
			out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	    }
	    
	    /*
	    a patient can only view his/her own records; 
	    a doctor can only view records of their patients; 
	    a radiologist can only review records conducted by oneself; 
	    an administrator can view any records.
	    */
	    
		try {			
			// create a table to print result
			out.println("<br><br>");
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
            
            //out.println(printRowInTable(testing,1,2,3,"X-ray","X-ray","X-ray","X-ray","X-ray",102));
            
            String recid = "";
        	//out.println("</table>");
		} catch(Exception ex){	
	        out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	    	out.println("<script language=javascript type=text/javascript>");
	    	out.println("setTimeout("+"\"javascript:location.href='../view/search.html'\""+", 2500);");
	    	out.println("</script>");
	        out.println("</div>");
	        conn.rollback();
	    }
	    
	    
	    
		//# star to build the table           
	 	String getResult = "";

		Integer recordID;
		Integer patientID;
		Integer doctorID;
		Integer radiologistID;
		String testType;
	
		String prescribingDdate;
		String testDate;
	
		String diagnosis;
		String description;
		


	    if (classType.equals("a")) {
	    	// select * from radiology_record rr, users u, pacs_images pi, persons p where u.user_name = 'yufei' and u.person_id = p.person_id and rr.record_id = pi.record_id and (rr.description like '%dd%' or rr.test_type like '%dd%' or rr.diagnosis like '%dd%' or p.first_name like '%"dd"%' or p.last_name like '%"dd"%' or u.user_name like '%dd%');
		 	getResult = "select * from radiology_record rr, users u, pacs_images pi, persons p where u.user_name = '"+userName+"' and u.person_id = p.person_id and rr.record_id = pi.record_id and (rr.description like '%"+searchText+"%' or rr.test_type like '%"+searchText+"%' or rr.diagnosis like '%"+searchText+"%' or p.first_name like '%"+searchText+"%' or p.last_name like '%"+searchText+"%' or u.user_name like '%"+searchText+"%')";
	    }
	    else if (classType.equals("r")) {
	    	// select * from radiology_record rr, users u, pacs_images pi, persons p where u.user_name = 'jyang' and u.person_id = rr.radiologist_id and rr.radiologist_id = p.person_id and rr.record_id = pi.record_id and (rr.description like '%dd%' or rr.test_type like '%dd%' or rr.diagnosis like '%dd%' or p.first_name like '%"dd"%' or p.last_name like '%"dd"%' or u.user_name like '%dd%');
		 	getResult = "select * from radiology_record rr, users u, pacs_images pi, persons p where u.user_name = '"+userName+"' and u.person_id = rr.radiologist_id and rr.radiologist_id = p.person_id and rr.record_id = pi.record_id and (rr.description like '%"+searchText+"%' or rr.test_type like '%"+searchText+"%' or rr.diagnosis like '%"+searchText+"%' or p.first_name like '%"+searchText+"%' or p.last_name like '%"+searchText+"%' or u.user_name like '%"+searchText+"%')";
	    }
	    else if (classType.equals("d")) {
	    	// select * from radiology_record rr, users u, pacs_images pi, persons p where u.user_name = 'gunge' and u.person_id = rr.doctor_id and rr.doctor_id = p.person_id and rr.record_id = pi.record_id and (rr.description like '%gun%' or rr.test_type like '%gun%' or rr.diagnosis like '%gun%' or p.first_name like '%"gun"%' or p.last_name like '%"gun"%' or u.user_name like '%gun%');

		 	getResult = "select * from radiology_record rr, users u, pacs_images pi, persons p where u.user_name = '"+userName+"' and u.person_id = rr.doctor_id and rr.doctor_id = p.person_id and rr.record_id = pi.record_id and (rr.description like '%"+searchText+"%' or rr.test_type like '%"+searchText+"%' or rr.diagnosis like '%"+searchText+"%' or p.first_name like '%"+searchText+"%' or p.last_name like '%"+searchText+"%' or u.user_name like '%"+searchText+"%')";
	    }
	    else {
	    	getResult = "select * from radiology_record rr, users u, pacs_images pi, persons p where u.user_name = '"+ userName +"' and u.person_id = rr.patient_id and p.person_id = u.person_id and rr.record_id = pi.record_id and (rr.description like '%"+searchText+"%' or rr.test_type like '%"+searchText+"%' or rr.diagnosis like '%"+searchText+"%' or p.first_name like '%"+searchText+"%' or p.last_name like '%"+searchText+"%' or u.user_name like '%"+ searchText +"%')";
				    	
	    }
	    
	    // try the different sql
	    try{
	        stmt = conn.createStatement();
		    rset = stmt.executeQuery(getResult); 
	    }  catch(Exception ex){
			out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	    }
	    
	    

	    
	    
	    
	    
	    
    	while (rset.next()) {
    		recordID =  rset.getInt(1);
    		patientID = rset.getInt(2);
    		doctorID =  rset.getInt(3);
    		radiologistID =  rset.getInt(4);
    		testType = rset.getString(5);
    	
    		prescribingDdate = rset.getString(6);
    		testDate = rset.getString(7);
    	
    		diagnosis = rset.getString(8);
    		description = rset.getString(9);
    	/*
	    	out.println("<center> prescribinDdate = "+ prescribingDdate);
	    	out.println("<center> testDate = "+ testDate);
	    	
	    	out.println("<center> diagnosis = "+ diagnosis);
	    	out.println("<center> description = "+ description +" </center><hr>");
	    	*/
	    	out.println(printRowInTable(recordID,patientID,doctorID,
	    			radiologistID,testType,prescribingDdate,testDate,diagnosis,description,10));
            out.println("<td>"); 
			out.println("<a href=\"PictureBrowse?"+"2"+"\" target='_blank'>Pictures</a>");								
            out.println("</td>");
	    	
    	}
    	out.println("</table><BR>");

        
		// create the back button and the link
        out.println("<form action='../view/search.html' METHOD='post'>");
        out.println("<input type='submit' name='search_back' value='Back'>");
        out.println("<br><br><a href='userDocumentation.html' target='_blank'>Help</a></form>");        		

        
        

%>

</div>
</BODY>
</HTML>

