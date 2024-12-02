//
//  MovieCell.swift
//  TestovoeVk
//
//  Created by Evgeni Novik on 02.12.2024.
//

import UIKit
import SDWebImage

final class ComicBookCell: UICollectionViewCell {
    static let reuseID = "MovieCell"
    
    let comicBookImage = UIImageView()
    let comicBookTitle = UILabel()
    let comicBookDescription = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(comics: ComicBook) {
        var urlString = comics.thumbnail.image_path + "." + comics.thumbnail.image_extension
        if let index = urlString.index(urlString.startIndex, offsetBy: 4, limitedBy: urlString.endIndex) {
            urlString.insert("s", at: index)
        }
        comicBookImage.sd_setImage(with: URL(string: urlString))
        comicBookTitle.text = comics.title
        if comics.textObjects.count > 0 {
            comicBookDescription.text = comics.textObjects[0].text
        }
    }
    
    func configure() {
        addSubview(comicBookImage)
        addSubview(comicBookTitle)
        addSubview(comicBookDescription)
        
        comicBookImage.clipsToBounds = true
        comicBookImage.contentMode = .scaleAspectFit
        comicBookImage.translatesAutoresizingMaskIntoConstraints = false
        
        comicBookTitle.text = "Заголовок"
        comicBookTitle.numberOfLines = 999
        comicBookTitle.textColor = UIColor.black
        comicBookTitle.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        comicBookTitle.translatesAutoresizingMaskIntoConstraints = false
        
        comicBookDescription.numberOfLines = 9999
        comicBookDescription.textColor = UIColor.black
        comicBookDescription.font = UIFont.systemFont(ofSize: 16, weight: .light)
        comicBookDescription.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            comicBookTitle.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            comicBookTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            comicBookTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            
            comicBookDescription.topAnchor.constraint(equalTo: comicBookTitle.bottomAnchor, constant: 5),
            comicBookDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            comicBookDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            
            comicBookImage.topAnchor.constraint(equalTo: comicBookDescription.bottomAnchor, constant: 5),
            comicBookImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            comicBookImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            comicBookImage.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

#Preview() {
    ComicsCollection()
}
