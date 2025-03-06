import Foundation
import UIKit
import Kingfisher

final class ListHeroesTableViewCell: UITableViewCell {
  private let heroeImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.cornerRadius = 40
    imageView.layer.masksToBounds = true
    return imageView
  }()
  
  private let heroeName: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    addSubviews()
    addContraints()
  }
  
  private func addSubviews() {
    addSubview(heroeImageView)
    addSubview(heroeName)
  }
  
  private func addContraints() {
    NSLayoutConstraint.activate([
      heroeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
      heroeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
      heroeImageView.heightAnchor.constraint(equalToConstant: 80),
      heroeImageView.widthAnchor.constraint(equalToConstant: 80),
      heroeImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12),
      
      heroeName.leadingAnchor.constraint(equalTo: heroeImageView.trailingAnchor, constant: 20),
      heroeName.centerYAnchor.constraint(equalTo: heroeImageView.centerYAnchor),
    ])
  }
  
  func configure(model: Character) {
    heroeImageView.kf.setImage(with: model.thumbnailURL)
    heroeName.text = model.name
  }
}
