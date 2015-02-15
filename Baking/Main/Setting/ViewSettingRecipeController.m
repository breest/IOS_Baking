//
//  ViewRecipeController.m
//  Baking
//
//  Created by Chang Wei on 15/2/3.
//  Copyright (c) 2015年 Chang Wei. All rights reserved.
//

#import "MyArray.h"
#import "MyMutableArray.h"
#import "BakeRecipe.h"
#import "MyData.h"
#import "TableViewCell.h"
#import "ViewSettingRecipeController.h"

@interface ViewSettingRecipeController () {
    UIScrollView *scrollCurrent;
    UIPickerView *pickerRecipe, *pickerMaterial;
    UIView *viewBlock;
    UIImageView *imgRecipe;
    NSArray *arrayM1;
    NSMutableArray *arrayC1, *arrayC2, *arrayC3, *arrayRecipe, *arrayM2;
    UITextField *txtNewRecipe, *txtEditRecipe, *txtMaterialAmount;
    EditType status;
    UIButton *btnNewCategory, *btnDeleteCategory, *btnEditCategory, *btnAddMaterial, *btnSubmit;
    UILabel *lblTitle, *lblMaterialName, *lblBakePercent;
    float fHeight;
    BOOL bFloatStatus;
    NSString *datafile;
    //NSString *datafile, *categoryName, *recipeName;
    UITableView *tableCurrent;
    NSMutableDictionary *dictCurrent;
    TableViewCell *cellMaterial, *cellRecipe;
    BakeRecipe *currentRecipe;
}

@end

@implementation ViewSettingRecipeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"配方設定";
    self.view.backgroundColor = [UIColor whiteColor];
    status = EditTypeNone;
    arrayRecipe = [NSMutableArray arrayWithObjects:nil];
    arrayC1 = (NSMutableArray *)App.arrDataCategory;
    arrayC2 = (NSMutableArray *)[App.arrDataCategory2 getRowsWithKey_CC:[arrayC1 objectAtIndex:0] inColumn:0];
    if (arrayC2.count > 0) {
        arrayC2 = (NSMutableArray *)[arrayC2 getSubArrayWithColumn_CC:1];
        arrayC3 = (NSMutableArray *)[App.arrDataRecipe getRowsWithKey_CC:[arrayC2 objectAtIndex:0] inColumn:1];
        if (arrayC3.count > 0){
            arrayC3 = (NSMutableArray *)[arrayC3 getSubArrayWithColumn_CC:2];
        }
    }else{
        arrayC3 = [NSMutableArray arrayWithObjects:nil];
    }
    [BakeRecipe setMaterialLib:[App.arrDataMaterial getSubArrayWithArray_CC:@[@"1",@"2",@"3"]]];
    currentRecipe = [BakeRecipe new];
    arrayM1 = [[App.arrDataMaterialCategory sortWithNumber_CC:1] getSubArrayWithColumn_CC:0];
    arrayM2 = (NSMutableArray *)[App.arrDataMaterial getRowsWithKey_CC:[arrayM1 objectAtIndex:0] inColumn:0];
    
    [self initControls];

    dictCurrent = (NSMutableDictionary *)[MyData getDictionaryWithUniqueColumnValue:App.arrDataMaterial indexColumn:0];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.navigationController.navigationBar addGestureRecognizer:gesture];
}

