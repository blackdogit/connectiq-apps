module BDIT {
module GAPI {
    using Toybox.WatchUi as UI;
    using Toybox.System as Sys;
    using Toybox.Application as App;
    using Toybox.Timer as Timer;
    using Toybox.Communications as Comm;

    const VERSION = "1.0.0.20150307";

    //!
    //!
    //!
    //! The response method is called with the arguments
    //! method(Client, state)
    //!
    //!
    //! @param [String] clientID Google Client ID
    //! @param [Callback] responseCallback the method called on finish
    function logon(clientID) {
        var c = new Client(clientID, responseCallback);
        c.logon();
    }

//! Google API Client
//!
//! TODO:
//! - sun image below "My Weather"
//! - version number
    class Client {
        //! @type [App.AppBase]
        var myApp;

        //! Google Client ID
        //! @type [String]
        var myClientID;

        //! Wanted Client Scope
        //! @type [String]
        var myScope;

        //! Response Callback
        //! @type [Method]
        var myCallback;

        //! Current state. One of
        //! - null - uninitialized
        //! - :haveCode -
        //! -
        //! -
        //! -
        //! @type [String]
        var myState;

        //! @param [String] clientID Google Client ID
        //! @param [String] scope Wanted Client Scope
        function initialize(clientID, scope) {
            myApp = App.getApp();
            myClientID = clientID;
            myScope = scope;

            myState = myApp.getProperty("gapi.state");
        }

        //! @param [Method] responseCallback the method called on finish
        function logon(responseCallback) {
            myCallback = responseCallback;
            if (myState == null) {
                var req = {
                };
                var options = {
                    "client_id"=>myClientID,
                    "scope"=>myScope
                };
                callback("codeRequest");
                Sys.println("> makeJsonRequest(.../code)");
                Comm.makeJsonRequest("http://accounts.google.com/o/oauth2/device/code", req, options, method(:codeRequestCB));
            }
        }

        function codeRequestCB(code, data) {
            Sys.println("> codeRequestCB("+code+")");
            callback("codeResponse");
            myState = "codeRequest";
            // Last!
            myApp.setProperty("gapi.state");
        }

        hidden function callback(state) {
            Sys.println("> callback("+state+")");
            myCallback.invoke(self, state);
        }
    }
}
}