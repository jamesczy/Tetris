//
//  ViewController.swift
//  Tetris
//
//  Created by jamesczy on 2018/9/13.
//  Copyright © 2018年 jamesczy. All rights reserved.
//

import UIKit


let screenW = UIScreen.main.bounds.width
let screenH = UIScreen.main.bounds.height

let pixScale = screenW / 375

class ViewController: UIViewController {

    var gamesView : TetrisView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        gamesView = TetrisView.init(frame: CGRect(x: 0,
                                                  y: 20,
                                                  width: screenW - 100 * pixScale, height: screenH - 170 * pixScale))
        
        
        self.view.addSubview(gamesView!)
 
        self.configeToolView()
        
        self.configControlView()
    }

    func configControlView() {
        let leftBtn = UIButton(type: .custom)
        leftBtn.setTitle("左", for: .normal)
        leftBtn.setTitleColor(UIColor.black, for: .normal)
        leftBtn.frame = CGRect(x:  screenW - 80 * pixScale - 100 * pixScale,
                               y: (screenH - 70 * pixScale - 50 * pixScale), width: 50 * pixScale, height: 50 * pixScale)
        leftBtn.addTarget(self, action: #selector(controAction(btn:)), for: .touchUpInside)
        
        self.view.addSubview(leftBtn)
        
        let downBtn = UIButton(type: .custom)
        downBtn.setTitle("下", for: .normal)
        downBtn.setTitleColor(UIColor.black, for: .normal)
        downBtn.frame = CGRect(x:  screenW - 80 * pixScale - 50 * pixScale,
                               y: (screenH - 70 * pixScale), width: 50 * pixScale, height: 50 * pixScale)
        downBtn.addTarget(self, action: #selector(controAction(btn:)), for: .touchUpInside)
        
        self.view.addSubview(downBtn)
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("右", for: .normal)
        rightBtn.setTitleColor(UIColor.black, for: .normal)
        rightBtn.frame = CGRect(x: screenW - 80 * pixScale ,
                                y: (screenH - 70 * pixScale - 50 * pixScale), width: 50 * pixScale, height: 50 * pixScale)
        rightBtn.addTarget(self, action: #selector(controAction(btn:)), for: .touchUpInside)
        
        self.view.addSubview(rightBtn)
        
        let upBtn = UIButton(type: .custom)
        upBtn.setTitle("上", for: .normal)
        upBtn.setTitleColor(UIColor.black, for: .normal)
        upBtn.frame = CGRect(x: screenW - 80 * pixScale - 50 * pixScale,
                             y: (screenH - 70 * pixScale - 100 * pixScale), width: 50 * pixScale, height: 50 * pixScale)
        upBtn.addTarget(self, action: #selector(controAction(btn:)), for: .touchUpInside)
        
        self.view.addSubview(upBtn)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longpress(gesture:)))
        upBtn.addGestureRecognizer(longPress)
        leftBtn.addGestureRecognizer(longPress)
        rightBtn.addGestureRecognizer(longPress)
        downBtn.addGestureRecognizer(longPress)
        
        let spaceBtn = UIButton(type: .custom)
        spaceBtn.setTitle("space", for: .normal)
        spaceBtn.setTitleColor(UIColor.black, for: .normal)
        spaceBtn.frame = CGRect(x:  20 * pixScale,
                                y: (screenH - 70 * pixScale - 40 * pixScale), width: 100 * pixScale, height: 40 * pixScale)
        spaceBtn.addTarget(self, action: #selector(spaceBtnClick), for: .touchUpInside)
        spaceBtn.layer.borderColor = UIColor.black.cgColor
        spaceBtn.layer.borderWidth = 1
        spaceBtn.layer.cornerRadius = 3
        self.view.addSubview(spaceBtn)
    }
    
    
    @objc func startBtnClick(btn:UIButton){
        
        switch btn.currentTitle  {
        case "开始":
            self.gamesView?.startGame()
            btn.setTitle("暂停", for: .normal)
            break
        default:
            self.gamesView?.pauseGame()
            btn.setTitle("开始", for: .normal)
            break
        }
    }
    @objc func spaceBtnClick(){
        self.gamesView?.AccelerateMoveDown()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func controAction(btn:UIButton){
        switch btn.currentTitle {
        case "上":
            self.gamesView?.rotateBlock()
            break
        case "下":
            self.gamesView?.moveDown()
            break
        case "左":
            self.gamesView?.moveLeft()
            break
        case "右":
            self.gamesView?.moveRight()
            break
        default:
            break
        }
    }
    
    @objc func longpress(gesture:UILongPressGestureRecognizer){
        let view = gesture.view as! UIButton
        
        switch view.currentTitle {
        case "上":
            self.gamesView?.rotateBlock()
            break
        case "下":
            self.gamesView?.moveDown()
            break
        case "左":
            self.gamesView?.moveLeft()
            break
        case "右":
            self.gamesView?.moveRight()
            break
        default:
            break
        }
    }
    
    func configeToolView() {
        let toolView = UIView()
        toolView.frame = CGRect(x: screenW - 100 * pixScale, y: (self.gamesView?.frame.origin.y)!, width: 100 * pixScale, height: (self.gamesView?.bounds.height)!)
        self.view.addSubview(toolView)
        
        let leveTipLabel = UILabel()
        leveTipLabel.text = "难度"
        leveTipLabel.textColor = UIColor.black
        leveTipLabel.font = UIFont.systemFont(ofSize: 16)
        toolView.addSubview(leveTipLabel)
        leveTipLabel.sizeToFit()
        leveTipLabel.frame = CGRect(x: 0, y: 100 * pixScale, width: toolView.frame.size.width, height: leveTipLabel.bounds.size.height)
        
        let leveValueLabel = UILabel()
        leveValueLabel.text = "1"
        leveValueLabel.textColor = UIColor.black
        leveValueLabel.font = UIFont.systemFont(ofSize: 16)
        toolView.addSubview(leveValueLabel)
        leveValueLabel.frame = CGRect(x: 0, y: leveTipLabel.frame.maxY+5, width: toolView.frame.width, height: 35*pixScale)
        leveValueLabel.textAlignment = .center
        leveValueLabel.layer.borderColor = UIColor.black.cgColor
        leveValueLabel.layer.borderWidth = 1
        leveValueLabel.layer.cornerRadius = 3
        
        
        let scoreTipLabel = UILabel()
        scoreTipLabel.text = "分数"
        scoreTipLabel.textColor = UIColor.black
        scoreTipLabel.font = UIFont.systemFont(ofSize: 16)
        toolView.addSubview(scoreTipLabel)
        scoreTipLabel.sizeToFit()
        scoreTipLabel.frame = CGRect(x: 0, y: leveValueLabel.frame.maxY + 10, width: toolView.frame.size.width, height: scoreTipLabel.bounds.size.height)
        
        
        
        let scoreLabel = UILabel()
        scoreLabel.text = "0"
        scoreLabel.textColor = UIColor.black
        scoreLabel.font = UIFont.systemFont(ofSize: 16)
        toolView.addSubview(scoreLabel)
        scoreLabel.layer.borderColor = UIColor.black.cgColor
        scoreLabel.layer.borderWidth = 1
        scoreLabel.layer.cornerRadius = 3
        scoreLabel.frame = CGRect(x: 0, y: scoreTipLabel.frame.maxY+5, width: toolView.frame.width, height: 35*pixScale)
        scoreLabel.textAlignment = .center
        self.gamesView?.scoreCallBack = { (score:Int?) in
            scoreLabel.text = "\(score ?? 0)"
            
        }
        self.gamesView?.levelCallBack = {(level:Int?) in
            leveValueLabel.text = "\(level ?? 1)"
        }
        
        
        let startBtn = UIButton(type: .custom)
        startBtn.setTitle("开始", for: .normal)
        startBtn.titleLabel?.sizeToFit()
        startBtn.setTitleColor(UIColor.black, for: .normal)
        startBtn.frame = CGRect(x:  5,
                                y: scoreLabel.frame.maxY + 10,
                                width: toolView.bounds.width - 10, height: 30 * pixScale)
        startBtn.layer.borderColor = UIColor.black.cgColor
        startBtn.layer.borderWidth = 1
        startBtn.layer.cornerRadius = 3
        startBtn.addTarget(self, action: #selector(startBtnClick), for: .touchUpInside)
        toolView.addSubview(startBtn)
        
        self.gamesView?.gameOverCallBack = {
            startBtn.setTitle("开始", for: .normal)
            self.gamesView?.gameStart = -1
            self.gamesView?.currentTimer?.invalidate()
            self.gamesView?.currentTimer = nil
        }
    }
    
}

