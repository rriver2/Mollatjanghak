//
//  HTTPUtils.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import SwiftUI

struct HTTPUtils {
    //FIXME: conFig에서 불러오게 코드 수정해야 함
    
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
    
    static func getURL(urlBack: String, parameter: String) async throws -> (data: Data, response: HTTPURLResponse) {
        do {
            guard let urlFront = urlFront,
                  let url = URL(string: urlFront + urlBack + parameter) else { throw URLError(.badURL)}
            var request = URLRequest(url: url)
            
            request.httpMethod = "GET"
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw URLError(.unknown)
            }
            return (data: data, response: response)
        } catch {
            throw error
        }
    }
    // 사용자 정보 ( 디바이스 고유넘버 )
    static func getDeviceUUID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
}
