//
//  UserNetworkManager.swift
//  GitHubUsers
//
//  Created by Sergey Myakinnikov on 9/8/16.
//  Copyright © 2016 Sergey Myakinnikov. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

class UserNetworkManger {
   private static func getUsers(params: String? = nil, completion: ([GitHubUser]?) -> ()) {
      var urlString = "https://api.github.com/users"
      
      if params != nil {
         urlString += params!
      }
      
      Alamofire.request(.GET, urlString).responseJSON { response in
         switch response.result {
         case .Success:
            guard let users = response.result.value as? [JSON] else {
               print("Wrong response result in response JSON")
               completion(nil)
               return
            }
            
            
            let gitHubUsers = [GitHubUser].fromJSONArray(users)
            
            completion(gitHubUsers)
            
         case .Failure(let error):
            print(error)
         }
      }
   }
   
   static func getUsersForPage(page: Int? = nil, completion: ([GitHubUser]?) -> ()) {
      var params: String?
      
      if page != nil {
         params = "?page=\(page!)"
      }
      
      self.getUsers(params, completion: completion)
   }
   
   static func getUsersSinceId(sinceId: Int? = nil, completion: ([GitHubUser]?) -> ()) {
      var params: String?
      
      if sinceId != nil {
         params = "?since=\(sinceId!)"
      }
      
      self.getUsers(params, completion: completion)
   }
   
   static func getFollowersForUser(userName: String!, completion: ([GitHubUser]?) -> ()) {
      guard userName != nil else {
         return
      }
      
      let params = "/\(userName)/followers"
      
      self.getUsers(params, completion: completion)
   }
}