- (void)viewDidAppear:(BOOL)animated {
    [self handlePickerRecipe];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initControls {
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    lblTitle.backgroundColor = [UIColor grayColor];
    lblTitle.font = [UIFont fontWithName:@"Helvetica" size:16];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lblTitle];
    
    scrollCurrent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-40-64)];
    [self.view addSubview:scrollCurrent];
    
    pickerRecipe = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-200)];
    pickerRecipe.dataSource = self;
    pickerRecipe.delegate = self;
    pickerRecipe.tag = 1;
    [scrollCurrent addSubview:pickerRecipe];
    
    btnDeleteCategory = [[UIButton alloc]initWithFrame:CGRectMake(20, 210, SCREEN_WIDTH/2-30, 40)];
    btnDeleteCategory.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    [btnDeleteCategory setTitle:@"刪除配方" forState:UIControlStateNormal];
    btnDeleteCategory.enabled = FALSE;
    [btnDeleteCategory addTarget:self action:@selector(btnClickedDelete) forControlEvents:UIControlEventTouchUpInside];
    [scrollCurrent addSubview:btnDeleteCategory];
    
    btnEditCategory = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 10, 210, SCREEN_WIDTH/2-30, 40)];
    btnEditCategory.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    [btnEditCategory setTitle:@"修改配方" forState:UIControlStateNormal];
    btnEditCategory.enabled = FALSE;
    [btnEditCategory addTarget:self action:@selector(btnClickedModify) forControlEvents:UIControlEventTouchUpInside];
    [scrollCurrent addSubview:btnEditCategory];
    
    txtNewRecipe = [[UITextField alloc]initWithFrame:CGRectMake(20, 270, SCREEN_WIDTH-40, 40)];
    txtNewRecipe.placeholder = @"新增配方時請在此輸入新配方名稱";
    txtNewRecipe.borderStyle = UITextBorderStyleBezel;
    txtNewRecipe.keyboardType = UIKeyboardTypeDefault;
    txtNewRecipe.returnKeyType = UIReturnKeyDone;
    txtNewRecipe.tag = 1;
    txtNewRecipe.delegate = self;
    [txtNewRecipe addTarget:self action:@selector(txtValueChanged:) forControlEvents:UIControlEventValueChanged];
    [scrollCurrent addSubview:txtNewRecipe];
    
    btnNewCategory = [[UIButton alloc]initWithFrame:CGRectMake(20, 330, SCREEN_WIDTH - 40, 40)];
    btnNewCategory.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:1];
    [btnNewCategory setTitle:@"新增配方" forState:UIControlStateNormal];
    [btnNewCategory addTarget:self action:@selector(btnClickedAddNew) forControlEvents:UIControlEventTouchUpInside];
    [scrollCurrent addSubview:btnNewCategory];
    
    imgRecipe = [[UIImageView alloc] initWithFrame:CGRectMake(10, 400, SCREEN_WIDTH -20, 0.618*SCREEN_WIDTH - 12)];
    imgRecipe.contentMode = UIViewContentModeScaleToFill;
    imgRecipe.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    [scrollCurrent addSubview:imgRecipe];
    imgRecipe.image = [UIImage imageNamed:@"200"];
    
    int yAxis = round (388 + 0.618*SCREEN_WIDTH);
    
    UILabel *lblTableTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, yAxis + 20, 160, 21)];
    lblTableTitle.font = [UIFont fontWithName:@"Helvetica" size:16];
    lblTableTitle.textAlignment = NSTextAlignmentCenter;
    lblTableTitle.text = @"原材料名稱";
    [scrollCurrent addSubview:lblTableTitle];
    
    lblTableTitle = [[UILabel alloc] initWithFrame:CGRectMake(200, yAxis + 20, 50, 21)];
    lblTableTitle.font = [UIFont fontWithName:@"Helvetica" size:16];
    lblTableTitle.textAlignment = NSTextAlignmentCenter;
    lblTableTitle.text = @"數量";
    [scrollCurrent addSubview:lblTableTitle];
    
    tableCurrent = [[UITableView alloc] initWithFrame:CGRectMake(0, yAxis + 60, SCREEN_WIDTH, 44) style:UITableViewStylePlain];
    tableCurrent.dataSource = self;
    tableCurrent.delegate = self;
    tableCurrent.tag = 2;
    [scrollCurrent addSubview:tableCurrent];
    
    viewBlock = [[UIView alloc] initWithFrame:CGRectMake(0, yAxis + 104, SCREEN_WIDTH, 560)];
    //viewBlock.backgroundColor = [UIColor yellowColor];
    [scrollCurrent addSubview:viewBlock];
    
    lblTableTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 160, 21)];
    lblTableTitle.font = [UIFont fontWithName:@"Helvetica－Bold" size:17];
    lblTableTitle.textAlignment = NSTextAlignmentCenter;
    lblTableTitle.text = @"合計";
    [viewBlock addSubview:lblTableTitle];
    
    lblBakePercent = [[UILabel alloc] initWithFrame:CGRectMake(180, 10, 70, 21)];
    lblBakePercent.font = [UIFont fontWithName:@"Helvetica－Bold" size:17];
    lblBakePercent.textAlignment = NSTextAlignmentRight;
    [viewBlock addSubview:lblBakePercent];
    
    lblMaterialName = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, SCREEN_WIDTH -40, 21)];
    lblMaterialName.font = [UIFont fontWithName:@"Helvetica" size:17];
    [viewBlock addSubview:lblMaterialName];
    
    txtMaterialAmount = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 120, 40)];
    txtMaterialAmount.placeholder = @"材料數量";
    txtMaterialAmount.textAlignment = NSTextAlignmentCenter;
    txtMaterialAmount.borderStyle = UITextBorderStyleBezel;
    txtMaterialAmount.keyboardType = UIKeyboardTypeDecimalPad;
    txtMaterialAmount.returnKeyType = UIReturnKeyDone;
    txtMaterialAmount.backgroundColor = [UIColor whiteColor];
    txtMaterialAmount.delegate = self;
    txtMaterialAmount.tag = 2;
    [viewBlock addSubview:txtMaterialAmount];
    
    btnAddMaterial = [[UIButton alloc]initWithFrame:CGRectMake(160, 80, SCREEN_WIDTH-180, 40)];
    btnAddMaterial.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    [btnAddMaterial setTitle:@"增加材料" forState:UIControlStateNormal];
    [btnAddMaterial addTarget:self action:@selector(btnClickedAddMaterial) forControlEvents:UIControlEventTouchUpInside];
    btnAddMaterial.enabled = FALSE;
    [viewBlock addSubview:btnAddMaterial];
    
    pickerMaterial = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH, SCREEN_HEIGHT-200)];
    pickerMaterial.dataSource = self;
    pickerMaterial.delegate = self;
    pickerMaterial.tag = 2;
    [viewBlock addSubview:pickerMaterial];
    
    lblTableTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 360, SCREEN_WIDTH-40, 100)];
    lblTableTitle.font = [UIFont fontWithName:@"Helvetica－Bold" size:17];
    //lblTableTitle.textAlignment = NSTextAlignmentCenter;
    lblTableTitle.textColor = [UIColor grayColor];
    lblTableTitle.numberOfLines = 0;
    lblTableTitle.text = @"每個配方原材料數量輸入需保持單位統一，如採用克，則在輸入材料數量時全部使用克為單位。如使用烘焙比例，則所有輸入全使用比例數值。";
    [viewBlock addSubview:lblTableTitle];
    
    btnSubmit = [[UIButton alloc]initWithFrame:CGRectMake(20, 470, SCREEN_WIDTH-40, 40)];
    btnSubmit.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    [btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(btnClickedSubmit) forControlEvents:UIControlEventTouchUpInside];
    btnSubmit.enabled = FALSE;
    btnSubmit.tag = 6;
    [viewBlock addSubview:btnSubmit];
    
    scrollCurrent.contentSize = CGSizeMake(SCREEN_WIDTH, viewBlock.frame.origin.y + viewBlock.frame.size.height);
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView.tag == 1) {
        return 3;
    }
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 1) {
        switch (component) {
            case 0:
                return arrayC1.count;
                break;
            case 1:
                return arrayC2.count;
                break;
            default:
                return arrayC3.count;
                break;
        }
    }else{
        switch (component) {
            case 0:
                return arrayM1.count;
                break;
            case 1:
                return arrayM2.count;
                break;
            default:
                break;
        }
    }
    return arrayM1.count;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] init];
    if (pickerView.tag == 1) {
        switch (component) {
            case 0:
                label.text = [arrayC1 objectAtIndex:row];
                break;
            case 1:
                label.text = [arrayC2 objectAtIndex:row];
                break;
            case 2:
                label.text = [arrayC3 objectAtIndex:row];
                break;
            default:
                break;
        }
    }else{
        switch (component) {
            case 0:
                label.text = [arrayM1 objectAtIndex:row];
                break;
            case 1:
                label.text = [[arrayM2 objectAtIndex:row] objectAtIndex:1];
                break;
            default:
                break;
        }
    }    
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    label.textAlignment = NSTextAlignmentCenter;
    //label.textColor = [UIColor blackColor];
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (pickerView.tag == 1) {
        switch (component) {
            case 0:
                return 70;
                break;
            case 1:
                return 100;
                break;
            case 2:
                return SCREEN_WIDTH - 170;
                break;
            default:
                break;
        }
    }else{
        switch (component) {
            case 0:
                return 140;
                break;
            case 1:
                return SCREEN_WIDTH - 140;
                break;
            default:
                break;
        }
    }
    return 50;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == 2) {
        switch (component) {
            case 0:
                arrayM2 = (NSMutableArray *)[App.arrDataMaterial getRowsWithKey_CC:[arrayM1 objectAtIndex:row] inColumn:0];
                [pickerMaterial reloadComponent:1];
                [pickerMaterial selectRow:0 inComponent:1 animated:YES];
                break;
            default:
                break;
        }
        if (arrayM2.count > 0 && status != EditTypeNone) {
            lblMaterialName.text = [[arrayM2 objectAtIndex:[pickerView selectedRowInComponent:1]] objectAtIndex:1];
            btnAddMaterial.enabled = TRUE;
            btnAddMaterial.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:1];
        }else if (arrayM2.count > 0 && status == EditTypeNone) {
            lblMaterialName.text = [[arrayM2 objectAtIndex:[pickerView selectedRowInComponent:1]] objectAtIndex:1];
            btnAddMaterial.enabled = FALSE;
            btnAddMaterial.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        }else{
            btnAddMaterial.enabled = FALSE;
            btnAddMaterial.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        }
        return;
    }
    switch (component) {
        case 0:
            arrayC2 = (NSMutableArray *)[App.arrDataCategory2 getRowsWithKey_CC:[arrayC1 objectAtIndex:row] inColumn:0];
            if (arrayC2.count == 0) {
                arrayC3 = [NSMutableArray new];
            }else{
                arrayC2 = (NSMutableArray *)[arrayC2 getSubArrayWithColumn_CC:1];
                arrayC3 = (NSMutableArray *)[App.arrDataRecipe getRowsWithKey_CC:[arrayC2 objectAtIndex:row] inColumn:1];
                if (arrayC3.count > 0){
                    arrayC3 = (NSMutableArray *)[arrayC3 getSubArrayWithColumn_CC:2];
                }
            }
            [pickerRecipe reloadComponent:1];
            [pickerRecipe reloadComponent:2];
            [pickerRecipe selectRow:0 inComponent:1 animated:YES];
            [pickerRecipe selectRow:0 inComponent:2 animated:YES];
            break;
        case 1:
            arrayC3 = (NSMutableArray *)[App.arrDataRecipe getRowsWithKey_CC:[arrayC2 objectAtIndex:row] inColumn:1];
            if (arrayC3.count > 0){
                arrayC3 = (NSMutableArray *)[arrayC3 getSubArrayWithColumn_CC:2];
            }
            [pickerRecipe reloadComponent:2];
            [pickerRecipe selectRow:0 inComponent:2 animated:YES];
            break;
        default:
            break;
    }
    [self handlePickerRecipe];
}

