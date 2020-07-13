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
		Sys.println(day_of_year.value());
		day_of_year = day_of_year.value() / Gregorian.SECONDS_PER_DAY + 1;
		Sys.println(day_of_year);
		
		return day_of_year;
    }
    
     function getWeekOfYear(){
     	return Math.floor((getDayOfYear() + 1)/7 + 1);
     }