//
//  ViewController.swift
//  TextFieldAutocomplete
//
//  Created by Luana Telha on 19/02/2023.
//

import UIKit

class ViewController: UIViewController {
    
    var containableView: ContentView {
        guard let view = view as? ContentView else {
            fatalError("Please implement 'loadView()' with proper view type in \(type(of: self))")
        }
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func loadView() {
        loadContentView()
    }

    func loadContentView() {
        view = ContentView()
    }

}

