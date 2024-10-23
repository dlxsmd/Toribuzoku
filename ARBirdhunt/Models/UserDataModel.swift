//
//  UserDataModel.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/10/16.
//

import Foundation

import Foundation

struct FetchUserDataModel: Decodable,Identifiable {
    let id: UUID?
    let name: String
    let score: Int
    let createdAt: Date
    let email: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case score
        case createdAt
        case email
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        score = try container.decode(Int.self, forKey: .score)
        email = try container.decode(String.self, forKey: .email)

        let dateString = try container.decode(String.self, forKey: .createdAt)
        
        // Assuming ISO 8601 format
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .createdAt,
                                                   in: container,
                                                   debugDescription: "Date string does not match format expected by formatter.")
        }
        createdAt = date
    }
}

struct RegisterUserDataModel: Encodable {
    var id: UUID?
    let name: String
    let score: Int
    let createdAt: String
    let email: String

    // Add this initializer
    init(id:UUID? = UUID(), name: String, score: Int, createdAt: String, email: String) {
        self.name = name
        self.score = score
        self.createdAt = createdAt
        self.email = email
    }
}
