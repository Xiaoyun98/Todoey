//
//  Data.swift
//  Todoey
//
//  Created by Xiaoyun Zhi on 2/19/18.
//  Copyright © 2018 Xiaoyun Zhi. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable { // for it to be encodable, all its properties has to be standard data type
    var title: String = ""
    var done: Bool = false
}
