//
//  ViewSettingDBController.m
//  Baking
//
//  Created by Chang Wei on 15/2/2.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "MyData.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "ViewSettingDBController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewSettingDBController () {
    AppDelegate *App;
    UIButton *btnRecipe, *btnMaterial;
    NSString *fileEmail, *backuFile, *mailTitle, *mailAddress;
}

@end

@implementation ViewSettingDBController

- (void)backupMaterial {
    mailTitle = @"材料數據庫備份";
    backuFile = [MyData dataFilePath:@"material.s3db"];
    fileEmail = @"material.chi";
    [self sendMailInApp];
}

- (void)backupRecipe {
    mailTitle = @"配方數據庫備份";
    backuFile = [MyData dataFilePath:@"recipe.s3db"];
    fileEmail = @"recipe.chi";
    [self sendMailInApp];
}

//激活邮件功能
- (void)sendMailInApp{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        [self AlertMessage:@"此系統版本不支持應用內發送郵件功能，您可以使用 mailto 方法代替"];
        return;
    }
    if (![mailClass canSendMail]) {
        [self AlertMessage:@"您沒有設置郵件賬戶"];
        return;
    }
    [self displayMailPicker];
}

- (void)AlertMessage:(NSString *)message {
    UIAlertView *existAlert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:message
                                                        delegate:nil
                                               cancelButtonTitle:@"確定"
                                               otherButtonTitles:nil];
    [existAlert show];
}

//调出邮件发送窗口
- (void)displayMailPicker {
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    //设置主题
    [mailPicker setSubject: mailTitle];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"1280035@qq.com"];
    [mailPicker setToRecipients: toRecipients];
    //添加抄送
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"perry@2688.com.tw", nil];
    [mailPicker setCcRecipients:ccRecipients];
    //关于mimeType：http://www.iana.org/assignments/media-types/index.html
    //添加一个s3db附件
    //NSString *file = [self fullBundlePathFromRelativePath:@"高质量C++编程指南.pdf"];
    NSData *databaseFile = [NSData dataWithContentsOfFile:backuFile];
    [mailPicker addAttachmentData:databaseFile mimeType: @"" fileName: fileEmail];
    NSString *emailBody = @"<font color='red'>Email: </font> 數據備份";
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"資料庫設定";
    // Do any additional setup after loading the view.
    
    App = [[UIApplication sharedApplication] delegate];
    //dataPath = [App getDataPath];
    
    btnMaterial = [[UIButton alloc]initWithFrame:CGRectMake(50, SCREEN_HEIGHT - 200, SCREEN_WIDTH - 100, 50)];
    [btnMaterial setTitle:@"備份材料數據庫" forState:UIControlStateNormal];
    [btnMaterial addTarget:self action:@selector(backupMaterial) forControlEvents:UIControlEventTouchUpInside];
    btnMaterial.backgroundColor = [UIColor redColor];
    btnMaterial.tag = 1;
    [self.view addSubview:btnMaterial];
    
    btnRecipe = [[UIButton alloc]initWithFrame:CGRectMake(50, SCREEN_HEIGHT - 135, SCREEN_WIDTH - 100, 50)];
    [btnRecipe setTitle:@"備份配方數據庫" forState:UIControlStateNormal];
    [btnRecipe addTarget:self action:@selector(backupRecipe) forControlEvents:UIControlEventTouchUpInside];
    btnRecipe.backgroundColor = [UIColor blueColor];
    btnRecipe.tag = 2;
    [self.view addSubview:btnRecipe];

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
