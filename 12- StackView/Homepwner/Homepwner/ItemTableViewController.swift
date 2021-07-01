//
//  ItemTableViewController.swift
//  Homepwner
//
//  Created by 전소영 on 2021/06/29.
//

import UIKit

class ItemTableViewController: UITableViewController {

    var itemStore: ItemStore!
    let list = ["50 이상", "50 이하", nil]
    
    @IBAction func toggleEditingMode(_ sender: AnyObject) {
        if isEditing {
            sender.setTitle("Edit", for: .normal)
            setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", for: .normal)
            setEditing(true, animated: true)
        }
    }
    
    @IBAction func addNewItem(_ sender: AnyObject) {
        let newItemDictionary = itemStore.createItem()
        var newItem: Item?
        var newItemIndex = 0
        for (key, value) in newItemDictionary {
            newItem = key
            newItemIndex = value
        }

//        let lastRow = tableView.numberOfRows(inSection: 0)
//        let indexPath = IndexPath(row: lastRow - 1, section: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)
//        tableView.reloadData()
        
//        let newIndexPath = IndexPath(row: meals.count, section: 0)
//
//        meals.append(meal)
//        tableView.insertRows(at: [newIndexPath], with: .automatic)
        
        tableView.reloadData()
        tableView.beginUpdates()
//        if let index = itemStore.allItems[newItemIndex].firstIndex(of: newItem!) {
//            let indexPath = IndexPath(row: index, section: newItemIndex)
//            tableView.insertRows(at: [indexPath], with: .automatic)
//            self.tableView.reloadData()
//        }
        tableView.endUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var items = [Item]()
        let item = Item(name: "no more items", valueInDollars: 0, serialNumber: nil, overFlag: false)
        items.append(item)
        itemStore.allItems.append(items)
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        tableView.backgroundView = UIImageView(image: UIImage(named: ""))
        
        if #available(iOS 13.0, *) {
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
            tableView.contentInset = insets
            tableView.scrollIndicatorInsets = insets
        }
//        tableView.rowHeight = 65
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return itemStore.allItems.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems[section].count
        
//        return itemStore.allItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let itemCell = cell as? ItemCell
       
        itemCell?.updateLabels()
        let item = itemStore.allItems[indexPath.section][indexPath.row]
        
        itemCell?.nameLabel.text = item.name
        
        if indexPath.section == 0 {
            itemCell?.valueLabel?.textColor = .red 
        } else if indexPath.section == 1 {
            itemCell?.valueLabel?.textColor = .green
        }
        
        if indexPath.section != itemStore.allItems.count - 1 {
            itemCell?.valueLabel?.text = "$\(item.valueInDollars)"
            itemCell?.nameLabel?.font = cell.textLabel?.font.withSize(20)
            itemCell?.valueLabel?.font = cell.detailTextLabel?.font.withSize(20)
        } else {
            itemCell?.valueLabel?.text = nil
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return list[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == itemStore.allItems.count - 1, indexPath.row == itemStore.allItems[indexPath.section].count - 1 {
            return 44
        } else {
            return 60
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let item = itemStore.allItems[indexPath.section]
            
            let title = "Delete \(item[indexPath.row].name)?"
            let message = "Are you sure you want to delete this item?"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
                (action) -> Void in
                self.itemStore.removeItem(item: item[indexPath.row], section: indexPath.section)
                tableView.deleteRows(at: [indexPath], with: .fade)
            })
            ac.addAction(deleteAction)
            present(ac, animated: true, completion: nil)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "remove"
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 2 {
            return false
        }
        return true
    }

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        itemStore.moveItemAtIndex(fromIndex: fromIndexPath.row, toIndex: to.row, fromSection: fromIndexPath.section, toSection: to.section)
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if (proposedDestinationIndexPath.section == 2) {
                return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        if indexPath.section == 2 {
            return false
        }
        return true
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowItem", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItem" {
            
            if let section = tableView.indexPathForSelectedRow?.section {
                if let row = tableView.indexPathForSelectedRow?.row {
                    if let detailViewController = segue.destination as? DetailViewController {
                        let item = itemStore.allItems[section][row]
                        detailViewController.item = item
                    }
                }
            }
        }
    }
}
