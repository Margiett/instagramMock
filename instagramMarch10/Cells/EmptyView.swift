//
//  EmptyView.swift
//  instagramMarch10
//
//  Created by Margiett Gil on 5/1/20.
//  Copyright © 2020 Margiett Gil. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    private lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.preferredFont(forTextStyle: .headline)
            label.numberOfLines = 1
            label.textAlignment = .center
            return label
        }()
        
        private lazy var msgLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.preferredFont(forTextStyle: .subheadline)
            label.numberOfLines = 1
            label.textAlignment = .center
            return label
        }()

        
        init(title: String, message: String) {
            super.init(frame: UIScreen.main.bounds)
            titleLabel.text = title
            msgLabel.text = message
            commonInit()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }
        
        private func commonInit() {
            setupMsgConstaints()
            setUptitleConstraints()
            
        }
        
        private func setupMsgConstaints() {
            addSubview(msgLabel)
            msgLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                msgLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                msgLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                msgLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                msgLabel.trailingAnchor.constraint(equalTo: leadingAnchor, constant: -8)
            ])
        }
        
        private func setUptitleConstraints() {
            addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                titleLabel.bottomAnchor.constraint(equalTo: msgLabel.topAnchor, constant: -8),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
                
            ])
        }
        

    }

