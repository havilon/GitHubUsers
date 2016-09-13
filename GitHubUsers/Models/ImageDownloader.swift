//
//  ImageDownloader.swift
//  GitHubUsers
//
//  Created by Sergey Myakinnikov on 9/12/16.
//  Copyright © 2016 Sergey Myakinnikov. All rights reserved.
//

import Foundation
import Alamofire

struct ErrorDomain {
   static let DownloadFailed = "GitHubUsersErrorDomainDownloadFailed"
}

class ImageDownloader: NSOperation {
   var imageInfo: ImageInfo
   let completion: ((ImageInfo!, NSError!) -> ())
   
   init(imageInfo: ImageInfo, completion: (ImageInfo!, NSError!) -> ()) {
      self.imageInfo = imageInfo
      self.completion = completion
   }
   
   override func main() {
      if self.cancelled {
         return
      }
      
      Alamofire.request(.GET, imageInfo.imageURL!).response(){ (_, _, imageData, _) in
         guard imageData != nil else {
            self.completion(nil, NSError(domain: ErrorDomain.DownloadFailed, code: 100, userInfo: [NSLocalizedDescriptionKey : "Error while downloading image"]))
            
            return
         }
         
         self.imageInfo.image = UIImage(data: imageData!)
         self.completion(self.imageInfo, nil)
      }
   }
}