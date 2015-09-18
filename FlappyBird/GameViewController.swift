//
//  GameViewController.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks")
        
        let sceneData = try? NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe)
        let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData!)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
        archiver.finishDecoding()
        return scene
    }
}

class GameViewController: UIViewController, TJPlacementDelegate {
    
    func tjcConnectSuccess(notifyObj: NSNotification) {
        NSLog("Tapjoy connect succeeded")
    }
    
    func tjcConnectFail(notifyObj: NSNotification) {
        NSLog("Tapjoy connect failed")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            scene.vc = self
            // TAPJOY
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "tjcConnectSuccess:", name: TJC_CONNECT_SUCCESS, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "tjcConnectFail:", name: TJC_CONNECT_FAILED, object: nil)
            Tapjoy.connect("tPdB5-ZZSAu6xC_VxPrC0QEBW5ww3pQYyCbXihbJCEYAxh2VOmrGWxaxWqqe",
                options: [TJC_OPTION_ENABLE_LOGGING: "YES"])
            Tapjoy.setUserID("inkyu")
            Tapjoy.setUserLevel(1)
            
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }
}
