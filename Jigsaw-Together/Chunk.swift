//
//  Chunk.swift
//  Jigsaw-Together
//
//  Created by Tyler Hunnefeld on 6/23/16.
//  Copyright © 2016 ThinkBig Applications. All rights reserved.
//

import Foundation
import UIKit

struct Chunk {
    var currentIndex : Int?
    var correctIndex : Int?
    var image : UIImage!
    
    init(){}
    
    init(withImage : UIImage) {
        image = withImage
    }
    
    func isCorrectPlace() -> Bool {
        return currentIndex == correctIndex
    }
}