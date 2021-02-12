//
//  CategoryModel.swift
//  EmojiPickerView
//
//  Created by Vido Shaweddy on 2/7/21.
//

import Foundation

enum Category: String, CaseIterable {
  case smileysAndPeople
  case animalsAndNature
  case foodAndDrink
  case activity
  case travelAndPlaces
  case objects
  case symbols
  case flags
}

extension Category {
  var displayString: String {
    switch self {
    case .smileysAndPeople:
        return "smileys & people"
    case .animalsAndNature:
        return "animals & nature"
    case .foodAndDrink:
        return "food & drink"
    case .activity:
        return "activity"
    case .travelAndPlaces:
        return "travel & places"
    case .objects:
        return "objects"
    case .symbols:
        return "symbols"
    case .flags:
        return "flags"
    }
  }
}

struct CategoryModel: Hashable, Identifiable, Decodable {
  var id = UUID()
  let title: String
  let emojis: [EmojiModel]

  enum CodingKeys: CodingKey {
    case title, emojis
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.title = try container.decode(String.self, forKey: .title)
    self.emojis = try container.decode([EmojiModel].self, forKey: .emojis)
  }
}