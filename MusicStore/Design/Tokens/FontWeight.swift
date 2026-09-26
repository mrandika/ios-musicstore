//
//  FontWeight.swift
//  MusicStore
//
//  Created by Andika on 26/09/26.
//

import SwiftUI

public enum FontWeight {
    case regular
    case bold
    
    var weight: Font.Weight {
        switch self {
        case .regular:
            .regular
        case .bold:
            .bold
        }
    }
}
