//
//  BLEUtilities.h
//  BLEManagerDemonstrator
//
//  Created by saha on 11/2/14.
//  Copyright (c) 2014 samratsaha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEUtilities : NSObject
+(NSData*)GetNSDataForString:(NSString*)string;
+(NSData*)GetNSDataForHEXString:(NSString*)string;
+(int)GetIntFromHEXString:(NSString*)string;
+(NSData*)GetNSDataForInt:(int)number;
+(NSData*)GetNSDataForFloat:(float)number;
+(NSData*)GetNSDataForLong:(long)number;
+(NSData*)GetNSDataForUInt8:(UInt8)number;
+(NSData*)GetNSDataForUInt16:(UInt16)number;
+(NSData*)GetNSDataForUInt32:(UInt32)number;
+(NSData*)GetNSDataForUint64:(UInt64)number;
@end
