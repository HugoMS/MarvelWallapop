import Foundation

struct CharacterDataModel {
  let id: Int
  let name: String
  let characterDescription: String?
  let thumbnail: Thumbnail
  
  init(id: Int,
       name: String,
       characterDescription: String? = nil,
       thumbnail: Thumbnail) {
    self.id = id
    self.name = name
    self.characterDescription = characterDescription
    self.thumbnail = thumbnail
  }
}

// MARK: - Codable

extension CharacterDataModel: Codable {
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case characterDescription = "description"
    case thumbnail
  }
}

extension CharacterDataModel: DomainMapper {
  func toDomain() -> Character {
    return Character(id: id,
                     name: name,
                     description: characterDescription,
                     thumbnailURL: thumbnail.url)
  }
}

