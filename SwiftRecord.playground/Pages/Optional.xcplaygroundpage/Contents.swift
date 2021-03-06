//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport

//: ---
//: ### 哨岗值

// 函数返回一个“魔法”数来标识其并没有返回真实的值。 这样的值被称为“哨岗值(sentinel values)”

// 啥是魔术： 这个数值既可能是正常值，也可能是nil，-1等标识异常的值

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


//: 使用上面的操作 提取关联值非常安全，但是读写起来都不是很顺畅，还是太繁琐了。

//:需要简化下， **使用 "?" 作为在switch中对some进行匹配是的模式后缀，另外还可以使用nil字面量来匹配none:**

// 已失效
//switch array.firstIndex1(of: "two") {
//case let idx?:
//    array.remove(at: idx)
//case nil:
//    break
//}

//: ---
//: ### 可选值概览
//: #### **if let**

/*: 使用 if let 来进行可选值绑定(Optional binding)要比上面使用switch语句要稍好些。if let语句会检查可选值是否为nil,

 如果不是nil，便会解包可选值。idx的类型就是Int(而不再是可选值)，并且idx也只在这个if let语句的作用域中有效
*/

var array1 = ["one","two","three","four"]
if let idx1 = array1.firstIndex(of: "four") {   // 不用firstIndex1 与系统定义Optional不一致
    array1.remove(at: idx1)
}

array1
// 如果查到位置是数组的第一个元素就不删除它
if let idx = array1.firstIndex(of: "three"), idx != array1.startIndex {
    array1.remove(at: idx)
}
array1

//: **优点**
//: 可以在同一个if语句中绑定多个值，更赞的是
//:**在后面的绑定中可以使用之前成功解包出来的结果**

let urlString = "https://www.objc.io/logo.png"
if let url = URL.init(string: urlString),
   let data = try? Data.init(contentsOf: url),
   let image = UIImage.init(data: data)
{  // image，可以使用成功后的data, data可以使用成功后的url
     // ...
    let view = UIImageView.init(image: image)
}


// 多个let的任意部分也能拥有布尔值限定的语句
if let url = URL.init(string: urlString), url.pathExtension == "png",
   let data = try? Data.init(contentsOf: url),
   let image = UIImage.init(data: data)
{
    let view = UIImageView.init(image: image)
}


// 最后，可以在同一个if中将可选值绑定，布尔语句和 case let 用任意的方式组合在一起使用？？？

//: #### **while let**
//: 和if let非常相似，
//: **它标识当一个条件返回nil时，便终止循环**

// 实现：读取内容，返回可选字符串，读取到尾部是，返回nil
while let line = readLine() {
    print(line)
}

// 和 if let 一样，你可以在可选绑定后面添加一个布尔值语句。如果你想在遇到EOF或者空行时终止循环的话，只需要添加一个判空语句就行
// 要注意，一旦条为false，循环就停止

while let line = readLine(), !line.isEmpty {
    print(line)
}

// 迭代器方式
let array2 = [1,2,3]
var iterator = array2.makeIterator()
while let i = iterator.next(), i % 2 != 0 { // 注意添加了条件语句后，条件不满足会直接停止迭代
    print(i, terminator: " ")
}


// 因为一个for循环其实就是while循环，这样一来，for循环也支持布尔语句也就是清理之中的事了
// 只是，我们要在布尔语句之前，使用where关键字:
for i in 0..<10 where i % 2 == 0 {      // 即使条件语句"i % 2"不成立，也会继续进行迭代
//    print(i, terminator: " ")
}

//: **注意**
/*: 使用 while let  如果后面添加Bool条件语句，当条件不成立会直接停止迭代
 
 而使用 for where condition，条件不成立不会停止迭代
 */

//: #### **双重可选值**

let stringNumbers = ["1","2","three"]
let maybeInts = stringNumbers.map{Int($0)}

//print(maybeInts) // [Optional(1), Optional(2), nil]
//由于 Int(String)可能是失败的，只要字符串无法转换为数字就会出现nil

for maybeInt in maybeInts {
//    print(maybeInt)
}

// 我们已经知道 for ... in 是while循环加上一个迭代器的简写方式。 由于next方法会把序列中的每个元素包装成可选值，
// 所以iterator.next()函数返回的起始是一个Optional<Optional<Int>>值，或者说是一个Int??
// 而while let 会解包并检查这个值是不是nil，如果不是，则绑定解包的值，并运行循环体部分

