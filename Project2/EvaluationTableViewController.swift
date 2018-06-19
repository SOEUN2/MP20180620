//
//  EvaluationTableViewController.swift
//  Project2
//
//  Created by SWUCOMPUTER on 2018. 6. 13..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class EvaluationTableViewController: UITableViewController {
    var evaluations: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Evaluation")
        
        let sortDescriptor = NSSortDescriptor (key: "saveDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            evaluations = try context.fetch(fetchRequest)
        }
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)") }
        
        self.tableView.reloadData() }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return evaluations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Evaluation Cell", for: indexPath)

        let evaluation = evaluations[indexPath.row]
        var display: String = ""
        
        let dbDate: Date? = evaluation.value(forKey: "saveDate") as? Date
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd h:mm a"
        if let unwrapDate = dbDate {
            let displayDate = formatter.string(from: unwrapDate as Date)
            display = displayDate }
        
        cell.textLabel?.text = display
        cell.detailTextLabel?.text = evaluation.value(forKey: "subj_Name") as? String
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = getContext()
            context.delete(evaluations[indexPath.row])
            do {
                try context.save()
                print("deleted!")
            } catch let error as NSError {
                print("Could not delete \(error), \(error.userInfo)") }
            // 배열에서 해당 자료 삭제
            evaluations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toDetailView"{
            if let destination = segue.destination as? DetailViewController{
                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row{
                    destination.detailEvaluation = evaluations[selectedIndex]
                }
            }
        }
    }

}
