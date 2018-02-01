//
//  TextFieldFormatter.swift
//  MenuBarControls
//
//  Copyright © 2017 Ghostly. All rights reserved.
//

import Foundation

class TextFieldFormatter: NumberFormatter {

    override func isPartialStringValid(_ partialString: String,
                                       newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?,
                                       errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        if partialString.isEmpty {
            return true
        }

        if String.init(partialString) == "100" {
            return true
        } else if partialString.count>2 {
            return false
        }

        return Int(partialString) != nil
    }
}