- (void)hideKeyboard {
    [txtNewRecipe resignFirstResponder];
    [txtMaterialAmount resignFirstResponder];
}

- (void)viewWillMoveHidden {
    [self hideKeyboard];
}

- (void)btnEnable {
    btnEditCategory.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.7 alpha:1];
    btnEditCategory.enabled = TRUE;
    btnDeleteCategory.backgroundColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1];
    btnDeleteCategory.enabled = TRUE;
}

- (void)btnDisable {
    btnEditCategory.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    btnEditCategory.enabled = FALSE;
    btnDeleteCategory.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    btnDeleteCategory.enabled = FALSE;
}
/*
- (void)btnClicked:(UIButton *)sender {
    NSString *s1, *whereString;
    NSMutableArray *arrayTemp;
    switch (sender.tag) {
          
            break;
        case 5: //增加材料
            /*
            arrayTemp = @[@"",categoryName, recipeName,lblMaterialName.text ,txtMaterialAmount.text];
            [arrayRecipe addArray_CC:arrayTemp uniqueColumn:3];
            [self countTotalPercent];
            txtMaterialAmount.text = @"";
            [self resizeTable];
            [self hideKeyboard];
            break;
        case 6: //提交新增或修改
            
            //[self hideKeyboard];
            break;
        default:
            break;
    }
    //[self segSelected:segTitle];
}*/

