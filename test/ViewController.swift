//
//  ViewController.swift
//  test
//
//  Created by Nikolay on 18.05.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var premum_label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? Practic_sh_img else { return }
            
        if segue.identifier == "toFavorites" {
            vc.practiceType = .favorites
        } else if segue.identifier == "toMistakes" {
            vc.practiceType = .errors
        }
    }

}

