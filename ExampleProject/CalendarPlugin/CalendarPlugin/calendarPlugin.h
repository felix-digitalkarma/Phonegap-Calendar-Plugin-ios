//
//  calendarPlugin.h
//  Author: Felix Montanez
//  Date: 01-17-2011
//  Notes:
//

#import <Foundation/Foundation.h>
#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVPlugin.h>
#else
#import "CDVPlugin.h"
#endif
#import <EventKitUI/EventKitUI.h>
#import <EventKit/EventKit.h>


@interface calendarPlugin : CDVPlugin {
    //NSArray *events;
    
    //future plan to have global type variables
    
    
}


@property (nonatomic, retain) EKEventStore* eventStore;

- (void)initEventStoreWithCalendarCapabilities;

-(NSArray*)findEKEventsWithTitle: (NSString *)title
                        location: (NSString *)location
                         message: (NSString *)message
                       startDate: (NSDate *)startDate
                         endDate: (NSDate *)endDate;

// Calendar Instance methods
- (void)createEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)modifyEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)findEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

- (void)deleteEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
