using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Time.Gregorian;
using Toybox.Time;

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
	
    function initialize() {
        WatchFace.initialize();
        restorePersistedSettings();
    }

    // Load your resources here
    function onLayout(dc) {
        
        customFont = Ui.loadResource(Rez.Fonts.bodoni_font);
        bluetooth_icon_on = Ui.loadResource(Rez.Drawables.bluetooth_on_icon);
        bluetooth_icon_off = Ui.loadResource(Rez.Drawables.bluetooth_off_icon);
        alarm2_icon = Ui.loadResource(Rez.Drawables.alarm2_icon);
        setLayout(Rez.Layouts.WatchFace(dc));
        
    }
    
    function restorePersistedSettings(){
    	//persist change properties
		var app = Application.getApp();
		
		LEFT_BACK_COLOR = getValidProperty(app, "BackgroundLeftColor", 0xFFFFFF);
		RIGHT_BACK_COLOR = getValidProperty(app, "BackgroundRightColor", 0x000000);
		LEFT_FONT_COLOR = getValidProperty(app, "FontLeftColor", 0xFF0000);
		RIGHT_FONT_COLOR = getValidProperty(app, "FontRightColor", 0x00FF00);
		LEFT_SMALLFONT_COLOR = getValidProperty(app, "FontSmallLeftColor", 0x000000);
		RIGHT_SMALLFONT_COLOR = getValidProperty(app, "FontSmallRightColor", 0xFFFFFF);
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
		LEFT_BACK_COLOR = Application.getApp().getProperty("BackgroundLeftColor");
		RIGHT_BACK_COLOR = Application.getApp().getProperty("BackgroundRightColor");
		LEFT_FONT_COLOR = Application.getApp().getProperty("FontLeftColor");
		RIGHT_FONT_COLOR = Application.getApp().getProperty("FontRightColor");
		LEFT_SMALLFONT_COLOR = Application.getApp().getProperty("FontSmallLeftColor");
		RIGHT_SMALLFONT_COLOR = Application.getApp().getProperty("FontSmallRightColor");
		
		//persist change properties
		var app = Application.getApp();
    	
    	app.setProperty("BackgroundLeftColor", LEFT_BACK_COLOR);    	
    	app.setProperty("BackgroundRightColor", RIGHT_BACK_COLOR);
    	app.setProperty("FontLeftColor", LEFT_FONT_COLOR);
    	app.setProperty("FontRightColor", RIGHT_FONT_COLOR);
    	app.setProperty("FontSmallLeftColor", LEFT_SMALLFONT_COLOR);
    	app.setProperty("FontSmallRightColor", RIGHT_SMALLFONT_COLOR);
    	    	
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

		/*background split screen*/
 	   dc.setColor(LEFT_BACK_COLOR, LEFT_BACK_COLOR);
       dc.fillRectangle(0, 0, dc.getWidth()/2, dc.getHeight()*2);
       	
       	/*hour and minutes*/
      dc.setColor(LEFT_FONT_COLOR, Gfx.COLOR_TRANSPARENT);
       dc.drawText(dc.getWidth()/2 - 5, 22, customFont,hour.format("%02d"), Gfx.TEXT_JUSTIFY_RIGHT);
       
       dc.setColor(RIGHT_FONT_COLOR, Gfx.COLOR_TRANSPARENT);
       dc.drawText(dc.getWidth()/2 + 5, 22, customFont, minutes.format("%02d"), Gfx.TEXT_JUSTIFY_LEFT);
       
     
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
     	dc.drawText(dc.getWidth()/2 - 1, 20, Gfx.FONT_MEDIUM, clockString1, Gfx.TEXT_JUSTIFY_RIGHT);
     	
     	
     	dc.setColor(RIGHT_SMALLFONT_COLOR, Gfx.COLOR_TRANSPARENT);
     	dc.drawText(dc.getWidth()/2 , 20, Gfx.FONT_MEDIUM, " W" + weekOfYear, Gfx.TEXT_JUSTIFY_LEFT);
     	
     	/*alarm status*/
     	if(Sys.getDeviceSettings().alarmCount > 0){       		 
       		 dc.drawBitmap(dc.getWidth()/2 - 50, dc.getHeight() - 42, alarm2_icon);
       }             
     	       
       /*android device connection status*/
       //dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
       
       if(Sys.getDeviceSettings().phoneConnected){
       		 //dc.drawText(dc.getWidth()/2, dc.getHeight() - 45, Gfx.FONT_MEDIUM, "true  ", Gfx.TEXT_JUSTIFY_RIGHT);
       		 dc.drawBitmap(dc.getWidth()/2 - 25, dc.getHeight() - 42, bluetooth_icon_on);
       }else{
       		//dc.drawBitmap(dc.getWidth()/2 - 25, dc.getHeight() - 42, bluetooth_icon_off);
       }
            
       
       /*battery status*/
       var batteryStat = System.getSystemStats().battery;
       
       dc.setColor(RIGHT_SMALLFONT_COLOR, Gfx.COLOR_TRANSPARENT);
       dc.drawText(dc.getWidth()/2, dc.getHeight() - 43, Gfx.FONT_TINY, " " + batteryStat.format("%3d") + "%", Gfx.TEXT_JUSTIFY_LEFT);

		/*no of messages*/
		if(Sys.getDeviceSettings().notificationCount > 0){
			dc.setColor(RIGHT_SMALLFONT_COLOR, Gfx.COLOR_TRANSPARENT);
       		dc.drawText(dc.getWidth()/2 , dc.getHeight() - 43, Gfx.FONT_TINY, "            #" + Sys.getDeviceSettings().notificationCount.format("%1d") , Gfx.TEXT_JUSTIFY_LEFT);
		}
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
    
   

}
