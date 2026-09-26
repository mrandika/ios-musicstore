//
//  Spacing.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import Foundation

public enum Spacing: CGFloat, CaseIterable {
    /// 4pt
    case xSmall = 4.0
    
    /// 8pt
    case small = 8.0
    
    /// 12pt
    case medium = 12.0
    
    /// 16pt
    case large = 16.0
    
    /// 20pt
    case xLarge = 20.0
    
    /// 24pt
    case xxLarge = 24.0
    
    /// 32pt
    case xxxLarge = 32.0
    
    /// The point value, for use where a `CGFloat` is expected.
    public var points: CGFloat { rawValue }
}