- (void)btnClickedAddNew {
    if ([txtNewRecipe.text isEqualToString:@""]) {
        return;
    }
    //s1 = [arrayC1 objectAtIndex:[pickerRecipe selectedRowInComponent:0]];
    //categoryName = [arrayC2 objectAtIndex:[pickerRecipe selectedRowInComponent:1]];
    //currentRecipe.category = [arrayC2 objectAtIndex:[pickerRecipe selectedRowInComponent:1]];
    //recipeName = txtNewRecipe.text;
    currentRecipe = [BakeRecipe new];
    [tableCurrent reloadData];
    [self resizeTable];
    currentRecipe.category = [arrayC2 objectAtIndex:[pickerRecipe selectedRowInComponent:1]];
    currentRecipe.name = txtNewRecipe.text;
    [arrayC3 addObject:currentRecipe.name];
    
    if (datafile == nil) {
        datafile = [MyData dataFilePath:@"recipe.s3db"];
    }
    [MyData addRecordToFile:datafile tableName:@"Recipe" InsertString:[NSString stringWithFormat:@"(Category, RecipeName) VALUES ('%@', '%@')", currentRecipe.category, currentRecipe.name]];
    App.arrDataRecipe = (NSMutableArray *)[MyData getArrayFormTableF:datafile tableName:@"Recipe"];
    [pickerRecipe reloadComponent:2];
    [pickerRecipe selectRow:arrayC3.count - 1 inComponent:2 animated:YES];
    [self handlePickerRecipe];
    txtNewRecipe.text = @"";
    [self hideKeyboard];
    arrayRecipe = [NSMutableArray arrayWithObjects:nil];
    status = EditTypeAddNew;
    self.title = @"配方設定（新增）";
    if (arrayM2.count > 0) {
        btnAddMaterial.enabled = TRUE;
        btnAddMaterial.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:1];
    }
    [btnSubmit setTitle:[NSString stringWithFormat:@"新增 %@ 配方",currentRecipe.name] forState:UIControlStateNormal];
    btnSubmit.enabled = TRUE;
    btnSubmit.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:1];
    [scrollCurrent setContentOffset:CGPointMake(0, viewBlock.frame.origin.y -110) animated:YES];
}

