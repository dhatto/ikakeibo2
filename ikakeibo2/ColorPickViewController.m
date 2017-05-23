//
//  ColorPickViewController..m
//  ikakeibo2
//
//  Created by daigoh on 2017/05/23.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

#import "ColorPickViewController.h"
//#import "HRBrightnessSlider.h"
#import "HRColorInfoView.h"

@interface ColorPickViewController ()
@end

@implementation ColorPickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    HRBrightnessSlider *slider = _picker.brightnessSlider;
    [_picker setColor:self.color];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pickerValueChanged:(HRColorPickerView *)sender {
    UIView<HRColorInfoView> *view = sender.colorInfoView;
    self.color = view.color;
}

//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}

@end


