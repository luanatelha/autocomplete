//
//  AutocompleteView.swift
//  Interface
//
//  Created by TELHA LUANA on 15/01/2023.
//

import UIKit

final public class AutocompleteView: UIView {
    
    // MARK: - Subviews
    
    private let tableView: UITableView = Subviews.tableView
    private let topSeparatorView: UIView = Subviews.topSeparatorView
    private let bottomSeparatorView: UIView = Subviews.bottomSeparatorView
    
    // MARK: - Initialization
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupShadow()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = shadowPath
    }

    // MARK: - Setup
    
    private func setupLayout() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        addSubview(topSeparatorView)
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topSeparatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Config.separatorMargin),
            topSeparatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Config.separatorMargin),
            topSeparatorView.topAnchor.constraint(equalTo: topAnchor, constant: -Config.separatorMargin),
            topSeparatorView.heightAnchor.constraint(equalToConstant: Config.separatorHeight)
        ])
        
        addSubview(bottomSeparatorView)
        bottomSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomSeparatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Config.separatorMargin),
            bottomSeparatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Config.separatorMargin),
            bottomSeparatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Config.separatorMargin),
            bottomSeparatorView.heightAnchor.constraint(equalToConstant: Config.separatorHeight)
        ])
    }
    
    // MARK: - Methods
    
    func hideSeparatorView(isTop: Bool) {
        topSeparatorView.isHidden = isTop
        bottomSeparatorView.isHidden = !isTop
        tableView.contentInset = isTop ?
        UIEdgeInsets(top: .zero, left: .zero, bottom: bottomSeparatorView.bounds.height, right: .zero) :
        UIEdgeInsets(top: topSeparatorView.bounds.height, left: .zero, bottom: .zero, right: .zero)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func register(cellClasses: [UITableViewCell.Type]) {
        cellClasses.forEach { tableView.register($0, forCellReuseIdentifier: String(describing: $0)) }
    }

    func setTableView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }

    func scrollToTop() {
        tableView.scrollToRow(at: .first, at: .top, animated: false)
    }

    func set(estimatedRowHeight: CGFloat) {
        tableView.estimatedRowHeight = estimatedRowHeight
    }
}

// MARK: - Shadow configuration

private extension AutocompleteView {
    
    func setupShadow() {
        layer.shadowColor = Config.Shadow.color
        layer.shadowRadius = Config.Shadow.radius
        layer.shadowOpacity = Config.Shadow.opacity
        layer.shadowOffset = Config.Shadow.offset
    }
    
    var shadowPath: CGPath {
        UIBezierPath(roundedRect: bounds.shadowFrame, cornerRadius: Config.tableViewCornerRadius).cgPath
    }
}

// MARK: - Subviews

private enum Subviews {
    static var tableView: UITableView {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.layer.cornerRadius = Config.tableViewCornerRadius
        tableView.layer.borderWidth = Config.tableViewBorederWidth
        tableView.layer.borderColor = Config.tableViewBorderColor
        tableView.separatorColor = Config.tableViewSeparatorColor
        tableView.separatorInset = .zero
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }
    
    static var topSeparatorView: UIView {
        let view = UIView()
        view.backgroundColor = Config.separatorBackgroundColor
        let lineView = Subviews.lineView
        view.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Config.lineMargin),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Config.lineMargin),
            lineView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: Config.lineHeight)
        ])
        return view
    }
    
    static var bottomSeparatorView: UIView {
        let view = UIView()
        view.backgroundColor = Config.separatorBackgroundColor
        let lineView = Subviews.lineView
        view.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Config.lineMargin),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Config.lineMargin),
            lineView.topAnchor.constraint(equalTo: view.topAnchor),
            lineView.heightAnchor.constraint(equalToConstant: Config.lineHeight)
        ])
        return view
    }
    
    private static var lineView: UIView {
        let view = UIView()
        view.backgroundColor = Config.lineColor
        return view
    }
}

// MARK: - Config

private enum Config {
    static let separatorHeight: CGFloat = 10
    static let separatorBackgroundColor: UIColor = .white
    static let tableViewCornerRadius: CGFloat = 5
    static let tableViewBorederWidth: CGFloat = 1
    static let tableViewBorderColor: CGColor = UIColor.lightGray.cgColor
    static let tableViewSeparatorColor: UIColor = UIColor.lightGray
    static let lineHeight: CGFloat = 1
    static let lineColor: UIColor = UIColor.lightGray
    static let lineMargin: CGFloat = 20
    static let separatorMargin: CGFloat = 1
    
    enum Shadow {
        static let color: CGColor = UIColor.black.cgColor
        static let radius: CGFloat = 15
        static let opacity: Float = 0.5
        static let offset: CGSize = .init(width: 0, height: 6)
    }
}

// MARK: - Helpers

private extension IndexPath {
    static var first: IndexPath {
        .init(row: .zero, section: .zero)
    }
}

private extension CGRect {
    private var shadowInset: UIEdgeInsets {
        UIEdgeInsets(top: height - Config.tableViewCornerRadius, left: Config.tableViewCornerRadius, bottom: .zero, right: Config.tableViewCornerRadius)
    }
    
    var shadowFrame: CGRect {
        inset(by: shadowInset)
    }
}
