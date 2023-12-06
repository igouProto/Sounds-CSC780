//
//  Align.swift
//  snds
//
//  Created by Reina Kawamoto on 2023/11/25.
//
// attribution - part of this file was adapted from this tutorial series:
// https://www.youtube.com/playlist?list=PLimqJDzPI-H9u3cSJCPB_EJsTU8XP2NUT

import Foundation
import SwiftUI

// shorthands that we can use to align items when building UI

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
