#import "PhotoModelManager.h"

@implementation PhotoModelManager


static PhotoModelManager * sharedInstance;

+(PhotoModelManager*) getInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [[PhotoModelManager alloc] init];
    }
    
    return sharedInstance;
}

-(id)init
{
    if (self = [super init])
    {
        currentPhotoModel = nil;
    }
    return self;
}

- (PhotoModel *) selectedPhotoModel
{
    return currentPhotoModel;
}

- (void) setSelectedPhotoModel:(PhotoModel*) photoModel
{
    if(currentPhotoModel != photoModel)
        currentPhotoModel = photoModel;
}

@end
