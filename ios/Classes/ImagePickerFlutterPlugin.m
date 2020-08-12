#import "ImagePickerFlutterPlugin.h"
#if __has_include(<flutter_image_picker/flutter_image_picker-Swift.h>)
#import <flutter_image_picker/flutter_image_picker-Swift.h>
#else

#import "flutter_image_picker-Swift.h"
#endif

@implementation ImagePickerFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftImagePickerFlutterPlugin registerWithRegistrar:registrar];
}
@end
