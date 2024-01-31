//
//  LibaryViewController.swift
//  photoEditor
//
//  Created by Alina Titarenko on 05.12.2023.
//

import UIKit

class LibaryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    private let viewModel: LibaryViewModel
    
    init(viewModel: LibaryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        let share = UIBarButtonItem(image: UIImage(systemName: ""), style: .plain, target: self, action: #selector(shareTapped))

        navigationBar.topItem?.rightBarButtonItems = [share]
        

        let rateCellNib = UINib(nibName: PhotoCell.id, bundle: nil)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(rateCellNib, forCellWithReuseIdentifier: PhotoCell.id)
    }
    

    @objc func shareTapped() {

    }
}

// MARK: - UICollectionViewDelegate

extension LibaryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {

    }

}


// MARK: - UICollectionViewDataSource

extension LibaryViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.id, for: indexPath) as! PhotoCell
        
        viewModel.loadImage(completion: { image in
            DispatchQueue.main.async {
                cell.setUp(image: image!)
            }
        })
        
        return cell
    }
}

