//
//  ParentViewController+PageViewController.swift
//  EmojiApp
//
//  Created by Vido Shaweddy on 2/12/21.
//

import UIKit

extension ParentViewController: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = emojisVC.firstIndex(of: viewController) else { return nil }
    if index > 0 { return emojisVC[index - 1] }
    return emojisVC.last
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let index = emojisVC.firstIndex(of: viewController) else { return nil }
    if index < emojisVC.count - 1 { return emojisVC[index + 1] }
    return emojisVC.first
  }

  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    emojisVC.count
  }

  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return 0
  }

  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed {
      pageControl.currentPage = pendingIndex
    }
  }
}

extension ParentViewController: EmojiPageControlDelegate {
  func didPick(index: Int) {
    guard index < emojisVC.count else { return }
    pageVC.setViewControllers([emojisVC[index]],
                              direction: .forward,
                              animated: false,
                              completion: nil)
  }
}

extension ParentViewController: UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    guard let view = pendingViewControllers.first, let index = emojisVC.firstIndex(where: { $0 == view }) else { return }
    pendingIndex = index
  }
}
