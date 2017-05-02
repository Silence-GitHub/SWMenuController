//
//  SWMenuController.swift
//  SWMenuController
//
//  Created by Kaibo Lu on 2017/4/28.
//  Copyright © 2017年 Kaibo Lu. All rights reserved.
//

import UIKit

private let kContentViewLeftRightMargin: CGFloat = 10
private let kContentViewMaxWidth: CGFloat = UIScreen.main.bounds.width - kContentViewLeftRightMargin * 2
private let kScrollButtonWidth: CGFloat = 30
private let kMenuSpace: CGFloat = 0.5
private let kMenuHeight: CGFloat = 36
private let kMenuMinWidth: CGFloat = 50
private let kMenuMaxWordCount: Int = 15
private let kArrowWidth: CGFloat = 19
private let kArrowHeight: CGFloat = 9
private let kContentViewArrowLeadingTrailingSpace: CGFloat = 5
private let kArrowMinX: CGFloat = kContentViewLeftRightMargin + kContentViewArrowLeadingTrailingSpace // frame origin x
private let kArrowMaxX: CGFloat = UIScreen.main.bounds.width - kContentViewLeftRightMargin - kContentViewArrowLeadingTrailingSpace - kArrowWidth // frame origin x
private let kTargetPointMinX: CGFloat = kArrowMinX + kArrowWidth / 2
private let kTargetPointMaxX: CGFloat = kArrowMaxX + kArrowWidth / 2

class SWMenuController: UIView {

    var menuItems: [SWMenuItem] = [] // all menu items
//    var menuSizeList: [CGSize] = []
    
    private var targetPoint: CGPoint = .zero // in window
    private var arrowDown: Bool = true
    
    private var contentView: UIView!
    private var menuContentView: UIView!
    private var currentMenuPage: Int = 0
    private var menuPageViews: [UIView] = []
    private var menuButtons: [UIButton] = []
    private var scrollLeftButton: UIButton!
    private var scrollRightButton: UIButton!
    private var arrowView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        frame = UIScreen.main.bounds
        
