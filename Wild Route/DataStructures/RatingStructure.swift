//
//  ReviewStructure.swift
//  Wild Route
//
//  Created by THOMAS GRAY on 05/02/2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Rating: Codable, Identifiable {
    @DocumentID var id: String?
    var location: String
    var user: String
    var score: Int
    @ServerTimestamp var timeCreated: Timestamp?
}

struct Favourite: Codable, Identifiable {
    @DocumentID var id: String?
    var location: String
    var user: String
}

struct LandmarkDB: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    var type: String
}



class RatingStructure: ObservableObject {
    
    let db = Firestore.firestore()
    
    var ratings = [Rating]()
    var favourites = [Favourite]()
    var landmark = [LandmarkDB]()
    
    func loadRatings(completion: @escaping ([Rating])-> Void) {
        if let userId = Auth.auth().currentUser?.uid {
            db.collection("rating").whereField("user", isEqualTo: userId).addSnapshotListener { (query, error) in
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
                    completion(self.ratings)
                }
            }
        }
    }
    
    func loadFavs(completion: @escaping ([Favourite])-> Void) {
        if let userId = Auth.auth().currentUser?.uid {
            db.collection("favourite").whereField("user", isEqualTo: userId).addSnapshotListener { (query, error) in
                if let query = query {
                    self.favourites = query.documents.compactMap { document in
                        do {
                            let x = try document.data(as: Favourite.self)
                            print("got them")
                            return x
                        } catch {
                            print(error)
                        }
                        return nil
                    }
                    completion(self.favourites)
                }
            }
        }
    }
    
    func loadOneFav(loc: String, completion: @escaping ([Favourite])-> Void) {
        if let userId = Auth.auth().currentUser?.uid {
            db.collection("favourite").whereField("user", isEqualTo: userId).whereField("location", isEqualTo: loc).addSnapshotListener { (query, error) in
                if let query = query {
                    self.favourites = query.documents.compactMap { document in
                        do {
                            let x = try document.data(as: Favourite.self)
                            print("got it")
                            return x
                        } catch {
                            print(error)
                        }
                        return nil
                    }
                    completion(self.favourites)
                }
            }
        }
    }
    
    
    func removeFavourite(fav: Favourite, completion: @escaping (Bool)-> Void) {
        if let favID = fav.id {
            do {
                let _ =  db.collection("favourite").document(favID).delete()
                print("REMOVED fav")
                completion(true)
            }
        }
    }
    
    
    func removeRating(rating: Rating, completion: @escaping (Bool)-> Void) {
        if let ratingID = rating.id {
            do {
                let _ =  db.collection("rating").document(ratingID).delete()
                print("REMOVED rating")
                completion(true)
            }
        }
    }
    
    
    func addFavourite(location: String) {
        if let userId = Auth.auth().currentUser?.uid {
            let fav = Favourite(location: location, user: userId)
            do {
                let _ = try db.collection("favourite").addDocument(from: fav)
                print("SUCCESS favourite")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func addLandmark(landmark: LandmarkDB) {
        db.collection("landmark").whereField("name", isEqualTo: landmark.name).getDocuments { (document, error) in
            if let document = document {
                if !document.isEmpty {
                    print("exists")
                } else {
                    print("Document does not exist")
                    do {
                        let _ = try self.db.collection("landmark").addDocument(from: landmark)
                        print("SUCCESS landmark")
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    
    func loadLandmark(location: String, completion: @escaping ([LandmarkDB]) -> ()){
        
        db.collection("landmark").whereField("name", isEqualTo: location).addSnapshotListener { (query, error) in
            if let query = query {
                self.landmark = query.documents.compactMap { document in
                    do {
                        let x = try document.data(as: LandmarkDB.self)
                        print("got place")
                        return x
                    } catch {
                        print(error)
                    }
                    return nil
                }
                completion(self.landmark)
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
    
    func getAverage(location: String, completion: @escaping ([Rating])-> Void) {
        
        let location = location
        
        db.collection("rating").whereField("location", isEqualTo: location).addSnapshotListener { (query, error) in
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
                completion(self.ratings)
            }
        }
    }
    
    func addReview(rating: Rating) {
        do {
            let _ = try db.collection("rating").addDocument(from: rating)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateReview(rating: Rating) {
        db.collection("rating").document(rating.id!).getDocument { (document, err) in
            if let err = err {
                print(err.localizedDescription)
            }
            else {
                document?.reference.updateData([
                    "score": rating.score
                ])
                print("UPDATED")
            }
        }
    }
}
