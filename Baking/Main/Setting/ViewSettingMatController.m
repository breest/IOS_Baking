//
//  ViewSettingMatController.m
//  Baking
//
//  Created by Chang Wei on 15/2/2.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "MyArray.h"
#import "MyMutableArray.h"
#import "MyData.h"
#import "TableViewCell.h"
#import "ViewSettingMatController.h"

@interface ViewSettingMatController () {
    UIScrollView *scrollView;
    UIPickerView *pickerCategory;
    UITableView *tableCurrent;
    TableViewCell *cellSelect;
    UITextField *txtName, *txtPrice, *txtCalorie;
    UIButton *btnNew, *btnEdit;
    NSMutableDictionary *dictCurrent;
    NSArray *arrayPicker;
    NSMutableArray *arraySection, *arrayCurrent;
    float fHeight;
    BOOL bFloatStatus, bSelect;
    NSString *datafile, *sectionselect, *sCurrentCategory, *sCurrentMaterial;
}

@end

@implementation ViewSettingMatController

- (void)btnAddNewClicked {
    sCurrentMaterial = txtName.text;
    for (int i=0; i<App.arrDataMaterial.count; i++) {
        if ([sCurrentMaterial isEqualToString:[[App.arrDataMaterial objectAtIndex:i] objectAtIndex:1]]) {
            UIAlertView *existAlert = [[UIAlertView alloc] initWithTitle:@"該材料已存在"
                                                                 message:@"如需修改此材料的基本信息請在表單上選擇後操作！"
                                                                delegate:nil
                                                       cancelButtonTitle:@"確定"
                                                       otherButtonTitles:nil];
            [existAlert show];
            return;
        }
    }
    sCurrentCategory = [arrayPicker objectAtIndex:[pickerCategory selectedRowInComponent:0]];
    [self addNewMaterial];
}

- (void)btnModifyClicked {
    NSString *s1, *s2, *s3;
    s1 = txtName.text;
    if (![s1 isEqualToString:sCurrentMaterial]) {
        for (int i=0; i<App.arrDataMaterial.count; i++) {
            if ([s1 isEqualToString:[[App.arrDataMaterial objectAtIndex:i] objectAtIndex:1]]) {
                UIAlertView *existAlert = [[UIAlertView alloc] initWithTitle:@"該材料已存在"
                                                                     message:@"如需修改此材料的基本信息請在表單上選擇後操作！"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"確定"
                                                           otherButtonTitles:nil];
                [existAlert show];
                return;
            }
        }
        [self deleteMaterial];
        sCurrentCategory = [arrayPicker objectAtIndex:[pickerCategory selectedRowInComponent:0]];
        sCurrentMaterial = s1;
        [self addNewMaterial];
        return;
    }
    NSMutableArray *cellArray = [dictCurrent objectForKey:sCurrentCategory];
    if (cellArray.count == 1) {
        [dictCurrent removeObjectForKey:sCurrentCategory];
    }else{
        [cellArray removeRowWithKey_CC:sCurrentMaterial inColumn:0];
        [dictCurrent setObject:cellArray forKey:sCurrentCategory];
    }
    
    sCurrentCategory = [arrayPicker objectAtIndex:[pickerCategory selectedRowInComponent:0]];
    s2 = txtPrice.text;
    s3 = txtCalorie.text;
    
    cellArray = [dictCurrent objectForKey:sCurrentCategory];
    if (cellArray == nil) {
        cellArray = [NSMutableArray new];
    }
    [cellArray addObject:@[sCurrentMaterial, s2, s3]];
    [dictCurrent setObject:cellArray forKey:sCurrentCategory];
    [self getNewSection];
    [App.arrDataMaterial removeRowWithKey_CC:sCurrentMaterial inColumn:1];
    [App.arrDataMaterial addObject:@[sCurrentCategory, sCurrentMaterial, s2, s3]];
    
    if (datafile == nil) {
        datafile = [MyData dataFilePath:@"material.s3db"];
    }
    NSString *valueString = [NSString stringWithFormat:@"Category = '%@', MaterialName = '%@', Price = '%@', Calorie = '%@'", sCurrentCategory, sCurrentMaterial, s2, s3];
    NSString *whereString = [NSString stringWithFormat:@"MaterialName = '%@'",sCurrentMaterial];
    [MyData updateRecordToFile:datafile tableName:@"Material" InsertString:valueString where:whereString];
    [tableCurrent reloadData];
    [self clearAllInfo];
}

