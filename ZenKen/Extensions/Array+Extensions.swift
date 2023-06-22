//
//  Array+Extensions.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 22.06.23.
//

import Foundation

extension Array: Identifiable where Element: Hashable {
   public var id: Self { self }
}
