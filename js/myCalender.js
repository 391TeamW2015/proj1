function populate(year,month,date){
	var year = document.getElementById(year);
	var month = document.getElementById(month);
	var date = document.getElementById(date);
	
	if(year.value=="NULL" || month.value=="NULL"){
		return;
	}
	date.innerHTML = "";
	
	var isLeap = null;
	if(year.value%4!=0){
		isLeap = false;
	} else if(year.value%100!=0) {
		isLeap = true;
	} else if(year.value%400!=0) {
		isLeap = false;
	} else {
		isLeap = true;
	}

    var maxDate = null;
	if (isLeap && month.value=="February"){
		maxDate = 30;
	} else if(month.value=="February") {
		maxDate = 29;
	} else if(month.value=="April" || 
	          month.value=="June" ||
	          month.value=="September" || 
			  month.value=="November") {
		maxDate = 31;
	} else {
		maxDate = 32;
	}
	
	for(var i=1;i<maxDate;i++){
		var newOption = document.createElement("option");
		newOption.value = ""+i; 
		newOption.innerHTML = ""+i;
		date.options.add(newOption);
	}
}
