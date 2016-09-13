//
//  MainViewController.swift
//  GitHubUsers
//
//  Created by Sergey Myakinnikov on 9/8/16.
//  Copyright © 2016 Sergey Myakinnikov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

   @IBOutlet weak var tableView: UITableView!
   var usersArray: Array<GitHubUser>!
   var placeholderImage: UIImage!
   let pendingOperations = PendingOperations()
   var waitForNewUsers: Bool = false

   override func viewDidLoad() {
      super.viewDidLoad()
      
      placeholderImage = Placeholder.imageWitText("Image", size: CGSize(width: 100, height: 100))
      
      UserNetworkManger.getUsers(completion: {[unowned self] (gitHubUsers) in
         self.usersArray = gitHubUsers
         self.tableView.reloadData()
      })
   }
   
   // MARK: - UITableViewDataSource
   
   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
   }
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return usersArray?.count ?? 0
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier(String(UserTableViewCell), forIndexPath: indexPath) as! UserTableViewCell
      
      let gitHubUser = usersArray[indexPath.row]
      
      if let image = gitHubUser.image {
         cell.avatarImageView.image = image
      } else {
         cell.avatarImageView.image = placeholderImage
         
         if (!tableView.dragging && !tableView.decelerating) {
            self.startDownloadImageForUser(gitHubUser, indexPath: indexPath)
         }
      }
      
      cell.loginLabel.text = gitHubUser.login
      cell.profileLinkLabel.text = gitHubUser.htmlURL
      
      return cell
   }
   
   // MARK: - UIScrollView Delegate
   
   func scrollViewDidScroll(scrollView: UIScrollView) {
      let offset = scrollView.contentOffset;
      let bounds = scrollView.bounds;
      let size = scrollView.contentSize;
      let inset = scrollView.contentInset;
      let y = offset.y + bounds.size.height - inset.bottom;
      let h = size.height;

      let reload_distance: CGFloat = 10;
      
      if (y > h + reload_distance && !waitForNewUsers) {
         waitForNewUsers = true
         
         UserNetworkManger.getUsers(usersArray.last?.userId, completion: {[unowned self] (gitHubUsers) in
            self.waitForNewUsers = false
            
            if gitHubUsers != nil {
               self.usersArray.appendContentsOf(gitHubUsers!)
               self.tableView.reloadData()
            }
            })
      }
   }
   
   func scrollViewWillBeginDragging(scrollView: UIScrollView) {
      suspendAllOperations()
   }
   
   func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
      if !decelerate {
         loadImagesForOnscreenCells()
         resumeAllOperations()
      }
   }
   
   func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
      loadImagesForOnscreenCells()
      resumeAllOperations()
   }
   
   // MARK: - Private
   
   func startDownloadImageForUser(imageInfo: ImageInfo, indexPath: NSIndexPath) {
      if pendingOperations.downloadsInProgress[indexPath] != nil {
         return
      }
      
      let imageDownloader = ImageDownloader(imageInfo: imageInfo) { (imageInfo, error) in
         if error != nil {
            print(error)
         } else {
            self.usersArray[indexPath.row].image = imageInfo.image
            
            self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
         }
      }
      
      pendingOperations.downloadsInProgress[indexPath] = imageDownloader
      pendingOperations.downloadQueue.addOperation(imageDownloader)
   }
   
   func suspendAllOperations () {
      pendingOperations.downloadQueue.suspended = true
   }
   
   func resumeAllOperations () {
      pendingOperations.downloadQueue.suspended = false
   }
   
   func loadImagesForOnscreenCells () {
      if let pathsArray = tableView.indexPathsForVisibleRows {
         let pendingOperations = Set(self.pendingOperations.downloadsInProgress.keys)
         
         var toBeCancelled = pendingOperations
         let visiblePaths = Set(pathsArray)
         toBeCancelled.subtractInPlace(visiblePaths)
         
         var toBeStarted = visiblePaths
         toBeStarted.subtractInPlace(pendingOperations)
         
         for indexPath in toBeCancelled {
            if let pendingDownload = self.pendingOperations.downloadsInProgress[indexPath] {
               pendingDownload.cancel()
            }
            
            self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
         }
         
         for indexPath in toBeStarted {
            let indexPath = indexPath as NSIndexPath
            let recordToProcess = self.usersArray[indexPath.row]
            
            if recordToProcess.image == nil {
               startDownloadImageForUser(recordToProcess, indexPath: indexPath)
            }
         }
      }
   }
}

