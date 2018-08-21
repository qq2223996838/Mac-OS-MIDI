
//

#import "ViewController.h"

@implementation ViewController
{
    NSTimer *timer;
    
    int progress;
    
    MIDIManager *midi;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.layer.borderColor = [NSColor blueColor].CGColor;
    
    _processView.maxValue =100;//设置进度条最大值
    _processView.bgimgColor =[NSColor whiteColor];//设置背景颜色为白色
    _processView.leftimgColor =[NSColor grayColor];//设置进度条更新颜色为黑色
    _processView.present = 0.f;
    
    
    //创建MIDI
    midi = [[MIDIManager alloc]initWithClientName:@"Client" inPort:@"portName" outPort:@"portName"];
    midi.infoDelegate = self;//加载返回数据代理
    NSLog(@"MIDI设备名字 ： %@",[midi getDeviceName]);
    
    //进度条开始 动作
    timer =[NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
    
}



-(void)timer
{
    progress++;
    if (progress<=100) {
        [_processView setPresent:progress];//传递进度条进度值
    }else{
//        [timer invalidate];//移除定时器
        timer = nil;
        progress = 0;
    }
}


- (IBAction)OpenButMethods:(NSButton *)sender {
    NSLog(@"我选择了 ： OpenBut");
    [self openFinder];
}
- (IBAction)UpdateButMethods:(NSButton *)sender {
    NSLog(@"我选择了 ： UpdateBut 并 测试MIDI传值");
    
    Byte testData[] = {0xAA,0x55,0xff,0xff};
    NSData *testSendData = [[NSData alloc] initWithBytes:testData length:4];
    [midi sendData:testSendData];
}


- (void)openFinder{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    [panel setCanChooseFiles:YES];  //是否能选择文件file
    
    [panel setCanChooseDirectories:YES];  //是否能打开文件夹
    
    [panel setAllowsMultipleSelection:NO];  //是否允许多选file
    
    NSInteger finded = [panel runModal];   //获取panel的响应
    
    if (finded == NSModalResponseOK) {
        
        for (NSURL *url in [panel URLs]) {
            
            NSLog(@"文件路径--->%@",url);
            _filePathTF.stringValue = [NSString stringWithFormat:@"%@",url];
            //同时这里可以处理你要做的事情 do something
            
            // 获取文件内容
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingFromURL:url error:nil];
            NSData *Data = [fileHandle readDataToEndOfFile];
            NSLog(@"内容 ==  %@",Data);
            
        }
    }
}


//MIDI返回数据代理
- (void)responeMidiGetData:(NSData *)getData
{
    NSLog(@"我是通过代理拿到的数据 %@",getData);
}


@end
