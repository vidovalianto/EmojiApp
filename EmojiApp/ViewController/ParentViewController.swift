//
//  ParentViewController.swift
//  EmojiApp
//
//  Created by Vido Shaweddy on 2/12/21.
//

import Combine
import UIKit

class ParentViewController: UINavigationController, UIPageViewControllerDelegate {
  private var pageVC: UIPageViewController!
  private var searchVC: EmojiPickerViewController!
  private let searchController = UISearchController()
  private var cancellables = Set<AnyCancellable>()

  public var color: UIColor = .systemBackground
  public var collectionViewColor: UIColor = .systemBackground
  var emojiLVM: EmojiListViewModel!
  var emojisVC = [UIViewController]()
  var searchTask: DispatchWorkItem?

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

    self.navigationBar.isTranslucent = false
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Emojis"
    definesPresentationContext = true

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
        } else if let initialVC = self.emojisVC.first {
          self.pageVC.setViewControllers([initialVC],
                                         direction: .forward,
                                         animated: false,
                                         completion: nil)
        }
      }.store(in: &cancellables)

    emojiLVM.$categories
      .receive(on: DispatchQueue.main)
      .sink { [weak self] categories in
        guard let self = self else { return }
        self.emojisVC = categories.map({ category -> UIViewController in
          let vc = EmojiPickerViewController()
          vc.color = self.collectionViewColor
          let viewModel = EmojiPickerViewController.ViewModel(title: category.title,
                                                              emojis: category.emojis)
          vc.configure(viewModel)
          return vc
        })

        if let initialVC = self.emojisVC.first {
          self.pageVC.setViewControllers([initialVC],
                                         direction: .forward,
                                         animated: false,
                                         completion: nil)
        }
      }.store(in: &cancellables)
  }
}
