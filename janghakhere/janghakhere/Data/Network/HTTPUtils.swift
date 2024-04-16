//
//  HTTPUtils.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import Foundation

struct HTTPUtils {
    static let urlFront: String? = Utils.getConfig(key: "urlFront", type: String.self)
    
    static func postURL<T: Encodable>(postStruct: T, urlBack: String) async throws -> (data: Data, response: HTTPURLResponse) {
        do {
            guard let urlFront = urlFront,
                  let url = URL(string: urlFront + urlBack) else { throw URLError(.badURL)}
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            
            let postData = try JSONEncoder().encode(postStruct)
            request.httpBody = postData
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw URLError(.unknown)
            }
            
            return (data: data, response: response)
        } catch {
            throw error
        }
    }
    
    static func getURL<T: Encodable>(parameter: T?, urlBack: String, header: (field: String, value: String)?) async throws -> (data: Data, response: HTTPURLResponse) {
        do {
            guard let urlFront = urlFront,
                  let url = URL(string: urlFront + urlBack) else { throw URLError(.badURL)}
            var request = URLRequest(url: url)
            
            request.httpMethod = "GET"
            if let parameter = parameter {
                let parameterData = try JSONEncoder().encode(parameter)
                request.httpBody = parameterData
            }
            
            if let header = header {
                request.setValue(header.value, forHTTPHeaderField: header.field)
            }
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw URLError(.unknown)
            }
            return (data: data, response: response)
        } catch {
            throw error
        }
    }
}
