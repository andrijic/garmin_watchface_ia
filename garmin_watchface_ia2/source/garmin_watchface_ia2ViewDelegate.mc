import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Complications;

class garmin_watchface_ia2ViewDelegate extends WatchUi.WatchFaceDelegate
{
	var view;
	
	function initialize(v) {
		WatchFaceDelegate.initialize();
		view=v;	
	}

    function onPress(evt) {
        System.println("on press!!!");
        var c=evt.getCoordinates();
        //if(c[1]>=view.hrY  && c[1]<view.pushStepY && view.hrId!=null) {
            Complications.exitTo(view.complic_heart_rate_id);
        //}
        return true;
    }

    function onPowerBudgetExceeded(powerInfo as WatchUi.WatchFacePowerInfo) as Void{
        System.println("onPowerBudgetExceeded !!!!");
    }
}