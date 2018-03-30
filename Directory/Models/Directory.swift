//
//  Directory.swift
//  Directory
//
//  Created by Abraham Done on 3/22/18.
//  Copyright © 2018 Abraham Done. All rights reserved.
//

import Foundation

import Alamofire

enum NetworkError: Error {
    case badData
}

struct Directory: Decodable {
    // force unwrap justification: The url must parse or the app must fail as well
    private static var directoryUrl: URL = URL(string: "https://edge.ldscdn.org/mobile/interview/directory")!
    
    let individuals: [Individual]
    
    static func fetch(forceReload: Bool, success: @escaping ((Directory) -> ()), failure: @escaping ((Error) -> ())) {
        let individuals = Individual.savedData
        
        guard individuals.count == 0 || forceReload else {
            let direcory = Directory(individuals: individuals)
            success(direcory)
            return
        }
        
        Alamofire.request(directoryUrl).responseJSON { response in
            guard let data = response.data else {
                failure(NetworkError.badData)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let directory = try decoder.decode(Directory.self, from: data)
                success(directory)
            } catch let error {
                failure(error)
            }
        }
    }
}
