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

    private var page = 0
    private var isLoadingMoreFollowers = false
    private var dataSourse: UITableViewDiffableDataSource<Section, ComicBook>!
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
        configureDataSourse()
        setConstraints()
    }
    
    private func getComics() {
        isLoadingMoreFollowers = true
        Task {
            do {
                let comics = try await NetworkManager.shared.getComics(offset: page * 20)
                ComicsRealmStorage.shared.saveComicsList(comics)
                updateData(on: ComicsRealmStorage.shared.getComicsList())
                isLoadingMoreFollowers = false
            } catch {
                print("Ошибка при загрузке коммиксов: \(error)")
            }
        }
    }
    
    private func updateData(on comics: [ComicBook]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ComicBook>()
        snapshot.appendSections([.main])
        snapshot.appendItems(comics)
        DispatchQueue.main.async {
            self.dataSourse.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func configureDataSourse() {
        dataSourse = UITableViewDiffableDataSource<Section, ComicBook>(tableView: comicsTable, cellProvider: { tableView, indexPath, comicBook in
            let cell = tableView.dequeueReusableCell(withIdentifier: ComicBookCell.reuseID, for: indexPath) as! ComicBookCell
            
            let descriptionText = comicBook.description
            let textTitle = comicBook.title
            
            cell.setCell(titleText: textTitle, descriptionText: descriptionText)
            return cell
        })
    }
    
    
    private func setConstraints() {
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
        let contentHeight = comicsTable.contentSize.height
        let height = comicsTable.frame.size.height
        
        if offsetY > (contentHeight - height) {
            guard !isLoadingMoreFollowers else { return }
            page += 1
            getComics()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let comicBooks = ComicsRealmStorage.shared.getComicsList()
        let path = ComicBookVC(comicBook: comicBooks[indexPath.row], indexPath: indexPath.row)
        path.delegate = self
        navigationController?.pushViewController(path, animated: true)
    }
}


extension ComicsVC: ComicBookDelegate {
    func didPressedSaveButton(comicBook: ComicBook) {
        DispatchQueue.main.async { [weak self] in
            ComicsRealmStorage.shared.save(comicBook: comicBook)
            self?.updateData(on: ComicsRealmStorage.shared.getComicsList())
        }
    }
    
    func didPressedDeleteButton(deleteItem: ComicBook, indexPath: Int) {
        DispatchQueue.main.async { [weak self] in
            ComicsRealmStorage.shared.delete(comicBook: deleteItem)
            self?.updateData(on: ComicsRealmStorage.shared.getComicsList())
        }
    }
}
