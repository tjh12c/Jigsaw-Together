//
//  Extensions.swift
//  Jigsaw-Together
//
//  Created by Tyler Hunnefeld on 6/28/16.
//  Copyright © 2016 ThinkBig Applications. All rights reserved.
//

import Foundation
import UIKit

//MARK: UIView

extension UIView
{
    class func initFromNib() -> UIView {
        let mainBundle = NSBundle.mainBundle()
        let className  = NSStringFromClass(self).componentsSeparatedByString(".").last ?? ""
        
        if ( mainBundle.pathForResource(className, ofType: "nib") != nil ) {
            let objects = mainBundle.loadNibNamed(className, owner: self, options: [:])
            
            for object in objects {
                if let view = object as? UIView {
                    return view
                }
            }
        }
        
        return UIView(frame: CGRectZero)
    }
}


//MARK: Collection Types - Shuffle

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

//MARK: UIImage Management

extension UIImage {
    
    func clipIntoSubImages(withRows rows: Int, withColumns columns: Int) -> Array<UIImage> {
        var imageArray = [UIImage]()
        let imageSize = self.size
        var xPos : CGFloat = 0.0
        var yPos : CGFloat = 0.0
        let width = imageSize.width/CGFloat(rows)
        let height = imageSize.height/CGFloat(columns)
        
        for _ in 0...columns-1 {
            xPos = 0.0
            for _ in 0...rows-1 {
                let rect = CGRectMake(xPos, yPos, width, height)
                let cImage = CGImageCreateWithImageInRect(self.CGImage!,  rect)
                let dImage = UIImage(CGImage: cImage!)
                imageArray.append(dImage)
                xPos += width;
            }
            yPos += height
        }
        
        return imageArray
    }


    func copyAndResize(toNewWidth newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        self.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
    image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}