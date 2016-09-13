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
   static func getUsers(sinceId: Int? = nil, completion: ([GitHubUser]?) -> ()) {
      var urlString = "https://api.github.com/users"
      
      if sinceId != nil {
         urlString = urlString + "?since=\(sinceId!)"
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
}
