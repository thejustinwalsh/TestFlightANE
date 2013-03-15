//
//  TestFlight.m
//  TestFlight Adobe Air Native Extension
//
//  Created by Justin Walsh on 3/1/12.
//  Copyright (c) 2012 Justin Walsh. All rights reserved.
//

//
// Logger performs the logging action in the background, testflight went back and forth
// with async vs sync logging, so we will always do it in the background to be safe
//
@interface Logger : NSObject { }
- (void)log:(NSString*)message;
- (void)doLogging:(NSString*)message;
@end

@implementation Logger
- (void)log:(NSString*)message {
    [self performSelectorInBackground:@selector(doLogging:) withObject:message];
}

- (void)doLogging:(NSString*)message {
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    TFLog(message);
    [pool drain];
}
@end

Logger* logger = nil;
BOOL inFlight = NO;


//
// addCustomEnvironmentInformation(key:String, value:String):void
//
FREObject TestFlight_AddCustomEnvironmentInformation(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    uint32_t keyLength = 0;
    const uint8_t *key = nil;
    NSString *pKey = nil;

    uint32_t valueLength = 0;
    const uint8_t *value = nil;
    NSString *pValue = nil;

    if (argc == 2)
    {
        FREObjectType keyType = FRE_TYPE_NULL;
        FREObjectType valueType = FRE_TYPE_NULL;
        FREGetObjectType(argv[0], &keyType);
        FREGetObjectType(argv[1], &valueType);

        if (keyType == FRE_TYPE_STRING && valueType == FRE_TYPE_STRING)
        {
            FREGetObjectAsUTF8(argv[0], &keyLength, &key);
            FREGetObjectAsUTF8(argv[1], &valueLength, &value);
            if (keyLength > 0)
            {
                pKey = [NSString stringWithUTF8String:(const char *)key];
                pValue = [NSString stringWithUTF8String:(const char *)value];
                [TestFlight addCustomEnvironmentInformation:pValue forKey:pKey];
            }
        }
    }

    return nil;
}


//
// takeOff(teamToken:String):Boolean
//
FREObject TestFlight_TakeOff(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject returnValue;
    BOOL success = NO;
    
    uint32_t tokenLength = 0;
    const uint8_t *appToken = nil;
    NSString *pAppToken = nil;
    
    // Only allow takeOff to happen once
    if (inFlight == NO)
    {
        if (argc == 1)
        {
            FREObjectType argumentType = FRE_TYPE_NULL;
            FREGetObjectType(argv[0], &argumentType);
            if (argumentType == FRE_TYPE_STRING)
            {
                FREGetObjectAsUTF8(argv[0], &tokenLength, &appToken);
                if (tokenLength > 0)
                {
                    pAppToken = [NSString stringWithUTF8String:(const char *)appToken];
                    [TestFlight takeOff:pAppToken];
                    success = inFlight = YES;
                }
            }
        }
    }
    else
    {
        success = YES;
    }
    
    FRENewObjectFromBool(success, &returnValue);    
	return returnValue;
}

