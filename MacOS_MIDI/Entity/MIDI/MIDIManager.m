
//

#import "MIDIManager.h"
#import "CRC.h"

@implementation MIDIManager

- (id)initWithClientName:(NSString *)clientName inPort:(NSString *)iPort outPort:(NSString *)oPort {
    if (self = [super init]) {
        
        _muData = [NSMutableData data];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveData:)name:@"receiveData" object:nil];
        
        // 如果存在，请处理旧的MIDI客户端
        if (client != (MIDIObjectRef)NULL) MIDIClientDispose(client);
        
        // 创建一个MIDI客户端
        MIDIClientCreate(CFSTR("Client"), MyMIDIStateChangedHander, (__bridge void *)(self), &client);
        
        
        // 列举所有MIDI来源
        ItemCount sourceCount = MIDIGetNumberOfSources();
        NSAssert(sourceCount < sizeof(idArray), @"ID buffer size is smaller than the nuber of MIDI sources.");
        
        // 将MIDI源连接到输入端口
        MIDIEndpointRef source = MIDIGetSource(0);
        MIDIObjectGetIntegerProperty(source, kMIDIPropertyUniqueID, &idArray[0]);
        MIDIOutputPortCreate(client, (__bridge CFStringRef)oPort, &outputPort);
        MIDIInputPortCreate(client, (__bridge CFStringRef)iPort, MyMIDIReadProc, (__bridge void *)(self), &inputPort);
        MIDIPortConnectSource(outputPort, source, &idArray[0]);
        MIDIPortConnectSource(inputPort, source, &idArray[0]);

    }
    return self;
}

//传数据到下位机
- (void)sendData:(NSData *)data
{
    NSLog(@"传至下位机数据内容 %@",data);
    
    // 传数据到MIDI源
    
    MIDIEndpointRef outputEndpoint = MIDIGetDestination(0);
    
    Byte *sendData = (Byte*)[data bytes];
    
    char buffer[1024];
    MIDIPacketList *packets = (MIDIPacketList *)buffer;
    
    MIDIPacket *packet = MIDIPacketListInit(packets);
    
    packet = MIDIPacketListAdd(packets, 1024, packet, 0, data.length, sendData);
    
    [self sendDataToMIDI:outputPort :outputEndpoint :packets];
   
}


//传数据到MIDI
-(void)sendDataToMIDI:(MIDIPortRef )inputPort :(MIDIEndpointRef)outputEndpoint :(MIDIPacketList *)packets
{
    MIDISend(inputPort, outputEndpoint, packets);
}

//获取设备名字
- (NSString *)getDeviceName
{
    MIDIEndpointRef source = MIDIGetSource(0);
    // 从MIDI源检索信息
    CFStringRef name;
    MIDIObjectGetStringProperty(source, kMIDIPropertyDisplayName, &name);
    
    NSString *deviceName = [NSString stringWithFormat:@"(%08X)", idArray[0]];
    return deviceName;
}

//监控MIDI设备状态
static void MyMIDIStateChangedHander(const MIDINotification *message, void *refCon)
{
    // 只处理添加和删除操作
    if (message->messageID != kMIDIMsgObjectAdded && message->messageID != kMIDIMsgObjectRemoved) return;
    
    // 只有过程源操作
    const MIDIObjectAddRemoveNotification *addRemoveDetail = (const MIDIObjectAddRemoveNotification*)message;
    if (addRemoveDetail->childType != kMIDIObjectType_Source) return;
    // 向应用程序委托发送更新消息(在主线程上)
    NSLog(@"%@",@"检测到MIDI状态的变化");
}

//接收MIDI数据
static void MyMIDIReadProc(const MIDIPacketList *packetList, void *readProcRefCon, void *srcConnRefCon)
{
    
    NSLog(@"我拿到MIDI返回的数据");
    
    // 处理所有传入的数据包.
    MIDIPacket *packet = (MIDIPacket *) packetList->packet;
    NSData *receiveData = [[NSData alloc] initWithBytes:packet->data length:packet->length];
    
    NSNotification *notification =[NSNotification notificationWithName:@"receiveData" object:receiveData userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}

- (void)receiveData:(NSNotification *)nottext
{
    //清除 aa之前的数据
    Byte *testByte = (Byte*)[nottext.object bytes];
    NSString *bytesStr = [NSString stringWithFormat:@"%1x", testByte[0]];
    if ([bytesStr  isEqual: @"aa"]) {
        [self emptyData];
    }
    
    //添加 到数据集
    [_muData appendData:nottext.object];
    
    if ([self.infoDelegate respondsToSelector:@selector(responeMidiGetData:)]) {
        [self.infoDelegate responeMidiGetData:_muData];
    }
    return;
}

- (void)emptyData
{
    [_muData resetBytesInRange:NSMakeRange(0, _muData.length)];
    [_muData setLength:0];
}

- (void)responeMidiGetData:(id<MidiGetDataDelegate>)delegate
{
    self.infoDelegate = delegate;
}

@end
