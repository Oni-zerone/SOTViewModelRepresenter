//
//  ViewController.swift
//  SOTViewModelRepresenter
//
//  Created by acct<blob>=<NULL> on 10/28/2018.
//  Copyright (c) 2018 acct<blob>=<NULL>. All rights reserved.
//

import UIKit
import PowerTools

class CollectionController: UIViewController {

    weak var collectionViewController: GridCollectionViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupCollection()
        self.registerCell()

        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.loadContent()
            }
        }
    }

    private func setupCollection() {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionController = GridCollectionViewController(collectionViewLayout: layout)
        collectionController.attach(to: self)
        self.collectionViewController = collectionController
    }

    private func registerCell() {

        self.collectionViewController.register(ColorCollectionViewCell.nibIdentifier)
    }

    private func loadContent() {

        var section = self.collectionViewController.model.first as? BaseSection ?? BaseSection()
        section.append(ColorViewModel(descriptor: ColorCollectionViewCell.Descriptor(), color: .red))
        let newContent = [section]
        self.collectionViewController.model = newContent
    }
}
