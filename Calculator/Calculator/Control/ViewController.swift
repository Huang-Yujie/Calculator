//
//  ViewController.swift
//  Calculator
//
//  Created by 黄宇杰 on 2019/10/2.
//  Copyright © 2019 黄宇杰. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    
    var calculator = Calculator()//创建一个类实例
    var userIsTyping = false//全局变量，用以指示是否为第一次输入字符
    var answer = "0"
    
    override func viewDidLoad() {
        for view in self.view.subviews {
            if view.isKind(of: UIButton.self) {
                view.layer.cornerRadius = view.frame.size.width/2
            }
        }
    }
    
    @IBOutlet weak var display: UILabel!
    @IBAction func backSpace(_ sender: UIButton)
    {
        display.text!.removeLast()//回退一个字符
        if display.text!.isEmpty//如果只剩一个字符，回退后将Label设为0
        {
            display.text = "0"
            userIsTyping = false//重新将状态修改为未输入
        }
    }
    @IBAction func callAnswer(_ sender: UIButton)
    {
        if answer != "0"
        {
            if userIsTyping
            {
                display.text?.append(answer)
            }
            else
            {
                userIsTyping = true
                display.text = answer
            }
        }
    }
    @IBAction func AC(_ sender: UIButton)//AC清除一切已修改内容
    {
        userIsTyping = false
        display.text = "0"
        operation = [String]()
        list = [String]()
        stack = [String]()
    }
    @IBAction func touchButton(_ sender: UIButton)
    {
//        sender.layer.cornerRadius = sender.bounds.size.width/2
//        sender.clipsToBounds = true
        let char = sender.currentTitle!
        if userIsTyping || char == "."//若在输入小数点，或者并非输入第一个字符，则将该字符置于当前文本之后
        {
            display.text! += char
            if char == "."//若在输入小数点，将状态修改为正在输入字符
            {
                userIsTyping = true
            }
        }
        else
        {
            display.text = char//输入第一个字符时，将0替换掉
            if char != "=" && char != "0"//避免用户输入等于号或着重复输入0字符时修改状态
            {
                userIsTyping = true
            }
        }
        if char == "="//输入终止
        {
            if display.text! == "="//若用户还未输入便按下等于号
            {
                display.text! = "0"//忽略此次操作
            }
            else
            {
                do
                {
                    try display.text = calculator.convert(display.text!)//调用计算函数
                }
                catch error.expression
                {
                    display.text = "Expression Error"
                }
                catch error.parenthese
                {
                    display.text = "Parenthese Error"
                }
                catch {}
                userIsTyping = false//将一切已输入状态重置，等待下一次计算
                answer = display.text!//存储计算结果
                operation = [String]()
                list = [String]()
                stack = [String]()
            }
        }
    }
}



