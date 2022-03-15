//
//  MarvelAPI.swift
//  HeroisMarvel
//
//  Created by Rodrigo Eduardo Silva on 11/03/22.
//  Copyright © 2022 Eric Brito. All rights reserved.
//

import Foundation
import SwiftHash
import Alamofire


class MaervelAPI{
    
    static private let basePath = "https://gateway.marvel.com/v1/public/characters?"
    static private let privateKey = "52fe30afbefa627d7895f52e50f0d6bdc6e7e78e"
    static private let publicKey = "4a22a2b5550e013268e380a5ae39fb20"
    static private let limit = 50
    
    class func loadHeros(name: String?, page : Int, onComplete: @escaping (MarvelInfo?) -> Void ){
        let offset = page * limit
        let startWith: String
        if let name = name , !name.isEmpty {
            startWith = "nameStartsWith=\(name.replacingOccurrences(of: " ", with: ""))&"
        }else{
            startWith = ""
        }
        let url = basePath + "offset=\(offset)&limit=\(limit)&" + startWith + getCredentials()
        print(url)
        
        AF.request(url).responseDecodable(of: MarvelInfo.self) { response in
               guard let data = response.data,
                  let marvelInfo = try? JSONDecoder().decode(MarvelInfo.self, from: data)else{
                onComplete(nil)
                return
            }
            onComplete(marvelInfo)
        }
    }

    private class func getCredentials()-> String{
        let ts = String(Date().timeIntervalSince1970)
        print(ts)
        let hash = MD5(ts + privateKey + publicKey).lowercased()
        return "ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
    }
}
