//
//  CharacteristicDetailsViewController.m
//  BLEManagerDemonstrator
//
//  Created by saha on 11/1/14.
//  Copyright (c) 2014 samratsaha. All rights reserved.
//

#import "CharacteristicDetailsViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEDevice.h"
#import "DeviceDetailsViewController.h"
#import "BLEUtilities.h"
@interface CharacteristicDetailsViewController ()

@end

@implementation CharacteristicDetailsViewController
@synthesize device,characteristic;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableString *deviceString = [NSMutableString stringWithString:@"Peripheral: "];
    [self.device addListener:self];
    [deviceString appendString:[self.device getPeripheralName]==nil?
                                @"No Name Found For Peripheral":[self.device getPeripheralName]];
    [deviceString appendString:[@" UUID: "stringByAppendingString:[[self.device getPeripheralUUID]UUIDString]]];
    [deviceString appendString:[@" RSSI:" stringByAppendingString:self.device.RSSI.stringValue]];
    _deviceNameLabel.text = deviceString;
    _serviceNameLabel.text = [@"Service UUID: " stringByAppendingString:[[self.characteristic.service UUID]UUIDString]];
    _characteristicNameLabel.text = [@"Characteristic UUID: " stringByAppendingString:[[self.characteristic UUID]UUIDString]];
    
    NSMutableString *detailsString = [NSMutableString stringWithString:@"Characteristic Details"];
    [detailsString appendString:@"\nProperties Value(CBCharacteristicProperties): "];
    [detailsString appendString:[NSString stringWithFormat:@"%lu",self.characteristic.properties]];
    self.characteristic.properties&CBCharacteristicPropertyBroadcast?
        [detailsString appendString:@"\nCBCharacteristicPropertyBroadcast: TRUE"]:[detailsString appendString:@"\nCBCharacteristicPropertyBroadcast: FALSE"];
    self.characteristic.properties&CBCharacteristicPropertyRead?
        [detailsString appendString:@"\nCBCharacteristicPropertyRead: TRUE"]:[detailsString appendString:@"\nCBCharacteristicPropertyRead: FALSE"];
    self.characteristic.properties&CBCharacteristicPropertyWriteWithoutResponse?
        [detailsString appendString:@"\nCBCharacteristicPropertyWriteWithoutResponse: TRUE"]:
        [detailsString appendString:@"\nCBCharacteristicPropertyWriteWithoutResponse: FALSE"];
    if(self.characteristic.properties&CBCharacteristicPropertyWrite)
    {
        [detailsString appendString:@"\nCBCharacteristicPropertyWrite: TRUE"];
        _characteristicValueTextField.enabled = YES;
        _characteristicValueTextField.placeholder = @"Write Value Of Characteristic Here";
        _writeCharacteristicValueButton.enabled = YES;
        _statusTextView.text = @"Input text above and click the Write Value Button to write value to characteristic";
        _statusTextView.hidden = NO;
    }else{
        [detailsString appendString:@"\nCBCharacteristicPropertyWrite: FALSE"];
        _characteristicValueTextField.enabled = NO;
        _characteristicValueTextField.placeholder = @"Can't write to this Characteristic";
        _statusTextView.text = @"";
        _writeCharacteristicValueButton.enabled = NO;
    }
    self.characteristic.properties&CBCharacteristicPropertyNotify?
        [detailsString appendString:@"\nCBCharacteristicPropertyNotify: TRUE"]:[detailsString appendString:@"\nCBCharacteristicPropertyNotify: FALSE"];
    self.characteristic.properties&CBCharacteristicPropertyIndicate?
    [detailsString appendString:@"\nCBCharacteristicPropertyIndicate: TRUE"]:[detailsString appendString:@"\nCBCharacteristicPropertyIndicate: FALSE"];
    self.characteristic.properties&CBCharacteristicPropertyAuthenticatedSignedWrites?
        [detailsString appendString:@"\nCBCharacteristicPropertyAuthenticatedSignedWrites: TRUE"]:
        [detailsString appendString:@"\nCBCharacteristicPropertyAuthenticatedSignedWrites: FALSE"];
    self.characteristic.properties&CBCharacteristicPropertyExtendedProperties?
        [detailsString appendString:@"\nCBCharacteristicPropertyExtendedProperties: TRUE"]:
        [detailsString appendString:@"\nCBCharacteristicPropertyExtendedProperties: FALSE"];
    self.characteristic.properties&CBCharacteristicPropertyNotifyEncryptionRequired?
        [detailsString appendString:@"\nCBCharacteristicPropertyNotifyEncryptionRequired: TRUE"]:
        [detailsString appendString:@"\nCBCharacteristicPropertyNotifyEncryptionRequired: FALSE"];
    self.characteristic.properties&CBCharacteristicPropertyIndicateEncryptionRequired?
        [detailsString appendString:@"\nCBCharacteristicPropertyIndicateEncryptionRequired: TRUE"]:
        [detailsString appendString:@"\nCBCharacteristicPropertyIndicateEncryptionRequired: FALSE"];
    _characteristicDetailsTextView.text = detailsString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
