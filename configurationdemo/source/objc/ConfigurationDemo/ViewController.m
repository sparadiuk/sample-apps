/**
 *  Copyright 2014-2016 CyberVision, Inc.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#import "ViewController.h"

@import Kaa;

@interface ViewController () <KaaClientStateDelegate, ConfigurationDelegate, ProfileContainer>

@property (nonatomic, weak) IBOutlet UITextView *logTextView;

@property (nonatomic, strong) id<KaaClient> kaaClient;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addLogWithText:@"ConfigurationDemo started"];

    // Create a Kaa client and add a listener which displays the Kaa client configuration
    // as soon as the Kaa client is started.
    self.kaaClient = [KaaClientFactory clientWithStateDelegate:self];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *configurationPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"savedconfig.cfg"];

    // Persist configuration in a local storage to avoid downloading it each time the Kaa client is started.
    [self.kaaClient setConfigurationStorage:[SimpleConfigurationStorage storageWithPath:configurationPath]];
    
    // Add a listener which displays the Kaa client configuration each time it is updated.
    [self.kaaClient addConfigurationDelegate:self];
    
    [self.kaaClient setProfileContainer:self];
    
    // Start the Kaa client and connect it to the Kaa server.
    [self.kaaClient start];
}

#pragma mark - Delegate methods

- (void)onStarted {
    [self addLogWithText:@"Kaa client started"];
    [self displayConfiguration];
}

- (void)onStopped {
    [self addLogWithText:@"Kaa client stopped"];
}

- (void)onStartFailureWithException:(NSException *)exception {
    [self addLogWithText:[NSString stringWithFormat:@"START FAILURE: %@ : %@", exception.name, exception.reason]];
}

- (void)onPaused {
    [self addLogWithText:@"Client paused"];
}

- (void)onPauseFailureWithException:(NSException *)exception {
    [self addLogWithText:[NSString stringWithFormat:@"PAUSE FAILURE: %@ : %@", exception.name, exception.reason]];
}

- (void)onResume {
    [self addLogWithText:@"Client resumed"];
}

- (void)onResumeFailureWithException:(NSException *)exception {
    [self addLogWithText:[NSString stringWithFormat:@"RESUME FAILURE: %@ : %@", exception.name, exception.reason]];
}

- (void)onStopFailureWithException:(NSException *)exception {
    [self addLogWithText:[NSString stringWithFormat:@"STOP FAILURE: %@ : %@", exception.name, exception.reason]];
}

- (KAAEmptyData *)getProfile {
    return [[KAAEmptyData alloc] init];
}

- (void)onConfigurationUpdate:(KAASampleConfiguration *)configuration {
    [self addLogWithText:@"Configuration was updated"];
    [self displayConfiguration];
}

- (void)displayConfiguration {
    KAASampleConfiguration *configuration = [self.kaaClient getConfiguration];
    NSArray *links = [configuration AddressList].data;
    NSMutableString *confBody = [NSMutableString stringWithFormat:@"Configuration body :\n"];
    for (KAALink *link in links) {
        [confBody appendString:[NSString stringWithFormat:@"%@ - %@\n", link.label, link.url]];
    }
    [self addLogWithText:confBody];
}

- (void) addLogWithText:(NSString *) text {
    NSLog(@"%@", text);
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.logTextView.text = [NSString stringWithFormat:@"%@%@\n", self.logTextView.text, text];
    }];
}

@end
