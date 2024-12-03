//
//  ViewController.swift
//  TestovoeVk
//
//  Created by Evgeni Novik on 02.12.2024.
//

import UIKit

final class ComicsCollection: UIViewController {
    
    enum Section {
        case main
    }
    
    var comics = [ComicBook]()
    
    var page = 0
    var dataSourse: UITableViewDiffableDataSource<Section, ComicBook>!
    var isLoadingMoreFollowers = false
    
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
        configureDataSourse()
    }
    
    private func configureDataSourse() {
        dataSourse = UITableViewDiffableDataSource<Section, ComicBook>(tableView: comicsTable, cellProvider: { tableView, indexPath, comicBook in
            let cell = tableView.dequeueReusableCell(withIdentifier: ComicBookCell.reuseID, for: indexPath) as! ComicBookCell
            
            let descriptionText = comicBook.textObjects.count > 0 ? comicBook.textObjects[0].text : nil
            guard let textTitle = comicBook.title else { return cell }
            
            cell.setCell(titleText: textTitle, descriptionText: descriptionText)
            return cell
        })
    }
    
    private func getComics() {
        isLoadingMoreFollowers = true
        APICaller.shared.getComics(offset: page * 20) { [weak self] results in
            guard let self else { return }
            switch results {
            case .success(let comics):
                self.comics.append(contentsOf: comics)
                print(self.comics.count)
                updateData(on: self.comics)
            case .failure(let error):
                print(error)
            }
            isLoadingMoreFollowers = false
        }
    }
    
    func updateData(on comics: [ComicBook]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ComicBook>()
        snapshot.appendSections([.main])
        snapshot.appendItems(comics)
        DispatchQueue.main.async {
            self.dataSourse.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func constraints() {
        view.addSubview(comicsTable)
        comicsTable.separatorStyle = .singleLine
        comicsTable.register(ComicBookCell.self, forCellReuseIdentifier: ComicBookCell.reuseID)
        comicsTable.delegate = self
        comicsTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            comicsTable.topAnchor.constraint(equalTo: view.topAnchor, constant: -20),
            comicsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            comicsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            comicsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),
        ])
    }
}


extension ComicsCollection: UITableViewDelegate {
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = comicsTable.contentOffset.y
        // The height of the content at the moment (how far we scroll down)
        let contentHeight = comicsTable.contentSize.height
        // The height of the content with the n followers
        let height = comicsTable.frame.size.height
        // The height of the phone
        
        if offsetY > (contentHeight - height) {
            guard !isLoadingMoreFollowers else { return }
            page += 1
            getComics()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
