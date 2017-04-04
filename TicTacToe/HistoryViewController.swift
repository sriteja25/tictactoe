//
//  HistoryViewController.swift
//  TicTacToe
//
//  Created by Anuraag Jain on 04/04/17.
//  Copyright © 2017 app. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var historyObj:[History]?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedObjectContext:NSManagedObjectContext{return appDelegate.managedObjectContext}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "History"
        historyObj = fetchData(entityName: "History") as! [History]
        // Do any additional setup after loading the view.
    }
    func fetchData(entityName:String) -> [Any]?{
        let fetchReq = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
        fetchReq.entity = entityDescription
        do{
            let fetchRes = try managedObjectContext.fetch(fetchReq)
            return fetchRes
        }catch{
            let fetchErr = error as NSError
            print(fetchErr)
            return nil
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = historyObj{
            return historyObj!.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryCell
        let object =  historyObj?[indexPath.row]
        cell.pOne.text = object?.winner
        cell.pTwo.text = object?.loser
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY HH:mm:s"
        if let _ = object?.playedOn{
            let dateStr = dateFormatter.string(from: object!.playedOn!)
            cell.date.text = dateStr
        }
        
        return cell
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class HistoryCell:UITableViewCell{
    @IBOutlet weak var pOne: UILabel!
    @IBOutlet weak var pTwo: UILabel!
    @IBOutlet weak var date: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
