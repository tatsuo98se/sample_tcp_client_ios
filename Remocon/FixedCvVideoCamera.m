//
//  FixedCvVideoCamera.m
//  Scouter
//
//  Created by Tatsuo Fukushima on 2016/11/02.
//  Copyright © 2016年 FXAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FixedCvVideoCamera.h"

@implementation FixedCvVideoCamera

- (void)layoutPreviewLayer{
  if (self.parentView != nil)
  {
    CALayer* layer = self->customPreviewLayer;
    CGRect bounds = self->customPreviewLayer.bounds;
    NSLog(@"[FixedCvVideoCamera]Custom Preview Layer bounds %fx%f", bounds.size.width, bounds.size.height);
    
    float previewAspectRatio = bounds.size.height / bounds.size.width;
    NSLog(@"[FixedCvVideoCamera]Preview aspect ratio %f", previewAspectRatio);
    
    //int rotation_angle = 0;
    
    layer.position = CGPointMake(self.parentView.frame.size.width/2., self.parentView.frame.size.height/2.);
    //layer.affineTransform = CGAffineTransformMakeRotation( DEGREES_RADIANS(rotation_angle) );
    
    // Get video feed's resolutions
    NSArray* devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice* device = nil;
    for (AVCaptureDevice *d in devices) {
      // Get the default camera device - should be either front of back camera device
      if ([d position] == self.defaultAVCaptureDevicePosition) {
        device = d;
      }
    }
    
    // Set the default device if not found
    if (!device) {
      device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(device.activeFormat.formatDescription);
    CGSize resolution = CGSizeMake(dimensions.width, dimensions.height);
    if (self.defaultAVCaptureVideoOrientation == AVCaptureVideoOrientationPortrait || self.defaultAVCaptureVideoOrientation == AVCaptureVideoOrientationPortraitUpsideDown) {
      resolution = CGSizeMake(resolution.height, resolution.width);
    }
    NSLog(@"[FixedCvVideoCamera]Video feed resolution is %fx%f", resolution.width, resolution.height);
    
    float videoFeedAspectRatio = resolution.height / resolution.width;
    NSLog(@"[FixedCvVideoCamera]Video feed's aspect ratio is %f", videoFeedAspectRatio);
    
    // Set layer bounds to ASPECT FILL by expanding either the width or the height
    if (previewAspectRatio > videoFeedAspectRatio) {
      NSLog(@"[FixedCvVideoCamera] Preview is more rectangular than the video feed aspect ratio. Expanding width to maintain aspect ratio.");
      float newWidth = bounds.size.height / videoFeedAspectRatio;
      layer.bounds = CGRectMake(0, 0, newWidth, bounds.size.height);
    } else {
      NSLog(@"[FixedCvVideoCamera] Preview is equally or less rectangular (wider) than the video feed's aspect ratio. Expanding height bound to maintain aspect ratio.");
      float newHeight = bounds.size.width * videoFeedAspectRatio;
      layer.bounds = CGRectMake(0, 0, bounds.size.width, newHeight);
    }
  }
}

@end