var itera = maybeInts.makeIterator()
while let maybeInt = itera.next() {
//    print(maybeInt, terminator: " ")    // Optional(1) Optional(2) nil
}


// 当循环达到最后一个值，也就是从“three”转换而来的nil时，从next返回的起始是一个非nil的值，这个值是.some(nil).
// while let 将这个值解包，并将解包结果(也就是nil)绑定到maybeInt上。如果没有嵌套可选值的话，这个操作将无法完成


//: **便捷方案**
// 如果指向对非nil的值做for循环可以使用case来进行模式匹配
for case let i? in maybeInts {  // 1 2
//    print(i, terminator: " ")
}

// 上述使用了x?这个模式，它只会匹配那些非nil的值，这个语法是.some(x)的简写形式

for case let .some(i) in maybeInts {    // 1*2*
//    print(i, terminator: "*")
}


// 或者只对nil值进行循环
for case nil in maybeInts {     // No value
//    print("No value")
}

//case语句是针对模式匹配展示的，由于maybeInts里面的值是可选类型即为Option枚举类型，我们可以通过case语句来进行模式匹配

//: **注意**

//基于case的模式匹配可以让我们把再switch的匹配中用到的规则同样的应用到if,for 和while上去。最有用的场景是结合可选值，但是也有其他的使用场景

let j = 5
if case 0..<10 = j {
//    print("\(j)在范围内")       // 5在范围内
}


//: #### **if var and while var**

// 除let以外，还可以使用var来搭配if,while,和for.这使得可以在语块中改变便量：
let number = "1"
if var i = Int(number) {
    i += 1
    print(i)
}

//: **注意**
//i 会是一个本地的复制，任何对i的改变将不会影响到原来的可选值。可选值是值类型，解包一个可选值做的事僵尸将它里面的值复制出来。

//: #### **解包后可选值的作用域**
// 有时只能在if块内部访问被解包的变量，让人很郁闷，如果有if not let 这种语法就方便很多， 正好有这样的API 'guard let'

// 问题展现
if let firstElement = array1.first {
    // 此处可以使用firstElement
}
// 此处不能使用firstElement

func doStuff() {
    guard let firstElement = array1.first else {
        return
    }
    
    //firstElement 已经被解包可以直接使用
    
    
}

//: #### **可选链**

//: **在进行方法的调用时，需要注意何时加？**
// A.doSome()   // A 不是可选值
// A?.doSome() // A 是可选值
// A.doSome()?.doOhers()    // A.doSome() 返回的是个可选值


//: 总结： 如果一个可选值，无论是返回值还是啥，需要调用方法时都需要在尾部添加？,这样来实现编译器展平结果类型让最终只有一个可选值

/*:
A 如果是可选值

**A? 相当于.some(A) 意思就是当A不为nil时才执行**
*/


var a:Int? = 5
a? = 10         // 由于a不是nil，a? = 10 会赋值
a

var b:Int? = nil
b? = 10   // 由于a是nil，a? = 10 不会赋值
b

b = 10      // 先赋值后面才可以再写入
b? = 20
b


//: #### **nil 合并运算符**
//很多时候，都会想再解包可选值的同时，为nil的情况设置一个默认值。。这正是nil合并运算符的功能

let stringeger = "1"

let number1 = Int(stringeger) ?? 0


// lhs ?? rhs 做的事情类似这样的代码
// lhs != nil ? lhs! : rhs


// 如果要检查一个索引是否在数组边界内，由于对索引超出边界不会返回Optional, 会直接崩溃
let arr = [1,2,3]
//arr[5]    // 直接会报错

arr.count > 5 ? arr[5] : 0

extension Array {
    subscript(guarded idx:Int) -> Element? {
        guard (startIndex..<endIndex).contains(idx) else {
            return nil
        }
        return self[idx]
    }
}


arr[guarded: 5] ?? 0


//: **用处**
//: 将会崩溃的值转换为可选值，然后可以直接进行使用nil合并运算符了



//合并操作也能够进行连接 - 如果你有多个可选值，并且想要选择第一个非nil的值，可以将他们按顺序合并
let i1:Int? = nil
let j1:Int? = nil
let k1:Int? = 43

i1 ?? j1 ?? k1 ?? 0     // 链式处理，找到不为0的解包，顺序执行


