//
//  PathModel.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import Foundation

class PathModel: ObservableObject {
  @Published var paths: [PathType]

  init(paths: [PathType] = []) {
    self.paths = paths
  }
}
