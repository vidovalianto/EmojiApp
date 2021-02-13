//
//  ParentViewController.swift
//  EmojiApp
//
//  Created by Vido Shaweddy on 2/12/21.
//

import Combine
import UIKit

class ParentViewController: UINavigationController {
  private let searchController = UISearchController()
  private var searchVC: EmojiPickerViewController!
  private var cancellables = Set<AnyCancellable>()

  public var color: UIColor = .systemBackground
  public var collectionViewColor: UIColor = .systemBackground
  var emojiLVM: EmojiListViewModel!
  var pageVC: UIPageViewController!
  var emojisVC = [UIViewController]()
  var emojisVCIcon = [String]()
  var searchTask: DispatchWorkItem?
  var pendingIndex = 0
  lazy var pageControl: EmojiPageControl = {
    let pageControl = EmojiPageControl()
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    return pageControl
  }()

  override func viewDidLoad() {
    self.view.backgroundColor = color

    emojiLVM = EmojiListViewModel()
    searchVC = EmojiPickerViewController()
    searchVC.color = collectionViewColor

    pageVC = UIPageViewController(transitionStyle: .scroll,
                                  navigationOrientation: .horizontal,
                                  options: nil)
    pageVC.navigationItem.searchController = searchController
    pageVC.dataSource = self
    pageVC.delegate = self

    viewControllers = [pageVC]
//    setupPageControl()

    self.navigationBar.isTranslucent = false
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Emojis"
    definesPresentationContext = true
    self.pageVC.setViewControllers([UIViewController()],
                                   direction: .forward,
                                   animated: false,
                                   completion: nil)
    let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
    pageControl.backgroundStyle = .prominent
    pageControl.numberOfPages = 7
    pageControl.currentPage = 0
    pageControl.pageIndicatorTintColor = .systemFill
    pageControl.currentPageIndicatorTintColor = .secondaryLabel
    ["👮🏻‍♀️", "🐻", "⛰", "🚴🏻‍♂️", "💡", "⁉️", "🏳️"].enumerated().forEach { i, emoji in
      pageControl.setIndicatorImage(emoji.image(), forPage: i)
    }

    emojiLVM.$isSearching
      .receive(on: DispatchQueue.main)
      .sink { [weak self] isSearching in
        guard let self = self else { return }
        if let initialVC = self.searchVC, isSearching {
          let viewModel = EmojiPickerViewController.ViewModel(title: "",
                                                              emojis: self.emojiLVM.searchResults)
          initialVC.configure(viewModel)
          self.pageVC.setViewControllers([initialVC],
                                         direction: .forward,
                                         animated: false,
                                         completion: nil)
          pageControl.isHidden = true
        } else if let initialVC = self.emojisVC.first {
          self.pageVC.setViewControllers([initialVC],
                                         direction: .forward,
                                         animated: false,
                                         completion: nil)
          pageControl.isHidden = false
        }
      }.store(in: &cancellables)

    emojiLVM.$categories
      .receive(on: DispatchQueue.main)
      .sink { [weak self] categories in
        guard let self = self else { return }
        var emojisVCIcon = [String]()
        self.emojisVC = categories.enumerated().map({ i, category -> UIViewController in
          let vc = EmojiPickerViewController()
          vc.color = self.collectionViewColor
          let viewModel = EmojiPickerViewController.ViewModel(title: category.titleEmoji,
                                                              emojis: category.emojis)
          vc.configure(viewModel)
          emojisVCIcon.append(category.titleEmoji)
          return vc
        })
        self.emojisVCIcon = emojisVCIcon

        if let initialVC = self.emojisVC.first {
          self.pageVC.setViewControllers([initialVC],
                                         direction: .forward,
                                         animated: false,
                                         completion: nil)
        }
        pageControl.numberOfPages = self.emojisVC.count
        pageControl.currentPage = 0
      }.store(in: &cancellables)
  }

  private func setupPageControl() {
    view.addSubview(pageControl)
    view.bringSubviewToFront(pageControl)

    NSLayoutConstraint.activate([
      pageControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
      pageControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
      pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
      pageControl.heightAnchor.constraint(equalToConstant: 50)
    ])

    pageControl.delegate = self
    pageControl.currentPage = 0
    pageControl.backgroundStyle = .prominent
  }
}

private extension String {
  func image(width: CGFloat = 20, height: CGFloat = 20, fontSize: CGFloat = 15) -> UIImage? {
    let size = CGSize(width: width, height: height)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    UIColor.clear.set()
    let rect = CGRect(origin: .zero, size: size)
    UIRectFill(CGRect(origin: .zero, size: size))
    (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: fontSize)])
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
}
