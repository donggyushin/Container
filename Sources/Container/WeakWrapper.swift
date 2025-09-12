//
//  File.swift
//  Container
//
//  Created by 신동규 on 9/12/25.
//

import Foundation

final class WeakWrapper {
    weak var value: AnyObject?
    
    init(value: AnyObject? = nil) {
        self.value = value
    }
}

