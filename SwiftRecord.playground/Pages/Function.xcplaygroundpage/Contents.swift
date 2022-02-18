//: [Previous](@previous)

import Foundation


//: # 概述

//: ## 函数三要素
//: ### 函数可以被赋值给变量，也能够作为函数的输入和输出

func printInt(i:Int) {
    print("You passed \(i)")
}

// i 为标签， swift只允许在函数声明中包含标签，这些标签不是函数类型的一部分
printInt(i: 10)

let funcVar = printInt

// 注意funcVar调用是没有参数标签
funcVar(10)


//: 总结： 不能将参数标签赋值给一个类型是函数的变量（ 未来可能会改变）



// 写一个接受函数作为参数的函数：
func useFunction(function:(Int)->()) {
    function(3)
}

useFunction(function: printInt)
useFunction(function: funcVar)


//: 为什么函数可以作为变量使用的这种能力如此关键呢？
// 因为它让你更容易写出"高阶"函数

// 函数返回函数
func returnFunc()->(Int)->String {
    func innerFuc(i:Int)->String {
        return "you passed \(i)"
    }
    return innerFuc
}
// returnFunc返回的是个函数，要赋值给变量的是返回的函数，不是它本身
let myFunc = returnFunc()

myFunc(10)


//: ### 函数可以捕获存在于他们作用域之外的变量

// 当函数引用了在其作用域之外的变量时，这个变量就被捕获了，他们将会继续存在，而不是再超过作用域后被销毁

// 验证方案，改造上面函数，添加一个计数器

func counterFunc()->(Int) -> String {
    var counter = 0
    func innerFunc(i:Int) -> String {
        counter += i
        return "Running total:\(counter)"
    }
    return innerFunc
}

// 由于counter是counterFunc的局部变量，它在return语句执行之后就应该离开作用域并被销毁，
// 但是由于innerFunc捕获了它，所以运行时如果f未被销毁，将一直保证存在，知道捕获它的函数被销毁为止
let f = counterFunc()
f(3)
f(4)

let g = counterFunc()
g(1)
g(2)

// 注意以上两个： f, g分别可以看成两个实例，这个示例有方法及一些成员变量， 只要不销毁，就会捕获一直使用


// 在编程属于中，一个函数和它锁捕获的变量环境组合起来被称为闭包
// 上面的f,g都是闭包的例子，因为他们捕获并使用了一个在它们作用域之外声明的非局部变量counter


//: ### 函数可以捕获存在于他们作用域之外的变量

//: **在Swift中，定义函数的方法有两种。一种是使用func关键字，另一种方法是使用闭包表达式**

// 将数字翻倍
func doubler(i: Int) -> Int {
    return i * 2;
}


[1,2,3,4].map(doubler)

// 使用闭包表达式的写法
let doublerAlt = {(i:Int) -> Int in return i * 2}
[1,2,3,4].map(doublerAlt)


//: 使用闭包表达式来定义的函数可以被想成
//:**函数的字面量**
//: 与func相比，它的区别在于闭包表达式是匿名的，它们没有被赋予一个名字。
//:使用它们的方式只能是在他们被创建时将其赋值给一个变量，或者将它们传递给另一个函数或方法

// 就像： 1 是整数字面量， ”hello“是字符串字面量

//: 还有第三种使用匿名方法的方式
// 可以在定义一个表达式的同时，对它进行调用。  这个方法在定义那些初始化时代码多余一行的属性时会很有用，多用于延迟属性


let a = Array(1..<10)

// 简写策略实现：
a.map({(a:Int) -> Int in return a * 2})
a.map({a in return a * 2})
a.map({a in a * 2})
a.map({$0 * 2})
a.map(){$0 * 2}
a.map{$0 * 2}



//: swift的特性简写方案： 对比 b 和 b1的方案，给定简写的处理方案

// 1. 如果你将闭包作为参数传递，并且你不再用这个闭包做其他事情的话，就没有必要先将它存储到一个局部变量中。可以想象一下比如 5*i 这样的数值表达式，你可以把它直接传递给一个接受 Int 的函数，而不必先将它计算并存储到变量里。

// 2. 如果编译器可以从上下文中推断出类型的话，你就不需要指明它了。在我们的例子中，从数组元素的类型可以推断出传递给 map 的函数接受 Int 作为参数，从闭包内的乘法结果的类型可以推断出闭包返回的也是 Int

