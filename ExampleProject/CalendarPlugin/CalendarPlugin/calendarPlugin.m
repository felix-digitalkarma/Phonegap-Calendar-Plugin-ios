//
//  calendarPlugin.m
//  Author: Felix Montanez
//  Date: 01-17-2011
//  Notes:
//
// Contributors : Sean Bedford


#import "calendarPlugin.h"
#import <EventKitUI/EventKitUI.h>
#import <EventKit/EventKit.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation calendarPlugin
@synthesize eventStore;

#pragma mark Initialisation functions

- (CDVPlugin*) initWithWebView:(UIWebView*)theWebView
{
    self = (calendarPlugin*)[super initWithWebView:theWebView];
    if (self) {
		//[self setup];
        [self initEventStoreWithCalendarCapabilities];
    }
    return self;
}

- (void)initEventStoreWithCalendarCapabilities {
    // Check for EventStore that is useful
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        // Need to request calendar permissions
        EKEventStore *localEventStore = [[EKEventStore alloc] init];
        [localEventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
            if (granted) {
                self.eventStore = localEventStore;
            }
            else {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"No Event Support" message:@"There will be no support to view your calendar" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [av show];
                [av release];
            }
        }];
        
    }
    else {
        self.eventStore = [[EKEventStore alloc] init];
    }
}

#pragma mark Helper Functions

-(NSArray*)findEKEventsWithTitle: (NSString *)title
                        location: (NSString *)location
                         message: (NSString *)message
                       startDate: (NSDate *)startDate
                         endDate: (NSDate *)endDate {
    
    // Build up a predicateString - this means we only query a parameter if we actually had a value in it
    NSMutableString *predicateString;
    [predicateString appendString:@""];
    if (title.length > 0) {
        [predicateString appendString:[NSString stringWithFormat:@"title LIKE %@" , title]];
    }
    if (location.length > 0) {
        [predicateString appendString:[NSString stringWithFormat:@"AND location LIKE %@" , location]];
    }
    if (message.length > 0) {
        [predicateString appendString:[NSString stringWithFormat:@"AND message LIKE %@" , message]];
    }
    
    NSPredicate *matches = [NSPredicate predicateWithFormat:predicateString];
    
    NSArray *matchingEvents = [[self.eventStore eventsMatchingPredicate:[eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil]] filteredArrayUsingPredicate:matches];
    
    
    return matchingEvents;
}

#pragma mark Cordova functions

-(void)createEvent:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options 
{
    EKEvent *myEvent = [EKEvent eventWithEventStore: self.eventStore];
    // Import arguments
    NSString *succFunc = [arguments objectAtIndex:0];
    NSString *errFunc = [arguments objectAtIndex:1];
    NSString* title      = [arguments objectAtIndex:2];
    NSString* location   = [arguments objectAtIndex:3];
    NSString* message    = [arguments objectAtIndex:4];
    NSString *startDate  = [arguments objectAtIndex:5];
    NSString *endDate    = [arguments objectAtIndex:6];
    
    
    //creating the dateformatter object
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *myStartDate = [df dateFromString:startDate];
    NSDate *myEndDate = [df dateFromString:endDate];
    
    myEvent.title = title;
    myEvent.location = location;
    myEvent.notes = message;
    myEvent.startDate = myStartDate;
    myEvent.endDate = myEndDate;
    myEvent.calendar = self.eventStore.defaultCalendarForNewEvents;
    
    
    EKAlarm *reminder = [EKAlarm alarmWithRelativeOffset:-2*60*60];
    
    [myEvent addAlarm:reminder];
    
    NSError *error = nil;
    [self.eventStore saveEvent:myEvent span:EKSpanThisEvent error:&error];
    
    // Check error code + return result
    if (error) {
        CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                           messageAsString:error.userInfo.description];
        [self writeJavascript:[pluginResult toErrorCallbackString:errFunc]];
        
    }
    else {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self writeJavascript:[pluginResult toSuccessCallbackString:succFunc]];
    }
}

