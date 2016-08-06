//
//  PuzzleTimer.swift
//  Jigsaw-Together
//
//  Created by Tyler Hunnefeld on 6/27/16.
//  Copyright © 2016 ThinkBig Applications. All rights reserved.
//

import UIKit

@IBDesignable class PuzzleTimer: UIView {
    
    
    
    //MARK: - Variables
    
    @IBOutlet var view: UIView!
    @IBOutlet var timerLabel: UILabel!
   
    
    private var counter = 0
    private var timer : NSTimer!
    private var isRunning : Bool!
    
    
    //Tracks the time for pauses
    private var pauseTime : Int?
    
    //MARK: Read-Only Variables
    var running : Bool {
        get {
            return self.isRunning
        }
    }
    
    
    //MARK: - Initialization

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
        NSBundle.mainBundle().loadNibNamed("PuzzleTimer", owner: self, options: nil)
        guard let content = view else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.addSubview(content)
        self.isRunning = false
    }

    
    
    //MARK: - Public Methods
    
    func startTimer () {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func pauseTimer(){
        self.isRunning = false
        self.timer.invalidate()
        self.pauseTime = self.counter
    }
    
    func resetTimer() {
        self.timer.invalidate()
        self.isRunning = false
        self.counter = 0
        self.pauseTime = 0
    }
    
    
    //Mark: - Private Methods
    
    @objc private func updateTime() {
        counter = counter + 1
        if counter < 60 {
            let seconds = counter
            if seconds < 10 {
                timerLabel.text = "0:0\(seconds)"
            }
            else {
                timerLabel.text = "0:\(seconds)"
            }
        }
        else if counter < (60*60) {
            let minutes = counter / 60
            let seconds = counter % 60
            if seconds < 10 {
                timerLabel.text = "\(minutes):0\(seconds)"
            }
            else {
                timerLabel.text = "\(minutes):\(seconds)"
            }
        }
        
        //Hours/Minutes are recorded now
        else {
            let hours = counter / (60*60)
            let minutes = counter / 60
            if minutes < 10 {
                timerLabel.text = "\(hours):0\(minutes)"
            }
            else {
                timerLabel.text = "\(hours):\(minutes)"
            }
        }
    }



    
    

}
