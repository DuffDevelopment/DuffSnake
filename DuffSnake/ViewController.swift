//
//  ViewController.swift
//  DuffSnake
//
//  Created by Eivind Morris Bakke on 6/28/15.
//  Copyright (c) 2015 Duff Development. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    enum Direction: Int {
        case N, S, E, W
    }
    
    
    let screenWidth:CGFloat = UIScreen.mainScreen().bounds.width;
    let screenHeight:CGFloat = UIScreen.mainScreen().bounds.height;
    let HEAD = 0
    let TAIL = 1
    let snakeSegmentWidth:CGFloat = 5
    var snakeSegmentSize:CGSize
    var startRect:CGRect
    var snake:[CGRect]
    var snakeSegmentViews:[UIView] = []
    
    var snakeDirection:Direction = Direction.E
    var apple:CGRect
    var appleView:UIView
    var appleWidth:Int = 5
    
    @IBOutlet var upDownSwipeRecognizer:UISwipeGestureRecognizer!
    @IBOutlet var leftRightSwipeRecognizer:UISwipeGestureRecognizer!
    

    required init(coder aDecoder: NSCoder) {
        
        var x = arc4random_uniform(UInt32(Int(screenWidth) - appleWidth))
        var y = arc4random_uniform(UInt32(Int(screenHeight) - appleWidth))
        apple = CGRectMake(CGFloat(x), CGFloat(y), CGFloat(appleWidth), CGFloat(appleWidth))
        appleView = UIView(frame: CGRectZero)
        snakeSegmentSize = CGSizeMake(snakeSegmentWidth, snakeSegmentWidth)
        startRect = CGRectMake(screenWidth / 2, screenHeight / 2, snakeSegmentWidth, snakeSegmentWidth)
        snake = [startRect, CGRectMake(startRect.origin.x - (1 * snakeSegmentWidth), startRect.origin.y, snakeSegmentWidth, snakeSegmentWidth), CGRectMake(startRect.origin.x - (2 * snakeSegmentWidth), startRect.origin.y, snakeSegmentWidth, snakeSegmentWidth)]
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        // Setup snake
        var snakeUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateSnake"), userInfo: nil, repeats: true)
        drawSnake()
        drawApple()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSnake() {
        addHead()
        redrawSnake()
        if (!CGRectIntersectsRect(snake[HEAD], apple)) {
            snake.removeLast()
        } else {
            updateApple()
        }
    }
    
    func redrawSnake() {
        var newSnakeHeadView = UIView(frame: snake[HEAD])
        newSnakeHeadView.tag = HEAD
        newSnakeHeadView.backgroundColor = UIColor.blueColor()
        snakeSegmentViews = [newSnakeHeadView] + snakeSegmentViews

        view.addSubview(newSnakeHeadView)
        
        if (snake.count != snakeSegmentViews.count) {
            snakeSegmentViews.last?.removeFromSuperview()
            snakeSegmentViews.removeLast()
        }
    }
    
    func drawSnake() {
        for s in snake {
            var snakeSegmentView = UIView(frame: s)
            snakeSegmentView.tag = find(snake, s)!
            snakeSegmentView.backgroundColor = UIColor.blueColor()
            snakeSegmentViews.append(snakeSegmentView)
            view.addSubview(snakeSegmentView)
        }
    }

    func addHead() {
        
        var newHead = snake[HEAD]
        
        switch snakeDirection {
        case .N:
            newHead.origin.y -= snakeSegmentWidth
            
        case .E:
            newHead.origin.x += snakeSegmentWidth
            
        case .S:
            newHead.origin.y += snakeSegmentWidth
            
        case .W:
            newHead.origin.x -= snakeSegmentWidth
        }
        
        snake = [newHead] + snake
    }
    
    
    func placeNewApple() -> CGRect {
        var x = arc4random_uniform(UInt32(Int(screenWidth) - appleWidth))
        var y = arc4random_uniform(UInt32(Int(screenHeight) - appleWidth))
        return CGRectMake(CGFloat(x), CGFloat(y), CGFloat(appleWidth), CGFloat(appleWidth))
    }
    
    func updateApple() {
        removeApple()
        apple = placeNewApple()
        drawApple()
    }
    
    func drawApple() {
        
        appleView = UIView(frame: apple)
        appleView.backgroundColor = UIColor.greenColor()
        view.addSubview(appleView)
        
    }

    func removeApple() {
        appleView.removeFromSuperview()
    }
    
    @IBAction func didSwipeRight(sender: UISwipeGestureRecognizer) {
        if (snakeDirection != Direction.W){
            snakeDirection = Direction.E
        }
    }

    
    @IBAction func didSwipeLeft(sender: UISwipeGestureRecognizer) {
        if (snakeDirection != Direction.E){
            snakeDirection = Direction.W
        }
    }


    @IBAction func didSwipeUp(sender: UISwipeGestureRecognizer) {
        if (snakeDirection != Direction.S){
            snakeDirection = Direction.N
        }
    }

    @IBAction func didSwipeDown(sender: UISwipeGestureRecognizer) {
        if (snakeDirection != Direction.N){
            snakeDirection = Direction.S
        }
    }

}

