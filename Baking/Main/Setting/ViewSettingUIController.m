//
//  ViewSettingController.m
//  Baking
//
//  Created by Chang Wei on 15/2/1.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

//#import <AssetsLibrary/AssetsLibrary.h>
#import "MyData.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "ViewSettingUIController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewSettingUIController () {
    AppDelegate *App;
    UIImageView *imgView;
    UIButton *btnSelect, *btnCamera, *btnEmail;
}

@end

@implementation ViewSettingUIController

//激活邮件功能
- (void)sendMailInApp{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        //[self alertWithMessage:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替"];
        return;
    }
    if (![mailClass canSendMail]) {
        //[self alertWithMessage:@"用户没有设置邮件账户"];
        return;
    }
    [self displayMailPicker];
}

//调出邮件发送窗口
- (void)displayMailPicker {
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    //设置主题
    [mailPicker setSubject: @"Email主题"];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"1280035@qq.com"];
    [mailPicker setToRecipients: toRecipients];
    //添加抄送
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"perry@128.com.tw", nil];
    [mailPicker setCcRecipients:ccRecipients];
    //添加密送
    NSArray *bccRecipients = [NSArray arrayWithObjects:@"fourth@example.com", nil];
    [mailPicker setBccRecipients:bccRecipients];
    // 添加一张图片
    //UIImage *addPic = [UIImage imageNamed: @"200.png"];
    UIImage *addPic = imgView.image;
    NSData *imageData = UIImagePNGRepresentation(addPic); // png
    //NSData *imageData2 = UIImageJPEGRepresentation(<#UIImage *image#>, <#CGFloat compressionQuality#>)
    //关于mimeType：http://www.iana.org/assignments/media-types/index.html
    [mailPicker addAttachmentData: imageData mimeType: @"" fileName: @"300.png"];
    //添加一个pdf附件
    //NSString *file = [self fullBundlePathFromRelativePath:@"高质量C++编程指南.pdf"];
    NSString *file = [MyData dataFilePath:@"baker.s3db"];
    NSData *pdf = [NSData dataWithContentsOfFile:file];
    [mailPicker addAttachmentData:pdf mimeType: @"" fileName: @"數據庫-database.chi"];
    NSString *emailBody = @"<font color='red'>eMail</font> 正文";
    [mailPicker setMessageBody:emailBody isHTML:YES];
    //[self presentModalViewController: mailPicker animated:YES];
    [self presentViewController:mailPicker animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    imgView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
}

- (void)btnClick:(UIButton *)sender {
    UIImagePickerController* ipC = [[UIImagePickerController alloc]init];
    if ([[[UIDevice currentDevice] model]rangeOfString:@"Sim"].location == NSNotFound) {
        if (sender.tag == 1) {
            [ipC setSourceType:UIImagePickerControllerSourceTypeCamera];
        } else if (sender.tag == 2) {
            [ipC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        [ipC setDelegate:self];
        [self presentViewController:ipC animated:YES completion:nil];
    }
    /*
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];//生成整个photolibrary句柄的实例
    NSMutableArray *mediaArray = [[NSMutableArray alloc]init];//存放media的数组
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {//获取所有group
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {//从group里面
            NSString* assetType = [result valueForProperty:ALAssetPropertyType];
            if ([assetType isEqualToString:ALAssetTypePhoto]) {
                NSLog(@"Photo");
            }else if([assetType isEqualToString:ALAssetTypeVideo]){
                NSLog(@"Video");
            }else if([assetType isEqualToString:ALAssetTypeUnknown]){
                NSLog(@"Unknow AssetType");
            }
            
            NSDictionary *assetUrls = [result valueForProperty:ALAssetPropertyURLs];
            NSUInteger assetCounter = 0;
            for (NSString *assetURLKey in assetUrls) {
                NSLog(@"Asset URL %lu = %@",(unsigned long)assetCounter,[assetUrls objectForKey:assetURLKey]);
            }
            
            NSLog(@"Representation Size = %lld",[[result defaultRepresentation]size]);
        }];
    } failureBlock:^(NSError *error) {
        NSLog(@"Enumerate the asset groups failed.");
    }];*/
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"界面設定";
    // Do any additional setup after loading the view.
    App = [[UIApplication sharedApplication] delegate];
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 3*SCREEN_WIDTH/4, 3*SCREEN_HEIGHT/4)];
    imgView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:imgView];
    
    btnCamera = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 75, 20, 70, 40)];
    [btnCamera setTitle:@"相機" forState:UIControlStateNormal];
    [btnCamera addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btnCamera.backgroundColor = [UIColor redColor];
    btnCamera.tag = 1;
    [self.view addSubview:btnCamera];
    
    btnSelect = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 75, 80, 70, 40)];
    [btnSelect setTitle:@"照片庫" forState:UIControlStateNormal];
    [btnSelect addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btnSelect.backgroundColor = [UIColor blueColor];
    btnSelect.tag = 2;
    [self.view addSubview:btnSelect];
    
    btnEmail = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 75, 140, 70, 40)];
    [btnEmail setTitle:@"Email" forState:UIControlStateNormal];
    [btnEmail addTarget:self action:@selector(sendMailInApp) forControlEvents:UIControlEventTouchUpInside];
    btnEmail.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:btnEmail];
    /*
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"My Subject"];
    [controller setMessageBody:@"Hello there." isHTML:NO];
    [self presentModalViewController:controller animated:YES];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
