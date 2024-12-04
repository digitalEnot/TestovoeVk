//
//  ComicBookVC.swift
//  TestovoeVk
//
//  Created by Evgeni Novik on 03.12.2024.
//

import UIKit

protocol ComicBookDelegate: AnyObject {
    func didPressedDeleteButton(deleteItem: ComicBook, indexPath: Int)
    func didPressedSaveButton(comicBook: ComicBook)
}

final class ComicBookVC: UIViewController {
    
    private let titleLabel = UILabel()
    private let titleTextField = TVKTextField()
    private let descriptionLabel = UILabel()
    private let saveButton = UIButton()
    private let indexPath: Int
    private let comicBook: ComicBook
    private var descriptionTextField: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 8.0
        tv.layer.borderColor = UIColor(.black).cgColor
        tv.layer.borderWidth = 2
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()
    
    
    weak var delegate: ComicBookDelegate?
    
   
    init(comicBook: ComicBook, indexPath: Int) {
        self.comicBook = comicBook
        self.titleTextField.text = comicBook.title
        self.descriptionTextField.text = comicBook.description
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavItems()
    }
    
    private func configureNavItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(deleteComicBook))
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(descriptionTextField)
        
        view.addSubview(titleLabel)
        titleLabel.text = "Заголовок"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(descriptionLabel)
        descriptionLabel.text = "Описание"
        descriptionLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        var signUpConfiguration = UIButton.Configuration.filled()
        signUpConfiguration.title = "Сохранить"
        signUpConfiguration.cornerStyle = .medium
        signUpConfiguration.baseBackgroundColor = .blue
        signUpConfiguration.baseForegroundColor = .systemBackground
        signUpConfiguration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            return outgoing
        }
        saveButton.configuration = signUpConfiguration
        saveButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 40),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 300),
            
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            saveButton.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    @objc func buttonPressed() {
        delegate?.didPressedSaveButton(comicBook: ComicBook(uniqueID: comicBook.uniqueID, title: titleTextField.text ?? "", text: descriptionTextField.text ?? ""))
        navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteComicBook() {
        delegate?.didPressedDeleteButton(deleteItem: comicBook, indexPath: indexPath)
        navigationController?.popViewController(animated: true)
    }
}
