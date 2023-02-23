//
//  ProfileViewController.swift
//  LoginLogoutApp
//
//  Created by Zhora Agadzhanyan on 23.02.2023.
//

import UIKit

protocol ProfileViewController: AnyObject {
    func setup()
    func changeName(with text: String)
}

class ProfileViewControllerImpl: UIViewController, ProfileViewController {
    
    var presenter: ProfilePresenter?
    
    private lazy var userName: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.font = .boldSystemFont(ofSize: 20)
        return lbl
    }()
    
    private lazy var signInButton: LLButton = {
        let btn = LLButton()
        btn.setTitle(Constants.signOutButtonTitle.rawValue, for: .normal)
        btn.addTarget(self, action: #selector(tappedOnSignOutButton), for: .touchUpInside)
        return btn
    }()
    
    private lazy var profileElementsStackView: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [
            userName,
            signInButton
        ])
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.spacing = 50
        vStack.distribution = .equalSpacing
        vStack.alignment = .center
        vStack.axis = .vertical
        vStack.backgroundColor = .systemBackground
        return vStack
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewShown()
    }
    
    func setup() {
        view.addSubview(profileElementsStackView)
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            profileElementsStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            profileElementsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileElementsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileElementsStackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            userName.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            
            signInButton.heightAnchor.constraint(equalToConstant: 40),
            signInButton.widthAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    func changeName(with text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.userName.text = text
        }
    }

    @objc
    private func tappedOnSignOutButton(_ sender: UIButton) {
        presenter?.signOut()
    }
}
