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
        viewModel.favorites.append(Station(name: "test1", coordinateX: 1, coordinateY: 1, capacity: 1000, stock: 500, need: 500))
        viewModel.favorites.append(Station(name: "test2", coordinateX: 1, coordinateY: 1, capacity: 1000, stock: 500, need: 500))
        favoritesTable.delegate = self
        favoritesTable.dataSource = self
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
            cell.distance.text = "DISTANCE"
            cell.unfavoriteButton.tag = indexPath.row
            cell.unfavoriteButton.addTarget(self, action: #selector(unfavoriteAction), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func unfavoriteAction(sender: UIButton) {
        print("##### - unfavorite: \(sender.tag)")
    }
}

class FavoriteCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var unfavoriteButton: UIButton!
}
