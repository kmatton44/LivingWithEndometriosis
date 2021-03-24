//
//  TodoTableViewController.swift
//  LivingWithEndo
//
//  Created by Kanoa Matton on 7/20/19.
//  Copyright © 2019 Kanoa Matton. All rights reserved.
//

import UIKit
import CoreData

class TodoTableViewController: UITableViewController {

    var resultsController: NSFetchedResultsController<Entity>!
    let coreDataStack = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: true)
        
        request.sortDescriptors = [sortDescriptors]
        
        resultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        resultsController.delegate = self
        
        do {
            try resultsController.performFetch()
        } catch {
            print("Peform fetch error:\(error)")
        }
        
        
       
    }

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)

        // Configure the cell...
        let note = resultsController.object(at: indexPath)
        
        cell.textLabel?.text = note.item

        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            //TODO: DELETE NOTE
            let todo = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(todo)
            do {
                try self.resultsController.managedObjectContext.save()
                completion(true)
            } catch {
                print("Delete failed: \(error)")
                completion(false)
            }
            
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "trash-2")
        action.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showAddToDo", sender: tableView.cellForRow(at: indexPath))
    }
 
    

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? AddToDoViewController {
            vc.manageContext = resultsController.managedObjectContext
        }
        
        if let cell = sender as? UITableViewCell, let vc = segue.destination as? AddToDoViewController {
            vc.manageContext = resultsController.managedObjectContext
            if let indexPath = tableView.indexPath(for: cell) {
                let todo = resultsController.object(at: indexPath)
                vc.todo = todo
            }
        }
        
        
        
        
    }
    

}

extension TodoTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
                let todo = resultsController.object(at: indexPath)
                cell.textLabel?.text = todo.item
            }
            
        default:
            break
        }
    }
}

