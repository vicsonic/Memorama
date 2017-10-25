//
//  Layout.swift
//  Memorama
//
//  Created by Victor Soto on 10/24/17.
//  Copyright © 2017 Radial Loop Inc. All rights reserved.
//

import UIKit

class Layout {
    var colums: Int
    var rows: Int
    var spacing: CGFloat
    var itemSize: CGSize
    var insets: UIEdgeInsets
    var footerSize: CGSize
    
    init(colums: Int, rows: Int, insets: UIEdgeInsets, footerHeight: CGFloat) {
        self.colums = colums
        self.rows = rows
        self.insets = insets
        let screenWidth = UIScreen.main.bounds.width
        let horizontalSpaces = colums - 1
        let availableSpace = screenWidth - insets.left - insets.right
        self.spacing = (availableSpace * 0.3) / CGFloat(horizontalSpaces)
        let itemWidth = (availableSpace * 0.7) / CGFloat(colums)
        let itemHeight = itemWidth / 0.7878
        self.itemSize = CGSize(width: itemWidth, height: itemHeight)
        self.footerSize = CGSize(width: screenWidth, height: footerHeight)
    }
}
