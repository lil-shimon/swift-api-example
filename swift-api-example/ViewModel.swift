//
//  ViewModel.swift
//  swift-api-example
//
//  Created by 下澤健太 on 2022/03/13.
//

import Foundation
import SwiftUI

// Course Structure
struct Course: Hashable, Codable {
    let name: String
    let image: String
}

class ViewModel: ObservableObject {
    // stateみたいなもん
    // 変更をUIに通知できる
    @Published var courses: [Course] = []
    
    func fetch() {
        
        /// api url
        guard let url = URL(string:
                                "https://iosacademy.io/api/v1/courses/index.php") else {
            return
        }
        
        // call api
        let task = URLSession.shared.dataTask(with: url) { [weak self]data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                /// Json decord
                let courses = try JSONDecoder().decode([Course].self, from: data)
                
                /// Queue for ui update
                DispatchQueue.main.async {
                    self?.courses = courses
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
}

