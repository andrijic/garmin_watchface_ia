using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Time.Gregorian;
using Toybox.Time;
import Toybox.Complications;

class garmin_watchface_ia2View extends Ui.WatchFace {

	var customFont = null;
	var bluetooth_icon_on = null;
	var bluetooth_icon_off = null;
	var alarm2_icon = null;
	
	var LEFT_BACK_COLOR;
	var RIGHT_BACK_COLOR;
	var LEFT_FONT_COLOR;
	var RIGHT_FONT_COLOR;	
	var LEFT_SMALLFONT_COLOR;
	var RIGHT_SMALLFONT_COLOR;

	var complic_heart_rate_id;
	var cur_hr = 60;

	var hasComplications = false;
	
    function initialize() {
        WatchFace.initialize();
        restorePersistedSettings();
		loadComplications();
    }

	function loadComplications(){
		hasComplications = (Toybox has :Complications); 
        
		if(hasComplications) {
            complic_heart_rate_id = new Id(Complications.COMPLICATION_TYPE_HEART_RATE);

            if(complic_heart_rate_id!=null) {
                var hr_comp = Complications.getComplication(complic_heart_rate_id);
                Complications.registerComplicationChangeCallback(self.method(:onComplicationChanged));
                Complications.subscribeToUpdates(complic_heart_rate_id);        
            }
        }
	}

	function onComplicationChanged(id as Complications.Id) as Void {
		if(id.equals(complic_heart_rate_id)) {
           	cur_hr=Complications.getComplication(id).value;
			//System.println(cur_hr);
        }
    }

    // Load your resources here
    function onLayout(dc) {
        
        customFont = Ui.loadResource(Rez.Fonts.gloucester);
        bluetooth_icon_on = Ui.loadResource(Rez.Drawables.bluetooth_on_icon);
        bluetooth_icon_off = Ui.loadResource(Rez.Drawables.bluetooth_off_icon);
        alarm2_icon = Ui.loadResource(Rez.Drawables.alarm2_icon);
        setLayout(Rez.Layouts.WatchFace(dc));
        
    }
    
    function restorePersistedSettings(){
    	//persist change properties
		var app = Application.getApp();
		
		LEFT_BACK_COLOR = getValidProperty(app, "BackgroundLeftColor", "FFFFFF").toNumberWithBase(16);
		RIGHT_BACK_COLOR = getValidProperty(app, "BackgroundRightColor", "000000").toNumberWithBase(16);
		LEFT_FONT_COLOR = getValidProperty(app, "FontLeftColor", "FF0000").toNumberWithBase(16);
		RIGHT_FONT_COLOR = getValidProperty(app, "FontRightColor", "00FF00").toNumberWithBase(16);
		LEFT_SMALLFONT_COLOR = getValidProperty(app, "FontSmallLeftColor", "000000").toNumberWithBase(16);
		RIGHT_SMALLFONT_COLOR = getValidProperty(app, "FontSmallRightColor", "FFFFFF").toNumberWithBase(16);
    }
    
    function getValidProperty(app, param_name, default_value){
    	var input_value = app.getProperty(param_name);
    	
    	if(input_value == null){
    		return default_value;
    	}else{
    		return input_value;
    	}
    }
    
