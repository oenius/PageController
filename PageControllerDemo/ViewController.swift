//
//  ViewController.swift
//  PageControllerDemo
//
//  Created by YURI_JOU on 15/9/28.
//  Copyright © 2015年 oenius. All rights reserved.
//

import UIKit

class ViewController: PageMenuController {

  override func viewDidLoad() {
    super.viewDidLoad()
    UIApplication.sharedApplication().statusBarHidden = true
    
    view.backgroundColor = UIColor.yellowColor()
    
    let titles: [String] = [
      "HAPPY",
      "FOOD",
      "OENIUS",
      "FUNNY",
      "STORY",
      "COOL",
      "MOOD",
    ]
    
    let controllers = titles.map { (title) -> UIViewController in
      let v = UIViewController()
      v.view.backgroundColor = UIColor(red: 70.0 / 255, green: 70.0 / 255, blue: 70.0 / 255, alpha: 1)
      let container = UIView(frame: CGRectMake(0, 0, 200, 200))
      container.backgroundColor = UIColor.clearColor()
      container.layer.borderColor = UIColor.orangeColor().CGColor
      container.layer.borderWidth = 2.0
      container.layer.cornerRadius = 100
      container.layer.masksToBounds = true
      container.center = v.view.center
      let label = UILabel(frame: CGRectMake(0, 0, CGRectGetWidth(v.view.frame), 60))
      label.text = title
      label.font = UIFont.systemFontOfSize(20)
      label.textAlignment = .Center
      label.textColor = UIColor.orangeColor()
      label.center = container.center
      v.view .addSubview(label)
      v.view .addSubview(container)
      v.title = title
      return v
    }
    
    self.controllerArr = controllers;
    
    self.configOptions = ConfigOptions(
      pageMenuOptions:
      [
        .SelectedColor(UIColor.orangeColor()),
        .NormalColor(UIColor.whiteColor()),
        .IndicatorColor(UIColor.orangeColor()),
        .MenuColor(UIColor(red: 30.0 / 255, green: 30.0 / 255, blue: 30.0 / 255, alpha: 1)),
      ]
    )
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

