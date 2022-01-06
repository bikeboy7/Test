//
//  SwiftFunction.swift
//  Test
//
//  Created by panjinyong on 2021/11/3.
//

import Foundation
protocol MyProtocol {
    
}

struct MyStruct: MyProtocol {
}

extension MyStruct {
    func extensionMethod() {
        print("结构体")
    }
}
extension MyProtocol {
    func extensionMethod() {
        print("协议")
    }
}

func test() {
    let myStruct = MyStruct()
    let proto: MyProtocol = myStruct

    myStruct.extensionMethod() // -> “结构体”
    proto.extensionMethod() // -> “协议”

}