        setupContentView()
        setupScrollButtons()
        setupArrowView()
    }
    
    private func setupContentView() {
        contentView = UIView()
        contentView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(contentViewPanned(_:))))
        addSubview(contentView)
        
        menuContentView = UIView()
        menuContentView.layer.cornerRadius = 8
        menuContentView.layer.masksToBounds = true
        contentView.addSubview(menuContentView)
    }
    
    @objc private func contentViewPanned(_ pan: UIPanGestureRecognizer) {
        
    }
    
    private func setupScrollButtons() {
        scrollLeftButton = UIButton(frame: CGRect(x: 0, y: 0, width: kScrollButtonWidth, height: kMenuHeight))
        scrollLeftButton.backgroundColor = .darkGray
        scrollLeftButton.addTarget(self, action: #selector(scrollButtonClicked(_:)), for: .touchUpInside)
        menuContentView.addSubview(scrollLeftButton)
        
        scrollRightButton = UIButton()
        scrollRightButton.backgroundColor = .darkGray
        scrollRightButton.addTarget(self, action: #selector(scrollButtonClicked(_:)), for: .touchUpInside)
        menuContentView.addSubview(scrollRightButton)
    }
    
    @objc private func scrollButtonClicked(_ button: UIButton) {
        switch button {
        case scrollRightButton:
            if currentMenuPage + 1 > menuItems.count - 1 { return }
            currentMenuPage += 1
        default:
            if currentMenuPage - 1 < 0 { return }
            currentMenuPage -= 1
        }
        for (i, pageView) in menuPageViews.enumerated() {
            pageView.isHidden = i != currentMenuPage
        }
        scrollRightButton.isEnabled = currentMenuPage != menuItems.count - 1
        scrollLeftButton.isHidden = currentMenuPage == 0
    }
    
    private func setupArrowView() {
        arrowView = UIView()
        arrowView.backgroundColor = .blue
        contentView.addSubview(arrowView)
    }
    
    func setMenuVisible(_ menuVisible: Bool, animated: Bool) {
        if menuVisible {
            update()
            UIApplication.shared.keyWindow?.addSubview(self)
        } else {
            removeFromSuperview()
        }
    }
    
    func update() {
        currentMenuPage = 0
        menuPageViews.forEach { $0.removeFromSuperview() }
        menuPageViews.removeAll()
        
        var menuSizeList: [CGSize] = []
        var totalWidth: CGFloat = 0
        menuItems.forEach { (item) in
            var title = item.title
            if title.characters.count > kMenuMaxWordCount {
                title = title.substring(to: title.endIndex)
            }
            var itemWidth = title.boundingRect(with: CGSize(width: CGFloat.infinity,
                                                            height: .infinity),
                                               options: .usesLineFragmentOrigin,
                                               attributes: [ NSFontAttributeName : SWMenuCell.titleFont ],
                                               context: nil).width + 20
            if itemWidth < kMenuMinWidth { itemWidth = kMenuMinWidth }
            totalWidth += itemWidth
            if !menuSizeList.isEmpty { totalWidth += kMenuSpace }
            menuSizeList.append(CGSize(width: itemWidth, height: kMenuHeight))
        }
        
        let contentViewWidth = min(totalWidth, kContentViewMaxWidth)
        
        var contentViewX = targetPoint.x - contentViewWidth / 2
        if contentViewX < kContentViewLeftRightMargin {
            contentViewX = kContentViewLeftRightMargin
        } else if contentViewX + contentViewWidth > UIScreen.main.bounds.width - kContentViewLeftRightMargin {
            contentViewX = UIScreen.main.bounds.width - kContentViewLeftRightMargin - contentViewWidth
        }
        contentView.frame = CGRect(x: contentViewX,
                                   y: arrowDown ? targetPoint.y - kMenuHeight - kArrowHeight : targetPoint.y,
                                   width: contentViewWidth,
                                   height: kMenuHeight + kArrowHeight)
        
        menuContentView.frame = CGRect(x: 0,
                                       y: arrowDown ? 0 : kArrowHeight,
                                       width: contentViewWidth,
                                       height: kMenuHeight)
        
        let targetPointInContentView = contentView.convert(targetPoint, from: nil)
        arrowView.frame = CGRect(x: targetPointInContentView.x,
                                 y: arrowDown ? kMenuHeight : 0,
                                 width: kArrowWidth,
                                 height: kArrowHeight)
        
        let firstPageWidth = kContentViewMaxWidth - (kScrollButtonWidth + kMenuSpace) // exclude scroll button
        let restPageWidth = kContentViewMaxWidth - (kScrollButtonWidth + kMenuSpace) * 2 // exclude scroll button
        
        if totalWidth > kContentViewMaxWidth {
            scrollRightButton.isHidden = false
            scrollRightButton.frame = CGRect(x: menuContentView.bounds.width - kScrollButtonWidth,
                                             y: 0,
                                             width: kScrollButtonWidth,
                                             height: kMenuHeight)
            
            var startIndex: Int = 0
            var endIndex: Int = 0
            var accumulatedWidth: CGFloat = 0
            var accumulateSpace: Bool = false
            let tempList = menuSizeList
            for (i, menuSize) in tempList.enumerated() {
                let pageMaxWidth = startIndex == 0 ? firstPageWidth : restPageWidth
                accumulatedWidth += menuSize.width
                if accumulateSpace {
                    accumulatedWidth += kMenuSpace
                }
                accumulateSpace = true
                if accumulatedWidth > pageMaxWidth || i == menuSizeList.count - 1 {
                    if accumulatedWidth > pageMaxWidth {
                        accumulatedWidth -= menuSize.width + kMenuSpace
                        endIndex = i
                    } else {
                        endIndex = i + 1 // = count
                    }
                    
                    let widthToAdd = (pageMaxWidth - accumulatedWidth) / CGFloat(endIndex - startIndex)
                    let pageView = UIView()
                    if menuPageViews.isEmpty {
                        pageView.isHidden = false
                        pageView.frame = CGRect(x: 0, y: 0, width: pageMaxWidth, height: kMenuHeight)
                    } else {
                        pageView.isHidden = true
                        pageView.frame = CGRect(x: kScrollButtonWidth + kMenuSpace, y: 0, width: pageMaxWidth, height: kMenuHeight)
                    }
                    var buttonX: CGFloat = 0
                    for index in startIndex..<endIndex {
                        var size = menuSizeList[index]
                        size.width += widthToAdd
                        menuSizeList[index] = size
                        let button = UIButton(frame: CGRect(x: buttonX, y: 0, width: size.width, height: size.height))
                        button.backgroundColor = .darkGray
                        button.setTitleColor(.white, for: .normal)
                        button.setTitle(menuItems[index].title, for: .normal)
                        pageView.addSubview(button)
                        menuButtons.append(button)
                        buttonX += size.width + kMenuSpace
                    }
                    menuContentView.addSubview(pageView)
                    menuPageViews.append(pageView)
                    accumulatedWidth = 0
                    accumulateSpace = false
                    startIndex = endIndex
                }
            }
        } else {
            
            
            scrollRightButton.isHidden = true
        }
    }
    
    func setTargetRect(_ targetRect: CGRect, in targetView: UIView) {
        let targetRectInWindow = targetView.convert(targetRect, to: nil)
        var statusBarHeight: CGFloat = 0
        if !UIApplication.shared.isStatusBarHidden {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        let screenBounds = UIScreen.main.bounds
        let x = max(min(targetRectInWindow.midX,
                        kTargetPointMaxX),
                    kTargetPointMinX)
        if kMenuHeight + kArrowHeight <= targetRectInWindow.minY - statusBarHeight {
            // Menu is at the top of target view
            // Arrow down
            targetPoint = CGPoint(x: x, y: targetRectInWindow.minY)
        } else if kMenuHeight + kArrowHeight <= UIScreen.main.bounds.height - targetRectInWindow.maxY {
            // Menu is at the bottom of target view
            // Arrow up
            targetPoint = CGPoint(x: x, y: targetRectInWindow.maxY)
        } else {
            // Menu is at the center of window
            // Arrow down
            targetPoint = CGPoint(x: screenBounds.width / 2, y: screenBounds.height / 2)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        removeFromSuperview()
    }

}
