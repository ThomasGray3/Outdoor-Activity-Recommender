//
//  ReviewStructure.swift
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


class RatingStructure: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var ratings = [Rating]()
    
    init() {
        loadDatabase()
    }
    
    func loadDatabase() {
        db.collection("rating").order(by: "timeCreated").addSnapshotListener { (query, error) in
            if let query = query {
                self.ratings = query.documents.compactMap { document in
                    do {
                        let x = try document.data(as: Rating.self)
                        return x
                    } catch {
                        print(error)
                    }
                    return nil
                }
            }
        }
    }
    
    func addRating(_ rating: Rating) {
        do {
            let _ = try db.collection("rating").addDocument(from: rating)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
