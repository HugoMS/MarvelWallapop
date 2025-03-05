import Foundation

protocol APIClientProtocol {
  func getHeroes(from offset: Int, by searchKey: String?) async throws -> BaseResponseModel<PaginatedResponseModel<CharacterDataModel>>
  func getHeroData(by characterId: Int, from offset: Int, type: HeroDataType)  async throws -> BaseResponseModel<PaginatedResponseModel<HeroDataModel>>
}

enum APIConstants {
  static let defaultLimit = 100
}

final class APIClient: APIClientProtocol {
    enum Constant {
        static let privateKey = "188f9a5aa76846d907c41cbea6506e4cc455293f"
        static let publicKey = "d575c26d5c746f623518e753921ac847"
    }
  
  private let baseURL = "https://gateway.marvel.com/v1/public/characters"
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
    let endpoint = "\(baseURL)"
    var urlComponents = URLComponents(string: endpoint)
    urlComponents?.queryItems = generateAuthParameters().map { URLQueryItem(name: $0.key, value: $0.value) }
    urlComponents?.queryItems?.append(URLQueryItem(name: "offset", value: "\(offset)"))
    urlComponents?.queryItems?.append(URLQueryItem(name: "limit", value: APIConstants.defaultLimit.description))
    guard let url = urlComponents?.url else { throw URLError(.badURL) }
    return try await fetchData(from: url)
  }
  
  
  func getHeroData(by characterId: Int, from offset: Int, type: HeroDataType)  async throws -> BaseResponseModel<PaginatedResponseModel<HeroDataModel>> {
    let endpoint = "\(baseURL)/\(characterId)/\(type.path)"
    var urlComponents = URLComponents(string: endpoint)
    urlComponents?.queryItems = generateAuthParameters().map { URLQueryItem(name: $0.key, value: $0.value) }
    urlComponents?.queryItems?.append(URLQueryItem(name: "offset", value: "\(offset)"))
    urlComponents?.queryItems?.append(URLQueryItem(name: "limit", value: APIConstants.defaultLimit.description))
    guard let url = urlComponents?.url else { throw URLError(.badURL) }
    return try await fetchData(from: url)
  }
  
  private func fetchData<T: Decodable>(from url: URL) async throws -> T {
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw URLError(.badServerResponse)
    }
    
    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
    return decodedResponse
  }
}
