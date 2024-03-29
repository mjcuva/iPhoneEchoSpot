//
//  ESNewEchoVC.m
//  The Echo Spot
//
//  Created by Marc Cuva on 6/29/14.
//  Copyright (c) 2014 The Echo Spot. All rights reserved.
//

#import "ESNewEchoVC.h"
#import "constants.h"
#import "ThemeManager.h"
#import "ESEchoFetcher.h"
#import "MBProgressHud.h"

@interface ESNewEchoVC () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, MBProgressHUDDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;

// Title
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextField *titleInput;

// Content
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UITextView *contentInput;

// Type
@property (strong, nonatomic) UILabel *typeLabel;
@property (strong, nonatomic) UISegmentedControl *typeControl;

// Category
@property (strong, nonatomic) UILabel *categoryLabel;
@property (strong, nonatomic) UIPickerView *categoryPicker;

// Privacy
@property (strong, nonatomic) UILabel *privacyLabel;
@property (strong, nonatomic) UISegmentedControl *privacyControl;

// Image
@property (strong, nonatomic) UIButton *uploadImage;
@property (strong, nonatomic) UIActionSheet *imageSourcePicker;

@property (strong, nonatomic) UIImageView *displayImage;

@property (strong, nonatomic) UIActionSheet *removeImage;

@end

@implementation ESNewEchoVC

- (void)viewDidLoad{
    self.navigationItem.title = @"Create Echo";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [[ThemeManager sharedManager] lightBackgroundColor];
    self.navigationController.navigationBar.barTintColor = [[ThemeManager sharedManager] navBarColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    
    double contentHeight = 0;
    
    // Title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width, 44)];
    self.titleLabel.text = @"Title";
    self.titleLabel.font = [UIFont systemFontOfSize:25];
    self.titleLabel.textColor = [[ThemeManager sharedManager] detailFontColor];
    
    contentHeight += 10 + self.titleLabel.frame.size.height;
    
    self.titleInput = [[UITextField alloc] initWithFrame:CGRectMake(0, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height, self.view.frame.size.width, 50)];
    self.titleInput.backgroundColor = [UIColor colorWithRed:244/255.0f green:238/255.0f blue:240/255.0f alpha:1.0f];
    
    contentHeight += self.titleInput.frame.size.height;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    self.titleInput.leftView = paddingView;
    self.titleInput.leftViewMode = UITextFieldViewModeAlways;
    
    // Content
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.titleInput.frame.origin.y + self.titleInput.frame.size.height + 10, self.view.frame.size.width, 50)];
    self.contentLabel.text = @"Echo";
    self.contentLabel.font = [UIFont systemFontOfSize:25];
    self.contentLabel.textColor = [[ThemeManager sharedManager] detailFontColor];
    
    contentHeight += self.contentLabel.frame.size.height + 10;
    
    self.contentInput = [[UITextView alloc] initWithFrame:CGRectMake(0, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height, self.view.frame.size.width, 150)];
    self.contentInput.backgroundColor = [UIColor colorWithRed:244/255.0f green:238/255.0f blue:240/255.0f alpha:1.0f];
    self.contentInput.editable = YES;
    self.contentInput.textContainerInset = UIEdgeInsetsMake(10, 10, 5, 10);
    self.contentInput.font = [UIFont systemFontOfSize:14];
    
    contentHeight += self.contentInput.frame.size.height;
    
    // Type
    
    self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.contentInput.frame.origin.y + self.contentInput.frame.size.height + 10, self.view.frame.size.height, 50)];
    self.categoryLabel.text = @"Category";
    self.categoryLabel.font = [UIFont systemFontOfSize:25];
    self.categoryLabel.textColor = [[ThemeManager sharedManager] detailFontColor];
    
    contentHeight += self.categoryLabel.frame.size.height + 10;
    
    self.categoryPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, self.categoryLabel.frame.size.height + self.categoryLabel.frame.origin.y + 10, self.view.frame.size.width - 20, 40)];
    self.categoryPicker.tintColor = [[ThemeManager sharedManager] themeColor];           
    self.categoryPicker.delegate = self;
    self.categoryPicker.dataSource = self;
    
    contentHeight += self.categoryPicker.frame.size.height + 10;
    
    // Privacy
    
    self.privacyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.categoryPicker.frame.origin.y + self.categoryPicker.frame.size.height + 20, self.view.frame.size.width, 50)];
    self.privacyLabel.text = @"Display Name";
    self.privacyLabel.font = [UIFont systemFontOfSize:25];
    self.privacyLabel.textColor = [[ThemeManager sharedManager] detailFontColor];
    
    contentHeight += self.privacyLabel.frame.size.height + 20;
    
    self.privacyControl = [[UISegmentedControl alloc] initWithItems:@[@"Anonymous", @"Username"]];
    self.privacyControl.frame = CGRectMake(10, self.privacyLabel.frame.origin.y + self.privacyLabel.frame.size.height + 10, self.view.frame.size.width - 20, 50);
    self.privacyControl.tintColor = [[ThemeManager sharedManager] themeColor];
    self.privacyControl.selectedSegmentIndex = 1;
    
    contentHeight += self.privacyControl.frame.size.height + 10;
    
    // Image
    
    self.uploadImage = [[UIButton alloc] initWithFrame:CGRectMake(30, self.privacyControl.frame.size.height + self.privacyControl.frame.origin.y + 30, self.view.frame.size.width - 60, 50)];
    self.uploadImage.tintColor = [[ThemeManager sharedManager] themeColor];
    [self.uploadImage setTitle:@"Add Image" forState:UIControlStateNormal];
    self.uploadImage.titleLabel.textColor = [UIColor whiteColor];
    [self.uploadImage addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    self.uploadImage.backgroundColor = [[ThemeManager sharedManager] themeColor];
    
    self.displayImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.uploadImage.frame.origin.y, self.view.frame.size.width, 100)];
    
    contentHeight += self.uploadImage.frame.size.height + 30;
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, contentHeight + 20);
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.titleInput];
    [self.scrollView addSubview:self.contentLabel];
    [self.scrollView addSubview:self.contentInput];
    [self.scrollView addSubview:self.categoryLabel];
    [self.scrollView addSubview:self.categoryPicker];
    [self.scrollView addSubview:self.privacyLabel];
    [self.scrollView addSubview:self.privacyControl];
    [self.scrollView addSubview:self.uploadImage];
    
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
}

