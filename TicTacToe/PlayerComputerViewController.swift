//
//  ViewController.swift
//  TicTacToe
//
//  Created by Anuraag Jain on 04/04/17.
//  Copyright © 2017 app. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerComputerViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TicProtocol {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var player1: UILabel!
    @IBOutlet var player2: UILabel!
    var player:AVAudioPlayer!
    
    let defaults = UserDefaults.standard
    
    var playerScore:Int?
    var computerScore:Int?
    var count:Int = 0
    
    var isPlayed = 0
    var b:Bool = false
    var c:Bool = false
    
    var gameActive:Bool = false
    var a:Bool = false
    var gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    var winningCombinations = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let _ = player{
            player.stop()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerScores()
        
        let refreshButton = UIBarButtonItem(image: UIImage(named:"refresh"), style: UIBarButtonItemStyle.plain, target:self , action: #selector(PlayerComputerViewController.reloadView))
        navigationItem.rightBarButtonItem = refreshButton
        navigationItem.title = "Player 1's turn"
        
        initialSetup()
    }
    func initialSetup(){
        let ticCell = UINib(nibName: "TicCell", bundle: nil)
        collectionView.register(ticCell, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        
        let audioURL = Bundle.main.path(forResource: "sample", ofType: "mp3")
        let url = URL(fileURLWithPath: audioURL!)
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            player =  try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        }catch{
            print(error.localizedDescription)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TicCell
        cell.cellValue.text = ""
        
        cell.layer.borderColor =  UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("IndexPath:\(indexPath.item)")
        let cell = collectionView.cellForItem(at: indexPath) as! TicCell
        
        
        
        if (a == false){
            
            isPlayed = 2
        }
        
        gameState[indexPath.item] = isPlayed
        
        if isPlayed == Player.One.rawValue{
            isPlayed = 2
            cell.cellValue.text = "O"
            navigationItem.title = "Player 1's Turn"
            
            
        }else{
            isPlayed = 1
            cell.cellValue.text = "X"
            navigationItem.title = "Computer's Turn"
            a = true
            b = true
            
            //computerTurn()
            
        }
        cell.isUserInteractionEnabled = false
        
        print(gameState)
        winning()
        draw()
        
        
        
        
    }
    
    //Computer's chance, a random block will be selected out of all the remaining blocks and "O" will be placed in one of the empty cell.
    
    func computerTurn(){
        
        b = false
        
        var randomNumber = [Int]()
    
        for i in 0..<gameState.count{
        
            if(gameState[i] == 0){
            
                randomNumber.append(i)
                
            }

        }
        
        let randomIndex = Int(arc4random_uniform(UInt32((randomNumber.count))))
        
        
        //self.collectionView(collectionView, didSelectItemAt: randomIndex)
        
        if(randomNumber != []){
        
        var indexpath = NSIndexPath(row: randomNumber[randomIndex], section: 0) as! IndexPath
        
        //indexpath = NSIndexPath(index: randomIndex) as! IndexPath
        
        indexpath.item = randomNumber[randomIndex]
        
        let cell = collectionView.cellForItem(at: indexpath) as! TicCell
        
        print(indexpath.item)
        
        gameState[randomNumber[randomIndex]] = isPlayed
        collectionView.selectItem(at: indexpath, animated: true, scrollPosition: UICollectionViewScrollPosition.top)
        
        
        
        isPlayed = 2
        cell.cellValue.text = "O"
        navigationItem.title = "Player 1's Turn"
        cell.isUserInteractionEnabled = false
        winning()
        draw()
        }
        
        if (randomNumber == []){
            
                draw()
        
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        return CGSize(width: screenSize.size.width/3, height: screenSize.size.width/3)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func didTapOnCell(cell: TicCell) {
        
    }
    
    //Check winning condition
    
    func winning(){
        
        var title:String = ""
        var message:String = ""
        
        for combination in winningCombinations{
            
            if (c == false){
            if (gameState[combination[0]] != 0 && gameState[combination[0]] == gameState[combination[1]] && gameState[combination[1]] == gameState[combination[2]]) {
                
                if (gameState[combination[0]] == 1){
                    
                    title = "Computer has won"
                    message = "Would you like to play again ?"
                    addAlertView(title:title, message:message)
                    computerScore = computerScore! + 1
                    defaults.set(computerScore, forKey: "computer")
                    defaults.synchronize()
                    playerScores()
                    
                    print("Noughts has won!")
                    c = true
                    
                }
                
                if gameState[combination[0]] == 2 {
                    
                    title = "Player 1 has won"
                    message = "Would you like to play again ?"
                    addAlertView(title:title, message:message)
                    playerScore = playerScore! + 1
                    defaults.set(playerScore, forKey: "player")
                    defaults.synchronize()
                    playerScores()
                    
                    print("Crosses has won!")
                    c = true
                    
                    
                 }
               }
            }
        }
     
        if(b == true){
            
            computerTurn()
            
        }
    }
    
    // Pops an alert view as soon as a Winning condition
    
    func addAlertView(title:String, message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Reset", style: UIAlertActionStyle.default, handler: { (action) in
            self.reloadView()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
            
            self.gameActive = true
            self.dismiss(animated: true, completion: nil)
            self.collectionView.allowsSelection = false
        }))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    //Resets the view wehn reload button on right navigation bar is pressed or Reset button in the alert view is pressed
    
    func reloadView(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayerComputerViewController") as! PlayerComputerViewController
        var navView = self.navigationController?.viewControllers
        navView?.remove(at: 1)
        navView?.append(vc)
        player.stop()
        self.navigationController?.setViewControllers(navView!, animated: true)
    }
    
    //The text fields are updated with the player scores
    
    func playerScores(){
        
        playerScore = defaults.object(forKey: "player") as? Int ?? 0
        computerScore = defaults.object(forKey: "computer") as? Int ?? 0
        
        
        player1.text = "\(playerScore!)"
        player2.text = "\(computerScore!)"
        
        
    }
    
     //Draw condition is checked
    
    func draw(){
        
        
        for i in 0...gameState.count-1{
            
            if(gameState[i] != 0){
                
                count = count + 1
            }
            
        }
        
        if (count == 45){
            
            let message = "Would you like to play again ?"
            addAlertView(title:"Match Drawn", message: message)
        }
        
        
    }
    
    
}


