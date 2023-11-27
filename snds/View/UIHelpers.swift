//
//  Align.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/11/25.
//

import Foundation
import SwiftUI

extension View {
    func hAlign(_ align: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: align)
    }
    
    func vAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }

    func disabledElement(_ cond: Bool) -> some View {
        self
            .disabled(cond)
            .opacity(cond ? 0.6 : 1)
    }
}
