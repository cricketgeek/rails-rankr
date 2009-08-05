#import <Foundation/Foundation.h>

@interface UIImage (Resizing)

+ (UIImage *)imageOfSize:(CGSize)size fromImage:(UIImage *)image;

- (UIImage *)imageScaledToSize:(CGSize)size;

@end
