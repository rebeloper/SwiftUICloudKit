//
//  CloudKitHelper.swift
//  SwiftUICloudKitDemo
//
//  Created by Alex Nagy on 23/09/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import Foundation
import CloudKit
import SwiftUI

struct CloudKitHelper {
    
    struct RecordType {
        static let Items = "Items"
    }
    
    static func save(item: ListElement, completion: @escaping (Result<ListElement, Error>) -> ()) {
        let itemRecord = CKRecord(recordType: RecordType.Items)
        itemRecord["text"] = item.text as CKRecordValue
        
        CKContainer.default().publicCloudDatabase.save(itemRecord) { (record, err) in
            if let err = err {
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
                return
            }
            guard let record = record else { return }
            let recordID = record.recordID
            guard let text = record["text"] as? String else { return }
            let listElement = ListElement(recordID: recordID, text: text)
            print("Successfully saved item with record ID: \(recordID)")
            DispatchQueue.main.async {
                completion(.success(listElement))
            }
        }
    }
    
    static func fetch(completion: @escaping (Result<ListElement, Error>) -> ()) {
        print("Fetching...")
        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: RecordType.Items, predicate: pred)
        query.sortDescriptors = [sort]

        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["text"]
        operation.resultsLimit = 50
        
        operation.recordFetchedBlock = { record in
            print("Did fetch record: \(record)")
            let recordID = record.recordID
            guard let text = record["text"] as? String else { return }
            let listElement = ListElement(recordID: recordID, text: text)
            DispatchQueue.main.async {
               completion(.success(listElement))
            }
        }
        
        operation.queryCompletionBlock = { (cursor, err) in
            if let err = err {
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
                return
            }
            guard let cursor = cursor else { return }
            print("Cursor: \(String(describing: cursor))")
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    static func delete(recordID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
        CKContainer.default().publicCloudDatabase.delete(withRecordID: recordID) { (recordID, err) in
            if let err = err {
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
                return
            }
            guard let recordID = recordID else {
                return
            }
            print("Successfully deleted record with ID: \(recordID)")
            DispatchQueue.main.async {
                completion(.success(recordID))
            }
        }
    }
    
    static func modify(item: ListElement, completion: @escaping (Result<ListElement, Error>) -> ()) {
        guard let recordID = item.recordID else { return }
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { record, err in

            if let err = err {
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
                return
            }
            guard let record = record else { return }
            record["text"] = item.text as CKRecordValue

            CKContainer.default().publicCloudDatabase.save(record) { (record, err) in
                if let err = err {
                    DispatchQueue.main.async {
                        completion(.failure(err))
                    }
                    return
                }
                guard let record = record else { return }
                let recordID = record.recordID
                guard let text = record["text"] as? String else { return }
                let listElement = ListElement(recordID: recordID, text: text)
                DispatchQueue.main.async {
                   completion(.success(listElement))
                }
            }
        }
        
        
    }
}
