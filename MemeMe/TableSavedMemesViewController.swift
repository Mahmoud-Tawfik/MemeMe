//
//  TableSavedMemesViewController.swift
//  MemeMe
//
//  Created by Mahmoud Tawfik on 10/2/16.
//  Copyright © 2016 Mahmoud Tawfik. All rights reserved.
//

import UIKit

class TableSavedMemesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    // MARK: Variables

    var memes: [Meme] {
        get { return (UIApplication.shared.delegate as! AppDelegate).memes }
        set {(UIApplication.shared.delegate as! AppDelegate).memes = newValue }
    }

    // MARK: IBOutlets

    @IBOutlet weak var memesTable: UITableView!
    
    // MARK: View Lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memesTable.reloadData()
    }

    // MARK: Table Datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")! as! MemeTableViewCell
        cell.meme = memes[indexPath.row]
        return cell
    }

    // MARK: Table Delegate methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "MemeDetailView", sender: indexPath.row)
    }

    // MARK: - Table editing methods
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
        }
    }
    
    // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MemeDetailViewController{
            destination.meme = memes[sender as! Int]
        }
    }

}
