//
//  ELConstants.h
//  ElanicTest
//
//  Created by Manohar T on 02/11/15.
//  Copyright © 2015 Manohar T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELConstants : NSObject

typedef enum
{
    eFileNotDownloaded = 0,
    eFileDownloading,
    eFileDownloaded
}eFileDownloadStatus;


extern  NSString*  const kGooglePlacesAPIKey;


@end
