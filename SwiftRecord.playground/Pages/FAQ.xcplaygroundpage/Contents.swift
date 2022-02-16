import UIKit


//:  **问题一： 如何创建随机值数组**
/*
 1. 找随机数值
 2. 将随机数字添加到数组中
 */

// 创建5个随机值, 由于不使用入参，需要忽略掉入参
let rands = (0..<5).map{_ in Int.random(in: 0..<100)}


rands


//: **问题二： 怎么搞到n个字符构成的字符串或者字符**
let a = [Int](1...10)

//:问题三： **Self 和 self 的区别**


//: ---

//: ## 问题四： 下划线的使用

//: ### 用法1： 方法名中省略参数标签
// func getMinMax(a:int, b:int)   a, b 作为参数标签使用，可以提高可读性

func getMinValue(a:Int, b:Int) -> Int{
    return min(a, b)
}

/*: 通过使用这个可以发现，在使用时，需要将,a，b在方法中写入名称
 
 如：`let minv = getMinValue(a: <#T##Int#>, b: <#T##Int#>)`
 */
let minV = getMinValue(a: 10, b: 30)

/*:
但是写多了就会发现，我们都清楚的知道a,b分别代表两个参数，再这样写就很浪费时间。

这个时候就可以使用"_"来简写, 在参数标签前面写就相当于可以省略参数标签
*/

func getMinValue1(_ a:Int, _ b:Int) -> Int {
    return min(a, b)
}


let minV1 = getMinValue1(20, 40)

/*:
这个时候，使用函数就可以发现，函数占位变成了这样, a，b也可以被占位替换

`let minV1 = getMinValue1(<#T##a: Int##Int#>, <#T##b: Int##Int#>)`
*/


//: [后续补充参考](https://zhuanlan.zhihu.com/p/153279991)


//: ---


//: ## 问题五： 尾闭包与入参的区别

// 示例：

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

let arra = [1,2,2,2,3,4,5,5]

// 以下为两种写法：
// 第一种是通过将函数入参
// 第二种是通过闭包， 只是简写了入参 返回值

let parts = arra.split(where: !=)
let parts1 = arra.split {$0 != $1}

parts
parts1

//: ---

//: ## 问题六：何时使用Element 何时使用<T>







//: ---

//: ## 问题七：使用Result处理任务


//: ---
//: ## 怎么输出需要的字母片段
//let letter = (lowercaseLetters)
//print(letter)


//: [参考地址](https://www.jianshu.com/p/df507e16e9c4)


//: ---

//: ## 问题八：case使用？ 下面的例子，在Optional篇中
let j = 5
if case 0..<10 = j {
    //    print("\(j)在范围内")       // 5在范围内
}

//: ---
