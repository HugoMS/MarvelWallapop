import Foundation

protocol APIClientProtocol {
  func getHeroes(from offset: Int, by searchKey: String?) async throws -> BaseResponseModel<PaginatedResponseModel<CharacterDataModel>>
  func getHeroData(by characterId: Int, from offset: Int, type: HeroDataType)  async throws -> BaseResponseModel<PaginatedResponseModel<HeroDataModel>>
}

enum APIConstants {
  static let defaultLimit = 100
}

enum NetworkError: LocalizedError {
  case networkError(URLError)
  case invalidServerResponse
  case decodingError(DecodingError)
  case badURL
}


final class APIClient: APIClientProtocol {
  enum Constant {
    static let privateKey = "188f9a5aa76846d907c41cbea6506e4cc455293f"
    static let publicKey = "d575c26d5c746f623518e753921ac847"
  }
  
  private let baseURL = "https://gateway.marvel.com/v1/public/characters" 
  
  private func generateAuthParameters() -> [String: String] {
    let ts = String(Int(Date().timeIntervalSince1970))
    let hash = "\(ts)\(Constant.privateKey)\(Constant.publicKey)".md5
    return [
      "apikey": Constant.publicKey,
      "ts": ts,
      "hash": hash
    ]
  }
  
  private func getURLComponents(endpoint: String, offset: Int) throws -> URLComponents {
    guard var urlComponents = URLComponents(string: endpoint) else { throw NetworkError.badURL }
    urlComponents.queryItems = generateAuthParameters().map { URLQueryItem(name: $0.key, value: $0.value) }
    urlComponents.queryItems?.append(URLQueryItem(name: "offset", value: "\(offset)"))
    urlComponents.queryItems?.append(URLQueryItem(name: "limit", value: APIConstants.defaultLimit.description))
    return urlComponents
  }
    
  init() { }
  
  func getHeroes(from offset: Int, by searchKey: String?) async throws -> BaseResponseModel<PaginatedResponseModel<CharacterDataModel>> {
    let endpoint = "\(baseURL)"
    let urlComponents = try getURLComponents(endpoint: endpoint, offset: offset)
    guard let url = urlComponents.url else { throw NetworkError.badURL }
    return try await fetchData(from: url)
  }
  
  
  func getHeroData(by characterId: Int, from offset: Int, type: HeroDataType)  async throws -> BaseResponseModel<PaginatedResponseModel<HeroDataModel>> {
    let endpoint = "\(baseURL)/\(characterId)/\(type.path)"
    let urlComponents = try getURLComponents(endpoint: endpoint, offset: offset)
    guard let url = urlComponents.url else { throw NetworkError.badURL }
    return try await fetchData(from: url)
  }
  
  private func fetchData<T: Decodable>(from url: URL) async throws -> T {
    do {
      let (data, response) = try await URLSession.shared.data(from: url)
      
      guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw NetworkError.invalidServerResponse
      }
      
      let decodedResponse = try JSONDecoder().decode(T.self, from: data)
      return decodedResponse
    }
    catch let urlError as URLError {
      throw NetworkError.networkError(urlError)
    } catch let decodingError as DecodingError {
      throw NetworkError.decodingError(decodingError)
      
    }
  }
}
  
  
