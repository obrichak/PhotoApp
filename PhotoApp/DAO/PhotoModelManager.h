#import <Foundation/Foundation.h>
#import "PhotoModel.h"

@interface PhotoModelManager : NSObject
{
    PhotoModel* currentPhotoModel;
}

+(PhotoModelManager*) getInstance;

- (PhotoModel *) selectedPhotoModel;
- (void) setSelectedPhotoModel:(PhotoModel*) photoModel;

@end
