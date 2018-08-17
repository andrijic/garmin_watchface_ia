using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Time.Gregorian;
using Toybox.Time;

class garmin_watchface_ia2View extends Ui.WatchFace {

	var customFont = null;
	var bluetooth_icon_on = null;
	var bluetooth_icon_off = null;
	
    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        
        customFont = Ui.loadResource(Rez.Fonts.bodoni_font);
        bluetooth_icon_on = Ui.loadResource(Rez.Drawables.bluetooth_on_icon);
        bluetooth_icon_off = Ui.loadResource(Rez.Drawables.bluetooth_off_icon);
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        View.onUpdate(dc);
       dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
       dc.clear();
       var clockTime = Sys.getClockTime();
       var hour = clockTime.hour;
       var minutes = clockTime.min;

		/*background split screen*/
 	   dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_WHITE);
       dc.fillRectangle(0, 0, dc.getWidth()/2, dc.getHeight()*2);
       	
       	/*hour and minutes*/
      dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
       dc.drawText(dc.getWidth()/2, 22, customFont,hour.format("%02d"), Gfx.TEXT_JUSTIFY_RIGHT);
       
       dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
       dc.drawText(dc.getWidth()/2, 22, customFont, minutes.format("%02d"), Gfx.TEXT_JUSTIFY_LEFT);
       
     
     	/*date on top*/
     	var date = Time.now();
     	var info = Gregorian.info(date, Time.FORMAT_LONG);
     	
     	var clockString1 = Lang.format(
		    "$1$ $2$",
		    [
		        info.day,
		       info.month
		    ]
		);
     	
     	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
     	dc.drawText(dc.getWidth()/2 - 1, 20, Gfx.FONT_MEDIUM, clockString1, Gfx.TEXT_JUSTIFY_RIGHT);
     	
     	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
     	dc.drawText(dc.getWidth()/2 , 20, Gfx.FONT_MEDIUM, " " + info.year, Gfx.TEXT_JUSTIFY_LEFT);
       
       /*connection settings*/
       dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
       
       if(Sys.getDeviceSettings().phoneConnected){
       		 //dc.drawText(dc.getWidth()/2, dc.getHeight() - 45, Gfx.FONT_MEDIUM, "true  ", Gfx.TEXT_JUSTIFY_RIGHT);
       		 dc.drawBitmap(dc.getWidth()/2 - 25, dc.getHeight() - 38, bluetooth_icon_on);
       }else{
       		dc.drawBitmap(dc.getWidth()/2 - 25, dc.getHeight() - 38, bluetooth_icon_off);
       }
       
       /*battery status*/
       var batteryStat = System.getSystemStats().battery;
       
       dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
       dc.drawText(dc.getWidth()/2, dc.getHeight() - 45, Gfx.FONT_MEDIUM, "  " + batteryStat.format("%02d") + "%", Gfx.TEXT_JUSTIFY_LEFT);

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
