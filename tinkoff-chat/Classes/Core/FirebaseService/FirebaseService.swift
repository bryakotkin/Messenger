//
//  FirebaseService.swift
//  tinkoff-chat
//
//  Created by Nikita on 18.04.2022.
//

import FirebaseFirestore
import UIKit

class FirebaseService: IFirebaseService {
    
    var db: Firestore = Firestore.firestore()
    var collectionReference: CollectionReference?
    
    func addSnapshotListener(block: @escaping (Result<[DocumentChange], Error>) -> Void) {
        guard let collectionReference = collectionReference else { return }
        collectionReference.addSnapshotListener { snapshot, error in
            if let error = error {
                block(.failure(error))
                return
            }
            
            if let documents = snapshot?.documentChanges {
                block(.success(documents))
            }
        }
    }
    
    func addDocument(data: [String: Any], completion: @escaping (Error?) -> Void) {
        guard let collectionReference = collectionReference else { return }
        collectionReference.addDocument(data: data) { error in
            completion(error)
        }
    }
    
    func deleteDocument(identifier: String, completion: @escaping (Error?) -> Void) {
        guard let collectionReference = collectionReference else { return }
        collectionReference.document(identifier).delete { error in
            completion(error)
        }
    }
}
