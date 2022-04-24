//
//  IFirebaseService.swift
//  tinkoff-chat
//
//  Created by Nikita on 18.04.2022.
//

import FirebaseFirestore

protocol IFirebaseService {
    var db: Firestore { get }
    var collectionReference: CollectionReference? { get set } 
    
    func addSnapshotListener(block: @escaping (Result<[DocumentChange], Error>) -> Void)
    func addDocument(data: [String: Any], completion: @escaping (Error?) -> Void)
    func deleteDocument(identifier: String, completion: @escaping (Error?) -> Void)
}
