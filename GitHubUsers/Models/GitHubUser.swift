//
//  GitHubUser.swift
//  GitHubUsers
//
//  Created by Sergey Myakinnikov on 9/8/16.
//  Copyright © 2016 Sergey Myakinnikov. All rights reserved.
//

import Gloss

protocol ImageInfo {
   var image: UIImage? { get set }
   var imageURL: String? { get set }
}

struct GitHubUser: Decodable, ImageInfo {
   let userId: Int?
   let login: String?
   var imageURL: String?
   var image: UIImage?
   let htmlURL: String?
   
   // MARK: - Deserialization
   
   init?(json: JSON) {
      self.userId = "id" <~~ json
      self.login = "login" <~~ json
      self.imageURL = "avatar_url" <~~ json
      self.htmlURL = "html_url" <~~ json
   }
   
   // MARK: - Serialization
   
   func toJSON() -> JSON? {
      return jsonify([
         "id" ~~> self.userId,
         "login" ~~> self.login,
         "avatar_url" ~~> self.imageURL,
         "html_url" ~~> self.htmlURL
         ])
   }
}
