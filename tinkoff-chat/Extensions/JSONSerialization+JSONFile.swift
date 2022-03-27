//
//  JSONSerialization+JSONFile.swift
//  tinkoff-chat
//
//  Created by Nikita on 23.03.2022.
//

import Foundation

extension JSONSerialization {
    
    static func loadJSON<T: Decodable>(withFilename filename: String, type: T.Type) throws -> T? {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let jsonObject = try decoder.decode(type, from: data)
            return jsonObject
        }
        return nil
    }
    
    static func save<T: Encodable>(jsonObject: T, toFilename filename: String) throws -> Bool {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            let encoder = JSONEncoder()
            let data = try encoder.encode(jsonObject)
            try data.write(to: fileURL, options: [.atomicWrite])
            return true
        }
        
        return false
    }
}