static NSString *SEGUE_BACK_TO_PERIPHERAL = @"K_BackToPeripheralFromCharacteristicSegue";
-(IBAction)backToPeripheralButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:SEGUE_BACK_TO_PERIPHERAL sender:self];
}
static NSString *SEGUE_BACK_TO_HOME = @"K_BackToHomeFromCharacteristicsSegue";
-(IBAction)handleLogoClickedTapGestureRecognizer:(UIGestureRecognizer *)recognizer
{
    [self performSegueWithIdentifier:SEGUE_BACK_TO_HOME sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SEGUE_BACK_TO_PERIPHERAL]) {
        DeviceDetailsViewController *controller = (DeviceDetailsViewController*)segue.destinationViewController;
        controller.device = self.device;
    }
}
-(IBAction)readValueClicked:(id)sender
{
    [self.device readCharacteristicValue:self.characteristic];
}
+(NSData*) GET_NS_DATA_FOR_UUID:(NSUUID*)uuid
{
    uuid_t temp;
    [uuid getUUIDBytes:temp];
    uint8_t dataAsUInt[16];
    for(int i=0;i<sizeof(temp);i++)
    {
        dataAsUInt[i] = (uint8_t)temp[i];
        //NSLog(@"Byte : %d value:%d",i,dataAsUInt[i]);
    }
    
    return [NSData dataWithBytes:dataAsUInt length:sizeof(dataAsUInt)];
}
-(IBAction)writeToCharacteristicClicked:(id)sender
{
    NSData *data;
    switch (_dataTypeSegmentedControl.selectedSegmentIndex) {
        case 1:
            data = [BLEUtilities GetNSDataForHEXString:_characteristicValueTextField.text];
            break;
        case 2:
            data = [BLEUtilities GetNSDataForInt:[_characteristicValueTextField.text intValue]];
            break;
        case 0:
        default:
            data = [BLEUtilities GetNSDataForString:_characteristicValueTextField.text];
            break;
    }
    [self.device writeToCharacteristic:self.characteristic withValue:data];
}
#pragma mark - PBLEDeviceEventListener message implementation
-(void) informDeviceConnected
{
    
}
-(void) informDeviceDisconnected
{
    
}
-(void) informDeviceConnectionFailed
{
    
}
-(void) informDiscoveredServices:(NSArray*)services
{
    
}
-(void) informDiscoveredCharacteristicsForService:(CBService*)service
{
    
}
-(void) informReadCharacteristic:(CBCharacteristic*)characteristic withError:(NSError*)error
{
    NSMutableString *results;
    if(error==nil)
    {
        results = [NSMutableString stringWithString:@"Read Value:\n"];
        [results appendFormat:@"%@\n",self.characteristic.value];
        NSString* responseString = [[NSString alloc] initWithData:self.characteristic.value encoding:NSUTF8StringEncoding];
        [results appendFormat:@"Ascii Value: %@",responseString];
        
        
    }else
    {
        results = [NSMutableString stringWithString:@"Error in Reading Value...details follow\n"];
        [results appendString:@"Error Code:"];
        [results appendFormat:@"%ld",(long)error.code];
        if(error.localizedFailureReason!=nil)
        {
            [results appendString:@"\nLocalized Failure Reason: "];
            [results appendString:error.localizedFailureReason];
        }
        if(error.localizedDescription!=nil)
        {
            [results appendString:@"\nLocalized Description: "];
            [results appendString:error.localizedDescription];
        }
        if(error.userInfo!=nil)
        {
            [results appendString:@"\nUser Info:\n"];
            [results appendFormat:@"%@",error.userInfo];
        }
    }
    [results appendString:@"\n"];
    [results appendString:_statusTextView.text];
    _statusTextView.text = results;
}
-(void) informWroteCharacteristic:(CBCharacteristic*)characteristic withError:(NSError*)error
{
    NSMutableString *results;
    if(error==nil)
    {
        results = [NSMutableString stringWithString:@"Wrote Value:\n"];
        [results appendFormat:@"%@\n",self.characteristic.value];
        NSString* responseString = [[NSString alloc] initWithData:self.characteristic.value encoding:NSUTF8StringEncoding];
        [results appendFormat:@"Ascii Value: %@",responseString];
        
    }else
    {
        results = [NSMutableString stringWithString:@"Error in Reading Value...details follow\n"];
        [results appendString:@"Error Code:"];
        [results appendFormat:@"%ld",(long)error.code];
        if(error.localizedFailureReason!=nil)
        {
            [results appendString:@"\nLocalized Failure Reason: "];
            [results appendString:error.localizedFailureReason];
        }
        if(error.localizedDescription!=nil)
        {
            [results appendString:@"\nLocalized Description: "];
            [results appendString:error.localizedDescription];
        }
        if(error.userInfo!=nil)
        {
            [results appendString:@"\nUser Info:\n"];
            [results appendFormat:@"%@",error.userInfo];
        }
    }
    [results appendString:@"\n"];
    [results appendString:_statusTextView.text];
    _statusTextView.text = results;
}
-(void) informCharcteristicNotificationReceived:(CBCharacteristic*)characteristic
{
    
}
-(void) informReadRSSIValue
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