- (void)btnClickedDelete {
    NSMutableArray *arrayRow;
    NSString *whereString;
    [arrayC3 removeObject:currentRecipe.name];
    for (int i = 0; i < App.arrDataRecipe.count; i++) {
        arrayRow = [App.arrDataRecipe objectAtIndex:i];
        if ([[arrayRow objectAtIndex:1]isEqualToString:currentRecipe.category] && [[arrayRow objectAtIndex:2]isEqualToString:currentRecipe.name]) {
            [App.arrDataRecipe removeObjectAtIndex:i];
            break;
        }
    }
    if (datafile == nil) {
        datafile = [MyData dataFilePath:@"recipe.s3db"];
    }
    whereString = [NSString stringWithFormat:@"Category = '%@' AND RecipeName = '%@'", currentRecipe.category, currentRecipe.name];
    [MyData deleteRecordFromFile:datafile tableName:@"Recipe" where:whereString];
    [pickerRecipe reloadComponent:2];
    status = EditTypeNone;
    self.title = @"配方設定";
    [self handlePickerRecipe];
}

- (void)btnClickedModify {
    //arrayRecipe = [NSMutableArray arrayWithObjects:nil];
    //s1 = [arrayC1 objectAtIndex:[pickerRecipe selectedRowInComponent:0]];
    //currentRecipe.category = [arrayC2 objectAtIndex:[pickerRecipe selectedRowInComponent:1]];
    //currentRecipe.name = [arrayC3 objectAtIndex:[pickerRecipe selectedRowInComponent:2]];
    //arrayRecipe = (NSMutableArray *)[App.arrDataRecipeDetail getRowsWithKey_CC:recipeName inColumn:2];
    NSArray *arrayTemp = [App.arrDataRecipeDetail getRowsWithKey_CC:currentRecipe.name inColumn:1];
    currentRecipe.recipeMaterials =[NSMutableArray arrayWithArray:[arrayTemp getSubArrayWithArray_CC:@[@"2", @"3"]]];
    [tableCurrent reloadData];
    [self resizeTable];
    status = EditTypeModify;
    self.title = @"配方設定（修改）";
    //[self countTotalPercent];
    if (arrayM2.count > 0) {
        btnAddMaterial.enabled = TRUE;
        btnAddMaterial.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:1];
    }
    [btnSubmit setTitle:[NSString stringWithFormat:@"修改 %@ 配方",currentRecipe.name] forState:UIControlStateNormal];
    btnSubmit.enabled = TRUE;
    btnSubmit.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:1];
    [scrollCurrent setContentOffset:CGPointMake(0, viewBlock.frame.origin.y -110) animated:YES];
}

