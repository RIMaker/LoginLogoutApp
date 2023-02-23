//
//  LLButton.swift
//  LoginLogoutApp
//
//  Created by Zhora Agadzhanyan on 23.02.2023.
//

import UIKit

class LLButton: UIButton {

   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        setTitleColor(.white, for: .normal)
        backgroundColor = .orange
        layer.cornerRadius = 20
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder) is not implemented")
    }
}
