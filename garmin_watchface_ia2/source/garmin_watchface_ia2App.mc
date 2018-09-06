using Toybox.Application;
using Toybox.WatchUi;

class garmin_watchface_ia2App extends Application.AppBase {

	var myView;
	
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
    	myView = new garmin_watchface_ia2View();
        return [ myView ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {
        WatchUi.requestUpdate();
        if(myView != null){
        	myView.handleSettingsChanged();
        }
    }

}