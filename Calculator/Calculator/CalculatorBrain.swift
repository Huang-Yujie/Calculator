//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 黄宇杰 on 2019/10/3.
//  Copyright © 2019 黄宇杰. All rights reserved.
//

import Foundation

var operation = [String]()//存放拆分后的字符串
var list = [String]()//存放逆波兰表达式
var stack = [String]()//双重作用：转换逆波兰表达式，计算逆波兰表达式
enum error :Error
{
    case expression
    case parenthese
}
class Calculator
{
    enum Operation
    {
        case unaryoperation((Double) -> Double)
        case binaryoperation((Double, Double) -> Double)
    }
    var operations: Dictionary<String, Operation> =
        [
            "+" : .binaryoperation({$0 + $1}),
            "−" : .binaryoperation({$0 - $1}),
            "×" : .binaryoperation({$0 * $1}),
            "÷" : .binaryoperation({$0 / $1}),
            "e" : .binaryoperation({$0 * pow(10, $1)}),
            "^" : .binaryoperation({pow($0, $1)}),
            "%" : .binaryoperation({fmod($0, $1)}),
            "s" : .unaryoperation({sin($0 / 180 * Double.pi)}),
            "c" : .unaryoperation({cos($0 / 180 * Double.pi)}),
            "t" : .unaryoperation({tan($0 / 180 * Double.pi)}),
            "!" : .unaryoperation(
                {
                    var product = 1
                    for i in 1...Int($0)
                    {
                        product *= i
                        
                    }
                    return Double(product)
                }
            )]
    func convert (_ str: String) throws -> String
    {
        let chars = Array (str)//将初始字符串转为字符数组
        var current = ""//创建空字符串
        for item in chars//遍历字符数组
        {
            let itemstr = String (item)//字符转为字符串
            if item.isNumber || itemstr == "."//判断是否为一个数字的一部分
            {
                current.append(item)//补全数字
            }
            else
            {
                operation.append(current)//将数字压入线性表
                current = ""//重置空字符串
                operation.append(itemstr)
            }
        }
        //                for item in operation
        //                {
        //                    print(item)
        //                }
        let priority =//设置优先级
            [
                nil : 0,
                "(" : 0,
                "+" : 1,
                "−" : 1,
                "×" : 2,
                "÷" : 2,
                "%" : 2,
                "e" : 3,
                "^" : 3,
                "s" : 3,
                "c" : 3,
                "t" : 3,
                "!" : 3
        ]
        for item in operation//中缀转后缀
        {
            if let _ = Double(item)
            {
                list.append(item)
            }
            else
            {
                switch item
                {
                case "(" :
                    stack.append(item)
                case ")" :
                    while stack.last != "("
                    {
                        if let _ = stack.last
                        {
                            list.append(stack.popLast()!)
                        }
                        else
                        {
                            throw error.parenthese
                        }
                    }
                    stack.removeLast()
                case "+", "−" :
                    while priority[stack.last]! >= 1
                    {
                        list.append(stack.popLast()!)
                    }
                    stack.append(item)
                case "×", "÷", "%" :
                    while priority[stack.last]! >= 2
                    {
                        list.append(stack.popLast()!)
                    }
                    stack.append(item)
                case "e", "^" :
                    while priority[stack.last]! >= 3
                    {
                        list.append(stack.popLast()!)
                    }
                    stack.append(item)
                case "s", "c", "t", "!" :
                    while priority[stack.last]! > 3
                    {
                        list.append(stack.popLast()!)
                    }
                    stack.append(item)
                default:
                    break
                }
            }
        }
        while let _ = stack.last
        {
            list.append(stack.popLast()!)
        }
        //        for item in list
        //        {
        //            print(item)
        //        }
        for item in list//计算后缀表达式
        {
            if let _ = Double(item)
            {
                stack.append(item)
            }
            else
            {
                var result = ""
                if let _ = operations[item]
                {
                    switch operations[item]!
                    {
                    case .unaryoperation(let operate) :
                        if let _ = stack.last
                        {
                            let operand = Double(stack.popLast()!)!
                            result = String(operate(operand))
                        }
                        else
                        {
                            throw error.expression
                        }
                    case .binaryoperation(let operate):
                        if let _ = stack.last
                        {
                            let operand1 = Double(stack.popLast()!)!
                            if let _ = stack.last
                            {
                                let operand2 = Double(stack.popLast()!)!
                                result = String(operate(operand2, operand1))
                            }
                            else
                            {
                                throw error.expression
                            }
                        }
                        else
                        {
                            throw error.expression
                        }
                    }
                }
                else
                {
                    throw error.parenthese
                }
                stack.append(result)
            }
        }
        return stack.last!
    }
}
