import Foundation
import UIKit
import Kingfisher

final class ListHeroesTableViewCell: UITableViewCell {
  
  private let heroImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleToFill
    imageView.layer.cornerRadius = 16
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private let overlayView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let heroeName: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    label.textColor = .white
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.backgroundColor = .clear
    
    contentView.addSubview(heroImageView)
    heroImageView.addSubview(overlayView)
    overlayView.addSubview(heroeName)
    
    NSLayoutConstraint.activate([
      heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      heroImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
      heroImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      heroImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 250),
      heroImageView.widthAnchor.constraint(equalToConstant: 200),
      
      overlayView.leadingAnchor.constraint(equalTo: heroImageView.leadingAnchor),
      overlayView.trailingAnchor.constraint(equalTo: heroImageView.trailingAnchor),
      overlayView.bottomAnchor.constraint(equalTo: heroImageView.bottomAnchor),
      
      heroeName.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 5),
      heroeName.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -5),
      heroeName.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
      heroeName.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
      heroeName.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -5)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func configure(model: Character) {
    heroImageView.kf.setImage(with: model.thumbnailURL)
    heroeName.text = model.name
  }
}
