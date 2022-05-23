//
//  SHPowerDetailModel.h
//  Saihub
//
//  Created by macbook on 2022/3/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HourDataListItem;
@interface SHPowerDetailModel : NSObject
@property (nonatomic , copy) NSString              * cabinetTemperature;
@property (nonatomic , copy) NSString              * consumptionUnit;
@property (nonatomic , copy) NSString              * deviceCode;
@property (nonatomic , copy) NSString              * deviceGroupTag;
@property (nonatomic , copy) NSString              * hotMeterInletWaterTemperature;
@property (nonatomic , copy) NSString              * hotMeterOutWaterTemperature;
@property (nonatomic , strong) NSArray <HourDataListItem *>              * hourDataList;
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , copy) NSString              * indoorTemperature;
@property (nonatomic , copy) NSString              * inletWaterTemperature;
@property (nonatomic , assign) BOOL              online;
@property (nonatomic , copy) NSString              * outWaterTemperature;
@property (nonatomic , copy) NSString              * outdoorTemperature;
@property (nonatomic , copy) NSString              * outputHeat;
@property (nonatomic , copy) NSString              * outputHeatUnit;
@property (nonatomic , copy) NSString              * powerUnit;
@property (nonatomic , copy) NSString              * pressureUnit;
@property (nonatomic , copy) NSString              * temperatureUnit;
@property (nonatomic , copy) NSString              * time;
@property (nonatomic , assign) NSInteger              timestamp;
@property (nonatomic , copy) NSString              * totalPower;
@property (nonatomic , copy) NSString              * unitEnergyConsumption;
@property (nonatomic , copy) NSString              * waterInletPressure;
@property (nonatomic , copy) NSString              * waterOutPressure;
@end
@interface HourDataListItem :NSObject
@property (nonatomic , copy) NSString              * outputHeat;
@property (nonatomic , copy) NSString              * time;
@property (nonatomic , assign) NSInteger              timestamp;
@property (nonatomic , copy) NSString              * unitEnergyConsumption;

@end
NS_ASSUME_NONNULL_END
