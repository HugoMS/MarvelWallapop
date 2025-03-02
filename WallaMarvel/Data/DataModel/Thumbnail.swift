import Foundation

struct Thumbnail {
    let path: String?
    let thumbnailExtension: String?
  
  var url: URL? {
    guard let path, let ext = thumbnailExtension else { return nil }
    return URL(string: "\(path).\(ext)")
  }
}

// MARK: - Codable

extension Thumbnail: Codable {
  enum CodingKeys: String, CodingKey {
    case path
    case thumbnailExtension = "extension"
  }
}

