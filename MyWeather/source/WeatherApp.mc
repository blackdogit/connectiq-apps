using Toybox.Application as App;

class WeatherApp extends App.AppBase {
    hidden var myModel;
    hidden var myController;

    function onStart() {
        myModel = new DataModel();
        myController = new ViewController(myModel);
        // Hack to set this
        myController.this = myController;
    }

    function onStop() {
    }

    function getInitialView() {
        return [ new SplashScreen(myController), myController ];
    }
}