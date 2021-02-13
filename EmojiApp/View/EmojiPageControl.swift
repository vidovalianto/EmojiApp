//
//  EmojiPageControl.swift
//  EmojiApp
//
//  Created by Vido Shaweddy on 2/12/21.
//

import UIKit

protocol EmojiPageControlDelegate: AnyObject {
  func didPick(index: Int)
}

class EmojiPageControl: UIPageControl {
  var emojis: [String] = []
  weak var delegate: EmojiPageControlDelegate?

  override var numberOfPages: Int {
    didSet {
      updateDots()
    }
  }

  override var currentPage: Int {
    didSet {
      updateDots()
    }
  }

  private func updateDots() {
    guard !emojis.isEmpty else { return }
    for index in 0..<numberOfPages {
      let image = emojis[index].image()
      setIndicatorImage(UIImage(systemName: "tray.circle"), forPage: index)
    }
  }
}

private extension String {
  func image(width: CGFloat = 30, height: CGFloat = 30, fontSize: CGFloat = 10) -> UIImage? {
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
