//
//  LLSPageMenuController.swift
//  LLSPageMenu
//
//  Created by Yuri.Jou on 6/19/15.
//  Copyright (c) 2015 YuriJou. All rights reserved.
//

import UIKit

public class PageMenuController:
  UIViewController,
  UIScrollViewDelegate,
  UIGestureRecognizerDelegate
{

  public var menuArr:[PageMenuView] = []
  public var controllerArr: [UIViewController] = []{
    didSet{
      reloadData()
    }
  }
  
  public var configOptions: ConfigOptions = ConfigOptions(){
    didSet{
      
      reloadData()
    }
  }
  
  public init(viewControllers: [UIViewController], frame: CGRect, options: [PageMenuOption]?)
  {
    super.init(nibName: nil, bundle: nil)
    
    if viewControllers.count == 0
    {
      return
    }
    
    controllerArr = viewControllers
    view.frame = frame
    
    reloadData()
  }
  
  required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
  private var offset: CGFloat  = 0
  private var currentPage: Int = 0
  
  private let menu      = UIScrollView()
  private let content   = UIScrollView()
  
  private var indicator: UIView = UIView(frame: CGRectZero)
  
  
  private func reloadData()
  {
    setup()
    pushMenuItems()

    scrollToPage(currentPage)
    menuArr[currentPage].state = .Selected
  }
  
  private func setup()
  {
    decorateScrollView(menu)
    decorateScrollView(content)
    
    layoutViews()
    content.contentSize = CGSizeMake(CGFloat(controllerArr.count) * CGRectGetWidth(content.frame), 0)
  }
  
  //MARK: - layout
  private func layoutViews()
  {
    view.addSubview(menu)
    menu.backgroundColor = configOptions.menuColor
    menu.translatesAutoresizingMaskIntoConstraints = false
    
    let mv = NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-(0)-[view(==60)]",
      options: .AlignAllBaseline,
      metrics: nil,
      views: ["view" : menu])
    
    let mh = NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-(0)-[view]-(0)-|",
      options: .AlignAllBaseline,
      metrics: nil,
      views: ["view" : menu])
    
    view.addConstraints(mv + mh)
    
    content.backgroundColor = configOptions.contentColor
    view.addSubview(content)
    content.translatesAutoresizingMaskIntoConstraints = false
    
    let cv = NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-(60)-[view]-(0)-|",
      options: .AlignAllBaseline,
      metrics: nil,
      views: ["view" : content])
    
    let ch = NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-(0)-[view]-(0)-|",
      options: .AlignAllBaseline,
      metrics: nil,
      views: ["view" : content])
    
    view.addConstraints(cv + ch)
    
    menu.addSubview(indicator)
    
    indicator.backgroundColor = configOptions.indicatorColor
    indicator.userInteractionEnabled = false
    
    indicator.setFrameHeight(configOptions.indicatorHeight)
    indicator.setFrameWidth(configOptions.indicatorWidth)
    let originY = configOptions.itemHeight - configOptions.indicatorHeight + configOptions.insets.top
    indicator.setOriginY(originY)
    
  }
  
  private func decorateScrollView(scrollview :UIScrollView)
  {
    scrollview.showsHorizontalScrollIndicator = false
    scrollview.showsVerticalScrollIndicator   = false
    scrollview.scrollsToTop = false
    scrollview.scrollEnabled = false
  }
  
}

//MARK: handle page's selected state
extension PageMenuController
{
  func setMenuOptions()
  {
    for m in menuArr
    {
      m.setOptions([
          .SelectedColor(configOptions.selectedColor),
          .NormalColor(configOptions.normalColor),
          .SelectedFont(configOptions.itemSelectedFont),
          .NormalFont(configOptions.itemNormalFont),
        ])
    }

  }
}

//MARK: handle page's layout action
extension PageMenuController
{
  
  func pushMenuItems()
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
    
    for controller in controllerArr
    {
      let view = PageMenuView(frame: frame)
      view.backgroundColor = UIColor.clearColor()
      menu.addSubview(view)
      
      view.index = menuArr.count
      view.state = .Normal
      view.setText(controller.title ?? "MENU_\(view.index)")

      view.handleTapClosure = {(menuView: PageMenuView) -> Void in
        
        self.menuArr[self.currentPage].state = .Normal
        
        UIView.animateWithDuration(0.2){
          self.indicator.setCenterX(menuView.center.x)
        }
        
        self.scrollToPage(menuView.index)
        menuView.state = .Selected
      }
      menuArr.append(view)
    }
    pushItemCentralAlign(configOptions.itemWidth)
    indicator.setCenterX(menuArr[0].center.x)
    setMenuOptions()
  }
  
  func pushItemCentralAlign(width: CGFloat)
  {
    let trail = configOptions.insets.left
    let spacing = configOptions.itemPadding
    
    let spaces = spacing * CGFloat(menuArr.count - 1)
    let widths = width * CGFloat(menuArr.count)
    let trails = trail * 2
    
    let totalWidth = spaces + widths + trails
    
    menu.contentSize = CGSizeMake(totalWidth, 0)
    
    var startX = trail
    
    if totalWidth < CGRectGetWidth(view.frame)
    {
      startX = (CGRectGetWidth(view.frame) - totalWidth) / 2 + trail
    }
    
    for var index = 0; index < menuArr.count; index++
    {
      menuArr[index].setOriginX(startX + trail * CGFloat(index) + width * CGFloat(index) + spacing * CGFloat(index))
    }
    
    let count = Int(floor(CGFloat(CGRectGetWidth(view.frame)) / CGFloat(width + spacing)));
    let moveCount = controllerArr.count - count
    
    if moveCount > 0
    {
      let totalOffset = totalWidth - CGRectGetWidth(view.frame)
      offset = totalOffset / CGFloat(controllerArr.count - 1)
    }
  }
  
}


//MARK: handle page's moved action
extension PageMenuController
{
  private func scrollToPage(page: Int){
    currentPage = page
    
    let offsetX = CGFloat(page) * CGRectGetWidth(view.frame);
    content.setContentOffset(CGPointMake(offsetX, 0), animated: true)
    menu.setContentOffset(CGPointMake(offset * CGFloat(page), 0), animated: true)
    
    let controller = controllerArr[page]
    controller.willMoveToParentViewController(self)
    
    let pageWidth = CGRectGetWidth(content.frame)
    let pageHeight = CGRectGetHeight(content.frame)
    
    controller.view.frame = CGRectMake(
      CGFloat(page) * pageWidth,
      0,
      pageWidth,
      pageHeight
    )
    
    addChildViewController(controller)
    content.addSubview(controller.view)
    controller.didMoveToParentViewController(self)
  }

  private func moveNext()
  {
    ++currentPage
    currentPage > 0 ? currentPage = controllerArr.count : scrollToPage(currentPage)
  }
  
  private func movePre()
  {
    --currentPage
    currentPage < 0 ? currentPage = 0 : scrollToPage(currentPage)
  }

}
