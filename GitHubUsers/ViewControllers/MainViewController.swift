//
//  MainViewController.swift
//  GitHubUsers
//
//  Created by Sergey Myakinnikov on 9/8/16.
//  Copyright © 2016 Sergey Myakinnikov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource {

   @IBOutlet weak var tableView: UITableView!
   var usersArray: Array<GitHubUser>!
   var placeholderImage: UIImage!

   override func viewDidLoad() {
      super.viewDidLoad()
      
      placeholderImage = Placeholder.imageWitText("Image", size: CGSize(width: 100, height: 100))
      
      UserNetworkManger.getUsers(completion: {(gitHubUsers) in
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
      
      if let image = gitHubUser.avatarImage {
         cell.avatarImageView.image = image
      } else {
         cell.avatarImageView.image = placeholderImage
      }
      
      cell.loginLabel.text = gitHubUser.login
      cell.profileLinkLabel.text = gitHubUser.htmlURL
      
      return cell
   }

}

