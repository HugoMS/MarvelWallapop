import Foundation

protocol APIClientProtocol {
  func getHeroes(from offset: Int, by searchKey: String?) async throws -> BaseResponseModel<PaginatedResponseModel<CharacterDataModel>>
}

final class APIClient: APIClientProtocol {
    enum Constant {
        static let privateKey = "188f9a5aa76846d907c41cbea6506e4cc455293f"
        static let publicKey = "d575c26d5c746f623518e753921ac847"
    }
  
  private let baseURL = "https://gateway.marvel.com/v1/public"
  private let publicKey = Constant.publicKey
  private let privateKey = Constant.privateKey
  
  private func generateAuthParameters() -> [String: String] {
    let ts = String(Int(Date().timeIntervalSince1970))
    let hash = "\(ts)\(privateKey)\(publicKey)".md5
    return [
      "apikey": publicKey,
      "ts": ts,
      "hash": hash
    ]
  }
    
    init() { }
  
  func getHeroes(from offset: Int, by searchKey: String?) async throws -> BaseResponseModel<PaginatedResponseModel<CharacterDataModel>> {
    let endpoint = "\(baseURL)/characters"
    return try await fetchData(from: endpoint)
  }
  
  private func fetchData<T: Decodable>(from urlString: String) async throws -> T {
    var urlComponents = URLComponents(string: urlString)
    urlComponents?.queryItems = generateAuthParameters().map { URLQueryItem(name: $0.key, value: $0.value) }
    
    guard let url = urlComponents?.url else { throw URLError(.badURL) }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw URLError(.badServerResponse)
    }
    
    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
    return decodedResponse
  }
    
//  func getHeroes(from offset: Int, by searchKey: String?) async throws -> BaseResponseModel<PaginatedResponseModel<CharacterDataModel>> {
//        let ts = String(Int(Date().timeIntervalSince1970))
//        let privateKey = Constant.privateKey
//        let publicKey = Constant.publicKey
//        let hash = "\(ts)\(privateKey)\(publicKey)".md5
//        let parameters: [String: String] = ["apikey": publicKey,
//                                            "ts": ts,
//                                            "hash": hash]
//        
//        let endpoint = "https://gateway.marvel.com:443/v1/public/characters"
//        var urlComponent = URLComponents(string: endpoint)
//        urlComponent?.queryItems = parameters.map { (key, value) in
//            URLQueryItem(name: key, value: value)
//        }
//        
//        let urlRequest = URLRequest(url: urlComponent!.url!)
//        
//        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//            let dataModel = try! JSONDecoder().decode(CharacterDataContainer.self, from: data!)
//            completionBlock(dataModel)
//            print(dataModel)
//        }.resume()
//    }
}
