//
//  ComicBookCell2.swift
//  TestovoeVk
//
//  Created by Evgeni Novik on 03.12.2024.
//

import UIKit

class ComicBookCell: UITableViewCell {
    static let reuseID = "MovieCell"
    
    let stackForText = UIStackView()
    let cellTitle = UILabel()
    let cellDescription = UILabel()
    let arrow = UIImageView()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
    }
    
    func setCell(titleText: String, descriptionText: String?) {
        cellTitle.text = titleText
        cellDescription.text = descriptionText
        if cellDescription.text == nil {
            stackForText.spacing = 0
        } else {
            stackForText.spacing = 10
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
            stackForText.trailingAnchor.constraint(equalTo: arrow.leadingAnchor, constant: -10),
            stackForText.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackForText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            arrow.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
