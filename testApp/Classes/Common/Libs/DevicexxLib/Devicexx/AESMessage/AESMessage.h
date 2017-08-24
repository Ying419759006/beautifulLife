//
//  AESMessage.h
//  AESMessage
//
//  Created Huang Rui on 2016-11-23
//  AES 128 -CBC 加密

#import <CommonCrypto/CommonCryptor.h>
#import <Foundation/Foundation.h>

#define FBENCRYPT_ALGORITHM     kCCAlgorithmAES128
#define FBENCRYPT_BLOCK_SIZE    kCCBlockSizeAES128
//#define FBENCRYPT_KEY_SIZE      kCCKeySizeAES256
#define FBENCRYPT_KEY_SIZE      kCCKeySizeAES128   //AES 128 -CBC 加密

#pragma mark - AES Message Encoding and Decoding

@interface AESMessage : NSObject

/**
 * encrypt AES message
 *
 * @param data     Message that to be encrypt
 * @param key      Password key of AES
 * @param iv       Initial vector of AES, always 16 bytes. IMPORTANT TO GET SAME RESULTS ON iOS and ANDROID
 * @return NSData  Message of AES encrypt result
 */
+ (NSData*)encryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv;


/**
 * decrypt AES message
 *
 * @param data     Message that to be decrypt
 * @param key      Password key of AES
 * @param iv       Initial vector of AES, always 16 bytes. IMPORTANT TO GET SAME RESULTS ON iOS and ANDROID
 * @return NSData  Message of AES decrypt result
 */
+ (NSData*)decryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv;

/**
 * encrypt AES message
 *
 * @param message  Message that to be encrypt
 * @param key      Password key of AES
 * @param iv       Initial vector of AES, always 16 bytes. IMPORTANT TO GET SAME RESULTS ON iOS and ANDROID
 * @return NSData  Message of AES encrypt result
 */
+ (NSData *)encryptDataWithKeyString:(NSData *)message key:(NSString *)key iv:(NSData *)iv;

/**
 * decrypt AES message
 *
 * @param message  Message that to be decrypt
 * @param key      Password key of AES
 * @param iv       Initial vector of AES, always 16 bytes. IMPORTANT TO GET SAME RESULTS ON iOS and ANDROID
 * @return NSData  Message of AES decrypt result
 */
+ (NSData *)decryptDataWithKeyString:(NSData *)message key:(NSString *)key iv:(NSData *)iv;

@end
