//
//  PuzzleActivityViewController.swift
//  Jigsaw-Together
//
//  Created by Tyler Hunnefeld on 6/23/16.
//  Copyright © 2016 ThinkBig Applications. All rights reserved.
//

import UIKit

class PuzzleActivityViewController: UIViewController {

    @IBOutlet var puzzleCollectionView: PuzzleView!
    @IBOutlet var puzzleTimer: PuzzleTimer!
    
    //Mark: - Variables
    
    //Testing
    var size = 4
    var image = UIImage(named: TEST_IMAGE_STRING)
    
    //For creating the randomized image pieces
    var imageArray : Array<UIImage> = []
    var randomizedImageArray : Array<UIImage> = []
    var chunkArray : [Chunk] = []
    
    //Managing Selected Puzzle
    
    
    //Mark: - Mark View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        //puzzleCollectionView.delegate = self
        //puzzleCollectionView.dataSource = self
        
        do {
            try puzzleCollectionView.load(TEST_IMAGE_STRING)
        }
        catch {
            print("Image Error")
        }
        puzzleTimer.startTimer()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory Warning!")
    }
}



extension PuzzleActivityViewController : UICollectionViewDelegate {
    
    
}




