//
//  AppDelegate.m
//  GetDistance
//
//  Created by Honghao on 8/2/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate() <NSTextFieldDelegate>

@end

@implementation AppDelegate {
    NSString *key;
    NSString *baseURL;
    int checker;
    NSPasteboard *pasteboard;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    key = @"AIzaSyDftpY3fi6x_TL4rntL8pgZb-A8mf6D0Ss";
    baseURL = @"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&key=%@&departure_time=1407240000&mode=%@";
//    https://maps.googleapis.com/maps/api/directions/json?alternatives=true&origin=N2L3G1&destination=N2L3E6&sensor=false&key=AIzaSyDftpY3fi6x_TL4rntL8pgZb-A8mf6D0Ss
    
    pasteboard = [NSPasteboard generalPasteboard];
    _origin.delegate = self;
    _destination.delegate = self;
    _driveDistance.delegate = self;
    _driveDistance.selectable = YES;
    _transitTime.delegate = self;
    _transitTime.selectable = YES;
    _bathRoom.delegate = self;
    _isApartment.delegate = self;
    _rentFee.delegate = self;
    
    [_destination becomeFirstResponder];
}

- (IBAction)get:(id)sender {
    checker = 0;
    [_driveDistance setStringValue:@""];
    [_transitTime setStringValue:@""];
    [_resultTextField setStringValue:@""];
    NSString *origin = [self urlEncodeString:_origin.stringValue];
    NSString *desination = [self urlEncodeString:_destination.stringValue];
    NSString *requestURLstring = [NSString stringWithFormat:baseURL, origin, desination, key, @"driving"];
    NSLog(@"%@", requestURLstring);
    NSURL *url = [NSURL URLWithString:requestURLstring];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray *routes = json[@"routes"];
//        [_driveDistance setStringValue:driveDist];
        [_driveDistance setStringValue:[self getDistanceFromDriveRoute:routes[0]]];
        NSLog(@"%f", [self getNumberFromString:_driveDistance.stringValue]);
        checker++;
        [self paste];
    }];
    
    [task resume];
    
    requestURLstring = [NSString stringWithFormat:baseURL, origin, desination, key, @"transit"];
    NSLog(@"%@", requestURLstring);
    url = [NSURL URLWithString:requestURLstring];
    request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *taskTransit = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSArray *routes = json[@"routes"];
//        for (NSDictionary *eachRoute in routes) {
//            <#statements#>
//        }
//        NSString *driveDist = json[@"routes"][0][@"legs"][0][@"distance"][@"text"];
        [_transitTime setStringValue:[self getTimeFromTransitRoute:routes[0]]];
        NSLog(@"%f", [self getNumberFromString:_transitTime.stringValue]);
        checker++;
        [self paste];
    }];
    [taskTransit resume];
}

-(NSString *)urlEncodeString:(NSString *)stringToURLEncode{
    // URL-encode the parameter string and return it.
    CFStringRef encodedURL = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                     (CFStringRef) stringToURLEncode,
                                                                     NULL,
                                                                     (CFStringRef)@"!@#$%&*'();:=+,/?[]",
                                                                     kCFStringEncodingUTF8);
    return (NSString *)CFBridgingRelease(encodedURL);
}

- (float)getNumberFromString:(NSString *)string {
    NSString *subString = [string substringToIndex:[string rangeOfString:@" "].location];
    return [subString doubleValue];
}

- (NSString *)getDistanceFromDriveRoute:(NSDictionary *)route {
    return route[@"legs"][0][@"distance"][@"text"];
}

- (NSString *)getTimeFromTransitRoute:(NSDictionary *)route {
    return route[@"legs"][0][@"duration"][@"text"];
}

- (void)paste {
    if (checker == 2) {
        [pasteboard clearContents];
        NSString *pasteString = [NSString stringWithFormat:@"%.1f %.0f %@ %@ %@", [self getNumberFromString:_driveDistance.stringValue], [self getNumberFromString:_transitTime.stringValue], _bathRoom.stringValue, _isApartment.stringValue, _rentFee.stringValue];
        [pasteboard writeObjects:@[pasteString]];
        [_resultTextField setStringValue:pasteString];
        [_resultTextField becomeFirstResponder];
    }
}
- (IBAction)textFieldSelceted:(id)sender {
    NSLog(@"sadasd");
//    NSTextField *textField = (NSTextField *)sender;
    [self simulateSelectAll];
//    [textField becomeFirstResponder];
//    NSRange range = {0, 2};
//    [textField selectText:nil];
//    [sender performSelector:@selector(selectText:) withObject:nil afterDelay:0];
//    NSText* textEditor = [self.window fieldEditor:YES forObject:textField];
//    NSRange range = {0, 2};
//    [textEditor setSelectedRange:range];
    
//    [textField selectText:nil];
}

- (void)simulateSelectAll {
    CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
    
    CGEventRef pressDownCommand_S = CGEventCreateKeyboardEvent(source, (CGKeyCode)0, YES);
    CGEventSetFlags(pressDownCommand_S, kCGEventFlagMaskCommand);
    CGEventRef pressUpS = CGEventCreateKeyboardEvent(source, (CGKeyCode)0, NO);
    
    CGEventPost(kCGAnnotatedSessionEventTap, pressDownCommand_S);
    CGEventPost(kCGAnnotatedSessionEventTap, pressUpS);
    
    CFRelease(pressUpS);
    CFRelease(pressDownCommand_S);
    CFRelease(source);
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
