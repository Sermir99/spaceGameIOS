//
//  SpaceViewController.swift
//  spaceGame.v1
//
//  Created by Admin on 01.04.2021.
//

import UIKit

class SpaceViewController: UIViewController {

    
    @IBOutlet var spaceView: UIView!
    @IBOutlet weak var gameView: UIView!
    
    var ship = Ship(frame: .zero)
    var shipPosition: Int = 2
    var bullet: [Bullet] = []
    var bulletNumber: Int = 0
    var firing: Bool = false
    var enemies: [Enemy] = []
    var score: Int = 0
    weak var firingTimer: Timer?
    weak var spawnTimer: Timer?
    weak var enemyTimer: Timer?
    weak var checkIntersectionTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shipPosition = 2
        let playerRect = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.ship = Ship(frame: playerRect)
        gameView.addSubview(self.ship)
        firingTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) {_ in
            var i = 0
            for b in self.bullet{
                 let bullet = b
                 bullet.center.y -= self.gameView.frame.height/50
                 if (bullet.center.y <= -50) {
                    bullet.removeFromSuperview()
                    self.bullet.remove(at: i)
                    self.bulletNumber -= 1
                    self.firing = false
                    }
                i += 1
                }
            }
        spawnTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true){_ in
            self.spawnEnemies()
        }
        
        enemyTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) {_ in
            for enemy in self.enemies {
                if (enemy.center.y >= self.gameView.frame.height + 50) {
                    self.GameOver()
                }
                enemy.center.y += self.gameView.frame.height/400
            }
        }
        
        checkIntersectionTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){_ in
            var i = 0;
            var enemyToDelete : [Int] = []
            var bulletToDelete : [Int] = []
            for enemy in self.enemies  {
                var j = 0
                for bullet in self.bullet {
                    if(enemy.frame.intersects(bullet.frame)) {
                        self.score += 10
                        self.firing = false
                        self.bulletNumber -= 1
                        enemyToDelete.append(i)
                        //
                        enemy.removeFromSuperview()
                        bulletToDelete.append(j)
                        //
                        bullet.removeFromSuperview()
                    }
                    j += 1
                }
                
                if (enemy.frame.intersects(self.ship.frame)) {
                    self.GameOver()
                }
                 
                if (enemy.frame.intersects(self.ship.frame)) {
                    self.GameOver()
                    
                }
                i += 1
            }
            bulletToDelete.sort(by: >)
            for b in bulletToDelete{
                self.bullet.remove(at: b)
            }
            enemyToDelete.sort(by: >)
            for e in enemyToDelete{
                self.enemies.remove(at: e)
            }
            
        }
        
    }
    
    func spawnEnemies(){
        let initialAsteroidRect = CGRect(x: 0, y: -100, width: 50, height: 50)
        for i in 0..<5 {
            if Int.random(in: 0...1) == 0{
                return
                
            }
            else{
                let enemy = Enemy(frame: initialAsteroidRect)
                enemy.center.x = spaceView.frame.width / 10 * (2 * CGFloat(i) + 1)
                self.gameView.addSubview(enemy)
                self.enemies.append(enemy)
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ship.center = CGPoint(x: spaceView.frame.width / 10 * (2 * CGFloat(self.shipPosition) + 1), y: spaceView.frame.height - ship.frame.height - 25)

    }
    
    @IBAction func FireTouched(_ sender: Any) {
        if (firing) {
            return
        }
        else {
            if bulletNumber < 3{
                let bulletRect = CGRect(x: 0, y: 0, width: 25, height: 25)
                bullet.insert(Bullet(frame: bulletRect), at: 0)
                bullet[0].center = CGPoint(x: self.ship.center.x, y: self.ship.center.y - 35)
                spaceView.addSubview(bullet[0])
                bulletNumber += 1
            }
            else{
                firing = true
            }
    }
}

    @IBAction func LeftTouched(_ sender: Any) {
        if (shipPosition <= 0){
            return
            
        }
        else {
            UIView.animate(withDuration: 0.3, animations: { self.ship.center.x -= self.spaceView.frame.width / 5})
            shipPosition -= 1
        }
    }
    @IBAction func RightTouched(_ sender: Any) {
        if (shipPosition >= 4){
            return
            
        }
        else {
            UIView.animate(withDuration: 0.15, animations: { self.ship.center.x += self.spaceView.frame.width / 5})
            shipPosition += 1
        }
    }
    
    func GameOver() {
        for enemy in self.enemies {
            enemy.removeFromSuperview()
        }
        for bullet in self.bullet {
            bullet.removeFromSuperview()
        }
        ship.removeFromSuperview()
        enemies.removeAll()
        self.ship = Ship(frame: .zero)
        self.bullet = []
        
        firingTimer?.invalidate()
        spawnTimer?.invalidate()
        enemyTimer?.invalidate()
        checkIntersectionTimer?.invalidate()
        var topScore = UserDefaults.standard.integer(forKey: "topScore") ?? 0
        if topScore < self.score {
            topScore = self.score
            UserDefaults.standard.set(topScore, forKey: "topScore")
        }
        let alert = UIAlertController(title: "GAME OVER", message: """
Final score: \(score)
Max score: \(topScore)
""", preferredStyle: .alert)
        self.score = 0
        let actionCancel = UIAlertAction(title: "Try again", style: .cancel){ _ in
                                            self.viewDidLoad()
                                            self.viewDidLayoutSubviews()
        }
        alert.addAction(actionCancel);
        self.present(alert, animated: true, completion: nil)

        //
        
    }
    
}
