//
//  MainViewController.swift
//  GitHubUsers
//
//  Created by Sergey Myakinnikov on 9/8/16.
//  Copyright © 2016 Sergey Myakinnikov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   var usersArray: Array<GitHubUser>!

   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
   }
   
   // 
   
   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
   }
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return usersArray.count
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier(String(UserTableViewCell), forIndexPath: indexPath) as! UserTableViewCell
      
//   let entry = data.places[indexPath.row]
//   let image = UIImage(named: entry.filename)
      cell.avatar.image = image
      cell.loginLabel.text = login
      cell.profileLinkLabel.text = login
      
      return cell
   }

}

