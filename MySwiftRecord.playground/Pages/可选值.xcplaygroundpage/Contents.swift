//: [Previous](@previous)

import Foundation

//: ---
//: ### 哨岗值

// 函数返回一个“魔法”数来标识其并没有返回真实的值。 这样的值被称为“哨岗值(sentinel values)”

//类似： EOF

//: ---
//: ### 使用枚举解决魔法数问题

//: **swift 目标就是消除哨岗值带来的问题，来提高编译器自动检查的保证性，同时降低无用代码的运行**


enum Optional<Wrapped> {
    case none
    case some(Wrapped)
}


extension Collection where Element: Equatable {
    func firstIndex1(of element:Element) -> Optional<Index> {
        var idx = startIndex
        while idx != endIndex {
            if self[idx] == element {
                return .some(idx)
            }
            formIndex(after: &idx)
        }
        // 没有找到
        return .none
    }
}

var array = ["One", "two", "three"]

let idx = array.firstIndex1(of: "four")

// 使用了这种方式后，用户就不会在没有检查的情况下，错误的使用给一个值了
//array.remove(at: idx)

switch array.firstIndex1(of: "two") {
case .some(let idx):
    array.remove(at: idx)
case .none:
    break
}


// 使用上面的操作 提取关联值非常安全，但是读写起来都不是很顺畅，还是太繁琐了，需要简化下， 使用“?” 作为再switch中对song进行匹配是的模式后缀，另外还可以使用nil字面量来匹配none:


//: [Next](@next)
