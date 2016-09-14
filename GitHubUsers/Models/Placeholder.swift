//
//  Placeholder.swift
//  GitHubUsers
//
//  Created by Sergey Myakinnikov on 9/12/16.
//  Copyright © 2016 Sergey Myakinnikov. All rights reserved.
//

import UIKit

class Placeholder {
   
   static func imageWitText(drawText: NSString, size: CGSize) -> UIImage {
      
      let textColor = UIColor.blackColor()
      let textFont = UIFont.systemFontOfSize(12)
      
      // Setup the image context using the passed image
      let scale = UIScreen.mainScreen().scale
      UIGraphicsBeginImageContextWithOptions(size, false, scale)
      
      let context = UIGraphicsGetCurrentContext()
      CGContextSetFillColorWithColor(context!, UIColor.grayColor().CGColor)
      CGContextFillRect(context!, CGRect(x: 0, y: 0, width: size.width, height: size.height))
      
      // Setup the font attributes that will be later used to dictate how the text should be drawn
      let textFontAttributes = [
         NSFontAttributeName: textFont,
         NSForegroundColorAttributeName: textColor,
      ]
      
      let calculatedSize = drawText.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: textFontAttributes, context: nil).size
      
      // Create a point within the space that is as bit as the image
      let rect = CGRectMake((size.width - calculatedSize.width) / 2, (size.height - calculatedSize.height) / 2, calculatedSize.width, calculatedSize.height)
      
      // Draw the text into an image
      drawText.drawInRect(rect, withAttributes: textFontAttributes)
      
      // Create a new image out of the images we have created
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      
      // End the context now that we have the image we need
      UIGraphicsEndImageContext()
      //Pass the image back up to the caller
      return newImage!
   }
}
