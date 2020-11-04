//
//  TableViewController.swift
//  Project4
//
//  Created by AnoraxAlmanac on 3/11/20.
//

import UIKit

class TableViewController: UITableViewController {
    // List of websites that will be available at startup.
    var webSites = ["apple.com", "404kartik.me", "google.com.au"]
    
    // Setting the size of the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webSites.count
    }
    // Putting sites in the list.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SiteLoader", for: indexPath)
        cell.textLabel?.text = webSites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // If the if let statement returns nil then the code inside will not be executed.
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Web") as? WebViewController {
            // Sets the seleceted image variable as the picture that was selected in the table.
            vc.pickedSite = webSites[indexPath.row]

            // Slides over to the Detail view (view showing image) and shows the selected image.
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
