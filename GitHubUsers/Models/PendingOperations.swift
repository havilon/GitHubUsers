//
//  PendingOperations.swift
//  GitHubUsers
//
//  Created by Sergey Myakinnikov on 9/13/16.
//  Copyright © 2016 Sergey Myakinnikov. All rights reserved.
//

import Foundation

class PendingOperations {
   lazy var downloadsInProgress = [NSIndexPath: NSOperation] ()
   lazy var downloadQueue: NSOperationQueue = {
      var queue = NSOperationQueue ()
      queue.name = "Download queue"
      queue.maxConcurrentOperationCount = 5
      return queue
   }()
}
