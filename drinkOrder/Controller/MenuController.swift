//
//  Transmission.swift
//  drinkOrder
//
//  Created by Jube on 2023/1/14.
//

import Foundation
import UIKit

class MenuController {
    static let shared = MenuController()
    
    let baseUrl = URL(string: "https://api.airtable.com/v0/appdWBgA90KG0CsDY")!
    //暫存圖片
    var imageCache = NSCache<NSURL, UIImage>()
    
    func getImage(url: URL?, completion: @escaping (UIImage?)->Void) {
        if let imageUrl = url {
            if let imageCached = imageCache.object(forKey: imageUrl as NSURL) {
                completion(imageCached)
                return
            }
            URLSession.shared.dataTask(with: imageUrl) { data, urLResponse, error in
                if let data, let image = UIImage(data: data) {
                    self.imageCache.setObject(image, forKey: imageUrl as NSURL)
                    completion(image)
                }else {
                    completion(nil)
                }
            }.resume()
        }
    }
    
    func fetchMenu(completion: @escaping (Result<[Item], NetworkError>) -> Void) {
        let newBaseUrl = baseUrl.appendingPathComponent("DrinkMenu")
        var component = URLComponents(url: newBaseUrl, resolvingAgainstBaseURL: true)
        component?.queryItems = [URLQueryItem(name: "sort[][field]", value: "genre"),
                                 URLQueryItem(name: "sort[][direction]", value: "asc"),
                                 URLQueryItem(name: "api_key", value: "keygO9mRKCJniMkNL")]
        if let url = component?.url{
            URLSession.shared.dataTask(with: url) { data, urLResponse, error in
                if let data {
                    let decoder = JSONDecoder()
                    do {
                        let menu = try decoder.decode(MenuResponse.self, from: data)
                        completion(.success(menu.records))
                    }catch{
                        completion(.failure(.jsonDecodeFailed))
                    }
                } else {
                    completion(.failure(.requestFailed))
                }
            }.resume()
        } else {
            completion(.failure(.invalidUrl))
        }
    }
    
    func uploadOrder(list: OrderPost, completion: @escaping (Result<[ListResponse], NetworkError>) -> Void){
        let newBaseUrl = baseUrl.appendingPathComponent("Order")
        var urlReuest = URLRequest(url: newBaseUrl)
        urlReuest.httpMethod = "POST"
        urlReuest.setValue("Bearer keygO9mRKCJniMkNL", forHTTPHeaderField: "Authorization")
        urlReuest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        urlReuest.httpBody = try? encoder.encode(list)
        
        URLSession.shared.dataTask(with: urlReuest) { data, urlresponse, error in
            if let data {
                do {
                    let decoder = JSONDecoder()
                    let orderResponse = try decoder.decode(OrderResponse.self, from: data)
                    let orderList = orderResponse.records
                    completion(.success(orderList))
                } catch {
                    completion(.failure(.jsonDecodeFailed))
                }
            } else {
                completion(.failure(.requestFailed))
            }
        }.resume()
    }
}