// 3. 如果闭包表达式的主体部分只包括一个单一的表达式的话，它将自动返回这个表达式的结果，你可以不写 return。

// 4. Swift 会自动为函数的参数提供简写形式，$0 代表第一个参数，$1 代表第二个参数，以此类推。

// 5. 如果函数的最后一个参数是闭包表达式的话，你可以将这个闭包表达式移到函数调用的圆括号的外部。这样的尾随闭包语法 (trailing closure syntax) 在多行的闭包表达式中表现非常好，因为它看起来更接近于装配了一个普通的函数定义，或者是像 if (expr) { } 这样的执行块的表达形式。

// 6. 最后，如果一个函数除了闭包表达式外没有别的参数，那么调用的时候在方法名后面的圆括号也可以一并省略


//: **变量不能持有泛型函数，它只能持有一个类型具体化之后的版本**

// 例如
func isEven<T:BinaryInteger>(_ i : T) -> Bool {
    return i % 2 == 0
}

// 如果赋值，变量 int8IsEven 不能包含泛型
let int8IsEven:(Int8) -> Bool = isEven



//: 只需要知道一件事： 闭包和函数，没什么不同，只是声明的时候有方法名，和匿名，及{}的形式不同，其他没什么了，他们都一样，即是函数也是闭包


//: # 函数的灵活性

let myArr = [3,1,2]

//: **接受两个对象作为参数，并在他们顺序正确的时候返回true**
myArr.sorted(by: <)     // 从小到大

// 就算待排序的元素不遵守Compareable, 但只要有<操作符，就可以使用这个方法来进行排序，比如元组
var numberStrings = [(2, "two"), (1, "one"), (3,"three")]
numberStrings.sort(by: <)

// 或者也可以使用一个更复杂的函数，按照任意你需要的计算标准进行排序

let animals = ["elephat", "zebra","dog"]
animals.sorted { left , right in
    let l = left.reversed() // 反序
    let r = right.reversed()
    return l.lexicographicallyPrecedes(r);// 内部使用<来对比
}


// 最后Swift的排序还有一个能力，它可以使用任意的比较函数来对集合进行排序。这使得Swift排序非常强大



// 接下来展示Objective-C强大的运行时来进行排序的工作方式
@objcMembers
final class Person: NSObject {
    let first:String
    let last:String
    let yearOfBirth:Int
    
    init(first:String, last:String, yearOfBirth:Int) {
        self.first = first
        self.last = last
        self.yearOfBirth = yearOfBirth
        
        // super.init() 会进行隐式调用
    }
    
    
    override var description: String {
        return "(\(first) \(last) (\(yearOfBirth)))\n"
    }
}


// 定义一个数组，包含不同的名字和出生年份的人
let people = [Person.init(first: "Emily", last: "Young", yearOfBirth: 2002),
              Person.init(first: "David", last: "Gray", yearOfBirth: 1991),
              Person.init(first: "Robert", last: "Barnes", yearOfBirth: 1985),
              Person.init(first: "Ava", last: "Barnes", yearOfBirth: 2000),
              Person.init(first: "Joanne", last: "Miller", yearOfBirth: 1994),
              Person.init(first: "Ava", last: "Barnes", yearOfBirth: 1998)
]


// 我们需要的规则： 1. 姓排序，2. 名排序， 3. 出生年份    备注：last: 姓  first:名


// 使用NSSortDescriptor对象来描述如何排序对象

