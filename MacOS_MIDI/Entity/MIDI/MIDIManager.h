
//

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>

@protocol MidiGetDataDelegate <NSObject>   // 下位机返回数据代理
- (void)responeMidiGetData:(NSData *)getData;
@end

@interface MIDIManager : NSObject
{
    MIDIClientRef client;
    MIDIPortRef inputPort;
    MIDIPortRef outputPort;
    //用于存储MIDI源ID的唯一ID数组
    MIDIUniqueID idArray[256];
    
}

- (void)responeMidiGetData:(id<MidiGetDataDelegate>)delegate;

//返回数据缓存区
@property (nonatomic, strong) NSMutableData * muData;
@property (nonatomic, weak) id<MidiGetDataDelegate> infoDelegate;

//创建MIDI 输入端口 输出端口
- (id)initWithClientName: (NSString *)clientName inPort: (NSString *)iPort outPort: (NSString *)oPort;

//传数据到下位机
- (void)sendData:(NSData *)data;

//获取设备名字
- (NSString *)getDeviceName;

@end
