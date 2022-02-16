//: [Previous](@previous)

import Foundation

let iPods:Set = ["iPod touch", "iPod nano", "iPod mini", "iPod shuffle", "iPod Clasic"]

let discontinuedIpods:Set = ["iPod mini", "iPod Classic", "iPod nano", "iPod shuffle"]


// 减法处理
let currentIpods = iPods.subtracting(discontinuedIpods)

// 交集处理
let iPodsWithTouch = iPods.intersection(discontinuedIpods)

// 并集处理， 注意并集是并入到当前的集合中，会改变原有集合，所以需要使用 var来声明
var totalTouch:Set = ["iBooks"]

totalTouch.formUnion(discontinuedIpods)

print(totalTouch)

//: ---
//: ### 索引集合 & 字符集合

// 一个由正整数组成的集合。对比Set<Int>更高效，因为它内部使用了一组范围列表进行实现。大哥比方存1000个元素的数据，使用Set<Int>需要1000个
// 而如果使用IndexSet, 里面其实值存储了选择的首位和末尾两个证书值 ？？？ 需要理解， 直接运行代码看效果图可以发现
IndexSet()

var indices = IndexSet()
indices.insert(integersIn: 1..<8)
indices.insert(integersIn: 11..<15)

let eventIndices = indices.filter{$0 % 2 == 0}

eventIndices

// 同样也是一个高效的集合，用来存储Unicode编码点(code point)的集合。它经常被用来检查一个特定字符串是否只包含某个字符子集
// 需要注意Objctive-C中的CharacerSet的区别点
CharacterSet()


//: ---
//: ### 闭包使用集合的方式

// 找出序列中的唯一元素，并且保证其顺序; 注意  并不是seen保证了顺序，而是filter返回了一个有序数组， seen只是保证了唯一性
extension Sequence where Element: Hashable {
    func unique() -> [Element] {
        var seen: Set<Element> = []     // 外部变量seen,可以在闭包里访问和修改它的值
        return filter { element in
            if seen.contains(element) {
                return false
            } else {
                seen.insert(element)
                return true
            }
        }
    }
}

let a1 = [100,1,2,3,4,23,34,23,12,23,21,2,3,21,1,2].unique()

type(of: a1)

print(a1)



//: [Next](@next)
