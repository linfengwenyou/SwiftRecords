//: [Previous](@previous)

import Foundation

//: #### Map使用
//: **对数组的每个值进行转换得到一个新的数组**
// Map的基本实现思路， 为了编译安全等因素还需要补充异常处理等机制

extension Array {
    func map1<T>(_ transform:(Element)->T) -> [T] {
        var result:[T] = []
        result.reserveCapacity(count)
        for e in self {
            result.append(transform(e))
        }
        return result
    }
}


let a = [1,5,32,6]

var b = a.map1{$0+5}

//: ---
//: ### split 自定义数组分割方式

//:  **相邻且相等的方式分开**

let arra = [1,2,2,2,3,4,5,5]

// endIndex 是超出有效范围后的下一个索引， 这不就是count? 有区别？
print(arra.endIndex, arra.count)

var result:[[Int]] = arra.isEmpty ? [] : [[arra[0]]]

for (pre, cur) in zip(arra, arra.dropFirst()) {
    if pre == cur {
        result[result.endIndex-1].append(cur)
    } else {
        result.append([cur])
    }
}


extension Array {
    func split(where condition:(Element, Element) -> Bool) -> [[Element]] {
        var result: [[Element]] = self.isEmpty ? [] : [[self[0]]]
        for (pre, cur) in zip(self, self.dropFirst()) {
            if condition(pre,cur) {
                result.append([cur])
            } else {
                result[result.endIndex - 1].append(cur)
            }
        }
        return result
    }
}


let parts = arra.split(where: !=)
parts


extension Array {
    func accumulate<Result>(_ initialResult: Result, _ nextPartialResult:(Result, Element) -> Result) -> [Result] {
        var running = initialResult
        return map1 { next in
            running = nextPartialResult(running, next)
            return running
        }
    }
}


[1,2,3,4,5].accumulate(0, +)

// 此方法会创建一个全新的数组，并且对源数组进行一一匹配， 需要注意要做的任务使用此方法的性能问题
extension Array {
    func fileter(_ isIncluded:(Element) -> Bool) -> [Element] {
        var result:[Element] = []
        for x in self where isIncluded(x) {
            result.append(x)
        }
        return result
    }
}


let numbs = [Int](1...100)

let r = numbs.fileter { x in
    return x % 2 == 0
}

r

//: ---
//: ### reduce
//减少的意思，为啥减少，是做什么用的

// 求和的方案
let fibs = [0,1,1,2,3,5]
var total = 0
for num in fibs {
    total += num
}

total

// reduce就是为了简写这些方案来实现的, 第一参数是初始值

let sum = fibs.reduce(0, +)
let sum1 = fibs.reduce(0) { total , x in
    total + x
}

sum1


// 不止是仅应用到数字上，输出值类型不必和元素类型相同
// 将数字转换为字符串，同时每个字符串后面添加","
let str = fibs.reduce1("") { s, x in
    s + "\(x),"
}

str


// reduce的实现
extension Array {
    func reduce1<Result>(_ initalResult: Result, _ nextPartialResult:(Result, Element) -> Result) -> Result {
        var result = initalResult
        for x in self {
            result = nextPartialResult(result, x)
        }
        return result
    }
}


extension Array {
    func map2<T>(_ transform:(Element) -> T) -> [T] {
        return reduce([]) { result, x in
            result + [transform(x)]
        }
    }
    
    func filter2(_ isIncluded:(Element) -> Bool) -> [Element] {
        return reduce([]) { result, x in
            isIncluded(x) ? result + [x] : result
        }
    }
}

let v = [Int](1..<10)
let v2 = v.map2 { $0 + 5}

let v3 = v.filter2 { $0 % 2 == 0}


//: ---
//: ### flatMap 展平数组

// 通过transform 函数将一个元素映射成数组。 而flatMap1 则是将transform映射出的数组的内容添加到一个大数组中，然后进行返回
extension Array {
    func flatMap1<T>(_ transform: (Element) -> [T]) -> [T] {
        var result:[T] = []
        for x in self {
            result.append(contentsOf: transform(x))
        }
        return result
    }
}


let x = [[1,2,3],[34,3,2,34],[5,3,2,1,3]]

// 入参是一个元素，将其返回为数组，然后拼接成最终的一个数组来处理
let x1 = x.flatMap1 {
    return $0.map1{"\($0)"}
}
x1


/* 高阶函数的解读方式:
 * 从最外层一层一层往里面看， 看闭包的入参和返回类型， 了解函数的描述
 *
 * 上述示例：
 *  1. flatMap1是将数组中的元素转换为一个数组， 直接使用$0,是因为$0本身就是一个数组
 *  2. 对$0，进行映射，返回的也是一个数组，只是我们将整型数组变成了字符串数组
 */


let suits = ["♠︎", "♥︎", "♣︎", "♦︎"]
let ranks = ["J","Q","K","A"]

let res1 = suits.flatMap1 { suit in
    ranks.map1 {
        (suit,$0)
    }
}
res1
print(res1)


//: ---
//: ### forEach

for element in [1,2,3] {
    print(element)
}
print("----")
[1,2,3].forEach { element in
    print(element)
}

// forEach内部不能使用return进行返回，因为返回的仅仅只是闭包,并不能让外部函数本身返回
//extension Array where Element: Equatable {
//    func firstIndex_foreach(of element:Element) -> Int? {
//        self.indices.filter { idx in
//            self[idx] == element
//        }.forEach { idx in
//            return idx
//        }
//        return nil
//    }
//}

// 如下效果，return语句并不会终止循环，它做的仅仅是从闭包中返回，因此再forEach的实现中会开始下一个循环的迭代
(1..<10).forEach { num in
    print(num)
    if num > 2 {
        return
    }
}

//: ---
//: ### 数组切片

//: 优点 切片类型只是数组的一种标识方式，它背后的数据仍然是原来的数组，只不过是用切片的方式来进行表示
//: 特性： 创建切片代价小   因为数组的元素不会被复制
fibs
let slice = fibs[1...]
slice       // 数组的一个切片，其中包含了从源数组第二个元素开始的所有部分

type(of: slice) // ArraySlice<Int>.Type

// ArraySlice 和 Array都满足了相同的协议，所以两者具有的方法是一致的，可以把它当做数组来处理，如果想转换成数组可以通过
let newArr = Array(slice)


//:*需要注意点*  切片和它背后的数组是使用相同的索引来引用元素的。因此切片的索引不需要从0开始，比如上述，我们slice第一个元素索引是1
//let slice = fibs[1...]    // 索引是从1开始的
slice[0]        // 会报错，因为超出索引了

//:*所以当操作切片时，最好是基于 startIndex和endIndex属性做索引计算，防止出问题*

//: [Next](@next)

