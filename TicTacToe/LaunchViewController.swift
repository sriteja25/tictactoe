//
//  LaunchViewController.swift
//  TicTacToe
//
//  Created by Anuraag Jain on 04/04/17.
//  Copyright © 2017 app. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.isTranslucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didTapOnPlayer(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapOnComputer(_ sender: Any) {
        //Pending...
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
