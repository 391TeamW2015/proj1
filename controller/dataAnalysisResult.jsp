<HTML>
<HEAD>
<TITLE>Your Login Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*" %>
<% 
	if(request.getParameter("doAnalysis") != null)
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
	        
	        
	        
	        out.println("<HTML><HEAD><TITLE>Data Analysis Result</TITLE></HEAD><BODY>");
	        out.println("<div id='image' style='background: url(../theme.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
	        out.println("<p><br><br><br><br><br><br></p>");
	        
	        //out.println("<p>"+name1+"</p>");
	        //out.println("<p>"+type+"</p>");

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
	

	        //select the user table from the underlying db and validate the user name and password
        	Statement stmt = null;
	        ResultSet rset = null;
	        Statement stmt2 = null;
	        ResultSet rset2 = null;
	        String sql = "";
	        
	      //********** none -> null *******************************************************************************1
	        if(name1=="off" && type=="off" && year == "off" && month=="off" && week=="off"){
	        	out.println("<p><center>------non selected</center></p>");
	        	sql = "select count(*) from pacs_images pp";
	        }
	      //********** single -> name, type, year *****************************************************************3
	        else if(name1!="off" && type=="off" && year == "off" && month=="off" && week=="off"){
	        	out.println("<p><center>------PATIENTS ONLY</center></p>");
	        	sql="select p.first_name,p.last_name,count(*) "
	        	+"from radiology_record rr,persons p,pacs_images pp where rr.patient_id = p.person_id and pp.record_id = rr.record_id "
	        	+"group by p.first_name,p.last_name "
	        	+"order by p.first_name,p.last_name,count(*)";
	        }
	        else if(name1=="off" && type!="off" && year == "off" && month=="off" && week=="off"){
	        	out.println("<p><center>------TEST_TYPE ONLY</center></p>");
	        	sql="select rr.test_type,count(*) "
	        	+"from radiology_record rr,pacs_images pp where pp.record_id = rr.record_id "
	        	+"group by rr.test_type "
	        	+"order by rr.test_type,count(*)";
	        }
	        else if(name1=="off" && type=="off" && year != "off" && month=="off" && week=="off"){
	        	out.println("<p><center>------TIME OF YEAR ONLY(DISTINCT)</center></p>");
	        	sql="select extract(year from rr.test_date),count(*) "
	        	+"from radiology_record rr,pacs_images pp where pp.record_id = rr.record_id "
	        	+"group by extract(year from rr.test_date) "
	        	+"order by extract(year from rr.test_date),count(*)";
	        }

	        //************* double ********************************************************************************************4
	        //----------------------------------Name and Type are selected---------------------------------
	        else if(name1!="off" && type!="off" && year == "off" && month=="off" && week=="off"){
	        	out.println("<p><center>------(PATIENTS && TEST_TYPE) ONLY</center></p>");
	        	sql="select p.first_name,p.last_name,rr.test_type,count(*) "
	        	+"from radiology_record rr,persons p,pacs_images pp where rr.patient_id = p.person_id and pp.record_id = rr.record_id "
	        	+"group by p.first_name,p.last_name,rr.test_type "
	        	+"order by p.first_name,p.last_name,rr.test_type,count(*)";
	        }
	        //----------------------------------Name and Year are selected---------------------------------
	        else if(name1!="off" && type=="off" && year != "off" && month=="off" && week=="off"){
	        	out.println("<p><center>------(PATIENTS && YEAR) ONLY</center></p>");
	        	sql="select p.first_name,p.last_name,extract(year from rr.test_date),count(*) "
	        	+"from radiology_record rr,persons p,pacs_images pp where rr.patient_id = p.person_id and pp.record_id = rr.record_id "
	        	+"group by p.first_name,p.last_name,extract(year from rr.test_date) "
	        	+"order by p.first_name,p.last_name,extract(year from rr.test_date),count(*)";
	        }
	        //----------------------------------Type and Year are selected---------------------------------
	        else if(name1=="off" && type!="off" && year != "off" && month=="off" && week=="off"){
	        	out.println("<p><center>------(TEST_TYPE && YEAR) ONLY</center></p>");
	        	sql="select rr.test_type,extract(year from rr.test_date),count(*) "
	        	+"from radiology_record rr,pacs_images pp where pp.record_id = rr.record_id "
	        	+"group by rr.test_type,extract(year from rr.test_date) "
	        	+"order by rr.test_type,extract(year from rr.test_date),count(*)";
	        }
			//---------------------------------- Year and Month are selected---------------------------------
	        else if(name1=="off" && type=="off" && year != "off" && month!="off" && week=="off"){
	        	out.println("<p><center>------(YEAR AND MONTH) ONLY</center></p>");
	        	sql="select extract(year from rr.test_date),extract(month from rr.test_date),count(*) "
	        	+"from radiology_record rr,pacs_images pp where pp.record_id = rr.record_id "
	        	+"group by extract(year from rr.test_date),extract(month from rr.test_date) "
	        	+"order by extract(year from rr.test_date),extract(month from rr.test_date),count(*)";
	        }
	      
	        //************* Triple ********************************************************************************************4
	      	//-------- Name, Type, Year are selected --------------------------------
	        else if(name1!="off" && type!="off" && year != "off" && month=="off" && week=="off"){
	        	out.println("<p><center>------(PATIENTS && TEST_TYPE && TIME TO YEAR) ONLY</center></p>");
	        	sql="select p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),count(*) "
	        	+"from radiology_record rr,persons p,pacs_images pp where rr.patient_id = p.person_id and pp.record_id = rr.record_id "
	        	+"group by p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date) "
	        	+"order by p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),count(*)";
	        }
			//-------- Name, Year, Month are selected --------------------------------
	        else if(name1!="off" && type=="off" && year != "off" && month!="off" && week=="off"){
	        	out.println("<p><center><------(PATIENTS && YEAR && MONTH) ONLY/center></p>");
	        	sql="select p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date),count(*) "
	        	+"from radiology_record rr,persons p,pacs_images pp where rr.patient_id = p.person_id and pp.record_id = rr.record_id "
	        	+"group by p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date) "
	        	+"order by p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date),count(*)";
	        }  
			//-------- Type, Year, Month are selected --------------------------------
	        else if(name1=="off" && type!="off" && year != "off" && month!="off" && week=="off"){
	        	out.println("<p><center>------(TEST_TYPE && TIME TO YEAR->MONTH) ONLY</center></p>");
	        	sql="select rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),count(*) "
	        	+"from radiology_record rr,pacs_images pp where pp.record_id = rr.record_id "
	        	+"group by rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date) "
	        	+"order by rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),count(*)";
	        }	
	        //-------- Year, Month, Day are selected --------------------------------
	        else if(name1=="off" && type=="off" && year != "off" && month!="off" && week!="off"){
	        	out.println("<p><center><------(YEAR && MONTH && WEEK) ONLY/center></p>");
/* <<<<<<< HEAD:controller/dataAnalysisResult.jsp
	        	sql="select extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww'),count(*)"
	        	+" from radiology_record rr,persons p,pacs_images pp "
	        	+"where rr.patient_id = p.person_id and pp.record_id = rr.record_id "
	        	+"group by extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww')";
======= */
	        	sql="select extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'w'),count(*)"
	        	+" from radiology_record rr,persons p,pacs_images pp "
	        	+"where rr.patient_id = p.person_id and pp.record_id = rr.record_id "
	        	+"group by extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'w')";

	        }
	      
	        //*************** 4 of them are selected*************************************************************************3
			// ------------------------- Name, Type Year, Month are selected -----------------------------
	        else if(name1!="off" && type!="off" && year != "off" && month!="off" && week=="off"){
	        	out.println("<p><center>------(PATIENTS && TEST_TYPE && TIME TO YEAR->MONTH) ONLY</center></p>");
	        	sql="select p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),count(*) "
	        	+"from radiology_record rr,persons p,pacs_images pp where rr.patient_id = p.person_id and pp.record_id = rr.record_id "
	        	+"group by p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date) "
	        	+"order by p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),count(*)";
	        }
	        // ------------------------- Name, Year, Month, Day are selected -----------------------------
	        else if(name1!="off" && type=="off" && year != "off" && month!="off" && week!="off"){
	        	out.println("<p><center>------(PATIENTS && TIME TO YEAR->MONTH->WEEK) ONLY</center></p>");
/* <<<<<<< HEAD:controller/dataAnalysisResult.jsp
	        	sql="select p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww'),count(*) "
	        	+"from radiology_record rr,persons p,pacs_images pp where rr.patient_id = p.person_id and pp.record_id = rr.record_id "
	        	+"group by p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww') "
	        	+"order by p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww'),count(*)";
======= */
	        	sql="select p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'w'),count(*) "
	        	+"from radiology_record rr,persons p,pacs_images pp where rr.patient_id = p.person_id and pp.record_id = rr.record_id "
	        	+"group by p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'w') "
	        	+"order by p.first_name,p.last_name,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'w'),count(*)";

	        }
	        // ------------------------- Type, Year, Month, Day are selected -----------------------------
	        else if(name1=="off" && type!="off" && year != "off" && month!="off" && week!="off"){
	        	out.println("<p><center>------(TEST_TYPE && TIME TO YEAR->MONTH->WEEK) ONLY</center></p>");
/* <<<<<<< HEAD:controller/dataAnalysisResult.jsp
	        	sql="select rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww'),count(*) "
	        	+"from radiology_record rr,pacs_images pp where pp.record_id = rr.record_id "
	        	+"group by rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww') "
	        	+"order by rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww'),count(*)";
======= */
	        	sql="select rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'w'),count(*) "
	        	+"from radiology_record rr,pacs_images pp where pp.record_id = rr.record_id "
	        	+"group by rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'w') "
	        	+"order by rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'w'),count(*)";

	        }
	        //*************** All of them are selected*************************************************************************1
	        else if(name1!="off" && type!="off" && year != "off" && month!="off" && week!="off"){
	        	out.println("<p><center>------(PATIENTS && TEST_TYPE && TIME TO YEAR->MONTH->WEEK) </center></p>");
/* <<<<<<< HEAD:controller/dataAnalysisResult.jsp
	        	sql="select p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww'),count(*) "
======= */
	        	sql="select p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'w'),count(*) "

	        	+"from radiology_record rr,persons p,pacs_images pp where rr.patient_id = p.person_id and pp.record_id = rr.record_id "
	        	+"group by p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww') "
	        	+"order by p.first_name,p.last_name,rr.test_type,extract(year from rr.test_date),extract(month from rr.test_date),to_char(rr.test_date,'ww'),count(*)";                                   
	        }
	      
	        else if(name1=="off" && type=="off" && year == "off" && month=="off" && week!="off"){
	        	out.println("<p><center>------TIME OF WEEK ONLY(DISTINCT)</center></p>");
	        	sql="select to_char(rr.test_date,'ww'),count(*) "
	        	+"from radiology_record rr,pacs_images pp where pp.record_id = rr.record_id "
	        	+"group by to_char(rr.test_date,'ww') "
	        	+"order by to_char(rr.test_date,'ww'),count(*)";
	        }

	        
	        else{
	        	out.println("condition unknow");
	        }
        	
        	try{
	        	stmt = conn.createStatement();
		        rset = stmt.executeQuery(sql);
        	}
	
	        catch(Exception ex){
		       out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
        	}

	        String basecase = "";
	        
	        int colums=1;// for the count(*)
	        //---------------------------------
	        out.println("<center><table border=1>");
            out.println("<tr>");
            if (name1!="off"){
           		 out.println("<th>Name(First Last)</th>");
           		colums=colums+1;
            }
            else{
            	colums=colums;
            }
            if(type!="off"){
            	out.println("<th>Test Type</th>");
            	colums=colums+1;
            }
            else{
            	colums=colums;
            }
            if(year!="off"){
            	out.println("<th>Year</th>");
            	colums=colums+1;
            }
            else{
            	colums=colums;
            }
            if(month!="off"){
            	out.println("<th>Month</th>");
            	colums=colums+1;
            }
            else{
            	colums=colums;
            }
            if(week!="off"){
            	out.println("<th>Week</th>");
            	colums=colums+1;
            }
            else{
            	colums=colums;
            }
            out.println("<th>Number of Pictures</th>");
            out.println("</tr>");
            //out.println(colums);
            //--------------
        	while(rset != null && rset.next()){
		        //basecase = (rset.getString(1)).trim();
	        	out.println("<tr>");
	        	//fist colom is name -------------------------------------------------
	           	if(name1!="off"){
	           		out.println("<td><center>"); 
	            	out.println(rset.getString(1));
	           		out.println(rset.getString(2)); 
	           		out.println("</td>");
	           		if(type!="off"){
	           			out.println("<td><center>"); 
		            	out.println(rset.getString(3));
		           		out.println("</td>");
		           		if(year!="off"){
	           				out.println("<td><center>"); 
			            	out.println(rset.getString(4));
			           		out.println("</td>");
			           		if(month!="off"){
			           			out.println("<td><center>"); 
				            	out.println(rset.getString(5));
				           		out.println("</td>");
				           		if(week!="off"){
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(6));
					           		out.println("</td>");
					           		out.println("<td><center>"); 
					            	out.println(rset.getString(7));
					           		out.println("</td>");
	           					}
		           				else{
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(6));
					           		out.println("</td>");
	           					}
			           		}
			           		else{
			           			if(week!="off"){
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(5));
					           		out.println("</td>");
					           		out.println("<td><center>"); 
					            	out.println(rset.getString(6));
					           		out.println("</td>");
	           					}
		           				else{
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(5));
					           		out.println("</td>");
	           					}
			           		}
	           			}
		           		else{
	           				if(month!="off"){
	           					out.println("<td><center>"); 
				            	out.println(rset.getString(4));
				           		out.println("</td>");
				           		if(week!="off"){
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(5));
					           		out.println("</td>");
					           		out.println("<td><center>"); 
					            	out.println(rset.getString(6));
					           		out.println("</td>");
	           					}
		           				else{
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(5));
					           		out.println("</td>");
	           					}
	           				}
	           				else{
		           				if(week!="off"){
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(4));
					           		out.println("</td>");
					           		out.println("<td><center>"); 
					            	out.println(rset.getString(5));
					           		out.println("</td>");
	           					}
		           				else{
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(4));
					           		out.println("</td>");
	           					}
	           				}
	           			}
	           		}
	           		else{
	           			if(year!="off"){
	           				out.println("<td><center>"); 
			            	out.println(rset.getString(3));
			           		out.println("</td>");
			           		if(month!="off"){
	           					out.println("<td><center>"); 
				            	out.println(rset.getString(4));
				           		out.println("</td>");
				           		if(week!="off"){
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(5));
					           		out.println("</td>");
					           		out.println("<td><center>"); 
					            	out.println(rset.getString(6));
					           		out.println("</td>");
	           					}
		           				else{
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(5));
					           		out.println("</td>");
	           					}
	           				}
	           				else{
		           				if(week!="off"){
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(4));
					           		out.println("</td>");
					           		out.println("<td><center>"); 
					            	out.println(rset.getString(5));
					           		out.println("</td>");
	           					}
		           				else{
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(4));
					           		out.println("</td>");
	           					}
	           				}
	           			}
	           			else{
	           				if(month!="off"){
	           					out.println("<td><center>"); 
				            	out.println(rset.getString(3));
				           		out.println("</td>");
				           		if(week!="off"){
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(4));
					           		out.println("</td>");
					           		out.println("<td><center>"); 
					            	out.println(rset.getString(5));
					           		out.println("</td>");
	           					}
		           				else{
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(4));
					           		out.println("</td>");
	           					}
	           				}
	           				else{
		           				if(week!="off"){
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(3));
					           		out.println("</td>");
					           		out.println("<td><center>"); 
					            	out.println(rset.getString(4));
					           		out.println("</td>");
	           					}
		           				else{
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(3));
					           		out.println("</td>");
	           					}
	           				}
	           			}
	           		}
	           	}
	           
	           	else{
	           		//fist colom is type ------------------------------
	           		if(type!="off"){
	           			out.println("<td><center>"); 
		            	out.println(rset.getString(1));
		           		out.println("</td>");
		           		if(year!="off"){
	           				out.println("<td><center>"); 
			            	out.println(rset.getString(2));
			           		out.println("</td>");
			           		if(month!="off"){
           						out.println("<td><center>"); 
				            	out.println(rset.getString(3));
				           		out.println("</td>");
				           		if(week!="off"){
				           			out.println("<td><center>"); 
					            	out.println(rset.getString(4));
					           		out.println("</td>");
					           		out.println("<td><center>"); 
					            	out.println(rset.getString(5));
					           		out.println("</td>");
				           		}
				           		else{
				           			out.println("<td><center>"); 
					            	out.println(rset.getString(4));
					           		out.println("</td>");
				           		}
           					}
	           				else{
	           					if(week!="off"){
				           			out.println("<td><center>"); 
					            	out.println(rset.getString(3));
					           		out.println("</td>");
					           		out.println("<td><center>"); 
					            	out.println(rset.getString(4));
					           		out.println("</td>");
				           		}
				           		else{
				           			out.println("<td><center>"); 
					            	out.println(rset.getString(3));
					           		out.println("</td>");
				           		}
           					}
	           			}
		           		else{
	           				if(month!="off"){
	           					out.println("<td><center>"); 
				            	out.println(rset.getString(2));
				           		out.println("</td>");
				           		if(week!="off"){
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(3));
					           		out.println("</td>");
					           		out.println("<td><center>"); 
					            	out.println(rset.getString(4));
					           		out.println("</td>");
	           					}
		           				else{
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(3));
					           		out.println("</td>");
	           					}
	           				}
	           				else{
		           				if(week!="off"){
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(2));
					           		out.println("</td>");
					           		out.println("<td><center>"); 
					            	out.println(rset.getString(3));
					           		out.println("</td>");
	           					}
		           				else{
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(2));
					           		out.println("</td>");
	           					}
	           				}
	           			}
	           		}
	           		
	           		else{
	           		//------fist colom is year--------------------
	           			if(year!="off"){
	           				out.println("<td><center>"); 
			            	out.println(rset.getString(1));
			           		out.println("</td>");
			           		if(month!="off"){
	           					out.println("<td><center>"); 
				            	out.println(rset.getString(2));
				           		out.println("</td>");
				           		if(week!="off"){
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(3));
					           		out.println("</td>");
					           		out.println("<td><center>"); 
					            	out.println(rset.getString(4));
					           		out.println("</td>");
	           					}
		           				else{
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(3));
					           		out.println("</td>");
	           					}
	           				}
	           				else{
		           				if(week!="off"){
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(2));
					           		out.println("</td>");
					           		out.println("<td><center>"); 
					            	out.println(rset.getString(3));
					           		out.println("</td>");
	           					}
		           				else{
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(2));
					           		out.println("</td>");
	           					}
	           				}
	           			}
	           			
	           			else{
	           				//---------------------first colum is month---------------------
	           				if(month!="off"){
	           					out.println("<td><center>"); 
				            	out.println(rset.getString(1));
				           		out.println("</td>");
				           		if(week!="off"){
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(2));
					           		out.println("</td>");
					           		out.println("<td><center>"); 
					            	out.println(rset.getString(3));
					           		out.println("</td>");
	           					}
		           				else{
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(2));
					           		out.println("</td>");
	           					}
	           				}
	           				else{
	           					if(week!="off"){
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(1));
					           		out.println("</td>");
					           		out.println("<td><center>"); 
					            	out.println(rset.getString(2));
					           		out.println("</td>");
	           					}
	           					else{
	           						out.println("<td><center>"); 
					            	out.println(rset.getString(1));
					           		out.println("</td>");
	           					}
	           				}
	           			}
	           		}
	           	}

        		}
        	out.println("</table></center>");
        	out.println("<center><FORM ACTION='dataAnalysis.jsp' METHOD='post'><br><br>");
        	out.println("<INPUT TYPE='submit' NAME='dataAnalysis' VALUE='Do Another Analysis' style= 'width: 300; height: 30'></FORM></center><br><br><br>");
			out.println("<center><FORM ACTION='../view/administrator.html' METHOD='post' ><INPUT TYPE='submit' NAME='ad_back' VALUE='Back' style= 'width: 150; height: 30'></FORM></center></div></BODY></HTML>");	
        		
			try{
                conn.close();
            }
            catch(Exception ex){
                 out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
            }
        }
  
%>



</BODY>
</HTML>
