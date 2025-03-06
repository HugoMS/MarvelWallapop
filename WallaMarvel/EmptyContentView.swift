//
//  EmptyContentView.swift
//  
//
//  Created by Hugo Morelli on 6/3/25.
//

import Foundation
import UIKit

protocol EmptyContentViewProtocol: AnyObject {
  func didTapReload()
}

final class EmptyContentView: UIView {
  
  weak var delegate: EmptyContentViewProtocol?
  
  private let messageLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 0
    label.font = .systemFont(ofSize: 20, weight: .medium)
    label.textColor = .label
    return label
  }()
  
  private let emptyImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.layer.cornerRadius = 16
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "image")
    return imageView
  }()
  
  private let reloadButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Reload", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .systemRed
    button.layer.cornerRadius = 8
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  init(delegate: EmptyContentViewProtocol?) {
    self.delegate = delegate
    super.init(frame: .zero)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }
  
  private func setupUI() {
    addSubview(messageLabel)
    addSubview(emptyImageView)
    addSubview(reloadButton)
    backgroundColor = .systemBackground
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    reloadButton.translatesAutoresizingMaskIntoConstraints = false
    
    messageLabel.text = "Oops! Looks like your heroes are missing!. Please try again."
    
    NSLayoutConstraint.activate([
      messageLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
      messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      
      emptyImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      emptyImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      emptyImageView.heightAnchor.constraint(equalToConstant: 300),
      
      reloadButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
      reloadButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      reloadButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      reloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      reloadButton.heightAnchor.constraint(equalToConstant: 44)
    ])
    
    reloadButton.addTarget(self, action: #selector(reloadTapped), for: .touchUpInside)
  }
  
  @objc private func reloadTapped() {
    delegate?.didTapReload()
  }
}
