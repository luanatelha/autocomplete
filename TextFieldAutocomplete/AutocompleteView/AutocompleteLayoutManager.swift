//
//  AutocompleteLayoutManager.swift
//  Interface
//
//  Created by TELHA LUANA on 15/01/2023.
//

import UIKit

extension AutocompleteLayoutManager {
    struct Input {
        var anchorView: UIView?
        var anchorFrame: CGRect?
        var height: CGFloat?
        var width: CGFloat?
        var keyboardFrame: CGRect?
        var keyboardIsVisible: Bool
    }
    
    struct Output {
        var x: CGFloat
        var y: CGFloat
        var width: CGFloat
        var offscreenHeight: CGFloat
    }
}

class AutocompleteLayoutManager {
    
    static let shared: AutocompleteLayoutManager = AutocompleteLayoutManager()
    
    private let window: UIWindow = UIApplication.shared.keyWindow ?? UIWindow()

    // MARK: - Public methods
    
    func computeLayoutForTopDisplay(with input: Input) -> Output {
        var offscreenHeight: CGFloat = 0

        let width = input.width ?? (input.anchorFrame?.width ?? 0)
        
        let anchorViewX = input.anchorFrame?.minX ?? 0
        let anchorViewY = (input.anchorFrame?.minY ?? 0) + Config.offset

        var y = anchorViewY - (input.height ?? 0.0)

        let windowY = window.bounds.minY + Config.margin

        if y < windowY {
            offscreenHeight = abs(y - windowY)
            y = windowY
        }
        
        return Output(x: anchorViewX, y: y, width: width, offscreenHeight: offscreenHeight)
    }
    
    func computeLayoutBottomDisplay(with input: Input) -> Output {
        var offscreenHeight: CGFloat = 0
        
        let width = input.width ?? (input.anchorFrame?.width ?? 0)
        let height = input.height ?? 0.0
        
        let anchorViewX = input.anchorFrame?.minX ?? window.frame.midX - (width / 2)
        let anchorViewY = (input.anchorFrame?.maxY ?? window.frame.midY - (height / 2)) - Config.offset
        
        let anchorViewFrameInWindow = input.anchorView?.convert(input.anchorView?.bounds ?? .zero, to: nil)
        let maxY = (anchorViewFrameInWindow?.maxY ?? anchorViewY) + height
        let windowMaxY = window.bounds.maxY - Config.margin
        
        let keyboardMinY = (input.keyboardFrame?.minY ?? 0.0) - Config.margin
        
        if input.keyboardIsVisible && maxY > keyboardMinY {
            offscreenHeight = abs(maxY - keyboardMinY)
        } else if maxY > windowMaxY {
            offscreenHeight = abs(maxY - windowMaxY)
        }
        
        return Output(x: anchorViewX, y: anchorViewY, width: width, offscreenHeight: offscreenHeight)
    }
}

private enum Config {
    static var margin: CGFloat { 20 }
    static var offset: CGFloat { 10 }
}

