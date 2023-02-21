//
//  AutocompleteViewController.swift
//  Interface
//
//  Created by TELHA LUANA on 15/01/2023.
//

import Foundation
import UIKit

final public class AutocompleteViewController: UIViewController {
    
    var containableView: AutocompleteView {
        guard let view = view as? AutocompleteView else {
            fatalError("Please implement 'loadView()' with proper view type in \(type(of: self))")
        }
        return view
    }
    
    // MARK: - Properties
    
    var viewModel: AutocompleteViewModel
    
    private weak var delegate: AutocompleteProtocol? {
        didSet {
            delegate
                .map( \.heightForCells )
                .map( containableView.set(estimatedRowHeight:) )
        }
    }
    
    private var direction: DropDirection? {
        didSet {
            direction
                .map( \.isTop )
                .map( containableView.hideSeparatorView(isTop:) )
        }
    }
    
    private var keyboardFrame: CGRect = .zero
    private var keyboardIsVisible: Bool = false
    
    // MARK: - Keyboard observer
    
    private var keyboardWillShowObserver: Any?
    private var keyboardWillHideObserver: Any?
    private var keyboardWillChangeFrameObserver: Any?
        
    // MARK: - Lifecycle
    
    public init(viewModel: AutocompleteViewModel, delegate: AutocompleteProtocol) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        unregisterForKeyboardNotifications()
    }
    
    public override func loadView() {
        view = AutocompleteView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupOutputBindings()
    }
    
    // MARK: - Setup
    
    func setupOutputBindings() {
        viewModel.output.onSearchResults = { filteredItems, showAutocomplete in
            guard showAutocomplete else {
                self.hideAutocompleteTableView()
                return
            }
            self.viewModel.items = filteredItems
            self.containableView.reloadData()
            if filteredItems.count > 0 || self.viewModel.hasAdditionalItem {
                self.showAutocompleteTableView()
                self.containableView.scrollToTop()
            } else {
                self.hideAutocompleteTableView()
            }
        }
    }
    
    // MARK: - Methods

    public func setupAutocomplete(for parentView: UIView) {
        view.removeFromSuperview()
        view.willMove(toSuperview: parentView)
        parentView.addSubview(view)
        view.didMoveToSuperview()
    }
    
    public func textFieldDidEndEditing() {
        hideAutocompleteTableView()
    }
    
    public func filter(_ text: String?, in items: [AutocompleteSearchableItemProtocol]?) {
        viewModel.items = items ?? []
        viewModel.input.search?(text)
    }
    
    // MARK: - Private Methods

    private func setupViews() {
        view.backgroundColor = .clear
        view.isHidden = true
        guard let delegate = delegate else { return }
        if let additionalItemType = delegate.additionalItemType {
            containableView.register(cellClasses: [delegate.cellType, additionalItemType])
        } else {
            containableView.register(cellClasses: [delegate.cellType])
        }
        containableView.setTableView(
            delegate: self,
            dataSource: self
        )
        registerForKeybordNotifications()
    }
    
    private func setupTableView(with layout: AutocompleteLayoutManager.Output) {
        view.frame = CGRect(x: layout.x,
                            y: layout.y,
                            width: layout.width,
                            height: tableViewHeight() - layout.offscreenHeight)
    }
        
    private func autoCompleteAnimation(for layout: AutocompleteLayoutManager.Output?, hide: Bool) {
        UIView.animate(withDuration: Config.animationDuration, animations: {
            self.view.frame.size.height = hide ? 0.0 : self.tableViewHeight() - (layout?.offscreenHeight ?? 0)
            self.view.isHidden = hide
        },
        completion: nil)
    }
        
    private func showAutocompleteTableView() {
        let inputLayout = AutocompleteLayoutManager.Input(
            anchorView: anchorView,
            anchorFrame: anchorViewFrame,
            height: tableViewHeight(),
            width: width,
            keyboardFrame: keyboardFrame,
            keyboardIsVisible: keyboardIsVisible
        )
        var layout = AutocompleteLayoutManager.shared.computeLayoutBottomDisplay(with: inputLayout)
        direction = .bottom
        if layout.offscreenHeight > 0 {
            let topLayout = AutocompleteLayoutManager.shared.computeLayoutForTopDisplay(with: inputLayout)
            if topLayout.offscreenHeight < layout.offscreenHeight {
                layout = topLayout
                direction = .top
            }
        }
        setupTableView(with: layout)
        autoCompleteAnimation(for: layout, hide: false)
    }
    
    private func hideAutocompleteTableView() {
        autoCompleteAnimation(for: nil, hide: true)
    }
        
    private func tableViewHeight() -> CGFloat {
        guard let delegate = delegate else { return 0 }
        let addBeneficiaryCellHeight: CGFloat = (viewModel.hasAdditionalItem ? delegate.heightForAdditionalItem ?? .zero : .zero)
        return CGFloat(viewModel.items.count) * cellHeight + addBeneficiaryCellHeight + Config.headerFooterHeight
    }
    
    private func registerForKeybordNotifications() {
        keyboardWillShowObserver = NotificationCenter.default.addObserver(
            forName: UITextField.keyboardWillShowNotification,
            object: .none,
            queue: .none,
            using: { [weak self] (notification: Notification) in
                self?.keyboardWillShow(notification)
            }
        )
        keyboardWillHideObserver = NotificationCenter.default.addObserver(
            forName: UITextField.keyboardWillHideNotification,
            object: .none,
            queue: .none,
            using: { [weak self] (notification: Notification) in
                self?.keyboardWillHide(notification)
            }
        )
        keyboardWillChangeFrameObserver = NotificationCenter.default.addObserver(
            forName: UITextField.keyboardWillChangeFrameNotification,
            object: .none,
            queue: .none,
            using: { [weak self] (notification: Notification) in
                self?.keyboardWillShow(notification)
            }
        )
    }
    
    private func unregisterForKeyboardNotifications() {
        keyboardWillShowObserver.map( NotificationCenter.default.removeObserver )
        keyboardWillHideObserver.map( NotificationCenter.default.removeObserver )
        keyboardWillChangeFrameObserver.map( NotificationCenter.default.removeObserver )
    }
    
    private func keyboardFrame(fromNotification notification: Notification) -> CGRect {
        ((notification as NSNotification).userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
    }
    
    private func keyboardWillShow(_ notification: Notification) {
        keyboardIsVisible = true
        keyboardFrame = keyboardFrame(fromNotification: notification)
    }
    
    private func keyboardWillHide(_ notification: Notification) {
        keyboardIsVisible = false
        keyboardFrame = keyboardFrame(fromNotification: notification)
    }
    
}

