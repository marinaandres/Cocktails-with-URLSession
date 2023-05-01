//
//  Networking.swift
//  Cocktails with URLSession
//
//  Created by Marina Andrés Aragón on 1/5/23.
//

import Foundation

final class Networking {
    
    static let shared = Networking()
    
    let baseURL = "https://www.thecocktaildb.com/api/json/v1/1/"
    
    func searchCocktails(name: String, success: @escaping (_ drinks: [Drink]) -> (), failure: @escaping (_ error: Error?) -> ()) {
        let urlString = "\(baseURL)search.php?s=\(name)"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    failure(error)
                    return
                }
                
                guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    failure(NSError(domain: "NetworkingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let drinks = try decoder.decode(Cocktails.self, from: data)
                    success(drinks.drinks)
                } catch {
                    failure(error)
                }
            }.resume()
        } else {
            failure(NSError(domain: "NetworkingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }
    }
}
