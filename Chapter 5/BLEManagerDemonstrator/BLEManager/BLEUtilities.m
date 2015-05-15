//
//  BLEUtilities.m
//  BLEManagerDemonstrator
//
//  Created by saha on 11/2/14.
//  Copyright (c) 2014 samratsaha. All rights reserved.
//

#import "BLEUtilities.h"

@implementation BLEUtilities
+(NSData*)GetNSDataForString:(NSString*)string
{
    return[string dataUsingEncoding:NSUTF8StringEncoding];
}
+(NSData*)GetNSDataForHEXString:(NSString *)string
{
    unsigned int outVal;
    NSScanner* scanner = [NSScanner scannerWithString:string];
    [scanner scanHexInt:&outVal];
    return [BLEUtilities GetNSDataForInt:outVal];
}
+(int)GetIntFromHEXString:(NSString *)string
{
    unsigned int outVal;
    NSScanner* scanner = [NSScanner scannerWithString:string];
    [scanner scanHexInt:&outVal];
    return outVal;
}
+(NSData*)GetNSDataForInt:(int)number
{
    return [NSData dataWithBytes:(void*)&number length:sizeof(number)];
}
+(NSData*)GetNSDataForFloat:(float)number
{
    return [NSData dataWithBytes:(void*)&number length:sizeof(number)];
}
+(NSData*)GetNSDataForLong:(long)number
{
    return [NSData dataWithBytes:(void*)&number length:sizeof(number)];
}
+(NSData*)GetNSDataForUInt8:(UInt8)number
{
    return [NSData dataWithBytes:(void*)&number length:sizeof(number)];
}
+(NSData*)GetNSDataForUInt16:(UInt16)number
{
    return [NSData dataWithBytes:(void*)&number length:sizeof(number)];
}
+(NSData*)GetNSDataForUInt32:(UInt32)number
{
    return [NSData dataWithBytes:(void*)&number length:sizeof(number)];
}
+(NSData*)GetNSDataForUint64:(UInt64)number
{
    return [NSData dataWithBytes:(void*)&number length:sizeof(number)];
}

@end
