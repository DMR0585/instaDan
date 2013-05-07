//
//  iDanViewController.h
//  InstaDan
//
//  Created by Dan Reife on 4/25/13.
//  Copyright (c) 2013 Dan Reife. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import "iDanComposeViewController.h"


@interface iDanProcessViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

+(UIImage *)imageFromColor:(UIColor *)color;

@end
