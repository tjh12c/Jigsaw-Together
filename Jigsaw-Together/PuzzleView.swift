//
//  PuzzleView.swift
//  Jigsaw-Together
//
//  Created by Tyler Hunnefeld on 6/23/16.
//  Copyright © 2016 ThinkBig Applications. All rights reserved.
//

import UIKit

@IBDesignable class PuzzleView: UIView {
    
    
    //MARK: - Variables/Outlets
    
    @IBOutlet var view: UIView!
    
    @IBOutlet var puzzleCollectionView: UICollectionView!
    
    //Delegate
    weak var delegate : UICollectionViewDelegate?
    weak var dataSource : UICollectionViewDataSource?
    
    //Puzzle Pieces
    private var puzzlePieces = Array<Chunk>()
    
    //Managing selected views
    private var selectedIndex : NSIndexPath?
    private var selectedView : UIView?
    
    //Publicly accessible variables
    var rows : Int = 4 {
        didSet {
            self.puzzleCollectionView.reloadData()
        }
    }
    
    var columns : Int = 4 {
        didSet {
            self.puzzleCollectionView.reloadData()
        }
    }
    
    
    
    
    //Mark: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    convenience init() {
        self.init(frame: CGRectZero)
        self.initialize()
    }
    
    private func initialize() {
        NSBundle.mainBundle().loadNibNamed("PuzzleView", owner: self, options: nil)
        guard let content = view else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.addSubview(content)
        puzzleCollectionView.delegate = self
        puzzleCollectionView.dataSource = self
        
        
        self.puzzleCollectionView.registerNib(UINib(nibName: "PuzzlePieceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "puzzlePiece")
        
    }
    
    
    //MARK: Layout View
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        self.puzzleCollectionView.reloadData()
    }
    
    //MARK: - Publically accessible methods
    func load(imageNamed: String) throws -> Void {
        enum LoadError: ErrorType {
            case loadImageFromStringFailure
        }
    
        guard let imageFromString = UIImage(named: imageNamed) else {
            throw LoadError.loadImageFromStringFailure
        }
        
        let tempPuzzlePieces = self.clipIntoPuzzlePieces(imageFromString)
        self.puzzlePieces = tempPuzzlePieces
        self.puzzleCollectionView.reloadData()
    }
    
    
    //MARK: - Private Methods
    /**
     Clips a UIImage into an Array of UIImages.
     
     - Parameter image: UIImage to clip.
     - Parameter rows, columns: Desired rows/columns.
     
     - Returns: An array with the clipped images.
     */
    private func clipIntoPuzzlePieces(image: UIImage, rows : Int? = nil, columns : Int? = nil) -> [Chunk] {
        var clippedImageArray = Array<UIImage>()
        
        //Check if rows/columns were given
        var unwrappedRows, unwrappedColumns : Int
        if rows != nil {
            unwrappedRows = rows!
        }
        else {
            unwrappedRows = self.rows
        }
        
        if columns != nil {
            unwrappedColumns = columns!
        }
        else {
            unwrappedColumns = self.columns
        }
        
        clippedImageArray = image.clipIntoSubImages(withRows: unwrappedRows, withColumns: unwrappedColumns)
        var pieces = [Chunk]()
        
        for index in 0...clippedImageArray.count-1 {
            var newPuzzlePiece = Chunk(withImage: clippedImageArray[index])
            newPuzzlePiece.correctIndex = index
            pieces.append(newPuzzlePiece)
        }
        
        var piecesAreShuffled = false
        while !piecesAreShuffled {
            pieces.shuffleInPlace()
            for index in 0..<pieces.count {
                pieces[index].currentIndex = index
            }
            if checkCorrect(pieces) == 0 {
                piecesAreShuffled = true
            }
        }

        return pieces
    }
    
    private func checkCorrect(pieces : [Chunk]) -> Int {
        var numberCorrect = 0
        for object in pieces {
            if object.correctIndex == object.currentIndex {
                numberCorrect+=1
            }
        }
        return numberCorrect
    }

}

//MARK: - Default Delegate Actions

//Allows user to select/deselect cells, as well as swap cell locations
extension PuzzleView : UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //TODO: Defaults to Red border on selection, should change based on multiplayer settings etc.
        
        //If there is nothing selected
        if selectedIndex == nil {
            selectedIndex = indexPath
            let cell = self.puzzleCollectionView.cellForItemAtIndexPath(selectedIndex!) as! PuzzlePieceCollectionViewCell
            selectedView = UIView(frame: cell.contentView.frame)
            selectedView!.layer.borderWidth = 1
            selectedView!.layer.borderColor = UIColor.redColor().CGColor
            cell.contentView.addSubview(selectedView!)
        }
            
        //If there is already a selected piece
        else {
            //If the indexPath is currently selected, deselects
            if selectedIndex != indexPath {
                puzzlePieces[indexPath.row].currentIndex = selectedIndex!.row
                puzzlePieces[selectedIndex!.row].currentIndex = indexPath.row
                swap(&puzzlePieces[indexPath.row], &puzzlePieces[selectedIndex!.row])
                
                self.puzzleCollectionView.reloadItemsAtIndexPaths([indexPath, selectedIndex!])

            }
            selectedIndex = nil
            self.selectedView?.removeFromSuperview()
        }
    }
    
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        
        
        let width:CGFloat = self.puzzleCollectionView.bounds.size.width/CGFloat(columns)
        let height:CGFloat = self.puzzleCollectionView.bounds.size.height/CGFloat(rows)
        
        return CGSizeMake(width, height)
    }
    
    
    


}

extension PuzzleView : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.puzzlePieces.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("puzzlePiece", forIndexPath: indexPath) as! PuzzlePieceCollectionViewCell
        cell.puzzlePieceImageView.image = self.puzzlePieces[indexPath.row].image
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}