-(void)deleteEvent:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options {
    // Import arguments
    NSString *succFunc = [arguments objectAtIndex:0];
    NSString *errFunc = [arguments objectAtIndex:1];
    NSString* title      = [arguments objectAtIndex:2];
    NSString* location   = [arguments objectAtIndex:3];
    NSString* message    = [arguments objectAtIndex:4];
    NSString *startDate  = [arguments objectAtIndex:5];
    NSString *endDate    = [arguments objectAtIndex:6];
    
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *myStartDate = [df dateFromString:startDate];
    NSDate *myEndDate = [df dateFromString:endDate];
    
    NSArray *matchingEvents = [self findEKEventsWithTitle:title location:location message:message startDate:myStartDate endDate:myEndDate];
    

    if (matchingEvents.count == 1) {
        // Definitive single match - delete it!      
        NSError *error = NULL;
        [self.eventStore removeEvent:[matchingEvents lastObject] span:EKSpanThisEvent error:&error];
        // Check for error codes and return result
        if (error) {
            CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                               messageAsString:error.userInfo.description];
            [self writeJavascript:[pluginResult toErrorCallbackString:errFunc]];
            
        }
        else {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self writeJavascript:[pluginResult toSuccessCallbackString:succFunc]];
        }
    }

}

-(void)findEvent:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options {
    NSString *succFunc = [arguments objectAtIndex:0];
    NSString *errFunc = [arguments objectAtIndex:1];
    NSString* title      = [arguments objectAtIndex:2];
    NSString* location   = [arguments objectAtIndex:3];
    NSString* message    = [arguments objectAtIndex:4];
    NSString *startDate  = [arguments objectAtIndex:5];
    NSString *endDate    = [arguments objectAtIndex:6];
    
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *myStartDate = [df dateFromString:startDate];
    NSDate *myEndDate = [df dateFromString:endDate];
    
    NSArray *matchingEvents = [self findEKEventsWithTitle:title location:location message:message startDate:myStartDate endDate:myEndDate];
    
    if (matchingEvents.count > 0) {
        // Return the results we got
        CDVPluginResult* result = [CDVPluginResult
                                   resultWithStatus: CDVCommandStatus_OK
                                   messageAsArray: matchingEvents
                                   ];
        [self writeJavascript:[result toSuccessCallbackString:succFunc]];
    }
    else {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
        [self writeJavascript:[result toErrorCallbackString:errFunc]];
    }
    
}

 
-(void)modifyEvent:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options {
    NSString *succFunc = [arguments objectAtIndex:0];
    NSString *errFunc = [arguments objectAtIndex:1];
    NSString* title      = [arguments objectAtIndex:2];
    NSString* location   = [arguments objectAtIndex:3];
    NSString* message    = [arguments objectAtIndex:4];
    NSString *startDate  = [arguments objectAtIndex:5];
    NSString *endDate    = [arguments objectAtIndex:6];
    
    // Make NSDates from our strings
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *myStartDate = [df dateFromString:startDate];
    NSDate *myEndDate = [df dateFromString:endDate];
    
    // Find matches
    NSArray *matchingEvents = [self findEKEventsWithTitle:title location:location message:message startDate:myStartDate endDate:myEndDate];
    
    if (matchingEvents.count == 1) {
        // Presume we have to have an exact match to modify it!
        // Need to load this event from an EKEventStore so we can edit it
        EKEvent *theEvent = [self.eventStore eventWithIdentifier:((EKEvent*)[matchingEvents lastObject]).eventIdentifier];
        theEvent.title = title;
        theEvent.location = location;
        theEvent.notes = message;
        theEvent.startDate = myStartDate;
        theEvent.endDate = myEndDate;
        
        // Now save the new details back to the store
        NSError *error = nil;
        [self.eventStore saveEvent:theEvent span:EKSpanThisEvent error:&error];
        
        // Check error code + return result
        if (error) {
            CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                               messageAsString:error.userInfo.description];
            [self writeJavascript:[pluginResult toErrorCallbackString:errFunc]];
            
        }
        else {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self writeJavascript:[pluginResult toSuccessCallbackString:succFunc]];
        }
    }
    else {
        // Otherwise return a no result error
        CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
        [self writeJavascript:[pluginResult toErrorCallbackString:errFunc]];
    }
    
}

@end
