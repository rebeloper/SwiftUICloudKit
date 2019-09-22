//
//  ListElements.swift
//  SwiftUICloudKitDemo
//
//  Created by Alex Nagy on 23/09/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import SwiftUI

class ListElements: ObservableObject {
    @Published var items: [ListElement] = []
}