// 需要注意一下两种操作，与带（）的方式来处理

let s1:String? = nil
(s1 ?? "inner") ?? "outer" // inner

let s2:String?? = .some(nil)
(s2 ?? "inner") ?? "outer" // outer

// a ?? b ?? c      // 合并操作的链接
// (a ?? b) ?? c    // 先解包括号内的内容，然后再处理外层


// 如果将 ?? 操作父看做是和'or'语句类似的话，那么可以把多个并列的if let 语句 视作'and'语句

//if let n = i, let m = j {}
// 和 if i != nil && j != nil 类似

//: ?? 操作符使用短路求值。当我们用 l ?? r 时，只有当l为nil时，r的部分才会被求值。这是因为在操作符的函数声明中，对第二个参数使用了@autoclosure.



// 由于 ?? 无法决定当表达式两侧不共享同样的基础类型时，到底应该使用哪一种类型，编写个方法来实现 ???:



// 让编译器闭嘴提示的方案 infix 运算符再运算值之间， prefix:运算符再运算值前方，postfix:运算符再运算值后方
infix operator ???: NilCoalescingPrecedence

public func ???<T>(optional:T?, defaultValue: @autoclosure()->String) -> String {
    switch optional {
    case let value?:
        return String(describing: value)
    case nil:
        return defaultValue()
    }
}


let bodyTemperature: Double? = 37.0
let bloodGlucose:Double? = nil

// 以下两个编译器提示警告
print(bodyTemperature)
print("Blood glucose level:\(bloodGlucose)")

// 处理之后就没有了警告信息
print("Body temperaure:\(bodyTemperature ??? "n/a")")

//: #### **可选值map**
// 目的就是：map方法对内部不为nil直接返回，不为nil直接进行操作了

// 其实现方案 大致如下
//extension Optional {
//    func map<U>(transform:(Wrapped) -> U) -> U? {
//        guard  let value = self else {
//            return nil
//        }
//        return transform(value)
//    }
//}

// 假设，我们要把一个字符数组的第一个元素转换成字符串
let c = ["a", "b", "c", "d"]

String(c[0])
// 如果c可能为空的话，使用if let ,在数组不为空的时候创建字符串

var firstCharAsString:String? = nil
if let char = c.first {
    firstCharAsString = String(char)
}

// 这种只在可选值不为nil的时候才进行转换的模式十分常见。因此，可选值提供了一个map方法专门处理这个问题。它接收一个转换可选值内容的函数作为参数。把刚才转换字符数组的功能用map来实现：
let firstChar = c.first.map{String($0)}

// 当想要的就是一个可选值的时候，Optional.map就非常有用，假设你要为数组实现变种的reduce方法，这个方法不接受初始值
// 由于数组可能是空的，这种情况下就没有初始值，结果只能是可选值

extension Array {
    func reduce(_ nextPartialResult: (Element, Element) -> Element) -> Element? {
        // 如果数组为空，first将是nil
        guard let fst = first else {return nil}
        return dropFirst().reduce(fst, nextPartialResult)
    }
}

[1,2,3,4,5].reduce(+)


// 由于可选值map也会返回nil，所以不使用guard，用一个return来实现reduce可以是

extension Array {
    func reduce1(_ nextPartialResult:(Element, Element)->Element) -> Element? {
        return first.map {  // 如果first是nil，直接返回，不是nil执行方法体的内容
//            $0即是本尊
            return dropFirst().reduce($0, nextPartialResult)
        }
    }
}

[1,2,3,4,5].reduce1(+)


//: #### **可选值flatmap**
// optional返回的多重可选值进行平铺

// 实现方案
//extension Optional {
//    func flatMap<U>(transform:(Wrapped) -> U?) -> U? {
//        if let value = self, let transformed = transform(value) {
//            return transformed
//        }
//        return nil
//    }
//}


//当多重可选值嵌套的情况下处理

let sn = ["1","2","3"]
let x = sn.first.map{Int($0)}       // Int($0) 返回的也是一个可选   map返回的也是一个可选

type(of: x) // Optional<Optional<Int>>.Type


// 多重嵌套，我们需要进行平铺处理


let x1 = sn.first.flatMap{Int($0)}
type(of: x1)     // 被平铺： Optional<Int>.Type

// 以上实现，相当于这个
if let a = sn.first, let b = Int(a) {
    print(b)
}

