//
//  String+Extension.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/23/23.
//

import Foundation

public extension Optional where Wrapped == String {
    
    func `or`(_ value: Wrapped?) -> Optional {
        return self ?? value
    }

    func `or`(_ value: Wrapped) -> Wrapped {
        return self ?? value
    }
    
    var orEmpty: Wrapped {
        return self.or("")
    }
    
    func replaceEmptyWithNil() -> String? {
        return self.orEmpty.isEmpty ? nil : self
    }
}
