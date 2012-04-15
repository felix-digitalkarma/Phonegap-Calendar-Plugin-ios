//
// PhoneGap Calendar Plugin
// Author: Felix Montanez 
// Created: 01-17-2012
//


function calendarPlugin()
{
}



calendarPlugin.prototype.createEvent = function(title,location,notes,startDate,endDate) {
    console.log("here");
    cordova.exec(null,null,"calendarPlugin","createEvent", [title,location,notes,startDate,endDate]);
};


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
