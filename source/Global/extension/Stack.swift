//
//  Stack.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 10/08/15.
//  Copyright (c) 2015 Jiajun Qiu. All rights reserved.
//

import Foundation

internal struct Stack<T> {
    var items = [T]()
    mutating func push(_ item: T) {
        items.append(item);
    }
    
    mutating func pop() -> T {
        return items.removeLast();
    }
}
