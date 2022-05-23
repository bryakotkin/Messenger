//
//  FirebaseServiceMock.swift
//  tinkoff-chat-tests
//
//  Created by Nikita on 22.05.2022.
//

@testable import tinkoff_chat
import FirebaseFirestore

class FirebaseServiceMock: IFirebaseService {

    var invokedDbGetter = false
    var invokedDbGetterCount = 0
    var stubbedDb: Firestore!

    var db: Firestore {
        invokedDbGetter = true
        invokedDbGetterCount += 1
        return stubbedDb
    }

    var invokedCollectionReferenceSetter = false
    var invokedCollectionReferenceSetterCount = 0
    var invokedCollectionReference: CollectionReference?
    var invokedCollectionReferenceList = [CollectionReference?]()
    var invokedCollectionReferenceGetter = false
    var invokedCollectionReferenceGetterCount = 0
    var stubbedCollectionReference: CollectionReference!

    var collectionReference: CollectionReference? {
        get {
            invokedCollectionReferenceGetter = true
            invokedCollectionReferenceGetterCount += 1
            return stubbedCollectionReference
        }
        set {
            invokedCollectionReferenceSetter = true
            invokedCollectionReferenceSetterCount += 1
            invokedCollectionReference = newValue
            invokedCollectionReferenceList.append(newValue)
        }
    }

    var invokedAddSnapshotListener = false
    var invokedAddSnapshotListenerCount = 0
    var stubbedAddSnapshotListenerBlockResult: (Result<[DocumentChange], Error>, Void)?

    func addSnapshotListener(block: @escaping (Result<[DocumentChange], Error>) -> Void) {
        invokedAddSnapshotListener = true
        invokedAddSnapshotListenerCount += 1
        if let result = stubbedAddSnapshotListenerBlockResult {
            block(result.0)
        }
    }

    var invokedAddDocument = false
    var invokedAddDocumentCount = 0
    var invokedAddDocumentParameters: (data: [String: Any], Void)?
    var invokedAddDocumentParametersList = [(data: [String: Any], Void)]()
    var stubbedAddDocumentCompletionResult: (Error?, Void)?

    func addDocument(data: [String: Any], completion: @escaping (Error?) -> Void) {
        invokedAddDocument = true
        invokedAddDocumentCount += 1
        invokedAddDocumentParameters = (data, ())
        invokedAddDocumentParametersList.append((data, ()))
        if let result = stubbedAddDocumentCompletionResult {
            completion(result.0)
        }
    }

    var invokedDeleteDocument = false
    var invokedDeleteDocumentCount = 0
    var invokedDeleteDocumentParameters: (identifier: String, Void)?
    var invokedDeleteDocumentParametersList = [(identifier: String, Void)]()
    var stubbedDeleteDocumentCompletionResult: (Error?, Void)?

    func deleteDocument(identifier: String, completion: @escaping (Error?) -> Void) {
        invokedDeleteDocument = true
        invokedDeleteDocumentCount += 1
        invokedDeleteDocumentParameters = (identifier, ())
        invokedDeleteDocumentParametersList.append((identifier, ()))
        if let result = stubbedDeleteDocumentCompletionResult {
            completion(result.0)
        }
    }
}
