//: [Previous](@previous)

import Foundation

/*:
 * 范围达标的是两个值的区间，它由上下边界进行定义.
 * 可以通过 ..< 创建 【） 这种区间
 * ... 创建 []
 
 */


let v = 0..<10

Array(v)

let lowercaseLetters = Character("a")...Character("z")

// 空间隔的标识：
//上下界相等的情况 只有半开范围能表达  5..<5

// 只有闭合范围能包括其元素类型所能表达的最大值   0...Int.max



//: ---
//: ### 可数范围

//范围看起来很自然的会是一个序列或者集合类型，并且确实可以遍历一个证书范围
for i in 0..<10 {
    print(i)
}

// 但是并不是所有范围都可以使用这种方式，编译器不允许我们遍历一个Character的范围， 以下会直接报错
//for c in lowercaseLetters {
//    print(c)
//}


// 想支持可数 需要遵循 Strideable协议 ： 可以通过增加偏移来从一个元素移动到另一个，并且步长(stride step)是整数

//: **总结：为了能遍历范围，它必须是可数的**



// 注意： 这不仅仅是为了兼容性，它还是有用的简写
public typealias CountableRange<Bound:Strideable> = Range<Bound> where Bound.Stride:SignedInteger


//: ---
//: ### 范围表达式

let arr = [1,2,3,4]

// 当首尾有缺失时，会进行补充
arr[2...] // [3,4]
arr[..<1] // [1]
arr[1...2] // [2,3]

arr[...] // [1,2,3,4]
type(of: arr)

//: [Next](@next)
