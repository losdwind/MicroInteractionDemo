//
//  TabItem.swift
//  popoo-ios-animation
//
//  Created by Losd wind on 2022/12/29.
//

import Foundation
import SwiftUI
struct TabItem:Identifiable, Hashable{
    var id:String = UUID().uuidString
    var iconName:String
    var title:String
    var color:Color

}
let exampleValues = [
            TabItem(iconName: "id-card", title: "id-card", color: Color.gray),
            TabItem(iconName: "id-card", title: "id-card", color: Color.gray),
            TabItem(iconName: "id-card", title: "id-card", color: Color.gray),
            TabItem(iconName: "id-card", title: "id-card", color: Color.gray)
        ]