//
// setDeviceIdentifier():void
//
FREObject TestFlight_SetDeviceIdentifier(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    if (inFlight == NO)
    {
        [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    }

    return nil;
}


//
// setOptions(reinstallCrashHandlers:Boolean, logToConsole:Boolean, logToSTDERR:Boolean, sendLogOnlyOnCrash:Boolean):void
//
FREObject TestFlight_SetOptions(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    // TODO: Set Options
    return nil;
}


//
// passCheckpoint(checkpointName:String):void
//
FREObject TestFlight_PassCheckpoint(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    uint32_t checkpointNameLength = 0;
    const uint8_t *checkpointName = nil;
    NSString *pCheckPointName = nil;
    
    if (argc == 1)
    {
        FREObjectType argumentType = FRE_TYPE_NULL;
        FREGetObjectType(argv[0], &argumentType);
        if (argumentType == FRE_TYPE_STRING)
        {
            FREGetObjectAsUTF8(argv[0], &checkpointNameLength, &checkpointName);
            if (checkpointNameLength > 0)
            {
                pCheckPointName = [NSString stringWithUTF8String:(const char *)checkpointName];
                [TestFlight passCheckpoint:pCheckPointName];
            }
        }
    }
    
    return nil;
}


//
// openFeedbackView():void
//
FREObject TestFlight_OpenFeedbackView(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    [TestFlight openFeedbackView];
    return nil;
}


//
// submitFeedback(feedback:String):void
//
FREObject TestFlight_SubmitFeedback(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    uint32_t feedbackLength = 0;
    const uint8_t *feedback = nil;
    NSString *pFeedback = nil;
    
    if (argc == 1)
    {
        FREObjectType argumentType = FRE_TYPE_NULL;
        FREGetObjectType(argv[0], &argumentType);
        if (argumentType == FRE_TYPE_STRING)
        {        
            FREGetObjectAsUTF8(argv[0], &feedbackLength, &feedback);
            if (feedbackLength > 0)
            {
                pFeedback = [NSString stringWithUTF8String:(const char *)feedback];
                [TestFlight submitFeedback:pFeedback];
            }
        }
    }
    
    return nil;
}


//
// log(message:String, ...):void
//
FREObject TestFlight_Log(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    uint32_t logStringLength = 0;
    const uint8_t *logString = nil;
    NSString *pLogString = nil;
    
    if (argc == 1)
    {
        FREObjectType argumentType = FRE_TYPE_NULL;
        FREGetObjectType(argv[0], &argumentType);
        if (argumentType == FRE_TYPE_STRING)
        {
            FREGetObjectAsUTF8(argv[0], &logStringLength, &logString);
            if (logStringLength > 0)
            {
                pLogString = [[NSString alloc] initWithUTF8String:(const char *)logString];
                [logger log:pLogString];
                [pLogString release];
            }
        }
    }
        
    return nil;
}

//
// ContextInitializer() 
//
void TestFlight_ContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    #define BOUND_FUNCTION_COUNT 8
    
	*numFunctionsToTest = BOUND_FUNCTION_COUNT;
	FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction) * BOUND_FUNCTION_COUNT);
    
    func[0].name = (const uint8_t*)"addCustomEnvironmentInformation";
	func[0].functionData = NULL;
	func[0].function = &TestFlight_AddCustomEnvironmentInformation;
    
	func[1].name = (const uint8_t*)"takeOff";
	func[1].functionData = NULL;
	func[1].function = &TestFlight_TakeOff;
    
	func[2].name = (const uint8_t*)"setOptions";
	func[2].functionData = NULL;
	func[2].function = &TestFlight_SetOptions;
    
	func[3].name = (const uint8_t*)"passCheckpoint";
	func[3].functionData = NULL;
	func[3].function = &TestFlight_PassCheckpoint;
	
    func[4].name = (const uint8_t*)"openFeedbackView";
	func[4].functionData = NULL;
	func[4].function = &TestFlight_OpenFeedbackView;
    
	func[5].name = (const uint8_t*)"submitFeedback";
	func[5].functionData = NULL;
	func[5].function = &TestFlight_SubmitFeedback;
    
    func[6].name = (const uint8_t*)"log";
	func[6].functionData = NULL;
	func[6].function = &TestFlight_Log;

    func[7].name = (const uint8_t*)"setDeviceIdentifier";
    func[7].functionData = NULL;
    func[7].function = &TestFlight_SetDeviceIdentifier;
    
	*functionsToSet = func;
    
    if (logger == nil) logger = [[[Logger alloc] init] retain];

}

//
// ContextFinalizer()
//
void TestFlight_ContextFinalizer(FREContext ctx)
{     
    if (logger) [logger release];
}

//
// ExtInitializer()
//
void TestFlightExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{    
	*extDataToSet = NULL;
	*ctxInitializerToSet = &TestFlight_ContextInitializer; 
	*ctxFinalizerToSet = &TestFlight_ContextFinalizer;
}  

//
// ExtFinalizer()
//
void TestFlightExtFinalizer(void* extData)
{
	return;
}
