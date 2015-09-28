//
//  LLSPageMenuView.swift
//  LLSPageMenu
//
//  Created by YuriJou on 6/19/15.
//  Copyright (c) 2015 YuriJou. All rights reserved.
//

import UIKit

public enum PageMenuViewState: Int
{
  case Selected
  case Normal
}

public enum PageMenuViewOptions
{
  case SelectedFont   (UIFont)
  case NormalFont     (UIFont)
  
  case SelectedColor  (UIColor)
  case NormalColor    (UIColor)
}

public class PageMenuView: UIView,
  UIGestureRecognizerDelegate

{
  public var index: Int     = 0
  public var handleTapClosure: ((menuView: PageMenuView) -> Void)?
  
  private var title: UILabel = UILabel(frame: CGRectZero)
  private var selectedFont:  UIFont  = UIFont.systemFontOfSize(12.0)
  private var selectedColor: UIColor = UIColor.blackColor()
  private var normalFont:    UIFont  = UIFont.systemFontOfSize(10.0)
  private var normalColor:   UIColor = UIColor.blackColor()
  

  public var state: PageMenuViewState = .Normal
  {
    
    didSet{
      switch(state)
      {
      case .Selected:
        title.font = self.selectedFont
        title.textColor = self.selectedColor
        
      case .Normal:
        self.title.font = self.normalFont
        self.title.textColor = self.normalColor
      }
    }
    
  }
  
  public init(frame: CGRect, options:[PageMenuViewOptions]?)
  {
    super.init(frame: frame)
    setOptions(options)
  }
  
  public func setOptions(options: [PageMenuViewOptions]?)
  {
    if let ops = options
    {
      for option in ops
      {
        switch(option)
        {
          case .NormalFont(let normalFont):
            self.normalFont = normalFont
          case .NormalColor(let normalColor):
            self.normalColor = normalColor
          case .SelectedFont(let selectedFont):
            self.selectedFont = selectedFont
          case .SelectedColor(let  selectedColor):
            self.selectedColor = selectedColor
        }
      }
    }
    if state == .Normal {state = .Normal}
    else {state = .Selected}
  }
  
  required public init(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)!
  }
  override init(frame: CGRect) {
   super.init(frame: frame)
  }

  
  override public func layoutSubviews()
  {
    super.layoutSubviews()
    layoutViews()
  }
  
  public func setText(string: String){
    title.text = string
    bringSubviewToFront(self.title)
  }
  
  public func handleTap(gusture :UIGestureRecognizer)
  {
    if let closure = self.handleTapClosure
    {
      closure(menuView: self)
    }
  }
}

//MARK: handle menu view's layouts
extension PageMenuView
{
  private func layoutViews()
  {
    addSubview(title)
    title.translatesAutoresizingMaskIntoConstraints = false
    let vertical = NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-(0)-[view]-(0)-|",
      options: .AlignAllBaseline,
      metrics: nil,
      views: ["view":title]
    )
    
    let horizonal = NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-(0)-[view]-(0)-|",
      options: .AlignAllBaseline ,
      metrics: nil,
      views: ["view":title]
    )
    
    addConstraints(vertical + horizonal)
    
    title.userInteractionEnabled = false
    title.textAlignment = .Center
    
    let tapGes = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
    tapGes.delegate = self
    addGestureRecognizer(tapGes)
  }

}
