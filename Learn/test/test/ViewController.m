//
//  ViewController.m
//  test
//
//  Created by Huiting Yu on 10/21/16.
//  Copyright © 2016 Huiting Yu. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375 , 650)];
  
  // Create a mask layer and the frame to determine what will be visible in the view.
  CALayer *maskLayer = [[CALayer alloc] init];
  CGImageRef cgimageRF = [[UIImage imageNamed:@"icGallery"] CGImage];
  [maskLayer setContents: (__bridge id) cgimageRF];
 // UIColor *maskColor = [[UIColor alloc]initWithRed:200 green:20 blue:200 alpha:1];
  maskLayer.frame = CGRectMake(0, 0, 200, 200);
  // Set the mask of the view.
  imageView.backgroundColor = [UIColor yellowColor];
  imageView.layer.mask = maskLayer;
  
  
  [self.view addSubview: imageView];
  
  // Do any additional setup after loading the view, typically from a nib.
 }


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
