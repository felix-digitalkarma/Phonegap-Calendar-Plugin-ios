/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },
  
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },

    onDeviceReady: function() {
        app.receivedEvent('deviceready');
    },
    
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        
        console.log('Received Event: ' + id);
    },
    
    createMyEvent : function(){
        var cal = window.plugins.calendarPlugin;
        
        console.log("creating event");
        var title= "My Sample Appt";
        var location = "Los Angeles";
        var notes = "This is a sample note";
        var startDate = "2013-03-15 09:30:00";
        var endDate = "2013-03-15 12:30:00";
        
        console.log(title);
        console.log(location);
        console.log(notes);
        console.log(startDate);
        console.log(endDate);
        
        cal.createEvent(title,location,notes,startDate,endDate,app.onSuccess,app.onError);
    },
    
    onSuccess : function(){
        console.log('success');
    },
    
    onError : function() {
        console.log('error');
    }
};
