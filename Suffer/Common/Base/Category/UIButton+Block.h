


#import <UIKit/UIKit.h>
typedef void(^ButtonBlock)(UIButton* btn);
@interface UIButton (Block)

- (void)addAction:(ButtonBlock)block;
- (void)addAction:(ButtonBlock)block forControlEvents:(UIControlEvents)controlEvents;

@end

@interface UIButton (lrextension)


@end