- (void)addNewMaterial {
    NSString *sPrice, *sCalorie;
    sPrice = txtPrice.text;
    sCalorie = txtCalorie.text;
    
    NSMutableArray *cellArray = [dictCurrent objectForKey:sCurrentCategory];
    if (cellArray == nil) {
        cellArray = [NSMutableArray new];
    }
    [cellArray addObject:@[sCurrentMaterial, sPrice, sCalorie]];
    [App.arrDataMaterial addObject:@[sCurrentCategory, sCurrentMaterial, sPrice, sCalorie]];
    [dictCurrent setObject:cellArray forKey:sCurrentCategory];
    [self getNewSection];
    if (datafile == nil) {
        datafile = [MyData dataFilePath:@"material.s3db"];
    }
    [MyData addRecordToFile:datafile tableName:@"Material" InsertArray:@[sCurrentCategory, sCurrentMaterial, sPrice, sCalorie]];
    [tableCurrent reloadData];
    [self clearAllInfo];

}

- (void)deleteMaterial {
    [App.arrDataMaterial removeRowWithKey_CC:sCurrentMaterial inColumn:1];
    NSMutableArray *cellArray = [dictCurrent objectForKey:sCurrentCategory];
    [cellArray removeRowWithKey_CC:sCurrentMaterial inColumn:0];
    [dictCurrent setObject:cellArray forKey:sCurrentCategory];
    [self getNewSection];
    if (datafile == nil) {
        datafile = [MyData dataFilePath:@"material.s3db"];
    }
    NSString *whereString = [NSString stringWithFormat:@"MaterialName = '%@'",sCurrentMaterial];
    [MyData deleteRecordFromFile:datafile tableName:@"Material" where:whereString];
    [tableCurrent reloadData];
    [self clearAllInfo];
}

- (void)clearAllInfo {
    txtName.text = txtPrice.text = txtCalorie.text = @"";
    sCurrentCategory = sCurrentMaterial = @"";
    bSelect = FALSE;
    [self btnDisable];
}

/*
//打开编辑模式后，默认情况下每行左边会出现红的删除按钮，这个方法就是关闭这些按钮的
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

//这个方法用来告诉表格 这一行是否可以移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//这个方法就是执行移动操作的
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *) sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSUInteger fromRow = [sourceIndexPath row];
    NSUInteger toRow = [destinationIndexPath row];
    
    id object = [list objectAtIndex:fromRow];
    [list removeObjectAtIndex:fromRow];
    list insertObject:object atIndex:toRow];
}
*/
- (void)textFieldDidChange:(UITextField *)sender {
    NSString *s =sender.text;
    switch (sender.tag) {
        case 1:
            s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([s isEqualToString:@""]) {
                [self btnDisable];
            }else{
                [self btnEnable];
            }
            break;
            
        default:
            break;
    }
}

- (void)btnEnable {
    if (bSelect) {
        btnEdit.backgroundColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1];
        btnEdit.enabled = TRUE;
    }
    btnNew.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:1];
    btnNew.enabled = TRUE;
}

