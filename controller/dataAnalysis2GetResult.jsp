<HTML>
<HEAD>
<TITLE>Data Analysis Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*" %>
<% 
	String sqlname = (String)session.getAttribute("SQLUSERID");
	String sqlpwd =  (String)session.getAttribute("SQLPASSWD");
	
	String upDown = "null";
	try {
		upDown = (request.getParameter("upDown")).trim();
	} catch(Exception ex) {
		upDown = "null";
	}
	
	String name1=(String)session.getAttribute("name1");
	String type=(String)session.getAttribute("type");
	String year=(String)session.getAttribute("year");;
	String month=(String)session.getAttribute("month");
	String week=(String)session.getAttribute("week");
	
    out.println("<HTML><HEAD><TITLE>Data Analysis Result</TITLE></HEAD><BODY>");
    out.println("<div id='image' style='background: url(../theme.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
    
	if (upDown.equals("Roll Up")) {
		if (week.equals("on")) {
			week = "off";
		}
		else if (week.equals("off") && month.equals("on")) {
			month = "off";
		}
	}
	else if (upDown.equals("Drill Down")) {
		if (year.equals("on") && month.equals("off")) {
			month = "on";
		}
		else if (year.equals("on") && month.equals("on") && week.equals("off")) {
			week = "on";
		}
	}
       

       //out.println("<p>"+name1 +" "+type+" "+year+" "+month+" "+week+ "</p>");

       String sql = "";
       String status = "";
       

     //********** none -> null *******************************************************************************1
       if(name1=="off" && type=="off" && year == "off" && month=="off" && week=="off"){
       	status = "<p><center>------non selected</center></p>";
       	sql = "select count(*) from pacs_images pp";
       }
     //********** single -> name, type, year *****************************************************************3
       else if(name1!="off" && type=="off" && year == "off" && month=="off" && week=="off"){
       	status = "<p><center>------PATIENTS ONLY</center></p>";
       	sql="select p.first_name,p.last_name,count(*) "
       	+"from radiology_record rr,persons p,pacs_images pp where rr.patient_id = p.person_id and pp.record_id = rr.record_id "
       	+"group by p.first_name,p.last_name "
       	+"order by p.first_name,p.last_name,count(*)";
       }
       else if(name1=="off" && type!="off" && year == "off" && month=="off" && week=="off"){
       	status = "<p><center>------TEST_TYPE ONLY</center></p>";
       	sql="select rr.test_type,count(*) "
       	+"from radiology_record rr,pacs_images pp where pp.record_id = rr.record_id "
       	+"group by rr.test_type "
       	+"order by rr.test_type,count(*)";
       }
       else if(name1=="off" && type=="off" && year != "off" && month=="off" && week=="off"){
       	status = "<p><center>------TIME OF YEAR ONLY(DISTINCT)</center></p>";
       	sql="select extract(year from rr.test_date),count(*) "
       	+"from radiology_record rr,pacs_images pp where pp.record_id = rr.record_id "
       	+"group by extract(year from rr.test_date) "
       	+"order by extract(year from rr.test_date),count(*)";
       }

       //************* double ********************************************************************************************4
       //----------------------------------Name and Type are selected---------------------------------
       else if(name1!="off" && type!="off" && year == "off" && month=="off" && week=="off"){
       	status = "<p><center>------(PATIENTS && TEST_TYPE) ONLY</center></p>";
       	sql="select p.first_name,p.last_name,rr.test_type,count(*) "
       	+"from radiology_record rr,persons p,pacs_images pp where rr.patient_id = p.person_id and pp.record_id = rr.record_id "
       	+"group by p.first_name,p.last_name,rr.test_type "
       	+"order by p.first_name,p.last_name,rr.test_type,count(*)";
       }
       //----------------------------------Name and Year are selected---------------------------------
       else if(name1!="off" && type=="off" && year != "off" && month=="off" && week=="off"){
       	status = "<p><center>------(PATIENTS && YEAR) ONLY</center></p>";
       	sql="select p.first_name,p.last_name,extract(year from rr.test_date),count(*) "
       	+"from radiology_record rr,persons p,pacs_images pp where rr.patient_id = p.person_id and pp.record_id = rr.record_id "
       	+"group by p.first_name,p.last_name,extract(year from rr.test_date) "
       	+"order by p.first_name,p.last_name,extract(year from rr.test_date),count(*)";
       }
       //----------------------------------Type and Year are selected---------------------------------
       else if(name1=="off" && type!="off" && year != "off" && month=="off" && week=="off"){
       	status = "<p><center>------(TEST_TYPE && YEAR) ONLY</center></p>";
       	sql="select rr.test_type,extract(year from rr.test_date),count(*) "
       	+"from radiology_record rr,pacs_images pp where pp.record_id = rr.record_id "
       	+"group by rr.test_type,extract(year from rr.test_date) "
       	+"order by rr.test_type,extract(year from rr.test_date),count(*)";
       }
	//---------------------------------- Year and Month are selected---------------------------------
       else if(name1=="off" && type=="off" && year != "off" && month!="off" && week=="off"){
       	status = "<p><center>------(YEAR AND MONTH) ONLY</center></p>";
       	sql="select extract(year from rr.test_date),extract(month from rr.test_date),count(*) "
       	+"from radiology_record rr,pacs_images pp where pp.record_id = rr.record_id "
       	+"group by extract(year from rr.test_date),extract(month from rr.test_date) "
       	+"order by extract(year from rr.test_date),extract(month from rr.test_date),count(*)";
       }
     
       //************* Triple ********************************************************************************************4
     	//-------- Name, Type, Year are selected --------------------------------
       else if(name1!="off" && type!="off" && year != "off" && month=="off" && week=="off"){
       	status = "<p><center>------(PATIENTS && TEST_TYPE && TIME TO YEAR) ONLY</center></p>";
       	sql="select p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),count(*) "
       	+"from radiology_record rr,persons p,pacs_images pp where rr.patient_id = p.person_id and pp.record_id = rr.record_id "
       	+"group by p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date) "
       	+"order by p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),count(*)";
       }
	//-------- Name, Year, Month are selected --------------------------------
       else if(name1!="off" && type=="off" && year != "off" && month!="off" && week=="off"){
       	status = "<p><center><------(PATIENTS && YEAR && MONTH) ONLY/center></p>";
       	sql="select p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date),count(*) "
       	+"from radiology_record rr,persons p,pacs_images pp where rr.patient_id = p.person_id and pp.record_id = rr.record_id "
       	+"group by p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date) "
       	+"order by p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date),count(*)";
       }  
	//-------- Type, Year, Month are selected --------------------------------
       else if(name1=="off" && type!="off" && year != "off" && month!="off" && week=="off"){
       	status = "<p><center>------(TEST_TYPE && TIME TO YEAR->MONTH) ONLY</center></p>";
       	sql="select rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),count(*) "
       	+"from radiology_record rr,pacs_images pp where pp.record_id = rr.record_id "
       	+"group by rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date) "
       	+"order by rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),count(*)";
       }	
       //-------- Year, Month, Day are selected --------------------------------
       else if(name1=="off" && type=="off" && year != "off" && month!="off" && week!="off"){
       	status = "<p><center><------(YEAR && MONTH && WEEK) ONLY/center></p>";
       	sql="select extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww'),count(*)"
       	+" from radiology_record rr,persons p,pacs_images pp "
       	+"where rr.patient_id = p.person_id and pp.record_id = rr.record_id "
       	+"group by extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww')";
       }
     
       //*************** 4 of them are selected*************************************************************************3
	// ------------------------- Name, Type Year, Month are selected -----------------------------
       else if(name1!="off" && type!="off" && year != "off" && month!="off" && week=="off"){
       	status = "<p><center>------(PATIENTS && TEST_TYPE && TIME TO YEAR->MONTH) ONLY</center></p>";
       	sql="select p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),count(*) "
       	+"from radiology_record rr,persons p,pacs_images pp where rr.patient_id = p.person_id and pp.record_id = rr.record_id "
       	+"group by p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date) "
       	+"order by p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),count(*)";
       }
       // ------------------------- Name, Year, Month, Day are selected -----------------------------
       else if(name1!="off" && type=="off" && year != "off" && month!="off" && week!="off"){
       	status = "<p><center>------(PATIENTS && TIME TO YEAR->MONTH->WEEK) ONLY</center></p>";
       	sql="select p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww'),count(*) "
       	+"from radiology_record rr,persons p,pacs_images pp where rr.patient_id = p.person_id and pp.record_id = rr.record_id "
       	+"group by p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww') "
       	+"order by p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww'),count(*)";
       }
       // ------------------------- Type, Year, Month, Day are selected -----------------------------
       else if(name1=="off" && type!="off" && year != "off" && month!="off" && week!="off"){
       	status = "<p><center>------(TEST_TYPE && TIME TO YEAR->MONTH->WEEK) ONLY</center></p>";
       	sql="select rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww'),count(*) "
       	+"from radiology_record rr,pacs_images pp where pp.record_id = rr.record_id "
       	+"group by rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww') "
       	+"order by rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww'),count(*)";
       }
       //*************** All of them are selected*************************************************************************1
       else if(name1!="off" && type!="off" && year != "off" && month!="off" && week!="off"){
       	status = "<p><center>------(PATIENTS && TEST_TYPE && TIME TO YEAR->MONTH->WEEK) </center></p>";
       	sql="select p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww'),count(*) "
       	+"from radiology_record rr,persons p,pacs_images pp where rr.patient_id = p.person_id and pp.record_id = rr.record_id "
       	+"group by p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww') "
       	+"order by p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww'),count(*)";                                   
       }
     
       else if(name1=="off" && type=="off" && year == "off" && month=="off" && week!="off"){
       	status = "<p><center>------TIME OF WEEK ONLY(DISTINCT)</center></p>";
       	sql="select to_char(rr.test_date,'ww'),count(*) "
       	+"from radiology_record rr,pacs_images pp where pp.record_id = rr.record_id "
       	+"group by to_char(rr.test_date,'ww') "
       	+"order by to_char(rr.test_date,'ww'),count(*)";
       }

       
       else{
       	sql = ""; 
       	out.println("Not those 16 kinds of status");
       }
      	
       session.setAttribute("status",status);
       session.setAttribute("sqlAnalysis",sql);
       session.setAttribute("name1",name1);
       session.setAttribute("type",type);
       session.setAttribute("year",year);
       session.setAttribute("month",month);
       session.setAttribute("week",week);
       
	out.println("<script language=javascript type=text/javascript>");
	out.println("setTimeout("+"\"javascript:location.href='dataAnalysis3PrintResult.jsp'\""+", 0);");
	out.println("</script>");
	
	out.println("</div></Body></HTML>");

%>



</BODY>
</HTML>
