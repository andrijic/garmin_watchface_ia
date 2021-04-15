 using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Time.Gregorian;
using Toybox.Time;
using Toybox.Math;

 function getDayOfYear() {
    	var date = Time.now();
     	var info = Gregorian.info(date, Time.FORMAT_LONG);
     	
    	var options = {
		    :year   => info.year,
		    :month  => 1,
		    :day    => 1,
		    :hour   => 0
		};
		
		var start_of_year = Gregorian.moment(options);

		var day_of_year = date.subtract(start_of_year);
		//Sys.println(day_of_year.value());
		day_of_year = day_of_year.value() / Gregorian.SECONDS_PER_DAY + 1;
							
		return day_of_year;
    }
    
     function getDayOfWeekForFirstDayOfYear() {
    	var date = Time.now();
     	var info = Gregorian.info(date, Time.FORMAT_LONG);
    	     	
    	var options = {
		    :year   => info.year,
		    :month  => 1,
		    :day    => 1,
		    :hour   => 0
		};
		
		var start_of_year = Gregorian.moment(options);
		var rez = Gregorian.info(start_of_year, Time.FORMAT_SHORT);
		
		var new_rez = rez.day_of_week - 1;
		
		if(new_rez == 0){
			new_rez = 7;
		}
		
		return new_rez; //day of week
    }
    
     function getWeekOfYear(){
     	var dy = getDayOfYear(); //day of year
     	var dw = getDayOfWeekForFirstDayOfYear(); //day of week on January 1st
     	var rez = 0;
     	
     	if(dw <=4){
     		return Math.floor((dy + dw - 2)/7) + 1;
     	}else if(dw == 5){
     		if(dy <= 3){
     			rez = 53;
     		}else{
	     		rez = Math.floor((dy - 4)/7) + 1;
	     	}     		
     	}else if(dw == 6){
     		if(dy <= 2){
     			rez = 52;
     		}else{
	     		rez = Math.floor((dy - 3)/7) + 1;
	     	}     		
     	}else if(dw == 7){
     		if(dy <= 1){
     			rez = 52;
     		}else{
	     		rez = Math.floor((dy - 2)/7) + 1;
	     	}     		
     	}
     	
//     	Sys.println(dy);
//     	Sys.println(dw);
//     	Sys.println(rez);
     	
     	return rez;    	
     }