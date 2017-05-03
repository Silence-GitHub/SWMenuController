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
private let kMenuFont: UIFont = UIFont.systemFont(ofSize: 15)
private let kArrowWidth: CGFloat = 19
private let kArrowHeight: CGFloat = 9
private let kContentViewArrowLeadingTrailingSpace: CGFloat = 8
private let kArrowMinX: CGFloat = kContentViewLeftRightMargin + kContentViewArrowLeadingTrailingSpace // frame origin x
private let kArrowMaxX: CGFloat = UIScreen.main.bounds.width - kContentViewLeftRightMargin - kContentViewArrowLeadingTrailingSpace - kArrowWidth // frame origin x
private let kTargetPointMinX: CGFloat = kArrowMinX + kArrowWidth / 2
private let kTargetPointMaxX: CGFloat = kArrowMaxX + kArrowWidth / 2

protocol SWMenuControllerDelegate: class {
    func menuController(_ menu: SWMenuController, didSelected index: Int)
}

class SWMenuController: UIView {

    weak var delegate: SWMenuControllerDelegate?
    
    var menuItems: [String] = [] // all menu items
    
    private var targetPoint: CGPoint = .zero // in window
    private var arrowDown: Bool = true {
        willSet {
            arrowView.arrowDown = newValue
        }
    }
    
    private var contentView: UIView!
    private var menuContentView: UIView!
    private var currentMenuPage: Int = 0
    private var menuPageViews: [UIView] = []
    private var menuButtons: [UIButton] = []
    private var scrollLeftButton: UIButton!
    private var scrollRightButton: UIButton!
    private var arrowView: SWMenuArrow!
    
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
            if currentMenuPage + 1 > menuPageViews.count - 1 { return }
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
        
