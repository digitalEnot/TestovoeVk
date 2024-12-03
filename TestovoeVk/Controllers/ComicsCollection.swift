//
//  ViewController.swift
//  TestovoeVk
//
//  Created by Evgeni Novik on 02.12.2024.
//

import UIKit

final class ComicsCollection: UIViewController {
    
    var comics = [ComicBook]()
    
    private let comicsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.separatorStyle = .none
        table.register(ComicBookCell.self, forCellReuseIdentifier: ComicBookCell.reuseID)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        getComics()
        constraints()
    }
    
    private func getComics() {
        APICaller.shared.getComics { [weak self] results in
            guard let self else { return }
            switch results {
            case .success(let comics):
                self.comics = comics
                DispatchQueue.main.async {
                    self.comicsTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func constraints() {
        view.addSubview(comicsTable)
        comicsTable.separatorStyle = .singleLine
        comicsTable.register(ComicBookCell.self, forCellReuseIdentifier: ComicBookCell.reuseID)
        comicsTable.delegate = self
        comicsTable.dataSource = self
        comicsTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            comicsTable.topAnchor.constraint(equalTo: view.topAnchor, constant: -20),
            comicsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            comicsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            comicsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),
        ])
    }
}


extension ComicsCollection: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = comicsTable.dequeueReusableCell(withIdentifier: ComicBookCell.reuseID, for: indexPath) as? ComicBookCell else { return UITableViewCell() }
        let descriptionText = comics[indexPath.row].textObjects.count > 0 ? comics[indexPath.row].textObjects[0].text : nil
        guard let textTitle = comics[indexPath.row].title else { return cell }
        
        cell.setCell(titleText: textTitle, descriptionText: descriptionText)
        return cell
    }
}
