//
//  APIManager.swift
//  BitcoinNews
//
//  Created by VitaliyShurin on 19.08.2020.
//  Copyright © 2020 VitaliyShurin. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - SortedBy

enum SortedBy: String {
    case relevancy
    case popularity
    case publishedAt
}

final class APIManager {
    
    // MARK: - Constants

    private struct Constants {
        static let contentTypeAppJson = ["Content-Type": "application/json"]
        static let wrongMessage = "Something went wrong."
        static let decodeDataMessage = "Can't decode data."
        static let responseCodeMessage = "Response with status code: "
        static let noNewsYetToday = "no news yet today"
    }
    
    // MARK: - URLs
    
    enum URLs {
        static let baseURL = "http://newsapi.org/v2/everything?q=bitcoin"
        static let fromDate = "&from="
        static let toDate = "&to="
        static let sortBy = "&sortBy="
        static let apiKey = "&apiKey=ce8ab28bb8df456d99f98cfcdae07dc6"
    }

    // MARK: - Properties
    
    static let shared = APIManager()
    
    // MARK: - Init

    private init() { }
    
    // MARK: - News API
    
    func getMyPathModel(fromDate: Date, toDate: Date, sortedBy: SortedBy, completion: @escaping(_ result: Result<NewsModel, Error>) -> Void) {
        cancelTasks()
        let url = getStringURL(fromDate: fromDate, toDate: toDate, sortedBy: sortedBy)
        request(for: url, parameters: Constants.contentTypeAppJson, completion: completion)
    }
    
    // MARK: - Requests
    
    private func request<T: Codable>(for url: String, parameters: [String: String] = [:], method: HTTPMethod = .get, completion: @escaping(_ result: Result<T, Error>) -> Void) {
        guard var request = try? URLRequest(url: url, method: method) else {
            let error = NSError.error(with: Constants.wrongMessage)
            completion(.failure(error))
            return
        }
        request.httpMethod = method.rawValue
        request.headers = HTTPHeaders(parameters)
        AF.request(request).responseData { [weak self] (response) in
            guard let self = self else {
                let error = NSError.error(with: Constants.wrongMessage)
                completion(.failure(error))
                return
            }
            completion(self.processResponse(response))
        }
    }
    
    // MARK: - Helpers
    
    private func getStringURL(fromDate: Date, toDate: Date, sortedBy: SortedBy) -> String {
        return URLs.baseURL + URLs.fromDate + FormatHelper.dateToString(from: fromDate) +
        URLs.toDate + FormatHelper.dateToString(from: toDate) + URLs.sortBy + sortedBy.rawValue + URLs.apiKey
    }
    
    private func cancelTasks() {
        Alamofire.Session.default.session.getTasksWithCompletionHandler { (_, _, downloadData) in
            downloadData.forEach { $0.cancel() }
        }
    }
    
    private func processResponse<T: Codable>(_ response: AFDataResponse<Data>) -> Result<T, Error> {
        let result: Result<T, Error> = self.dataDecoder(response.data)
        switch result {
        case .success(let object):
            return .success(object)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    private func dataDecoder<T: Codable>(_ data: Data?) -> Result<T, Error> {
        guard let data = data else {
            return .failure(NSError.error(with: Constants.decodeDataMessage))
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(FormatHelper.dateFormatter())
        do {
            let object = try decoder.decode(T.self, from: data)
            return .success(object)
        } catch {
            print(error.localizedDescription)
            return .failure(NSError.error(with: Constants.decodeDataMessage))
        }
    }
}
