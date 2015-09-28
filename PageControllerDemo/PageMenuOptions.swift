//
//  LLSPageMenuOptions.swift
//  LLSPageMenu
//
//  Created by YuriJou on 6/23/15.
//  Copyright (c) 2015 YuriJou. All rights reserved.
//

import UIKit

public enum PageMenuOption
{
  
  case Insets           (UIEdgeInsets)
  
  case ItemPadding      (CGFloat)
  case ItemWidth        (CGFloat)
  case ItemHeight       (CGFloat)
  
  case NormalColor      (UIColor)
  case SelectedColor    (UIColor)
  case IndicatorColor   (UIColor)
  case IndicatorHeight  (CGFloat)
  
  case MenuColor        (UIColor)
  case ContentColor     (UIColor)
  
  case ItemNormalFont         (UIFont)
  case ItemSelectedFont       (UIFont)
}

public class ConfigOptions
{
  var insets: UIEdgeInsets = UIEdgeInsetsMake(15, 0, 0, 0)
  
  var itemHeight:      CGFloat     = 44.0
  var itemWidth:       CGFloat     = 64.0
  var itemPadding:     CGFloat     = 20.0
  var indicatorHeight: CGFloat     = 3.0
  var indicatorWidth: CGFloat      = 54.0
  
  var normalColor:    UIColor  = UIColor.blackColor()
  var selectedColor:  UIColor  = UIColor.blackColor()
  var indicatorColor: UIColor  = UIColor.blackColor()
  var menuColor:      UIColor  = UIColor.whiteColor()
  var contentColor:   UIColor  = UIColor.whiteColor()
  
  var itemSelectedFont: UIFont   = UIFont.systemFontOfSize(14.0)
  var itemNormalFont:   UIFont   = UIFont.systemFontOfSize(14.0)
  
  public init(){}
  
  public init(pageMenuOptions: [PageMenuOption]?)
  {
    if let options = pageMenuOptions
    {
      for option in options
      {
        switch(option)
        {
          
        case .Insets(let insets):
          self.insets = insets
          
        case .ItemHeight(let height):
          self.itemHeight = height
        
        case .ItemWidth(let itemWidth):
          self.itemWidth = itemWidth
        
        case .ItemSelectedFont(let itemSelectedFont):
          self.itemSelectedFont = itemSelectedFont
          
        case .ItemNormalFont(let itemNormalFont):
          self.itemNormalFont = itemNormalFont
        
        case .ItemPadding(let itemPadding):
          self.itemPadding = itemPadding
          
        case .NormalColor(let normalColor):
          self.normalColor = normalColor
          
        case .SelectedColor(let selectedColor):
          self.selectedColor = selectedColor
          
        case .IndicatorColor(let indicatorColor):
          self.indicatorColor = indicatorColor
          
        case .IndicatorHeight(let indicatorHeight):
          self.indicatorHeight = indicatorHeight
          
        case .MenuColor(let menuColor):
          self.menuColor = menuColor
          
        case .ContentColor(let contentColor):
          self.contentColor = contentColor
          
        }
      }
    }
  }
}