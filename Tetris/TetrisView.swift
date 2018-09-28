//
//  TetrisView.swift
//  Tetris
//
//  Created by jamesczy on 2018/9/13.
//  Copyright © 2018年 jamesczy. All rights reserved.
//  俄罗斯方块的主界面

import Foundation
import UIKit

class TetrisView: UIView {
    
    var TETRIS_ROWS = 32
    var TETRIS_COLS = 10
    var STROKE_WIDTH:CGFloat = 1.0
    var BASE_SPEED = 0.6
    
    /// 没有方块
    var NO_BLOCK = 0
    var CELL_SIZI:Int = 0
    
    var currentTetris = Array<Tetris>()
    
    var currentTimer : Timer?
    var curScore = 0
    var curLevel = 1
    
    
    var scoreCallBack : ((_ score:Int)->())?
    var levelCallBack : ((_ level:Int)->())?
    var gameOverCallBack : (()->())?
    
    
    let colors = [UIColor.white.cgColor,
                  UIColor.red.cgColor,
                  UIColor.green.cgColor,
                  UIColor.blue.cgColor,
                  UIColor.yellow.cgColor,
                  UIColor.magenta.cgColor,
                  UIColor.purple.cgColor,
                  UIColor.brown.cgColor,
                  ]
    
    var tetris_status = Array<Array<Int>>()
    
    
    /// 定义方块的几种类型
    lazy var tetrisArray:  Array<Array<Tetris>> = {
        let tempArray = [
            //Z
            [
                Tetris(x: TETRIS_COLS / 2 - 1 , y: 0, color: 1),
                Tetris(x: TETRIS_COLS / 2 - 1 , y: 1, color: 1),
                Tetris(x: TETRIS_COLS / 2 , y: 1, color: 1),
                Tetris(x: TETRIS_COLS / 2 , y: 2, color: 1)
            ],
            //反Z
            [
                Tetris(x: TETRIS_COLS / 2  , y: 0, color: 1),
                Tetris(x: TETRIS_COLS / 2  , y: 1, color: 1),
                Tetris(x: TETRIS_COLS / 2 - 1 , y: 1, color: 1),
                Tetris(x: TETRIS_COLS / 2 - 1 , y: 2, color: 1)
            ],
            //田
            [
                Tetris(x: TETRIS_COLS / 2 - 1 , y: 0, color: 2),
                Tetris(x: TETRIS_COLS / 2 , y: 0, color: 2),
                Tetris(x: TETRIS_COLS / 2 - 1 , y: 1, color: 2),
                Tetris(x: TETRIS_COLS / 2 , y: 1, color: 2)
            ],
            //L
            [
                Tetris(x: TETRIS_COLS / 2 - 1 , y: 0, color: 3),
                Tetris(x: TETRIS_COLS / 2 - 1 , y: 1, color: 3),
                Tetris(x: TETRIS_COLS / 2 - 1 , y: 2, color: 3),
                Tetris(x: TETRIS_COLS / 2 , y: 2, color: 3)
            ],
            //反L
            [
                Tetris(x: TETRIS_COLS / 2  , y: 0, color: 3),
                Tetris(x: TETRIS_COLS / 2  , y: 1, color: 3),
                Tetris(x: TETRIS_COLS / 2  , y: 2, color: 3),
                Tetris(x: TETRIS_COLS / 2 - 1 , y: 2, color: 3)
            ],
            //7
            [
                Tetris(x: TETRIS_COLS / 2 - 1 , y: 0, color: 3),
                Tetris(x: TETRIS_COLS / 2  , y: 0, color: 3),
                Tetris(x: TETRIS_COLS / 2  , y: 1, color: 3),
                Tetris(x: TETRIS_COLS / 2  , y: 2, color: 3)
            ],
            //反7
            [
                Tetris(x: TETRIS_COLS / 2 - 1 , y: 0, color: 3),
                Tetris(x: TETRIS_COLS / 2  , y: 0, color: 3),
                Tetris(x: TETRIS_COLS / 2 - 1 , y: 1, color: 3),
                Tetris(x: TETRIS_COLS / 2 - 1 , y: 2, color: 3)
            ],
            //一
            [
                Tetris(x: TETRIS_COLS / 2  , y: 0, color: 4),
                Tetris(x: TETRIS_COLS / 2 - 1 , y: 0, color: 4),
                Tetris(x: TETRIS_COLS / 2 - 2 , y: 0, color: 4),
                Tetris(x: TETRIS_COLS / 2 + 1 , y: 0, color: 4)
            ],
            //l
            [
                Tetris(x: TETRIS_COLS / 2  , y: 0, color: 4),
                Tetris(x: TETRIS_COLS / 2  , y: 1, color: 4),
                Tetris(x: TETRIS_COLS / 2  , y: 2, color: 4),
                Tetris(x: TETRIS_COLS / 2  , y: 3, color: 4)
            ],
            //凸
            [
                Tetris(x: TETRIS_COLS / 2 , y: 0, color: 5),
                Tetris(x: TETRIS_COLS / 2 , y: 1, color: 5),
                Tetris(x: TETRIS_COLS / 2 - 1 , y: 1, color: 5),
                Tetris(x: TETRIS_COLS / 2 + 1 , y: 1, color: 5)
            ],
            //下凸
            [
                Tetris(x: TETRIS_COLS / 2 , y: 1, color: 5),
                Tetris(x: TETRIS_COLS / 2 , y: 0, color: 5),
                Tetris(x: TETRIS_COLS / 2 - 1 , y: 0, color: 5),
                Tetris(x: TETRIS_COLS / 2 + 1 , y: 0, color: 5)
            ]
        ]
        return tempArray
    }()
    
