//
//  iDanComposeViewController.m
//  InstaDan
//
//  Created by Dan Reife on 5/6/13.
//  Copyright (c) 2013 Dan Reife. All rights reserved.
//

#import "iDanComposeViewController.h"

@interface iDanComposeViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation iDanComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Set the image of the share buttons
    [self.facebookButton setImage:[UIImage imageNamed:@"fblogo.jpg"] forState:UIControlStateNormal];
    [self.twitterButton setImage:[UIImage imageNamed:@"twitterlogo.jpg"] forState:UIControlStateNormal];
    
    // Add the gesture recognizer that will dismiss the keyboard to the view
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tweet {
    // If possible, initialize a Twitter compose view controller,
    // add the text and image, and present the view controller
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:self.textView.text];
        [tweetSheet addImage:self.imageView.image];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

- (IBAction) share {
    // If possible, initialize a Facebook compose view controller,
    // add the text and image, and present the view controller
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *faceBook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [faceBook setInitialText:self.textView.text];
        [faceBook addImage:self.imageView.image];
        [self presentViewController:faceBook animated:YES completion:nil];
    }
}

- (IBAction)savePhoto:(id)sender {
    // Generate a CGImageRef to save the image
    CIImage *imgToSave = [[CIImage alloc] initWithImage:self.imageView.image];
    CIContext *context = [CIContext contextWithOptions:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:kCIContextUseSoftwareRenderer]];
    CGImageRef cgImg = [context createCGImage:imgToSave
                                          fromRect:[imgToSave extent]];
    // Save it to the photos album
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:cgImg
                                 metadata:[imgToSave properties]
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              CGImageRelease(cgImg);
                          }];
}

// Dismiss the keyboard
-(void)dismissKeyboard{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end
