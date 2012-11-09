//
//  VKModel.h
//  MusicBox
//
//  Created by Serg Krivoblotsky on 10/3/12.
//
//

#import <Foundation/Foundation.h>

@interface VKModel : NSObject

//Login
- (void)connectToVCWithUserName:(NSString *)name
                       password:(NSString *)password
                    resultBlock:(void (^)(NSDictionary *result))successBlock
                     errorBlock:(void (^)(NSDictionary *result, NSError *error))errorBlock;

//Register
- (void)registerUserWithFirstName:(NSString *)name
                         lastName:(NSString *)lastName
                         password:(NSString *)password
                      phoneNumber:(NSString *)phoneNumber
                         testMode:(BOOL)testMode
                      resultBlock:(void (^)(NSDictionary *result))successBlock
                       errorBlock:(void (^)(NSDictionary *result, NSError *error))errorBlock;

//Check phone
- (void)checkPhone:(NSString *)phone
       resultBlock:(void (^)(NSDictionary *result))successBlock
        errorBlock:(void (^)(NSDictionary *result, NSError *error))errorBlock;

//Confirm phone
- (void)confirmPhone:(NSString *)phone
            password:(NSString *)password
                code:(NSString *)code
            testMode:(NSInteger)testMode
         resultBlock:(void (^)(NSDictionary *result))successBlock
          errorBlock:(void (^)(NSDictionary *result, NSError *error))errorBlock;

//Common request
- (void)startConnectctionWithURL:(NSString *)urlString
                    successBlock:(void (^)(NSDictionary *result))successBlock
                     failedBlock:(void (^)(NSDictionary *result, NSError *error))errorBlock;

+ (NSString *)encodeSearchText:(NSString *)searchText;

@end
