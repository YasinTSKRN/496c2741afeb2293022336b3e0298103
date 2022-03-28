//
//  FavoritesViewController.swift
//  496c2741afeb2293022336b3e0298103
//
//  Created by yasintaskiran on 27.03.2022.
//

import UIKit

class FavoritesViewController: UIViewController {

    private var viewModel = FavoritesViewModel()

    @IBOutlet weak var favoritesTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        favoritesTable.delegate = self
        favoritesTable.dataSource = self
        viewModel.refreshFavorites()
        favoritesTable.reloadData()
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCell {
            let station = self.viewModel.favorites[indexPath.row]
            cell.name.text = station.name
            cell.distance.text = "\(Int(sqrt(pow(station.coordinateX, 2) + pow(station.coordinateY, 2)).rounded())) EUS"
            cell.unfavoriteButton.tag = indexPath.row
            cell.unfavoriteButton.addTarget(self, action: #selector(unfavoriteAction), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func unfavoriteAction(sender: UIButton) {
        let station = viewModel.favorites[sender.tag]
        FavoriteManager.shared.removeFavorite(station: station)
        viewModel.refreshFavorites()
        favoritesTable.reloadData()
    }
}

class FavoriteCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var unfavoriteButton: UIButton!
}
