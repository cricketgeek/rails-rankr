#import "UIImage+Resizing.h"

@implementation UIImage (Resizing)

+ (UIImage *)imageOfSize:(CGSize)size fromImage:(UIImage *)image;
{
	UIGraphicsBeginImageContext(size);
    
	[image drawInRect:CGRectMake(0,0, size.width, size.height)];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
	
	return scaledImage;    
}

- (UIImage *)imageScaledToSize:(CGSize)size
{
	return [[self class] imageOfSize:size fromImage:self];
}

@end