        updateArrowView()
    }
    
    private func setupArrowView() {
        arrowView = SWMenuArrow()
        contentView.addSubview(arrowView)
    }
    
    func setMenuVisible(_ menuVisible: Bool, animated: Bool) {
        if menuVisible {
            update()
            UIApplication.shared.keyWindow?.addSubview(self)
        } else {
            dismiss()
        }
    }
    
    override func didMoveToWindow() {
        guard window != nil else { return }
        contentView.alpha = 0
        UIView.animate(withDuration: 0.25) { 
            self.contentView.alpha = 1
        }
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.25, animations: { 
            self.contentView.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    func update() {
        currentMenuPage = 0
        menuPageViews.forEach { $0.removeFromSuperview() }
        menuPageViews.removeAll()
        menuButtons.removeAll()
        
        var menuWidthList: [CGFloat] = []
        var totalWidth: CGFloat = 0
        menuItems.forEach { (item) in
            var title = item
            if title.characters.count > kMenuMaxWordCount {
                title = title.substring(to: title.endIndex)
            }
            var itemWidth = title.boundingRect(with: CGSize(width: CGFloat.infinity,
                                                            height: .infinity),
                                               options: .usesLineFragmentOrigin,
                                               attributes: [ NSFontAttributeName : kMenuFont ],
                                               context: nil).width + 20
            if itemWidth < kMenuMinWidth { itemWidth = kMenuMinWidth }
            totalWidth += itemWidth
            if !menuWidthList.isEmpty { totalWidth += kMenuSpace }
            menuWidthList.append(itemWidth)
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
        
        let targetPointInContentView = contentView.convert(targetPoint, from: UIApplication.shared.keyWindow)
        arrowView.frame = CGRect(x: targetPointInContentView.x - kArrowWidth / 2,
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
            var needToAddLast: Bool = false
            let tempList = menuWidthList
            for (i, menuWidth) in tempList.enumerated() {
                let pageMaxWidth = startIndex == 0 ? firstPageWidth : restPageWidth
                accumulatedWidth += menuWidth
                if i != 0 {
                    accumulatedWidth += kMenuSpace
                }
                if accumulatedWidth > pageMaxWidth || i == menuWidthList.count - 1 {
                    if accumulatedWidth > pageMaxWidth {
                        accumulatedWidth -= menuWidth + kMenuSpace
                        endIndex = i
                        if i == menuWidthList.count - 1 {
                            needToAddLast = true
                        }
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
                        var width = menuWidthList[index]
                        width += widthToAdd
                        let button = produceMenuButton()
                        button.frame = CGRect(x: buttonX, y: 0, width: width, height: kMenuHeight)
                        button.setTitle(menuItems[index], for: .normal)
                        pageView.addSubview(button)
                        menuButtons.append(button)
                        buttonX += width + kMenuSpace
                    }
                    menuContentView.addSubview(pageView)
                    menuPageViews.append(pageView)
                    accumulatedWidth = menuWidth
                    startIndex = endIndex
                }
            }
            if needToAddLast {
                let pageView = UIView()
                pageView.frame = CGRect(x: kScrollButtonWidth + kMenuSpace, y: 0, width: restPageWidth, height: kMenuHeight)
                pageView.isHidden = true
                let button = produceMenuButton()
                button.frame = CGRect(x: 0, y: 0, width: restPageWidth, height: kMenuHeight)
                button.setTitle(menuItems.last, for: .normal)
                pageView.addSubview(button)
                menuButtons.append(button)
                menuContentView.addSubview(pageView)
                menuPageViews.append(pageView)
            }
        } else {
            scrollRightButton.isHidden = true
            
            let pageView = UIView(frame: CGRect(x: 0, y: 0, width: totalWidth, height: kMenuHeight))
            var buttonX: CGFloat = 0
            for (i, item) in menuItems.enumerated() {
                let button = produceMenuButton()
                button.frame = CGRect(x: buttonX, y: 0, width: menuWidthList[i], height: kMenuHeight)
                button.setTitle(item, for: .normal)
                pageView.addSubview(button)
                menuButtons.append(button)
                buttonX += menuWidthList[i] + kMenuSpace
            }
            menuContentView.addSubview(pageView)
            menuPageViews.append(pageView)
        }
        updateArrowView()
    }
    
    private func produceMenuButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .darkGray
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = kMenuFont
        button.addTarget(self, action: #selector(menuButtonClicked(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func menuButtonClicked(_ button: UIButton) {
        guard let index = menuButtons.index(of: button) else { return }
        dismiss()
        delegate?.menuController(self, didSelected: index)
    }
    
    private func updateArrowView() {
        let pageView = menuPageViews[currentMenuPage]
        for button in pageView.subviews {
            let buttonFrameInContentView = contentView.convert(button.frame, from: pageView)
            let y = buttonFrameInContentView.minY - kArrowHeight
            let height = kArrowHeight * 2 + buttonFrameInContentView.height
            let leftFrame = CGRect(x: buttonFrameInContentView.minX - kMenuSpace,
                                   y: y,
                                   width: kMenuSpace,
                                   height: height)
            if leftFrame.intersects(arrowView.frame) {
                let intersection = leftFrame.intersection(arrowView.frame)
                arrowView.blankRect = arrowView.convert(intersection, from: contentView)
                arrowView.drawImage()
                return
            }
            let rightFrame = CGRect(x: buttonFrameInContentView.maxX,
                                    y: y,
                                    width: kMenuSpace,
                                    height: height)
            if rightFrame.intersects(arrowView.frame) {
                let intersection = rightFrame.intersection(arrowView.frame)
                arrowView.blankRect = arrowView.convert(intersection, from: contentView)
                arrowView.drawImage()
                return
            }
        }
        arrowView.blankRect = .zero
        arrowView.drawImage()
    }
    
    func setTargetRect(_ targetRect: CGRect, in targetView: UIView) {
        let targetRectInWindow = targetView.convert(targetRect, to: UIApplication.shared.keyWindow)
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
            arrowDown = true
        } else if kMenuHeight + kArrowHeight <= UIScreen.main.bounds.height - targetRectInWindow.maxY {
            // Menu is at the bottom of target view
            // Arrow up
            targetPoint = CGPoint(x: x, y: targetRectInWindow.maxY)
            arrowDown = false
        } else {
            // Menu is at the center of window
            // Arrow down
            targetPoint = CGPoint(x: screenBounds.width / 2, y: screenBounds.height / 2)
            arrowDown = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print(#function)
        dismiss()
    }

}
