//
//  APIManager.swift
//  ContactProject
//
//  Created by 남지연 on 7/17/24.
//

import Foundation
import UIKit

//MARK: - 네트워크에서 발생에러
enum NetworkError: Error {
    case invalidURL
    case networkingError(Error)
    case dataError
    case parseError(Error)
}


final class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    // 랜덤 포켓몬 이미지 데이터
    private func getRandomImageData() async throws -> Data {
        let randomId = Int.random(in: 1...1000)
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(randomId)"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let sprites = jsonObject["sprites"] as? [String: Any],
              let frontImageUrlString = sprites["front_default"] as? String,
              let frontImageUrl = URL(string: frontImageUrlString) else {
            throw NetworkError.parseError(NSError(domain: "Invalid JSON response", code: -1, userInfo: nil))
        }
        
        let (imageData, _) = try await URLSession.shared.data(from: frontImageUrl)
        
        return imageData
    }
    
    // UIImage 로드
    public func loadImageData(data: Data) async throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw NetworkError.dataError
        }
        return image
    }
    
    // 랜덤 포켓몬 이미지
    public func loadRandomPokemonImage() async throws -> UIImage {
        let imageData = try await getRandomImageData()
        let image = try await loadImageData(data: imageData)
        return image
    }
    
    
}

