//
//  iDanComposeViewController.h
//  InstaDan
//
//  Created by Dan Reife on 5/6/13.
//  Copyright (c) 2013 Dan Reife. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>
#import "iDanProcessViewController.h"



@interface iDanComposeViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
