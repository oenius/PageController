//
//  LLSPageMenuBar.swift
//  LLSPageMenu
//
//  Created by YuriJou on 6/24/15.
//  Copyright (c) 2015 YuriJou. All rights reserved.
//

import UIKit

public class PageMenuBar: UIScrollView
{
  
  public var configOptions: ConfigOptions = ConfigOptions()
  
  public var selectedMenu: ((menu: PageMenuView, index: Int) -> Void)?
  
  private var currentIndex: Int          = 0
  private var offset: CGFloat            = 0.0
  
  private var indicator: UIView          = UIView(frame: CGRectZero)
  
  private var menuArr: [PageMenuView] = []
  private var titles:  [String]          = []
  
  private var beMaked: Bool              = false
  
  public init(frame: CGRect, titles: [String], options: [PageMenuOption])
  {
    super.init(frame: frame)
    
    if titles.count == 0
    {
      return
    }
    
    setTitles(titles, options: options)
  }
  
  public func setTitles(titles: [String], options: [PageMenuOption])
  {
    
    configOptions = ConfigOptions(pageMenuOptions: options)
    self.titles = titles
    setupItems()
  
  }
  
  required public init(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)!
  }

  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    if titles.count == 0
    {
      return
    }
    
    if !beMaked
    {
      setupItems()
      
      setupLayout()
      indicator.setCenterX(self.menuArr[currentIndex].center.x)
      menuArr[currentIndex].state = .Selected
      
      beMaked = true
    }

  }
  
  private func setupLayout()
  {
    showsVerticalScrollIndicator = false
    showsHorizontalScrollIndicator = false
    scrollsToTop = false
    scrollEnabled = true
    
    addSubview(indicator)
    
    indicator.setFrameHeight(configOptions.indicatorHeight)

    indicator.setFrameWidth(50)
    indicator.setOriginY(CGRectGetHeight(frame) - configOptions.indicatorHeight)
    
    indicator.backgroundColor = configOptions.indicatorColor
  }
  
  private func setupItems()
  {
    for view in menuArr
    {
      view.removeFromSuperview()
    }
    
    
    menuArr.removeAll(keepCapacity: true)
    
    let frame = CGRectMake(0,
      configOptions.insets.top,
      configOptions.itemWidth,
      configOptions.itemHeight)
    
    for title in titles
    {
      let view = PageMenuView(frame: frame, options: [
        
          .SelectedFont(configOptions.itemSelectedFont),
          .NormalFont(configOptions.itemNormalFont),
        
          .SelectedColor(configOptions.selectedColor),
          .NormalColor(configOptions.normalColor),
        
        ])
      view.backgroundColor = UIColor.clearColor()
      addSubview(view)
      view.index = menuArr.count
    
      view.setText(title.isEmpty ? "MENU_\(view.index)" : title)
      
      view.state = .Normal
      
      view.handleTapClosure = {(menuView: PageMenuView) -> Void in
        self.scrollToIndex(menuView.index)
      }
      menuArr.append(view)
    }
    
    pushItemCentralAlign(configOptions.itemWidth)
    
  }
  
}

//MARK: page menu bar's push item
extension PageMenuBar
{
  private func pushItemCentralAlign(width: CGFloat)
  {
    let padding = configOptions.itemPadding
    let left = configOptions.insets.left
    
    let contentWidth = padding * CGFloat(menuArr.count - 1) +
      width * CGFloat(menuArr.count) +
      left * 2
    
    contentSize = CGSizeMake(contentWidth, 0)
    var startX = left
    if contentWidth < CGRectGetWidth(frame)
    {
      startX = (CGRectGetWidth(self.frame) - contentWidth) / 2 + left
    }
    
    for var index = 0; index < menuArr.count; index++
    {
      menuArr[index].setOriginX(startX + padding * CGFloat(index) + width * CGFloat(index))
    }
    
    
    let count = floor(Float(CGRectGetWidth(frame)) / Float(width + padding));
    let moveCount = titles.count - Int(count)
    
    if moveCount > 0
    {
      let totalOffset = contentWidth - CGRectGetWidth(frame)
      offset = totalOffset / CGFloat(titles.count - 1)
    }
  }

}

//MARK: handle menu bar's layout
extension PageMenuBar
{
  private func scrollToIndex(index: Int){
    menuArr[currentIndex].state = .Normal
    UIView.animateWithDuration(0.2, animations: { () -> Void in
      self.indicator.setCenterX(self.menuArr[index].center.x)
    })
    menuArr[index].state = .Selected
    if let closure = selectedMenu
    {
      closure(menu: menuArr[index], index: index)
    }
    
    setContentOffset(CGPointMake(offset * CGFloat(index), 0), animated: true)
    currentIndex = index
    
  }
  
  private func moveNext()
  {
    
    ++currentIndex
    currentIndex > titles.count ? currentIndex = titles.count : scrollToIndex(currentIndex)
  }
  
  private func movePre()
  {
    --currentIndex
    currentIndex < 0 ? currentIndex = 0 : scrollToIndex(currentIndex)
  }

}