// 姓氏排序
let lastDescriptor = NSSortDescriptor.init(key: #keyPath(Person.last),
                                           ascending: true,
                                           selector: #selector(NSString.localizedStandardCompare(_:)))
// 名排序
let firstDescriptor = NSSortDescriptor.init(key: #keyPath(Person.first),
                                            ascending: true,
                                            selector: #selector(NSString.localizedStandardCompare(_:)))
// 生日排序
let yearDescriptor = NSSortDescriptor.init(key: #keyPath(Person.yearOfBirth), ascending: true)

// 使用数组的描述进行排序
let descriptors = [lastDescriptor, firstDescriptor, yearDescriptor]

let y = (people as NSArray).sortedArray(using: descriptors)


// 排序描述符用到了Objective-C的两个运行时特性；
// 首先key是Objective-C的键路径，它其实是一个包含属性名字的量表。不要把它和Swift4引入的原生的(强类型的)键路径搞混
// 其次是 键值编程（key-value-coding），它可以在运行时通过键查找一个对象上的对应值。
// selector参数接受一个selector（实际上也是一个用来猫叔方法名字的字符串）
// 在运行时，这个selector会被用来查找比较函数，当对两个对象进行比较时，这个函数将使用指定键对应的值进行比较。

// 这是运行时变成的一个很酷的用例，排序描述的数组可以在运行时构建，这一点在实现比如用户点击某一列时按照该列进行排序这种需求时会特别有用


// 那用Swift的sort怎么来赋值这个功能呢？

var strings = ["Hello", "hallo", "Hallo", "hello"]
strings.sort{$0.localizedStandardCompare($1) == .orderedAscending}
//strings

// 如果是想用队形的某一个属性进行排序的haul，也简单
let sortPerson = people.sorted{$0.yearOfBirth < $1.yearOfBirth}

// 不过，当要把可选值属性与像是localizedStandardCompare这样的方法结合起来使用的话，这条路就有点走不通了，代码会迅速变得丑陋不堪 示例：
//var files = ["one", "file.h", "file.c", "test.h"]
//files.sort { l, r in
//    r.fileExtension.flatMap {
//        l.fileExtension?.localizedStandardCompare($0)
//    } == .orderedAscending
//}

// 要同时排序姓和名，我们可以用标准库的lexicographicallyPrecedes方法来进行实现。
// 这个方法接收两个序列,并对它们执行一个电话簿的方式比较， 也就是说，这个比较将顺次从两个序列中各取一个元素进行比较，知道发现不相等的元素。
// 所以我们可以用姓和名构建两个数组，然后使用lexicographicallyPrecedes来比较它们。我们还需要一个函数来执行这个比较，这里我们把使用了localizedStandardCompare的比较代码放到这个函数中：

people.sorted { p0 , p1 in
    let l = [p0.last, p0.first]
    let r = [p1.last, p1.first]
    return l.lexicographicallyPrecedes(r) {
        $0.localizedStandardCompare($1) == .orderedAscending
    }
}

// 至此，我们用了差不多相同的行数重新实现了原来的那个排序方法，不过还有很大的改进空间：
// 在每次比较的时候都构建一个数组是非常没有效率的，比较操作也是被写死的，通过这种实现无法对yearOfBirth进行排序


//sortPerson.forEach { person in
//    print(person)
//}

//: ## 函数作为数据

// 其实排序最好的定义方式就是入参两个，当顺序一致时返回true
typealias SortDescriptor<Root> = (Root, Root) -> Bool


// 接下来使用函数的方式定义描述符
let sortByYear:SortDescriptor<Person> = {$0.yearOfBirth < $1.yearOfBirth}
let sortByLastName:SortDescriptor<Person> = {$0.last.localizedStandardCompare($1.last) == .orderedAscending}
let sortByFirstName:SortDescriptor<Person> = {$0.first.localizedStandardCompare($1.first) == .orderedAscending}

// 为了避免复制粘贴时，容易造成.first与.last进行比较导致的问题, 可以进行更进一步的封装

func sortDescriptor<Root, Value> (key: @escaping (Root)->Value, by areInIncreasingOrder:@escaping (Value, Value) -> Bool) -> SortDescriptor<Root>
{
    return {areInIncreasingOrder(key($0), key($1))}
}

// key函数描述了如何深入一个Root类型的元素，并提取出一个和特定排序步骤相关的Value类型的值。因为借鉴了泛型参数名字Root和Value
// 所以它和Swift4引入的Swift原生键路径有很多相同之处。我们会再下面讨论怎么用Swift的键值路径重写这个方法


// 有了上述方法，就可以定义sortByYear了
let sortByYearAlt:SortDescriptor<Person> = sortDescriptor(key: {$0.yearOfBirth}, by: <)

let mySort = people.sorted(by: sortByYearAlt)

mySort.forEach { person in
    print(person)
}

// 甚至还可以为所有实现了Comparable的类型定义一个重载版本：
func sortDescriptor<Root, Value>(key:@escaping (Root)-> Value)
-> SortDescriptor<Root> where Value: Comparable {
    return {key($0) < key($1)}
}

let sortByYearAlt2: SortDescriptor<Person> = sortDescriptor(key: {$0.yearOfBirth})



//: ---
//: [Next](@next)
