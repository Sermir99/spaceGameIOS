//
//  Ship.swift
//  spaceGame.v1
//
//  Created by Admin on 01.04.2021.
//

import UIKit

class Ship: UIImageView {
    
    func setup() {
        let image = UIImage(named: "Ship")
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