- (void)btnClickedAddMaterial {
    [currentRecipe addMaterial:lblMaterialName.text Account:txtMaterialAmount.text.integerValue];
    [tableCurrent reloadData];
    //lblBakePercent.text = [NSString stringWithFormat:@"%.2f", [currentRecipe totalMaterialAccount]];
    //[self countTotalPercent];
    txtMaterialAmount.text = @"";
    [self resizeTable];
    [self hideKeyboard];
}

- (void)btnClickedSubmit {

    btnSubmit.enabled = FALSE;
    btnSubmit.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    status = EditTypeNone;
    //[arrayRecipe removeAllObjects];
    
    if (datafile == nil) {
        datafile = [MyData dataFilePath:@"recipe.s3db"];
    }
    for (int i=0; i<currentRecipe.recipeMaterials.count; i++) {
        [MyData replaceRecordToFile:datafile tableName:@"RecipeContent" InsertString:[NSString stringWithFormat:@"(Category, RecipeName, MaterialName, Quantity) VALUES ('%@', '%@', '%@', '%@')", currentRecipe.category, currentRecipe.name,
            [[currentRecipe.recipeMaterials objectAtIndex:i] objectAtIndex:0],
            [[currentRecipe.recipeMaterials objectAtIndex:i] objectAtIndex:1]
            ]];
    }
    App.arrDataRecipeDetail = (NSMutableArray *)[MyData getArrayFormTableF:datafile tableName:@"RecipeContent"];
    //[pickerRecipe reloadComponent:2];
    //[pickerRecipe selectRow:arrayC3.count - 1 inComponent:2 animated:YES];
    //[self handlePickerRecipe];
    //txtNewRecipe.text = @"";
    //[self hideKeyboard];
    
    //currentRecipe = [BakeRecipe new];
    currentRecipe.recipeMaterials = [NSMutableArray new];
    [tableCurrent reloadData];
    [self resizeTable];
    [scrollCurrent setContentOffset:CGPointMake(0, 0)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return arrayRecipe.count;
    return currentRecipe.recipeMaterials.count;
}

- (TableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    float account;
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:5];
    }
    cell.lblTitle.text = [[currentRecipe.recipeMaterials objectAtIndex:indexPath.row] objectAtIndex:0];
    account = [[[currentRecipe.recipeMaterials objectAtIndex:indexPath.row ] objectAtIndex:1] floatValue];
    if (account < 2.0) {
        cell.lblAmount.text =[NSString stringWithFormat:@"%.2f", account];
    }else if (account < 20.0){
        cell.lblAmount.text =[NSString stringWithFormat:@"%.1f", account];
    }else{
        cell.lblAmount.text =[NSString stringWithFormat:@"%.f", account];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    cellMaterial = (TableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    lblMaterialName.text = cellMaterial.lblTitle.text;
}

- (void)resizeTable {
    NSUInteger rows = currentRecipe.recipeMaterials.count;
    CGRect frame;
    if (rows > 0) {
        frame = tableCurrent.frame;
        frame.size.height = rows * 44;
        tableCurrent.frame = frame;
    }else{
        frame = tableCurrent.frame;
        frame.size.height = 44;
        tableCurrent.frame = frame;
    }
    frame = viewBlock.frame;
    frame.origin.y = tableCurrent.frame.origin.y + tableCurrent.frame.size.height;
    viewBlock.frame = frame;
    scrollCurrent.contentSize = CGSizeMake(SCREEN_WIDTH, frame.origin.y+frame.size.height);
    lblBakePercent.text = [NSString stringWithFormat:@"%.2f", [currentRecipe totalMaterialAccount]];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 1:
            if (scrollCurrent.contentOffset.y < 160) {
                [scrollCurrent setContentOffset:CGPointMake(0, 160) animated:YES];
            }
            break;
        case 2:
            if (scrollCurrent.contentOffset.y < viewBlock.frame.origin.y -110) {
                [scrollCurrent setContentOffset:CGPointMake(0, viewBlock.frame.origin.y -110) animated:YES];
            }
            break;
        default:
            break;
    }
}

