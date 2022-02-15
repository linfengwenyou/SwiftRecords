//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: 对比数组优点： 查找花费时间是常数级，数组花费时间与数组尺寸成正比

//: 对比数组缺点： 数组有序，字段无序


//: 字典总是返回可选值，当指定键不存在时，返回nil; 数组使用越界下标进行访问将导致程序崩溃

enum Setting {
    case text(String)
    case int(Int)
    case bool(Bool)
}


let defaultSetting:[String : Setting] = [
    "Airplance Mode" : .bool(false),
    "Name" : .text("My iPhone")
]

defaultSetting["Name"]

//defaultSetting["Name"] = .text("新机器")     // 会报错，因为对不可变字典进行了操作

// 如果想修改字典，需要通过var获取一个可变字典

var userSettings = defaultSetting

userSettings["Name"] = .text("测试机")

// 或者，更新名字，返回之前的旧名
let oldName = userSettings.updateValue(.text("Jane's iPhone"), forKey:"Name")

oldName

userSettings["Name"]


userSettings

//: ---
//: ### 字典的合并

//: 目标： 合并两个字典， 有值的覆盖默认的key对应的value

var settings = defaultSetting

let overrrideSettings: [String: Setting] = ["Name": .text("Jane's iPhone")]

// merge 方法，规定了相同Key使用前面还是后面来覆写
// 注意： 如果使用 $1 可以， $0 不行，原因是使用$1, 默认存在$0，有两个参数，使用 $0 不知道几个参数
settings.merge(overrrideSettings, uniquingKeysWith: {a,_ in
    a
})

settings


//: ---
//: ### 创建字典

extension Sequence where Element : Hashable {
    var frequencies: [Element:Int] {
        let frenquencyPairs = self.map{($0,1)}
        print(frenquencyPairs)  // [("H", 1), ("e", 1), ("l", 1), ("l", 1), ("o", 1), (" ", 1), ("w", 1), ("o", 1), ("r", 1), ("l", 1), ("d", 1)]
        // 构建一个字典， 将序列拼接， 发现key相同时，将value相加
        return Dictionary(frenquencyPairs, uniquingKeysWith: +)
    }
}

let frequencies = "Hello world".frequencies

frequencies.filter{$0.value > 1}


let seq1 = [("H", 1), ("e", 1), ("l", 3),  ("o", 4)]

// 反转Key-value
let seq2 = seq1.map{($1,$0)}

print(seq2)



//: ---
//: ### 对字典的值做映射
let settingsAsStrings = settings.mapValues { setting -> String in
    switch setting {
    case .text(let text): return text
    case .int(let num): return String(num)
    case .bool(let value): return String(value)
    }
}

settingsAsStrings




//: [Next](@next)
