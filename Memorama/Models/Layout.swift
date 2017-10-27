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
        let screenHeight = UIScreen.main.bounds.height
        let horizontalSpaces = CGFloat(colums - 1)
        let verticalSpaces = CGFloat(rows - 1)
        
        self.spacing = 10 //(availableSpace * 0.3) / CGFloat(horizontalSpaces)
        
        let availableVerticalSpace = screenHeight - insets.top - insets.bottom - (spacing * verticalSpaces) - verticalSpaces
        let availableHorizontalSpace = screenWidth - insets.left - insets.right - (spacing * horizontalSpaces) - horizontalSpaces
        
//        let itemWidth = availableSpace / CGFloat(colums) //(availableSpace * 0.7) / CGFloat(colums)
//        let itemHeight = itemWidth / 0.7878
        
//        let availableSpace = screenWidth - insets.left - insets.right - (spacing * horizontalSpaces) - horizontalSpaces
//        let itemWidth = availableSpace / CGFloat(colums) //(availableSpace * 0.7) / CGFloat(colums)
        var itemHeight = availableVerticalSpace / CGFloat(rows)
        var itemWidth = itemHeight * 0.7878
        
        let floatColumns = CGFloat(colums)
        // Verification
        repeat {
            itemWidth *= 0.9
        } while (itemWidth * floatColumns) > availableHorizontalSpace
        
        itemHeight = itemWidth / 0.7878
        
        self.itemSize = CGSize(width: itemWidth, height: itemHeight)
        self.footerSize = CGSize(width: screenWidth, height: footerHeight)
    }
}
