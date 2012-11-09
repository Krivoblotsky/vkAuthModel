//
//  VKModel.m
//  MusicBox
//
//  Created by Serg Krivoblotsky on 10/3/12.
//
//

#import "VKModel.h"

#define kClientId    2842739
#define kSecurityKey @"E38EkTPE7H7nlKNEkAVE"

#define kLoginURL            @"https://oauth.vk.com/token?grant_type=password&client_id=%d&client_secret=%@&username=%@&password=%@&scope=audio"
#define kRegisterURL         @"https://api.vk.com/method/auth.signup.json?cliend_id=%d&test_mode=%d&first_name=%@&last_name=%@&phone=%@&password=%@&client_secret=%@"
#define kCheckPhoneURL       @"https://api.vk.com/method/auth.checkPhone.json?cliend_id=%d&client_secret=%@&phone=%@"
#define KFinishRegisterURL   @"https://api.vk.com/method/auth.confirm.json?cliend_id=%d&client_secret=%@&phone=%@&code=%@&password=%@&test_mode=%d"

@implementation VKModel

#pragma mark - Login
- (void)connectToVCWithUserName:(NSString *)name
                       password:(NSString *)password
                    resultBlock:(void (^)(NSDictionary *result))successBlock
                     errorBlock:(void (^)(NSDictionary *result, NSError *error))errorBlock {
    
    NSString *loginURL = [NSString stringWithFormat:kLoginURL, kClientId, kSecurityKey, name, password];
    [self startConnectctionWithURL:loginURL successBlock:successBlock failedBlock:errorBlock];
}

#pragma mark - Register
- (void)registerUserWithFirstName:(NSString *)name
                         lastName:(NSString *)lastName
                         password:(NSString *)password
                      phoneNumber:(NSString *)phoneNumber
                         testMode:(BOOL)testMode
                      resultBlock:(void (^)(NSDictionary *result))successBlock
                       errorBlock:(void (^)(NSDictionary *result, NSError *error))errorBlock {
    
    NSString *registerURL = [NSString stringWithFormat:kRegisterURL, kClientId, testMode, name, lastName, phoneNumber, password, kSecurityKey];
    [self startConnectctionWithURL:registerURL successBlock:successBlock failedBlock:errorBlock];
}

#pragma mark - CheckPhone
- (void)checkPhone:(NSString *)phone
       resultBlock:(void (^)(NSDictionary *result))successBlock
        errorBlock:(void (^)(NSDictionary *result, NSError *error))errorBlock {
    
    NSString *checkPhoneURL = [NSString stringWithFormat:kCheckPhoneURL, kClientId, kSecurityKey, phone];
    [self startConnectctionWithURL:checkPhoneURL successBlock:successBlock failedBlock:errorBlock];
}

- (void)confirmPhone:(NSString *)phone
            password:(NSString *)password
                code:(NSString *)code
            testMode:(NSInteger)testMode
       resultBlock:(void (^)(NSDictionary *result))successBlock
        errorBlock:(void (^)(NSDictionary *result, NSError *error))errorBlock {
    
    NSString *checkPhoneURL = [NSString stringWithFormat:KFinishRegisterURL, kClientId, kSecurityKey, phone, code,password, testMode];
    [self startConnectctionWithURL:checkPhoneURL successBlock:successBlock failedBlock:errorBlock];
}

#pragma mark - Common
- (void)startConnectctionWithURL:(NSString *)urlString
                    successBlock:(void (^)(NSDictionary *result))successBlock
                     failedBlock:(void (^)(NSDictionary *result, NSError *error))errorBlock {
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               //Connection failed
                               if (error != nil) {
                                   errorBlock(nil, error);
                                   return;
                               }
                               
                               NSError *jsonError = nil;
                               id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                               
                               //Can't parse json
                               if (jsonError != nil || object == nil) {
                                   errorBlock(nil, jsonError);
                                   return;
                               }
                               
                               //Json parsed
                               if ([object isKindOfClass:[NSDictionary class]]) {
                                   
                                   //VK login incorrect
                                   if (object[@"error"] != nil) {
                                       errorBlock(object, nil);
                                       return;
                                   }
                                   
                                   //Correct
                                   successBlock(object);
                               } else {
                                   errorBlock(nil, nil);
                               }
                           }];    
}

+ (NSString *)encodeSearchText:(NSString *)text {
    NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                   NULL,
                                                                                   (CFStringRef)text,
                                                                                   NULL,
                                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[] ",
                                                                                   kCFStringEncodingUTF8 );
    return encodedString;
}


@end