// 通过这个可以发现flatMap和if let是非常相似的，所以可以将之前的实现进行调整为
let view1 = URL.init(string: urlString)
    .flatMap{try? Data.init(contentsOf: $0)}
    .flatMap{UIImage.init(data: $0)}
    .map { UIImageView.init(image: $0)}

if let view1 = view1 {
    PlaygroundPage.current.liveView = view1;
}




//: **使用注意方式：**
// A.flatMap(B)   A 是可选， B也是可选，使用faltMap最终只返回一层可选
// A.map(B)       A 是可选，B是当A解包不为nil后执行的值

// 使用flatMap，和map 可以用链式的方式返回最尾部的值

//: #### **使用compactMap过滤nil**
// 内部实现
// 使用了lazy，来将数组的时机创建推迟到了使用前的最后一刻，这并不是标准库的实现方案
//extension Sequence {
//    func compactMap<B>(_ transform:(Element) -> B?) -> [B] {
//        return lazy.map(transform).filter{$0 != nil}.map{$0!}     // 获取到非nil数据后，强制解包
//    }
//}


let nbs = ["1", "2", "3", "foo"]
var sum = 0
for case let i? in nbs.map{Int($0)} {
    sum += i
}


// 也可以使用?? 把nil替换成0:
let sum1 = nbs.map{Int($0)}.reduce(0) { $0 + ($1 ?? 0)}
sum1

// 实际上，我们更想将那些nil过滤出去，并将非nil值进行解包的map。 compactMap实现了我们的需要
let sum2 = nbs.compactMap{Int($0)}.reduce(+)
sum2



//: #### **使用可选值判等**
//有时候，并不关心可选值是否为nil，仅仅只是想判断是否匹配我们需要的值
let regex = "^hello$"
if regex.first == "^" {
    // 只匹配字符串开头
}


//: **当你在使用一个非可选值的时候，如果需要匹配成可选值类型，swift总是会将它升级为一个可选值**


//: #### **强制解包的时机**

// 1. 当你能确定你的某个值不可能是nil时，可以使用叹号
// 2. 希望如果它意外是nil的话，程序应当直接挂掉

//: #### **改进强制解包的错误信息**

// 使用！强制解包，如果程序发生错误，从输出的log中无法通过描述知道 原因是什么，那我们可以通过把注释作为错误信息进行操作
infix operator !!
func !!<T>(Wrapped: T?, failureText:@autoclosure()->String) -> T {
    if let x = Wrapped {return x}
    fatalError(failureText())
}

// 示例
let s = "foo"
//let i = Int(s) !! "Expecting integer, got \"\(s)\""


//: #### **在调试版本中进行断言**

//: 发布环境，让应用崩溃还是很大胆的行为，通常，可以选择再调试版本或者测试版本中进行断言，让程序崩溃，但是最终产品中，把它替换成像是零或者空数组这样的默认值。

//可以定义一个!?来代表这个行为，对失败解包进行断言，并且再断言不触发的发布版本中将值替换为默认值

infix operator !?

func !?<T:ExpressibleByIntegerLiteral> (wrapped: T?, failureText:@autoclosure ()->String) -> T {
    assert(wrapped != nil, failureText())
    return wrapped ?? 0;
}

// 下面代码将再调试时触发断言，发布版本中打印0
let b1 = "20"
let i = Int(b1) !? "Expecting integer, got\"\(b1)\""



//: #### **隐式解包可选值**
//像UIView!这种在类型后面加一个感叹号的隐式解包可选值，无论何时使用它们的时候都会自动强制解包，但是它们依然是可选值

// 存在的原因：

// 1. 暂时还需要到Objective-C里取调用那些没有检查返回是否存在的代码，或者会调用一个没有针对Swift做注解的C语言库

// 2. 因为一个值展示很短暂的为nil，在一段时间后，它就再也不会是nil
// 常见的场景就是interfaceBuild在ViewController的声明周期使用的方式， viewController会延时创建他们的View，所以在viewController自身已经被初始化，但是它的view还没被加载的这段时间内 就会出现这种场景



//: #### **隐式的可选值行为**

// 虽然隐式解包的可选值在行为上就好像是非可选值一样，不过依然可以对它们使用可选链

var  sr:String! = "Hello"
sr?.isEmpty

if let s = sr {
    print(s)
}

sr = nil
sr ?? "GoodBye"

//: [Next](@next)