    function handleSettingsChanged(){
		LEFT_BACK_COLOR = Application.getApp().getProperty("BackgroundLeftColor").toNumberWithBase(16);
		RIGHT_BACK_COLOR = Application.getApp().getProperty("BackgroundRightColor").toNumberWithBase(16);
		LEFT_FONT_COLOR = Application.getApp().getProperty("FontLeftColor").toNumberWithBase(16);
		RIGHT_FONT_COLOR = Application.getApp().getProperty("FontRightColor").toNumberWithBase(16);
		LEFT_SMALLFONT_COLOR = Application.getApp().getProperty("FontSmallLeftColor").toNumberWithBase(16);
		RIGHT_SMALLFONT_COLOR = Application.getApp().getProperty("FontSmallRightColor").toNumberWithBase(16);
		
		//persist change properties
		var app = Application.getApp();
    	
    	app.setProperty("BackgroundLeftColor", LEFT_BACK_COLOR.format("%06X"));    	
    	app.setProperty("BackgroundRightColor", RIGHT_BACK_COLOR.format("%06X"));
    	app.setProperty("FontLeftColor", LEFT_FONT_COLOR.format("%06X"));
    	app.setProperty("FontRightColor", RIGHT_FONT_COLOR.format("%06X"));
    	app.setProperty("FontSmallLeftColor", LEFT_SMALLFONT_COLOR.format("%06X"));
    	app.setProperty("FontSmallRightColor", RIGHT_SMALLFONT_COLOR.format("%06X"));
    	    	
    	app.saveProperties();
	}

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	
    }

    // Update the view
    function onUpdate(dc) {
        View.onUpdate(dc);
       dc.setColor(RIGHT_BACK_COLOR, RIGHT_BACK_COLOR);
       dc.clear();
       var clockTime = Sys.getClockTime();
       var hour = clockTime.hour;
       var minutes = clockTime.min;

	   var hourText;
	   var minutesText;

	   var minutesWidth;
	   var minutesHeight;

	   var tinyTextHeight;
	   var mediumTextHeight;

	   var dimensions = dc.getTextDimensions("12", Gfx.FONT_TINY);
	   tinyTextHeight = dimensions[1];

	   dimensions = dc.getTextDimensions("12", Gfx.FONT_MEDIUM);
	   mediumTextHeight = dimensions[1];


		/*background split screen*/
 	   dc.setColor(LEFT_BACK_COLOR, LEFT_BACK_COLOR);
       dc.fillRectangle(0, 0, dc.getWidth()/2, dc.getHeight()*2);

	   
       	
       	/*hour and minutes*/
      dc.setColor(LEFT_FONT_COLOR, Gfx.COLOR_TRANSPARENT);
	   hourText = hour.format("%02d");
       dc.drawText(dc.getWidth()/2 - 5, dc.getHeight()/2 - 90, customFont,hourText, Gfx.TEXT_JUSTIFY_RIGHT);
       
       dc.setColor(RIGHT_FONT_COLOR, Gfx.COLOR_TRANSPARENT);
	   minutesText = minutes.format("%02d");
       dc.drawText(dc.getWidth()/2 + 5, dc.getHeight()/2 - 90, customFont, minutesText , Gfx.TEXT_JUSTIFY_LEFT);

	   dimensions = dc.getTextDimensions(minutesText, customFont);
	   minutesWidth = dimensions[0];
	   minutesHeight = dimensions[1];
       
     
     	/*date on top*/
     	var date = Time.now();
     	var info = Gregorian.info(date, Time.FORMAT_LONG);
     	
//     	var clockString1 = Lang.format(
//		    "$1$ $2$",
//		    [
//		        info.day,
//		       info.month
//		    ]
//		);

		var info2 = Gregorian.info(date, Time.FORMAT_MEDIUM);
		var dayOfWeekText = info2.day_of_week.substring(0,3);
		var weekOfYear = getWeekOfYear();
		

		var clockString1 = Lang.format(
		    "$1$ $2$ ",
		    [
		        info.day,
		        dayOfWeekText
		    ]
		);
     	
     	dc.setColor(LEFT_SMALLFONT_COLOR, Gfx.COLOR_TRANSPARENT);
     	dc.drawText(dc.getWidth()/2 - 1, (dc.getHeight() - minutesHeight)/2 - 10, Gfx.FONT_MEDIUM, clockString1, Gfx.TEXT_JUSTIFY_RIGHT);
     	
     	
     	dc.setColor(RIGHT_SMALLFONT_COLOR, Gfx.COLOR_TRANSPARENT);
     	dc.drawText(dc.getWidth()/2 , (dc.getHeight() - minutesHeight)/2 - 10, Gfx.FONT_MEDIUM, " W" + weekOfYear, Gfx.TEXT_JUSTIFY_LEFT);
     	
     	/*alarm status*/
     	if(Sys.getDeviceSettings().alarmCount > 0){     
       		 dc.drawBitmap2(dc.getWidth()/2 - alarm2_icon.getWidth() - 10 ,
			  dc.getHeight() - minutesHeight/2 + tinyTextHeight + 20 + (tinyTextHeight-alarm2_icon.getHeight())/2,
			   alarm2_icon,
			    {:tintColor=>LEFT_SMALLFONT_COLOR});
       }             
     	       
       /*android device connection status*/
       //dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
       
       if(Sys.getDeviceSettings().phoneConnected){       		 		
       		 dc.drawBitmap2(dc.getWidth()/2 - bluetooth_icon_on.getWidth() - 10 , 
			 	 dc.getHeight() - minutesHeight/2 + 20 + (tinyTextHeight-bluetooth_icon_on.getHeight())/2, 
				 bluetooth_icon_on,
				  {:tintColor=>LEFT_SMALLFONT_COLOR});
       }else{
       		dc.drawBitmap2(dc.getWidth()/2 - bluetooth_icon_on.getWidth() - 10 , 
			 	 dc.getHeight() - minutesHeight/2 + 20 + (tinyTextHeight-bluetooth_icon_on.getHeight())/2, 
				 bluetooth_icon_off,
				  {:tintColor=>LEFT_SMALLFONT_COLOR});
       }
            
       
       /*battery status*/
       var batteryStat = System.getSystemStats().battery;
       
       dc.setColor(RIGHT_SMALLFONT_COLOR, Gfx.COLOR_TRANSPARENT);
       dc.drawText(dc.getWidth()/2, dc.getHeight() - minutesHeight/2 + 20, Gfx.FONT_TINY, " " + batteryStat.format("%3d") + "%", Gfx.TEXT_JUSTIFY_LEFT);

		/*no of messages*/
		if(Sys.getDeviceSettings().notificationCount > 0){
			dc.setColor(RIGHT_SMALLFONT_COLOR, Gfx.COLOR_TRANSPARENT);
       		dc.drawText(dc.getWidth()/2 , dc.getHeight() - minutesHeight/2 + 20, Gfx.FONT_TINY, "           #" + Sys.getDeviceSettings().notificationCount.format("%1d") , Gfx.TEXT_JUSTIFY_LEFT);
		}

		/*heart rate*/       
	   var hearRate = (hasComplications and cur_hr != null) ? cur_hr : Activity.getActivityInfo().currentHeartRate;
             
       dc.setColor(RIGHT_SMALLFONT_COLOR, Gfx.COLOR_TRANSPARENT);
	   
	   
       dc.drawText(dc.getWidth()/2 , dc.getHeight() - minutesHeight/2 + tinyTextHeight + 20 , Gfx.FONT_TINY, " " + hearRate.format("%3d"), Gfx.TEXT_JUSTIFY_LEFT);

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
    
	//Partial updates can be used to update a small part of the screen to allow for Always On Watch Faces.
    function onPartialUpdate(dc) as Void{
		System.println("onPartialUpdate called !!!");
	}

}
