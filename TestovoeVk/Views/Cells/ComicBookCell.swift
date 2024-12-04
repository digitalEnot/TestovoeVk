//
//  ComicBookCell2.swift
//  TestovoeVk
//
//  Created by Evgeni Novik on 03.12.2024.
//

import UIKit

final class ComicBookCell: UITableViewCell {
    static let reuseID = "MovieCell"
    
    private let stackForText = UIStackView()
    private let cellTitle = UILabel()
    private let cellDescription = UILabel()
    private let arrow = UIImageView()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCell(titleText: String, descriptionText: String) {
        if titleText == "" {
            cellTitle.text = "No Title"
        } else {
            cellTitle.text = titleText
        }
        
        if descriptionText == "" {
            cellDescription.text = "No Description"
        } else {
            cellDescription.text = descriptionText
        }
        
    }
    
    private func configureUI() {
        addSubview(stackForText)
        addSubview(arrow)
        stackForText.addArrangedSubview(cellTitle)
        stackForText.addArrangedSubview(cellDescription)
        stackForText.axis = .vertical
        stackForText.spacing = 10
        stackForText.alignment = .leading
        stackForText.translatesAutoresizingMaskIntoConstraints = false
        
        arrow.image =  UIImage(systemName: "chevron.forward")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        arrow.translatesAutoresizingMaskIntoConstraints = false
        
        cellTitle.text = "Настройки"
        cellTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        cellTitle.textColor = .black
        cellTitle.numberOfLines = 0
        
        cellDescription.text = "Описание"
        cellDescription.font = UIFont.systemFont(ofSize: 14, weight: .light)
        cellDescription.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            stackForText.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackForText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackForText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            stackForText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            arrow.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
