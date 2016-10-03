//
//  CollectionSavedMemesViewController.swift
//  MemeMe
//
//  Created by Mahmoud Tawfik on 10/2/16.
//  Copyright © 2016 Mahmoud Tawfik. All rights reserved.
//

import UIKit

class CollectionSavedMemesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: Variables

    var memes: [Meme] {
        get { return (UIApplication.shared.delegate as! AppDelegate).memes }
        set {(UIApplication.shared.delegate as! AppDelegate).memes = newValue }
    }

    // MARK: IBOutlets

    @IBOutlet weak var memesCollection: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: View Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFlowLayoutToFit(items: 3, inWidth: view.frame.size.width)
    }
    
    func updateFlowLayoutToFit(items: Int, inWidth width: CGFloat) {
        let space: CGFloat = 3.0
        let dimension = (width - (CGFloat(items-1) * space)) / CGFloat(items)
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        updateFlowLayoutToFit(items: (toInterfaceOrientation.isPortrait ? 3 : 5), inWidth: view.frame.size.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memesCollection.reloadData()
    }

    // MARK: Collection Datasource methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! MemeCollectionViewCell
        cell.meme = memes[indexPath.row]
        return cell
    }
    
    // MARK: Collection Delegate methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        performSegue(withIdentifier: "MemeDetailView", sender: indexPath.row)

    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MemeDetailViewController{
            destination.meme = memes[sender as! Int]
        }
    }


}
