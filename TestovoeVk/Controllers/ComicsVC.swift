//
//  ViewController.swift
//  TestovoeVk
//
//  Created by Evgeni Novik on 02.12.2024.
//

import UIKit


final class ComicsVC: UIViewController {
    
    enum Section {
        case main
    }

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
            
            let descriptionText = comicBook.text
            let textTitle = comicBook.title
            
            cell.setCell(titleText: textTitle, descriptionText: descriptionText)
            return cell
        })
    }
    
    private func getComics() {
        isLoadingMoreFollowers = true
        Task {
            do {
                let comics = try await APICaller.shared.getComicsAsync(offset: page * 20)
                TVKRealmStorage.shared.saveAirportList(comics)
                updateData(on: TVKRealmStorage.shared.getAirportList())
                isLoadingMoreFollowers = false
            } catch {
                print("Error when fecthing comics: \(error)")
            }
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


extension ComicsVC: UITableViewDelegate {
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
        
//        DispatchQueue.main.async { [weak self] in
//            guard let self else { return }
//            TVKRealmStorage.shared.deleteOneItem(item: realmComics[indexPath.row])
//        }
//        
//        self.comics.remove(at: indexPath.row)
//        updateData(on: self.comics)
        let comicBooks = TVKRealmStorage.shared.getAirportList()
        let path = ComicBookVC(comicBook: comicBooks[indexPath.row], indexPath: indexPath.row)
        path.delegate = self
        navigationController?.pushViewController(path, animated: true)
    }
}

extension ComicsVC: ComicBookDelegate {
    func didPressedSaveButton(comicBook: ComicBook) {
        DispatchQueue.main.async { [weak self] in
            TVKRealmStorage.shared.saveComicBook(item: comicBook)
            self?.updateData(on: TVKRealmStorage.shared.getAirportList())
        }
    }
    
    func didPressedDeleteButton(deleteItem: ComicBook, indexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            TVKRealmStorage.shared.deleteOneItem(item: deleteItem)
            self?.updateData(on: TVKRealmStorage.shared.getAirportList())
        }
    }
}
