//
//  FollowersViewController.swift
//  GitHubUsers
//
//  Created by Sergey Myakinnikov on 9/13/16.
//  Copyright © 2016 Sergey Myakinnikov. All rights reserved.
//

import UIKit

class FollowersViewController: UsersListViewController {
   var userName: String!
   var page: Int! = 1
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      tableView.allowsSelection = false
   }
   
   // MARK: - Private
   override func getUsers() {
      UserNetworkManger.getFollowersForUser(userName, completion: {[unowned self] (gitHubUsers) in
         self.usersArray = gitHubUsers
         self.tableView.reloadData()
         })
   }
   
   override func getOtherUsers() {
      page = page! + 1
      
      UserNetworkManger.getUsersForPage(page!, completion: {[unowned self] (gitHubUsers) in
         self.waitForNewUsers = false
         
         if gitHubUsers != nil {
            self.usersArray.appendContentsOf(gitHubUsers!)
            self.tableView.reloadData()
         }
         })
   }
}
