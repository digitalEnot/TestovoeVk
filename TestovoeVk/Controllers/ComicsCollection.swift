//
//  ViewController.swift
//  TestovoeVk
//
//  Created by Evgeni Novik on 02.12.2024.
//

import UIKit

final class ComicsCollection: UIViewController {
    
    var comics = [ComicBook]()
    var comicsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    

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
                    self.comicsCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func constraints() {
        comicsCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTwoSquareColumnLayout(in: view))
        view.addSubview(comicsCollectionView)
        comicsCollectionView.delegate = self
        comicsCollectionView.dataSource = self
        comicsCollectionView.register(ComicBookCell.self, forCellWithReuseIdentifier: ComicBookCell.reuseID)
    }
}

extension ComicsCollection: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        comics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicBookCell.reuseID, for: indexPath) as! ComicBookCell
        cell.set(comics: comics[indexPath.row])
        return cell
    }
}
