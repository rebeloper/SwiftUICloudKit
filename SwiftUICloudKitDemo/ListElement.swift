//
//  ListElement.swift
//  SwiftUICloudKitDemo
//
//  Created by Alex Nagy on 22/09/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import SwiftUI
import CloudKit

struct ListElement: Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var text: String
}
