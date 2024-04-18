//
//  JudyDiaryApp.swift
//  JudyDiary
//
//  Created by 김주현 on 4/15/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct JudyDiaryApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(
        store: Store(initialState: DiaryList.State()) {
          DiaryList()
        }
      )
    }
  }
}
