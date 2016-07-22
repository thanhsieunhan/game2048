//
//  ViewController.swift
//  game2048
//
//  Created by le ha thanh on 7/18/16.
//  Copyright © 2016 le ha thanh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var b = Array(count: 4, repeatedValue: Array(count: 4, repeatedValue: 0))
    
    @IBOutlet weak var score: UILabel!
    var lose = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let directions: [UISwipeGestureRecognizerDirection] = [.Right, .Left, .Up, .Down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: Selector("respondToSwipeGesture:"))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
        randomNum(-1)
    }
    func randomNum(type: Int)
    {
        if(!lose)
        {
            switch(type)
            {
            case 0 : left()
            case 1 : right()
            case 2 : up()
            case 3 : down()
            default : break
            }
        }
        // 2 func checkRandom và checkLose các bạn tự viết
        // 1) func checkRandom check xem còn vị trí để random hay không tránh trường hợp bị vong lặp vô tận
        
        // 2) func checkLose kiểm tra xem đã thua hay chưa nếu thua thì cho hiện lên một hộp thoại
        
        
        if (checkRandom())
        {
            var rnlableX  = arc4random_uniform(4)
            var rnlableY = arc4random_uniform(4)
            let rdNum = arc4random_uniform(2) == 0 ? 2 : 4
            while (b[Int(rnlableX)][Int(rnlableY)] != 0)
            {
                rnlableX = arc4random_uniform(4)
                rnlableY = arc4random_uniform(4)
            }
            b[Int(rnlableX)][Int(rnlableY)] = rdNum
            let numlabel = 100 + (Int(rnlableX) * 4) + Int(rnlableY)
            ConvertNumLabel(numlabel, value: String(rdNum))
            transfer()
        }
        else if (checkLose())
        {
            lose = true
            let alert = UIAlertController(title: "Game Over", message: "You Lose", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    func changeBackColor(numlabel: Int, color: UIColor)
    {
        let label = self.view.viewWithTag(numlabel) as! UILabel
        label.backgroundColor = color
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Left:
                randomNum(0)
            case UISwipeGestureRecognizerDirection.Right:
                randomNum(1)
            case UISwipeGestureRecognizerDirection.Up:
                randomNum(2)
            case UISwipeGestureRecognizerDirection.Down:
                randomNum(3)
            default:
                break
            }
        }
    }
    func transfer()
    {
        for (var i = 0; i < 4; i++)
        {
            for (var j = 0; j < 4; j++)
            {
                let numlabel = 100 + (i * 4) + j;
                ConvertNumLabel(numlabel, value: String(b[i][j]));
                switch(b[i][j])
                {
                case 2,4:changeBackColor(numlabel, color: UIColor.cyanColor())
                case 8,16:changeBackColor(numlabel, color: UIColor.greenColor())
                case 16,32:changeBackColor(numlabel, color: UIColor.orangeColor())
                case 64:changeBackColor(numlabel, color: UIColor.redColor())
                case 128,256,512:changeBackColor(numlabel, color: UIColor.yellowColor())
                case 1024,2048:changeBackColor(numlabel, color: UIColor.purpleColor())
                default: changeBackColor(numlabel, color: UIColor.brownColor())
                }
            }
        }
    }
    func ConvertNumLabel(numlabel: Int, let value: String)
    {
        let label = self.view.viewWithTag(numlabel) as! UILabel
        label.text = value
    }
    

    
    func up(){
        for (var col = 0; col < 4; col += 1){
            var check = false
            for (var row = 1; row < 4; row += 1){
                var tx = row
                if (b[row][col] == 0){
                    continue
                }
                for (var rowc = row - 1; rowc != -1; rowc--){
                    if (b[rowc][col] != 0 && (b[rowc][col] != b[row][col] || check)){
                        break
                    }
                    else
                    {
                        tx = rowc
                    }
                }
                if (tx == row){
                    continue
                }
                if (b[row][col] == b[tx][col]){
                    check = true
                    GetScore(b[tx][col])
                    b[tx][col] *= 2
                }
                else
                {
                    b[tx][col] = b[row][col]
                }
                b[row][col] = 0;
            }
        }
    }
    func down()
    {
        for (var col = 0; col < 4;col += 1 )
        {
            var check = false
            for (var row = 0; row < 4; row += 1)
            {
                var tx = row
                
                if (b[row][col] == 0)
                {
                    continue
                }
                for (var rowc = row + 1; rowc < 4; rowc++)
                {
                    if (b[rowc][col] != 0 && (b[rowc][col] != b[row][col] || check))
                    {
                        break;
                    }
                    else
                    {
                        tx = rowc
                    }
                }
                if (tx == row)
                {
                    continue
                }
                if (b[tx][col] == b[row][col])
                {
                    check = true
                    GetScore(b[tx][col])
                    b[tx][col] *= 2
                    
                }
                else
                {
                    b[tx][col] = b[row][col]
                }
                b[row][col] = 0;
            }
        }
    }
    func left()
    {
        for(var row = 0; row < 4; row++)
        {
            var check = false
            for (var col = 1; col < 4; col++)
            {
                if (b[row][col] == 0)
                {
                    continue
                }
                var ty = col
                for (var colc = col - 1; colc != -1; colc--)
                {
                    if (b[row][colc] != 0 && (b[row][colc] != b[row][col] || check))
                    {
                        break
                    }
                    else
                    {
                        ty = colc
                    }
                }
                if (ty == col)
                {
                    continue;
                }
                if (b[row][ty] == b[row][col])
                {
                    check = true
                    GetScore(b[row][ty])
                    b[row][ty] *= 2
                    
                }
                else
                {
                    b[row][ty]=b[row][col]
                }
                b[row][col] = 0
                
            }
        }
    }
    func right() {
        for(var row = 0; row < 4; row++){
            var check = false
            for (var col = 3; col != -1; col--){
                if (b[row][col] == 0){
                    continue
                }
                var ty = col
                for (var colc = col + 1; colc < 4; colc++){
                    if (b[row][colc] != 0 && (b[col][colc] != b[row][col] || check))
                    {
                        break
                    }
                    else
                    {
                        ty = colc
                    }
                }
                if (ty == col)
                {
                    continue;
                }
                if (b[row][ty] == b[row][col])
                {
                    check = true
                    GetScore(b[row][ty])
                    b[row][ty] *= 2
                    
                }
                else
                {
                    b[row][ty] = b[row][col]
                }
                b[row][col] = 0
                
            }
        }
    }
    func GetScore(value: Int)
    {
        score.text = String(Int(score.text!)! + value)
    }
    
    func checkRandom() -> Bool{
        for i in 0 ..< 4 {
            for j in 0 ..< 4 {
                if b[i][j] == 0 {
                    return true
                }
            }
        }
        return false
    }
    
    func checkLose() -> Bool{
        
        
        if !(b[0][0] != b[0][1] && b[0][0] != b[1][0]) { return false }
        
        if !(b[0][3] != b[1][3] && b[0][3] != b[0][2])  { return false }
        
        if !(b[3][0] != b[2][0] && b[3][0] != b[3][1])  { return false }
        
        if !(b[3][3] != b[3][2] && b[3][3] != b[2][3])  { return false }
        
        for i in 1..<3 {
            if !((b[i][0] != b[i-1][0]) &&  (b[i][0] != b[i][1])    && (b[i][0] != b[i+1][0])) { return false }
            if !((b[0][i] != b[0][i-1]) &&  (b[0][i] != b[1][i])    && (b[0][i] != b[0][i+1])) { return false }
            if !((b[i][3] != b[i][2])   &&  (b[i][3] != b[i-1][3])  && (b[i][3] != b[i+1][3])) { return false }
            if !((b[3][i] != b[2][i])   &&  (b[3][i] != b[3][i-1])  && (b[3][i] != b[3][i+1])) { return false }
        }
        
        for i in 1..<3 {
            for j in 1..<3 {
                if !(   (b[i][j] != b[i][j+1]) && (b[i][j] != b[i][j-1]) &&
                        (b[i][j] != b[i+1][j]) && (b[i][j] != b[i-1][j])
                    ) {
                    return false
                }
            }
        }
        return true
    }
    
}

