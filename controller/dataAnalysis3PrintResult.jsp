<HTML>
<HEAD>
<TITLE>Data Analysis Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*" %>
<% 
		
	String sqlname = (String)session.getAttribute("SQLUSERID");
	String sqlpwd =  (String)session.getAttribute("SQLPASSWD");
	
	out.println("<HTML><HEAD><TITLE>Data Analysis Result</TITLE></HEAD><BODY>");
	out.println("<div id='image' style='background: url(../theme.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
	out.println("<p><br><br><br><br><br></p>");
       

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

       
	String status = (String)session.getAttribute("status");
	String sql    = (String)session.getAttribute("sqlAnalysis");
   	String name1=(String)session.getAttribute("name1");
   	String type=(String)session.getAttribute("type");
   	String year=(String)session.getAttribute("year");;
   	String month=(String)session.getAttribute("month");
   	String week=(String)session.getAttribute("week");
   	
   	out.println(status);
     
	// connect to the database
	try{
		stmt = conn.createStatement();
		rset = stmt.executeQuery(sql);
	} catch(Exception ex){
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
          
          if (year!="off") {
        	  
      		out.println("<table><br><td><center><FORM ACTION='dataAnalysis2GetResult.jsp' METHOD='post'>");
      		out.println("<INPUT TYPE='submit' NAME='upDown' VALUE='Roll Up' style= 'width: 100; height: 30'></FORM></center></td>");

      		out.println("<td><center><FORM ACTION='dataAnalysis2GetResult.jsp' METHOD='post'>");
      		out.println("<INPUT TYPE='submit' NAME='upDown' VALUE='Drill Down' style= 'width: 100; height: 30'></FORM></center></td></table><br><br>");
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

%>



</BODY>
</HTML>
