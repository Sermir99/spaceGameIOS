//
//  Enemy.swift
//  spaceGame.v1
//
//  Created by Admin on 01.04.2021.
//

import UIKit

class Enemy: UIImageView {
    
    func setup() {
        let image: UIImage? = UIImage(named: "Enemy"+String(Int.random(in: 0...2)))
        self.contentMode = .redraw
        self.image = image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}
