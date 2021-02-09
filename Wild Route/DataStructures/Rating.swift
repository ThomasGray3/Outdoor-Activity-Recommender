//
//  Review.swift
//  Wild Route
//
//  Created by THOMAS GRAY on 05/02/2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Rating: Codable, Identifiable {
    @DocumentID var id: String?
    var location: String
    var user: String
    var score: Int
    @ServerTimestamp var timeCreated: Timestamp?
}