- (void)addImage{
    self.imageSourcePicker = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
    self.imageSourcePicker.tag = 0;
    [self.imageSourcePicker showFromToolbar:self.navigationController.toolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == 0){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        if(buttonIndex == 0){
            // Take Photo
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = NO;
            [self presentViewController:picker animated:YES completion:nil];
        }else if(buttonIndex == 1){
            // Select Photo
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
        }else{
            // Canceled
        }
    }else if(actionSheet.tag == 1){
        if(buttonIndex == 0){
            self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.scrollView.contentSize.height - self.displayImage.frame.size.height + self.uploadImage.frame.size.height + 20);
            [self.displayImage removeFromSuperview];
            self.displayImage.image = nil;
        }else if(buttonIndex == 1){
            [self.imageSourcePicker showFromToolbar:self.navigationController.toolbar];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    if([self.displayImage isDescendantOfView:self.scrollView]){
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.scrollView.contentSize.height - self.displayImage.frame.size.height + self.uploadImage.frame.size.height + 20);
    }
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    double imgWidth = chosenImage.size.width;
    double ratio = self.view.frame.size.width / imgWidth;
    self.displayImage.image = chosenImage;
    self.displayImage.frame = CGRectMake(0, self.displayImage.frame.origin.y, self.view.frame.size.width, chosenImage.size.height * ratio);
    self.displayImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage)];
    [self.displayImage addGestureRecognizer:tap];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.scrollView.contentSize.height + self.displayImage.frame.size.height - self.uploadImage.frame.size.height - 20);
    [self.scrollView addSubview:self.displayImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 6;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSArray *categoryTitles = @[@"Academics", @"Projects", @"People", @"Finances", @"Misc", @"Grad Students"];
    return categoryTitles[row];
}

- (void)hideImage{
    self.removeImage = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove Image" otherButtonTitles:@"Change Image", nil];
    self.removeImage.tag = 1;
    [self.removeImage showFromToolbar:self.navigationController.toolbar];
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)post {
    NSString *anon;
    if(self.privacyControl.selectedSegmentIndex == 0){
        anon = @"true";
    }else{
        anon = @"false";
    }
    
    id image;
    if(self.displayImage.image){
        image = self.displayImage.image;
    }else{
        image = [NSNull null];
    }
    
    NSDictionary *data = @{@"title": self.titleInput.text, @"content": self.contentInput.text, @"anonymous": anon, @"image": image, @"category": [self pickerView:self.categoryPicker titleForRow:[self.categoryPicker selectedRowInComponent:0] forComponent: 0]};
    BOOL success = [ESEchoFetcher postEchoWithData:data];
    if(success){
        [self showInfoAlert];
    }
}

- (void)showInfoAlert {
    [self.view endEditing:YES];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeText;
    [self.view addSubview:hud];
    hud.delegate = self;
    hud.labelText = @"Posted!";
    [hud showWhileExecuting:@selector(waitForTwoSeconds) 
                   onTarget:self withObject:nil animated:YES];
}

- (void)waitForTwoSeconds {
    sleep(2);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