- (void)txtValueChanged:(UITextField *)sender {
    switch (sender.tag) {
        case 1:
            if ([sender.text isEqualToString:@""]) {
                btnNewCategory.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
                btnNewCategory.enabled = FALSE;
            }else{
                btnNewCategory.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:1];
                btnNewCategory.enabled = TRUE;
            }
            break;
            
        default:
            break;
    }
}
/*
- (void)countTotalPercent {
    /*
    float total = 0;
    [tableCurrent reloadData];
    for (int i=0; i<arrayRecipe.count; i++) {
        total += [[[arrayRecipe objectAtIndex:i] objectAtIndex:4] floatValue];
    }
    lblBakePercent.text = [NSString stringWithFormat:@"%.2f", total];
    lblBakePercent.text = [NSString stringWithFormat:@"%.2f", [currentRecipe totalMaterialAccount]];
}
*/
- (void)handlePickerRecipe {
    NSString *s1, *s2;
    s1 = [arrayC1 objectAtIndex:[pickerRecipe selectedRowInComponent:0]];
    currentRecipe.category = [arrayC2 objectAtIndex:[pickerRecipe selectedRowInComponent:1]];
    if (arrayC3.count > 0) {
        currentRecipe.name = [arrayC3 objectAtIndex:[pickerRecipe selectedRowInComponent:2]];
        lblTitle.text = [NSString stringWithFormat:@"%@-%@-%@", s1, currentRecipe.category, currentRecipe.name];
        [self btnEnable];
    }else{
        lblTitle.text = [NSString stringWithFormat:@"%@-%@", s1, currentRecipe.category];
        [self btnDisable];
    }
    s1 = [arrayM1 objectAtIndex:[pickerMaterial selectedRowInComponent:0]];
    if (arrayM2.count > 0) {
        s2 = [[arrayM2 objectAtIndex:[pickerMaterial selectedRowInComponent:1]] objectAtIndex:1];
        lblMaterialName.text = s2;
    }else{
        lblMaterialName.text = @"";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"刪除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
//拦截下级视图的手势
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}

//手势会传递到下级视图
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}

//手势派发给下级视图
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
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
