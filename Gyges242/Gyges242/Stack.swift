//
//  Stack.swift
//  Gyges242
//
//  Created by Osayd Abdu on 4/28/16.
//  Copyright © 2016 Osayd3. All rights reserved.
//

import Foundation

class Stack<TYPE> {
    
    var array = Array<TYPE>()
    
    func push(element: TYPE) {
        array.append(element)
    }
    
    func pop() -> TYPE {
        return array.removeLast()
    }
    
    func empty() -> Bool {
        return self.array.count == 0 
    }
}