// MARK: - Computed properties

private extension AutocompleteViewController {
    var cellHeight: CGFloat { delegate?.heightForCells ?? .zero }
    var footerHeight: CGFloat { delegate?.heightForAdditionalItem ?? .zero }
    var width: CGFloat? { anchorView?.bounds.width }
    var anchorView: UIView? { delegate?.textFieldContainerView }
    var anchorViewFrame: CGRect? { delegate?.textFieldContainerFrame }
}

// MARK: - AutocompleteFieldViewController.DropDirection

private extension AutocompleteViewController {
    enum DropDirection {
        case top, bottom
    }
}

private extension AutocompleteViewController.DropDirection {
    var isTop: Bool { self == .top }
}

// MARK: - Config

private enum Config {
    static var headerFooterHeight: CGFloat { 9 }
    static var animationDuration: TimeInterval { 0.2 }
}


// MARK: - UITableViewDelegate & UITableViewDataSource

extension AutocompleteViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        direction == .bottom ? Config.headerFooterHeight : 0
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        direction == .top ? Config.headerFooterHeight : 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let delegate = delegate
        else {
            return UITableViewCell()
        }
        
        if viewModel.hasAdditionalItem, viewModel.isAdditonalItem(indexPath) {
            return delegate.additionalCell(tableView, in: indexPath)
        }
        return delegate.cell(tableView, in: indexPath, with: viewModel.itemForIndex(indexPath))
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        delegate?.textFieldContainerView.endEditing(true)
        if let item = viewModel.itemForIndex(indexPath) {
            delegate?.onItemSelection?(item)
        } else {
            delegate?.onAdditionalItemSelection?(delegate?.searchText)
        }
    }
}
