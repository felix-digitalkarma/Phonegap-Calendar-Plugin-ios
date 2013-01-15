//
// PhoneGap Calendar Plugin
// Author: Felix Montanez 
// Created: 01-17-2012
//
// Contributors : 
// Michael Brooks
// Sean Bedford
// 



function calendarPlugin()
{
}

calendarPlugin.prototype.createEvent = function(title,location,notes,startDate,endDate, successCallback, errorCallback) {
    if (typeof errorCallback != "function")  {
        console.log("calendarPlugin.createEvent failure: errorCallback parameter must be a function");
        return
    }
    
    if (typeof successCallback != "function") {
        console.log("calendarPlugin.createEvent failure: successCallback parameter must be a function");
        return
    }
    cordova.exec(successCallback,errorCallback,"calendarPlugin","createEvent", [title,location,notes,startDate,endDate]);
};

calendarPlugin.prototype.deleteEvent = function(title,location,notes,startDate,endDate, deleteAll, successCallback, errorCallback) {
    if (typeof errorCallback != "function")  {
        console.log("calendarPlugin.deleteEvent failure: errorCallback parameter must be a function");
        return
    }
    
    if (typeof successCallback != "function") {
        console.log("calendarPlugin.deleteEvent failure: successCallback parameter must be a function");
        return
    }
    cordova.exec(successCallback,errorCallback,"calendarPlugin","deleteEvent", [title,location,notes,startDate,endDate, deleteAll]);
}

calendarPlugin.prototype.findEvent = function(title,location,notes,startDate,endDate, successCallback, errorCallback) {
    if (typeof errorCallback != "function")  {
        console.log("calendarPlugin.findEvent failure: errorCallback parameter must be a function");
        return
    }
    
    if (typeof successCallback != "function") {
        console.log("calendarPlugin.findEvent failure: successCallback parameter must be a function");
        return
    }
    cordova.exec(successCallback,errorCallback,"calendarPlugin","findEvent", [title,location,notes,startDate,endDate]);
}

calendarPlugin.prototype.modifyEvent = function(title,location,notes,startDate,endDate, newTitle, newLocation, newNotes, newStartDate, newEndDate, successCallback, errorCallback) {
    if (typeof errorCallback != "function")  {
        console.log("calendarPlugin.modifyEvent failure: errorCallback parameter must be a function");
        return
    }
    
    if (typeof successCallback != "function") {
        console.log("calendarPlugin.modifyEvent failure: successCallback parameter must be a function");
        return
    }
    cordova.exec(successCallback,errorCallback,"calendarPlugin","modifyEvent", [title,location,notes,startDate,endDate,newTitle, newLocation, newNotes, newStartDate, newEndDate]);
}

calendarPlugin.install = function()
{
    if(!window.plugins)
    {
        window.plugins = {};
    }
    
    window.plugins.calendarPlugin = new calendarPlugin();
    return window.plugins.calendarPlugin;
};

cordova.addConstructor(calendarPlugin.install);
