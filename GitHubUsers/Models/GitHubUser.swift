//
//  GitHubUser.swift
//  GitHubUsers
//
//  Created by Sergey Myakinnikov on 9/8/16.
//  Copyright © 2016 Sergey Myakinnikov. All rights reserved.
//

import Gloss

struct GitHubUser: Decodable {
   let userId: Int?
   let login: String?
   let avatarURL: String?
   let htmlURL: String?
   
   // MARK: - Deserialization
   
   init?(json: JSON) {
      self.userId = "id" <~~ json
      self.login = "login" <~~ json
      self.avatarURL = "avatar_url" <~~ json
      self.htmlURL = "html_url" <~~ json
   }
   
}
