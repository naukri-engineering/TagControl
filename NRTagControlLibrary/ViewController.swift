//
//  ViewController.swift
//  NRTagControlLibrary
//
//  Created by Bhumika Goyal on 12/12/17.
//  Copyright © 2017 Naukri. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NRTagsControlDelegate {
    
    @IBOutlet weak var tagView: NRTagsControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
    
    private func initializeView() {
        
        tagView.tapDelegate = self
        //change the mode of the tag as per ur requirement
        tagView.mode = NRTagsControlMode.edit
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tagControl(tagsControl: NRTagsControl, tappedAtIndex: Int) {
        print("tapped at index")
    }
    
    func tagControl(arrayModel: [TagModel]) {
        //get the tags in form of your model
        print(arrayModel);
    }
}
