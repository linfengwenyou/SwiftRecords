//: [Previous](@previous)

import Foundation

//: ## 目标： 实现脚本方式进行操作
//: ### 1. 读取命令行入参
//: ### 2. 命令行运行方式

//: ## 操作方式一，使用XCode工程方式
//: ### 1. 新建一个MAC OS 命令行包
//: ### 2. 导入头文件，支持读取命令行参数
import Cocoa

let argc = CommandLine.argc // 返回命令行入参个数，注意文件名是第一个参数
le argvs = CommandLine.arguments // 返回参数数组

//: ## 操作方式二，独立存在
//: ### 1. 将文件移出工程独立存在
//: ### 2. 添加运行命令， 注意要放到第一行才行
//: #!/usr/bin/env xcrun swift
//: ### 3. 添加文件执行权限
//: chmod +x QuickCoder.swift
//: ### 执行操作， 入参都是字符串
//: ./QuickCoder.swift b botomButton



//: [Next](@next)
