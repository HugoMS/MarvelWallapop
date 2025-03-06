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
    label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    label.textColor = .gray
    return label
  }()
  
  private let reloadButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Reload", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
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
    addSubview(reloadButton)
    backgroundColor = .systemBackground
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    reloadButton.translatesAutoresizingMaskIntoConstraints = false
    
    messageLabel.text = "Oops! Looks like your heroes are missing!. Please try again."
    
    NSLayoutConstraint.activate([
      messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
      messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      
      reloadButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
      reloadButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      reloadButton.widthAnchor.constraint(equalToConstant: 120),
      reloadButton.heightAnchor.constraint(equalToConstant: 44)
    ])
    
    reloadButton.addTarget(self, action: #selector(reloadTapped), for: .touchUpInside)
  }
  
  @objc private func reloadTapped() {
    delegate?.didTapReload()
  }
}
