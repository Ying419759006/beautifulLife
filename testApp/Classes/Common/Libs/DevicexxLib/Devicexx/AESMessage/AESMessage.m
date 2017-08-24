//
//  AESMessage.m
//  AESMessage
//
//  Created Huang Rui on 2016-11-23
//

#import "AESMessage.h"

#if 0 // set to 1 to enable logs

#define LogD(frmt, ...) NSLog(frmt, ##__VA_ARGS__);

#else

#define LogD(frmt, ...) {}

#endif

#pragma mark - AES Message Encoding and Decoding

@interface AESMessage()

@end

@implementation AESMessage

/**
 * encrypt AES message
 *
 * @param data     Message that to be encrypt
 * @param key      Password key of AES
 * @param iv       Initial vector of AES, always 16 bytes. IMPORTANT TO GET SAME RESULTS ON iOS and ANDROID
 * @return NSData  Message of AES encrypt result
 */
+ (NSData*)encryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
{
    NSData* result = nil;
    
    // setup key
    unsigned char cKey[FBENCRYPT_KEY_SIZE];
    bzero(cKey, sizeof(cKey));
    [key getBytes:cKey length:FBENCRYPT_KEY_SIZE];
    
    // setup iv
    char cIv[FBENCRYPT_BLOCK_SIZE];
    bzero(cIv, FBENCRYPT_BLOCK_SIZE);
    if (iv) {
        [iv getBytes:cIv length:FBENCRYPT_BLOCK_SIZE];
    }
    
    // setup output buffer
    size_t bufferSize = [data length] + FBENCRYPT_BLOCK_SIZE;
    void *buffer = malloc(bufferSize);
    
    // do encrypt
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          FBENCRYPT_ALGORITHM,
                                          kCCOptionPKCS7Padding,
                                          cKey,
                                          FBENCRYPT_KEY_SIZE,
                                          cIv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:buffer length:encryptedSize];
    } else {
        free(buffer);
        LogD(@"[ERROR] failed to encrypt|CCCryptoStatus: %d", cryptStatus);
    }
    
    return result;
}

/**
 * decrypt AES message
 *
 * @param data     Message that to be decrypt
 * @param key      Password key of AES
 * @param iv       Initial vector of AES, always 16 bytes. IMPORTANT TO GET SAME RESULTS ON iOS and ANDROID
 * @return NSData  Message of AES decrypt result
 */
+ (NSData*)decryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
{
    NSData* result = nil;
    
    // setup key
    unsigned char cKey[FBENCRYPT_KEY_SIZE];
    bzero(cKey, sizeof(cKey));
    [key getBytes:cKey length:FBENCRYPT_KEY_SIZE];
    
    // setup iv
    char cIv[FBENCRYPT_BLOCK_SIZE];
    bzero(cIv, FBENCRYPT_BLOCK_SIZE);
    if (iv) {
        [iv getBytes:cIv length:FBENCRYPT_BLOCK_SIZE];
    }
    
    // setup output buffer
    size_t bufferSize = [data length] + FBENCRYPT_BLOCK_SIZE;
    void *buffer = malloc(bufferSize);
    
    // do decrypt
    size_t decryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          FBENCRYPT_ALGORITHM,
                                          kCCOptionPKCS7Padding,
                                          cKey,
                                          FBENCRYPT_KEY_SIZE,
                                          cIv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &decryptedSize);
    
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:buffer length:decryptedSize];
    } else {
        free(buffer);
        LogD(@"[ERROR] failed to decrypt| CCCryptoStatus: %d", cryptStatus);
    }
    
    return result;
}

/**
 * encrypt AES message
 *
 * @param message  Message that to be encrypt
 * @param key      Password key of AES
 * @param iv       Initial vector of AES, always 16 bytes. IMPORTANT TO GET SAME RESULTS ON iOS and ANDROID
 * @return NSData  Message of AES encrypt result
 */
+ (NSData *)encryptDataWithKeyString:(NSData *)message key:(NSString *)key iv:(NSData *)iv;
{
    NSData* data = [self encryptData:message
                                 key:[key dataUsingEncoding:NSUTF8StringEncoding]
                                  iv:iv];
    return data;
}

/**
 * decrypt AES message
 *
 * @param message  Message that to be decrypt
 * @param key      Password key of AES
 * @param iv       Initial vector of AES, always 16 bytes. IMPORTANT TO GET SAME RESULTS ON iOS and ANDROID
 * @return NSData  Message of AES decrypt result
 */
+ (NSData *)decryptDataWithKeyString:(NSData *)message key:(NSString *)key iv:(NSData *)iv;
{
    NSData* data = [self decryptData:message
                                 key:[key dataUsingEncoding:NSUTF8StringEncoding]
                                  iv:iv];
    return data;
}

@end
