//
//  iDanViewController.m
//  InstaDan
//
//  Created by Dan Reife on 4/25/13.
//  Copyright (c) 2013 Dan Reife. All rights reserved.
//

//
//  AYKMainViewController.m
//  Sharing
//
//  Created by Ayaka Nonaka on 4/14/13.
//  Copyright (c) 2013 Ayaka Nonaka. All rights reserved.
//

#import "iDanProcessViewController.h"

@interface iDanProcessViewController ()

@property (weak, nonatomic) IBOutlet UIButton *getButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@property (weak, nonatomic) IBOutlet UISlider *hueSlider;
@property (weak, nonatomic) IBOutlet UISlider *blurSlider;
@property (weak, nonatomic) IBOutlet UISlider *highlightShadowSlider;

@property (strong, nonatomic) CIContext *context;
@property (strong, nonatomic) CIFilter *hueFilter;
@property (strong, nonatomic) CIFilter *blurFilter;
@property (strong, nonatomic) CIFilter *shFilter;
@property (strong, nonatomic) CIImage *inImg;

- (IBAction)affectImage:(id)sender;
- (IBAction)changePhoto:(id)sender;

@end

@implementation iDanProcessViewController

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
    
    // Initialize the appearance of the reset and get (Photos) button
    [self initButtons];
    
    // Add picture
    UIImage *img = [UIImage imageNamed:@"me.jpg"];
    self.imageView.image = img;
    self.inImg = [[CIImage alloc] initWithImage:img];
    
    // Initialize the CIContext
    self.context = [CIContext contextWithOptions:nil];
    
    // Initialize all of the filters
    self.hueFilter = [CIFilter filterWithName:@"CIHueAdjust"];
    [self.hueFilter setValue:self.inImg forKey:kCIInputImageKey];
    self.blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [self.blurFilter setValue:self.inImg forKey:kCIInputImageKey];
    self.shFilter = [CIFilter filterWithName:@"CIHighlightShadowAdjust"];
    [self.shFilter setValue:self.inImg forKey:kCIInputImageKey];
}

-(void)initButtons{
    [self.resetButton setBackgroundImage:[iDanProcessViewController imageFromColor:[UIColor darkGrayColor]]
                      forState:UIControlStateNormal];
    self.resetButton.layer.cornerRadius = 8.0;
    self.resetButton.layer.masksToBounds = YES;
    self.resetButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.resetButton.layer.borderWidth = 1;
    
    [self.getButton setBackgroundImage:[iDanProcessViewController imageFromColor:[UIColor darkGrayColor]]
                                forState:UIControlStateNormal];
    self.getButton.layer.cornerRadius = 8.0;
    self.getButton.layer.masksToBounds = YES;
    self.getButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.getButton.layer.borderWidth = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    iDanComposeViewController *cvc = (iDanComposeViewController *)segue.destinationViewController;
    if ([cvc view]) {
        // Set the image to be sent as the edited one
        cvc.imageView.image = self.imageView.image;
    }
}

-(IBAction)reset {
    // Reset the image to be the unmodified version
    UIImage *img = [UIImage imageWithCGImage:[self.context createCGImage:self.inImg fromRect:self.inImg.extent]];
    self.imageView.image = img;
    
    // Reinitialize all of the sliders
    self.context = [CIContext contextWithOptions:nil];
    self.hueFilter = [CIFilter filterWithName:@"CIHueAdjust"];
    self.blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    self.shFilter = [CIFilter filterWithName:@"CIHighlightShadowAdjust"];
    self.inImg = [[CIImage alloc] initWithImage:img];
    
    // And set the sliders' default values
    [self.hueSlider setValue:0];
    [self.blurSlider setValue:0];
    [self.highlightShadowSlider setValue:0.5];
}

-(IBAction)affectImage:(UISlider *)slider {
    if ([slider minimumValue] < [slider value] && [slider value] < [slider maximumValue]) {
        if (slider == self.hueSlider) {
            [self.hueFilter setValue:[NSNumber numberWithFloat:[slider value]] forKey:@"inputAngle"];
        }
        if (slider == self.blurSlider) {
            [self.blurFilter setValue:[NSNumber numberWithFloat:[slider value]] forKey:@"inputRadius"];
        }
        if (slider == self.highlightShadowSlider) {
            [self.shFilter setValue:[NSNumber numberWithFloat:[slider value]] forKey:@"inputHighlightAmount"];
            [self.shFilter setValue:[NSNumber numberWithFloat:[slider value]] forKey:@"inputShadowAmount"];
        }
        [self renderImage];
    }
}

// Present the picker view controller
- (IBAction)changePhoto:(id)sender {
    UIImagePickerController *picker =
    [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

// Send the input image through all of the filters and
// display the output image
-(void)renderImage {
    [self.hueFilter setValue:self.inImg forKey:kCIInputImageKey];
    CIImage *img = [self.hueFilter outputImage];
    
    [self.blurFilter setValue:img forKey:kCIInputImageKey];
    img = [self.blurFilter outputImage];
    
    [self.shFilter setValue:img forKey:kCIInputImageKey];
    img = [self.shFilter outputImage];
    
    self.imageView.image = [UIImage imageWithCGImage:[self.context createCGImage:img fromRect:img.extent]];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Return to the ProcessVC
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // And set the image to be the one that was just retrieved
    UIImage *gotImage =
    [info objectForKey:UIImagePickerControllerOriginalImage];
    self.inImg = [CIImage imageWithCGImage:gotImage.CGImage];
    [self.hueFilter setValue:self.inImg forKey:kCIInputImageKey];
    [self.blurFilter setValue:self.inImg forKey:kCIInputImageKey];
    [self.shFilter setValue:self.inImg forKey:kCIInputImageKey];
    [self affectImage:self.hueSlider];
}

- (void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker {
    // Return to the ProcessVC
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Generate an image for a button made entirely of the color
+(UIImage *) imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(void) logSliderValues {
    NSLog(@"Hue: %f, Blur: %f, SH: %f",[self.hueSlider value], [self.blurSlider value], [self.highlightShadowSlider value]);
}

@end
