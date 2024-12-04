//
//  TVKTextField.swift
//  TestovoeVk
//
//  Created by Evgeni Novik on 03.12.2024.
//


import UIKit

final class TVKTextField: UITextField {
    
    private let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 8
        layer.borderColor = UIColor(.black).cgColor
        
        layer.borderColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        }.cgColor
        
        textColor = .label
        tintColor = .label
        
        backgroundColor = .systemBackground
        autocorrectionType = .no
        clearButtonMode = .whileEditing
        
        font = .boldSystemFont(ofSize: 15)
    }
}

