function validate()
{
   if (( document.newUserRegistration.personid.value != parseInt(document.newUserRegistration.personid.value) ))
   {
     alert( "Person ID Should Be Integers!" );
     document.newUserRegistration.personid.focus() ;
     return false;
   }
   if( document.newUserRegistration.username.value == "" )
   {
     alert( "Please provide your User Name!" );
     document.newUserRegistration.username.focus() ;
     return false;
   }
   if( document.newUserRegistration.password.value == "" )
   {
     alert( "Please provide your Password!" );
     document.newUserRegistration.password.focus() ;
     return false;
   }
   if( document.newUserRegistration.Class.value == "-1" )
   {
     alert( "Please Choose your Class!" );
     document.newUserRegistration.Class.focus() ;
     return false;
   }  
   return( true );
}
