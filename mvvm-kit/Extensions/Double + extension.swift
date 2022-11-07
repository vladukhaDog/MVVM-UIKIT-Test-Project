//
//  Double + extension.swift
//  TestTask
//
//  Created by Владислав Пермяков on 29.10.2022.
//

import Foundation

extension Double{
    
    ///красивое форматирование
    var clean: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesSignificantDigits = false
        numberFormatter.groupingSeparator = ""
        numberFormatter.roundingMode = .down
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