    var image: UIImage?
    
    
    /// 游戏是否在进行中:-1游戏未开始 0进行中 1暂停 2加速下落中
    var gameStart = -1
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        CELL_SIZI = Int(frame.size.width) / TETRIS_COLS
        TETRIS_ROWS = Int(frame.size.height) / CELL_SIZI
        
        self.backgroundColor = UIColor.white
        
        UIGraphicsBeginImageContext(self.bounds.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.white.cgColor)
        
        self.drawCells(rows: TETRIS_ROWS, cols: TETRIS_COLS, length: CELL_SIZI)

        self.image = UIGraphicsGetImageFromCurrentImageContext()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        // 获取绘图上下文
        _ = UIGraphicsGetCurrentContext()
        // 将内存中的image图片绘制在该组件的左上角
        image?.draw(at: CGPoint.zero)
        
    }
    
    func drawCells(rows:Int,cols:Int,length:Int){
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.brown.cgColor)
        context?.setLineWidth(STROKE_WIDTH)
        context?.beginPath()
   
        for i in 0...cols {
            context?.move(to: CGPoint(x: i*length, y: 0))
            context?.addLine(to: CGPoint(x: i*length, y: rows*length))
        }
   
        for j in 0...rows{
            context?.move(to: CGPoint(x: 0, y: j*length))
            context?.addLine(to: CGPoint(x: cols * length, y: j*length))
        }
   
        context?.strokePath()
        context?.closePath()
    }

    /// 绘制一个格子
    func drawBlock() {
        for i in 0..<TETRIS_ROWS {
            for j in 0..<TETRIS_COLS{
                let context = UIGraphicsGetCurrentContext()
                if tetris_status[i][j] != NO_BLOCK{
                    context?.setFillColor(colors[tetris_status[i][j]])
                }else{
                    context?.setFillColor(UIColor.white.cgColor)
                }
                context?.fill(CGRect(x: CGFloat(j * CELL_SIZI) + STROKE_WIDTH,
                                        y: CGFloat(i * CELL_SIZI) + STROKE_WIDTH,
                                        width: CGFloat(CELL_SIZI) - STROKE_WIDTH * 2,
                                        height: CGFloat(CELL_SIZI) - STROKE_WIDTH * 2))
            }
        }
    }
    
    /// 判断一行是否满啦
    func isLineFull() {
        for i in 0..<TETRIS_ROWS {
            var flag = true
            for j in 0..<TETRIS_COLS{
                if tetris_status[i][j] == NO_BLOCK{
                    flag = false
                    break
                }
            }
            if flag {
                curScore += 1
                if self.scoreCallBack != nil{
                    self.scoreCallBack!(curScore)
                }
                if curScore/200 >= curLevel{
                    curLevel = curScore/200
                    self.currentTimer?.invalidate()
                    self.currentTimer = Timer.scheduledTimer(timeInterval: BASE_SPEED/Double(curLevel), target: self, selector: #selector(moveDown), userInfo: nil, repeats: true)
                    
                    if self.levelCallBack != nil{
                        self.levelCallBack!(curLevel)
                    }
                }
                for m in (1...i).reversed(){
                    if m > 0{
                        for k in 0..<TETRIS_COLS{
                            tetris_status[m][k] = tetris_status[m-1][k]
                        }
                    }
                }
                
            }else{
                
            }
        }
        
        
    }
    
    @objc func moveDown() {
        if self.gameStart == -1 || self.gameStart == 1 {
            return
        }
        var canDown = true
        
        for i in 0..<currentTetris.count {
            if currentTetris[i].y! >= TETRIS_ROWS - 1{
                canDown = false
                break
            }
            if tetris_status[currentTetris[i].y! + 1][currentTetris[i].x!] != NO_BLOCK{
                canDown = false
                break
            }
        }
        
        if canDown {
            self.drawBlock()
            
            for i in 0..<currentTetris.count{
                let cur = currentTetris[i]
                let context = UIGraphicsGetCurrentContext()
                context?.setFillColor(UIColor.white.cgColor)
                context?.fill(CGRect(x: CGFloat(cur.x! * CELL_SIZI) + STROKE_WIDTH,
                                       y: CGFloat(cur.y! * CELL_SIZI) + STROKE_WIDTH,
                                       width: CGFloat(CELL_SIZI) - STROKE_WIDTH * 2,
                                       height: CGFloat(CELL_SIZI) - STROKE_WIDTH * 2))
            }
            
            for i in 0..<currentTetris.count{
                currentTetris[i].y! += 1
            }
            
            for i in 0..<currentTetris.count{
                let cur = currentTetris[i]
                let context = UIGraphicsGetCurrentContext()
                context?.setFillColor(colors[cur.color!])
                context?.fill(CGRect(x: CGFloat(cur.x! * CELL_SIZI) + STROKE_WIDTH,
                                       y: CGFloat(cur.y! * CELL_SIZI) + STROKE_WIDTH,
                                       width: CGFloat(CELL_SIZI) - STROKE_WIDTH * 2,
                                       height: CGFloat(CELL_SIZI) - STROKE_WIDTH * 2))
            }
        }else{
            for i in 0..<currentTetris.count{
                let cur = currentTetris[i]
                if cur.y! < 2 {
                    currentTimer?.invalidate()
                    self.gameStart = -1
                    
                    if self.gameOverCallBack != nil{
                        self.gameOverCallBack!()
                    }
                    
//                    print("Game Over!")
                }
                tetris_status[cur.y!][cur.x!] = cur.color!
            }
            self.isLineFull()
            if self.gameStart == 2{
                self.currentTimer?.invalidate()
                self.gameStart = 0
            }
            self.currentTetris = self.initBlock()
        }
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        self.setNeedsDisplay()
    }
    
    @objc func moveRight(){
        if self.gameStart != 0 {
            return
        }
        var canRight = true
        
        for i in 0..<currentTetris.count {
            if currentTetris[i].x! >= TETRIS_COLS - 1 {
                canRight = false
                break
            }
            if tetris_status[currentTetris[i].y!][currentTetris[i].x! + 1] != NO_BLOCK{
                canRight = false
                break
            }
        }
        
        if canRight {
            self.drawBlock()
            for i in 0..<currentTetris.count{
                let cur = currentTetris[i]
                let context = UIGraphicsGetCurrentContext()
                context?.setFillColor(UIColor.white.cgColor)
                context?.fill(CGRect(x: CGFloat(cur.x! * CELL_SIZI) + STROKE_WIDTH,
                                     y: CGFloat(cur.y! * CELL_SIZI) + STROKE_WIDTH,
                                     width: CGFloat(CELL_SIZI) - STROKE_WIDTH * 2,
                                     height: CGFloat(CELL_SIZI) - STROKE_WIDTH * 2))
            }
            for i in 0..<currentTetris.count{
                currentTetris[i].x! += 1
            }
            for i in 0..<currentTetris.count{
                let cur = currentTetris[i]
                let context = UIGraphicsGetCurrentContext()
                context?.setFillColor(colors[cur.color!])
                context?.fill(CGRect(x: CGFloat(cur.x! * CELL_SIZI) + STROKE_WIDTH,
                                     y: CGFloat(cur.y! * CELL_SIZI) + STROKE_WIDTH,
                                     width: CGFloat(CELL_SIZI) - STROKE_WIDTH * 2,
                                     height: CGFloat(CELL_SIZI) - STROKE_WIDTH * 2))
            }
            
            self.image = UIGraphicsGetImageFromCurrentImageContext()
            
            self.setNeedsDisplay()
        }
    }
    
    @objc func moveLeft(){
        if self.gameStart != 0 {
            return
        }
        var canLeft = true
        
        for i in 0..<currentTetris.count {
            if currentTetris[i].x! <= 0 {
                canLeft = false
                break
            }
            if tetris_status[currentTetris[i].y!][currentTetris[i].x! - 1] != NO_BLOCK{
                canLeft = false
                break
            }
        }
        
        if canLeft {
            self.drawBlock()
            for i in 0..<currentTetris.count{
                let cur = currentTetris[i]
                let context = UIGraphicsGetCurrentContext()
                context?.setFillColor(UIColor.white.cgColor)
                context?.fill(CGRect(x: CGFloat(cur.x! * CELL_SIZI) + STROKE_WIDTH,
                                     y: CGFloat(cur.y! * CELL_SIZI) + STROKE_WIDTH,
                                     width: CGFloat(CELL_SIZI) - STROKE_WIDTH * 2,
                                     height: CGFloat(CELL_SIZI) - STROKE_WIDTH * 2))
            }
            for i in 0..<currentTetris.count{
                currentTetris[i].x! -= 1
            }
            for i in 0..<currentTetris.count{
                let cur = currentTetris[i]
                let context = UIGraphicsGetCurrentContext()
                context?.setFillColor(colors[cur.color!])
                context?.fill(CGRect(x: CGFloat(cur.x! * CELL_SIZI) + STROKE_WIDTH,
                                     y: CGFloat(cur.y! * CELL_SIZI) + STROKE_WIDTH,
                                     width: CGFloat(CELL_SIZI) - STROKE_WIDTH * 2,
                                     height: CGFloat(CELL_SIZI) - STROKE_WIDTH * 2))
            }
            
            self.image = UIGraphicsGetImageFromCurrentImageContext()
            
            self.setNeedsDisplay()
        }
    }
    
    @objc func rotateBlock(){
        if self.gameStart != 0 {
            return
        }
        var canRotate = true
        
        for i in 0..<currentTetris.count {
            let preX = currentTetris[i].x
            let preY = currentTetris[i].y
            
            if i != 2{
                let afterRotateX = currentTetris[2].x! + preY! - currentTetris[2].y!
                let afterRotateY = currentTetris[2].y! + currentTetris[2].x! - preX!
                
                if afterRotateX < 0 || afterRotateX > TETRIS_COLS - 1 || afterRotateY < 0 || afterRotateY > TETRIS_COLS - 1 || tetris_status[afterRotateX][afterRotateY] != NO_BLOCK {
                    canRotate = false
                    break
                }
            }
        }
        
        if canRotate {
            for i in 0..<currentTetris.count {
                let cur = currentTetris[i]
                let context = UIGraphicsGetCurrentContext()
                context?.setFillColor(UIColor.white.cgColor)
                context?.fill(CGRect(x: CGFloat(cur.x! * CELL_SIZI) + STROKE_WIDTH,
                                     y: CGFloat(cur.y! * CELL_SIZI) + STROKE_WIDTH,
                                     width: CGFloat(CELL_SIZI) - STROKE_WIDTH * 2,
                                     height: CGFloat(CELL_SIZI) - STROKE_WIDTH * 2))
            }
            
            for i in 0..<currentTetris.count {
                let preX = currentTetris[i].x
                let preY = currentTetris[i].y
                
                if i != 2{
                    currentTetris[i].x = currentTetris[2].x! + preY! - currentTetris[2].y!
                    currentTetris[i].y = currentTetris[2].y! + currentTetris[2].x! - preX!
                }
            }
            
            for i in 0..<currentTetris.count {
                let cur = currentTetris[i]
                let context = UIGraphicsGetCurrentContext()
                context?.setFillColor(colors[cur.color!])
                context?.fill(CGRect(x: CGFloat(cur.x! * CELL_SIZI) + STROKE_WIDTH,
                                     y: CGFloat(cur.y! * CELL_SIZI) + STROKE_WIDTH,
                                     width: CGFloat(CELL_SIZI) - STROKE_WIDTH * 2,
                                     height: CGFloat(CELL_SIZI) - STROKE_WIDTH * 2))
            }
            
            image = UIGraphicsGetImageFromCurrentImageContext()
            
            self.setNeedsDisplay()
        }
    }
    
    /// 初始化一个方块
    func initBlock()-> Array<Tetris> {
        let ranMax:UInt32 = UInt32(self.tetrisArray.count)
        let randomRoll = arc4random_uniform(ranMax)
        
        let tempArray = self.tetrisArray[Int(randomRoll)]
        
        return tempArray
    }
    
    func initTetrisStats() {
        let tmpRow = Array(repeating: NO_BLOCK, count: TETRIS_COLS)
        tetris_status = Array(repeating: tmpRow, count: TETRIS_ROWS)
    }
    
    func startGame() {
        if self.gameStart == -1 {
            self.initTetrisStats()
            
            self.currentTetris = self.initBlock()
            
            self.gameStart = 0
            currentTimer = nil
            self.currentTimer?.invalidate()
            
            currentTimer = Timer.scheduledTimer(timeInterval: BASE_SPEED/Double(curLevel), target: self, selector: #selector(moveDown), userInfo: nil, repeats: true)
            
            currentTimer?.fire()
        }else{
            self.pauseGame()
        }
    }
    
    func pauseGame() {
        if self.gameStart == 0 {
            self.currentTimer?.invalidate()
            self.gameStart = 1
        }else if self.gameStart == 1{
            self.currentTimer = Timer.scheduledTimer(timeInterval: BASE_SPEED/Double(curLevel), target: self, selector: #selector(moveDown), userInfo: nil, repeats: true)
            self.gameStart = 0
        }
        
        
    }
    
    func AccelerateMoveDown() {
        if self.gameStart == 0 {
            self.gameStart = 2
            self.currentTimer = Timer.scheduledTimer(timeInterval: BASE_SPEED/100, target: self, selector: #selector(moveDown), userInfo: nil, repeats: true)
        }
    }
    
}
