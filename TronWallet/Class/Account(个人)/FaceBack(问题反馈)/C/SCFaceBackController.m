//
//  SCFaceBackController.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/14.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCFaceBackController.h"
#import "SCCustomPlaceHolderTextView.h"
#import "SCFaceBackPictureView.h"
#import "TZImagePickerController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#define marginX 15

@interface SCFaceBackController ()
<SCCustomPlaceHolderTextViewDelegate, UBPublishDraftPictureViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,TZImagePickerControllerDelegate,UITextFieldDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) SCCustomPlaceHolderTextView *placeHolderTextView;
@property (nonatomic, weak) SCFaceBackPictureView *pictureView;
@property (nonatomic, strong) NSMutableArray *picArray;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *picCountLab;
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UITextField *emailTextField;
@end

@implementation SCFaceBackController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = LocalizedString(@"提交反馈");
    [self subViews];
    
}

- (void)subViews{
 
    // 设置占位文字
    self.placeHolderTextView.placehoder = LocalizedString(@"请输入问题的详细描述，提交钱包地址交易请尽量使用文本格式，切勿向我们提交助记词，Kesyore或私钥");
    
    UIView *line = [RewardHelper addLine2];
    line.x = 15;
    line.width = SCREEN_WIDTH - 30;
    line.y = self.placeHolderTextView.bottom;
    [self.scrollView addSubview:line];
    
    [self titleView];
    
    [self pictureView];
    
    UITextField *tf = [UITextField new];
    tf.size = CGSizeMake(SCREEN_WIDTH-30, 58);
    tf.x = 15;
    tf.y = self.pictureView.bottom;
    tf.tintColor = MainColor;
    tf.placeholder = LocalizedString(@"你的邮箱");
    [tf setValue:kFont(15) forKeyPath:@"_placeholderLabel.font"];
    [self.scrollView addSubview:tf];
    _emailTextField = tf;
    tf.tag = 102;
    tf.delegate = self;
    
    _picker = [[UIImagePickerController alloc]init];
    _picker.view.backgroundColor = [UIColor orangeColor];
    UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypePhotoLibrary;
    _picker.sourceType = sourcheType;
    _picker.delegate = self;
    _picker.allowsEditing = NO;

}

- (SCFaceBackPictureView *)pictureView {
    if (!_pictureView) {
        UILabel *t1 = [UILabel new];
        t1.size = CGSizeMake(80, 44);
        t1.font = kFont(16);
        t1.textColor = SCTEXTCOLOR;
        t1.text = LocalizedString(@"图片上传");
        t1.x = marginX;
        t1.top = self.placeHolderTextView.bottom;
        [self.scrollView addSubview:t1];
        
        _picCountLab = [UILabel new];
        _picCountLab.size = CGSizeMake(80, 44);
        _picCountLab.font = kFont(16);
        _picCountLab.textColor = SCGray(179);
        _picCountLab.text = @"0/5";
        _picCountLab.right = SCREEN_WIDTH - marginX;
        _picCountLab.textAlignment = NSTextAlignmentRight;
        _picCountLab.top = self.placeHolderTextView.bottom;
        [self.scrollView addSubview:_picCountLab];
        
        SCFaceBackPictureView *pic = [[SCFaceBackPictureView alloc] init];
        [self.scrollView addSubview:pic];
        _pictureView = pic;
        _pictureView.pictureArray = self.picArray;
        pic.delegate = self;
        pic.left = 10;
        pic.width = SCREEN_WIDTH-20;
        pic.top = t1.bottom;
        pic.height = ((SCREEN_WIDTH - 20) - 5 * 4) / 5.0+10;
    }
    return _pictureView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *sc = [[UIScrollView alloc] init];
        sc.delegate = self;
        [self.view addSubview:sc];
        _scrollView = sc;
        sc.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        sc.x = sc.y = 0;
        sc.showsVerticalScrollIndicator = NO;
        sc.showsHorizontalScrollIndicator = NO;
        sc.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (SCCustomPlaceHolderTextView *)placeHolderTextView {
    if (!_placeHolderTextView) {
        SCCustomPlaceHolderTextView *placeHolderTextView = [[SCCustomPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, self.titleView.bottom, SCREEN_WIDTH-20, 110)];
        placeHolderTextView.tintColor = MainColor;
        [self.scrollView addSubview:placeHolderTextView];
        _placeHolderTextView = placeHolderTextView;
        placeHolderTextView.placeholderFont = kFont(14);
        placeHolderTextView.del = self;
    }
    return _placeHolderTextView;
}

- (UIView *)titleView
{
    if (!_titleView) {
        _titleView = [UIView new];
        _titleView.size = CGSizeMake(SCREEN_WIDTH, 60);
        _titleView.x = 0;
        _titleView.y = 0;
        [self.scrollView addSubview:_titleView];
        UITextField *tf = [UITextField new];
        tf.size = CGSizeMake(SCREEN_WIDTH-30, _titleView.height);
        tf.x = 15;
        tf.y = 0;
        tf.tintColor = MainColor;
        tf.placeholder = LocalizedString(@"主题");
        [tf setValue:kFont(15) forKeyPath:@"_placeholderLabel.font"];
        _titleTextField = tf;
        [_titleView addSubview:tf];
    }
    return _titleView;
}

- (NSMutableArray *)picArray
{
    if (!_picArray) {
        _picArray = [NSMutableArray new];
    }
    return _picArray;
}

- (void)dealloc
{
    SCLog(@"释放");
}

#pragma mark - SCCustomPlaceHolderTextViewDelegate
- (void)customPlaceHolderTextViewTextDidChange:(SCCustomPlaceHolderTextView *)textView {
    NSString *text = textView.text;
    
    if (text.length > 120) {
        textView.text = [textView.text substringToIndex:120];
    
    } else {
     
    }
}

#pragma mark - 键盘弹出
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGFloat height = 260;
    if (textField.tag==102) {
        if ((self.emailTextField.bottom)>(self.view.frame.size.height - height))
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.2 animations:^{
                    self.scrollView.frame = CGRectMake(0, -(height-(self.view.frame.size.height-self.emailTextField.bottom)), self.view.frame.size.width, self.view.frame.size.height);
                }];
            });
        }
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag==102) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            }];
        });
    }
    return YES;
}

#pragma mark - UBPublishDraftPictureViewDelegate
- (void)publishDraftPictureView:(SCFaceBackPictureView *)pictureView picArrayDidChange:(NSArray *)picArray {
    //    self.bottomView.limitPhotos = picArray.count;
    self.picArray = picArray.mutableCopy;
}

#pragma mark - UBPublishDraftPictureViewDelegate
- (void)publishDraftPictureViewAddImage:(SCFaceBackPictureView *)pictureView {
    [self addImage];
}

- (void)addImage {
    WeakSelf(weakSelf);
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:MAXPHOTOSCOUNT - self.picArray.count delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        
        if (photos.count) {
            if (weakSelf.picArray.count > 0) { // 继续添加
                [weakSelf.pictureView addImages:photos];
            } else { // 从无到有
                weakSelf.pictureView.pictureArray = photos.mutableCopy;
                weakSelf.picArray = photos;
            }
        }
        weakSelf.picCountLab.text = [NSString stringWithFormat:@"%ld/5",weakSelf.pictureView.pictureArray.count];
    }];
    [self.navigationController presentViewController:imagePickerVc animated:YES completion:^{

    }];
}

- (void)addVideo {
    
}

#pragma mark --- UIImagePicker
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self.picArray addObject:image];
    _pictureView.pictureArray = self.picArray;
    [_picker dismissViewControllerAnimated:YES completion:nil];
}

@end