- (void)btnDisable {
    btnEdit.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    btnEdit.enabled = FALSE;
    btnNew.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    btnNew.enabled = FALSE;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return arraySection.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [arraySection objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    arrayCurrent = [dictCurrent objectForKey:[arraySection objectAtIndex:section]];
    return arrayCurrent.count;
}

- (TableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:1];
    }
    arrayCurrent = [dictCurrent objectForKey:[arraySection objectAtIndex:indexPath.section]];
    cell.lblTitle.text = [[arrayCurrent objectAtIndex:indexPath.row ] objectAtIndex:0];
    cell.lblPrice.text = [[arrayCurrent objectAtIndex:indexPath.row ] objectAtIndex:1];
    cell.lblCarolie.text = [[arrayCurrent objectAtIndex:indexPath.row ] objectAtIndex:2];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    sCurrentCategory = [arraySection objectAtIndex:indexPath.section];
    sCurrentMaterial = [[[dictCurrent objectForKey:sCurrentCategory] objectAtIndex:indexPath.row] objectAtIndex:0];
    //sCurrentMaterial = [(TableViewCell *)[tableView cellForRowAtIndexPath:indexPath]].lblTitle.text;
    [self deleteMaterial];
    /*
    cellSelect = (TableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSMutableArray *arrayTemp = (NSMutableArray *)[dictCurrent allKeys];
    NSString *strSection = [arrayTemp objectAtIndex:indexPath.section];

    arrayTemp = [dictCurrent objectForKey:strSection];
    if (arrayTemp.count == 1) {
        [dictCurrent removeObjectForKey:strSection];
    }else{
        //[arrayTemp removeObject:@[cellSelect.lblTitle.text,cellSelect.lblPrice.text,cellSelect.lblCarolie.text]];
        [arrayTemp removeRowWithKey_CC:cellSelect.lblTitle.text inColumn:0];
        [dictCurrent setObject:arrayTemp forKey:strSection];
    }
    [App.arrDataMaterial removeRowWithKey_CC:cellSelect.lblTitle.text inColumn:1];
    if (datafile == nil) {
        datafile = [MyData dataFilePath:@"material.s3db"];
    }
    NSString *whereString = [NSString stringWithFormat:@"MaterialName = '%@'",cellSelect.lblTitle.text];
    [MyData deleteRecordFromFile:datafile tableName:@"Material" where:whereString];*/
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"刪除";
}
/*
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *a;
    return a;
}*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    bSelect = TRUE;
    [self btnEnable];
    sCurrentCategory = [arraySection objectAtIndex:indexPath.section];
    for (int i = 0; i < arrayPicker.count; i++) {
        if ([sCurrentCategory isEqualToString:[arrayPicker objectAtIndex:i]]) {
            [pickerCategory selectRow:i inComponent:0 animated:YES];
        }
    }
    NSArray *cellArray = [[dictCurrent objectForKey:sCurrentCategory] objectAtIndex:indexPath.row];
    txtName.text = sCurrentMaterial = [cellArray objectAtIndex:0];
    txtPrice.text = [cellArray objectAtIndex:1];
    txtCalorie.text = [cellArray objectAtIndex:2];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return arrayPicker.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [arrayPicker objectAtIndex:row];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerCategory.frame.size.width, 20)];
    label.text = [arrayPicker objectAtIndex:row];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    return label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"原料設定";
    //NSArray *arrayTemp = [App.arrDataMaterialCategory sortWithNumber_CC:1];
    arrayPicker = [[App.arrDataMaterialCategory sortWithNumber_CC:1] getSubArrayWithColumn_CC:0];
    dictCurrent = (NSMutableDictionary *)[MyData getDictionaryWithUniqueColumnValue:App.arrDataMaterial indexColumn:0];
    [self getNewSection];
    
    tableCurrent= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 -200) style:UITableViewStyleGrouped];
    tableCurrent.backgroundColor = [UIColor clearColor];
    tableCurrent.delegate = self;
    tableCurrent.dataSource = self;
    [self.view addSubview:tableCurrent];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT -64 - 200, SCREEN_WIDTH, 200)];

    pickerCategory = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 110, 200)];
    pickerCategory.dataSource = self;
    pickerCategory.delegate = self;
    [scrollView addSubview:pickerCategory];

    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, 100, 20)];
    lblName.text = @"材料";
    [lblName setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [scrollView addSubview:lblName];
    UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(110, 65, 100, 20)];
    lblPrice.text = @"價格(元/千克)";
    [lblPrice setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [scrollView addSubview:lblPrice];
    UILabel *lblCarolie = [[UILabel alloc] initWithFrame:CGRectMake(110, 110, 100, 20)];
    lblCarolie.text = @"熱量(卡/百克)";
    [lblCarolie setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [scrollView addSubview:lblCarolie];
    
    txtName = [[UITextField alloc] initWithFrame:CGRectMake(150, 15, SCREEN_WIDTH - 160, 30)];
    txtName.borderStyle = UITextBorderStyleBezel;
    txtName.keyboardType = UIKeyboardTypeDefault;
    txtName.returnKeyType = UIReturnKeyNext;
    [txtName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    txtName.tag = 1;
    txtName.delegate = self;
    [scrollView addSubview:txtName];
    
    txtPrice = [[UITextField alloc] initWithFrame:CGRectMake(210, 60, SCREEN_WIDTH - 220, 30)];
    txtPrice.borderStyle = UITextBorderStyleBezel;
    txtPrice.keyboardType = UIKeyboardTypeDecimalPad;
    txtPrice.returnKeyType = UIReturnKeyNext;
    //txtPrice.placeholder = @"";
    [scrollView addSubview:txtPrice];
    
    txtCalorie = [[UITextField alloc] initWithFrame:CGRectMake(210, 105, SCREEN_WIDTH - 220, 30)];
    txtCalorie.borderStyle = UITextBorderStyleBezel;
    txtCalorie.keyboardType = UIKeyboardTypeDecimalPad;
    txtCalorie.returnKeyType = UIReturnKeyDone;
    //txtCalorie.placeholder = @"";
    [scrollView addSubview:txtCalorie];
    
    btnEdit = [[UIButton alloc]initWithFrame:CGRectMake(110, 150, SCREEN_WIDTH/2 - 70, 40)];
    btnEdit.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    [btnEdit setTitle:@"修改" forState:UIControlStateNormal];
    btnEdit.enabled = false;
    [btnEdit addTarget:self action:@selector(btnModifyClicked) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnEdit];
    
    btnNew= [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 60, 150, SCREEN_WIDTH/2 - 70, 40)];
    btnNew.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    [btnNew setTitle:@"新增" forState:UIControlStateNormal];
    btnNew.enabled = false;
    [btnNew addTarget:self action:@selector(btnAddNewClicked) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnNew];
    
    [self.view addSubview:scrollView];
    bSelect = bFloatStatus = FALSE;
    [self registerForKeyboardNotifications];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gesture.numberOfTapsRequired = 1;
    //[floatView addGestureRecognizer:gesture];
    [self.view addGestureRecognizer:gesture];
    [self.navigationController.navigationBar addGestureRecognizer:gesture];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)getNewSection {
    //arraySection = (NSMutableArray *)[dictCurrent.allKeys sortedArrayUsingSelector:@selector(compare:)];
    //NSMutableArray *temp;
    //temp = [NSMutableArray arrayWithArray:dictCurrent.allKeys];
    //arraySection = (NSMutableArray *)[temp sortWithDictionaryArray_CC:arrayPicker];
    arraySection = [NSMutableArray arrayWithArray:[dictCurrent.allKeys sortWithDictionaryArray_CC:arrayPicker]];
}

- (void)viewDidAppear:(BOOL)animated {
    int i;
    i=1;
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(KeyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(KeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)KeyboardDidShow:(NSNotification*)aNotification {
    if (!bFloatStatus) {
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        fHeight = kbSize.height - 5;
        CGRect fRect = tableCurrent.frame;
        fRect.size.height -= fHeight;
        tableCurrent.frame = fRect;
        fRect = scrollView.frame;
        fRect.origin.y -=fHeight;
        scrollView.frame = fRect;
        bFloatStatus = TRUE;
    }
}

- (void)KeyboardWillHide:(NSNotification*)aNotification
{
    if (bFloatStatus) {
        CGRect fRect = tableCurrent.frame;
        fRect.size.height += fHeight;
        tableCurrent.frame = fRect;
        fRect = scrollView.frame;
        fRect.origin.y +=fHeight;
        scrollView.frame = fRect;
        bFloatStatus = FALSE;
    }
}

- (void)hideKeyboard {
    [txtName resignFirstResponder];
    [txtPrice resignFirstResponder];
    [txtCalorie resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([txtName isFirstResponder]) {
        [txtPrice becomeFirstResponder];
    }
    else if([txtPrice isFirstResponder])
    {
        [txtCalorie becomeFirstResponder];
    }
    return YES;// 表示允许使用return键 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillMoveHidden {
    [self hideKeyboard];
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
