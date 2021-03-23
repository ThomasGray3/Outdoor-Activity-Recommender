//
//  ContentFilter.swift
//  Wild Route
//
//  Created by THOMAS GRAY on 16/03/2021.
//

import SwiftUI

struct Cfilter {
    
    
    
    func calculate(pref: FetchedResults<UserPreference>, places: [[LandmarkDB]]) -> [(type: String, value: Double)]{
        var matrix = [Double()]
        var userMatrix = [Double()]
        var filteredMatrix:[(type: String, value: Double)] = []
        var total = 0.0
        userMatrix.removeAll()
        for item in pref {
            userMatrix.append(item.score)
        }
        print(userMatrix)
        
        total = userMatrix.reduce(1,*)
        
        print(places.count)
       
        for j in 0..<places.count {
            var none = 0
            for i in 0..<pref.count {

                if places[j][0].type == pref[i].activity {
                    print(pref[i].score)
                    filteredMatrix.append((type: places[j][0].type, value: total*(pref[i].score+1)))
                    none+=1
                }
                if i == pref.count-1 && none == 0 {
                    filteredMatrix.append((type: places[j][0].type, value: total))
                }
            }
        }
        matrix.removeAll()
        for i in 0..<filteredMatrix.count {
            matrix.append(filteredMatrix[i].value)
        }
        let min = matrix.min() ?? 0.0
        let max = matrix.max() ?? 0.0
        let results = matrix.map { ($0 - min ) / (max - min ) }
        
        for i in 0..<results.count {
            filteredMatrix[i].value = (results[i] * 4).rounded()
        }
        
        filteredMatrix.sort(by: { ($0.value < $1.value) })
        filteredMatrix.reverse()
        print(filteredMatrix)
        return filteredMatrix
    }
}
