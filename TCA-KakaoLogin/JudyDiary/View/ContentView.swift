//
//  ContentView.swift
//  JudyDiary
//
//  Created by 김주현 on 4/15/24.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
  @Bindable var store: StoreOf<DiaryList>
  
  var body: some View {
    NavigationView {
      List {
        ForEach(store.scope(state: \.diaryList, action: \.diaryList)) { store in
          NavigationLink(destination: EditDiaryView(store: store)) {
            DiaryRowView(store: store)
          }
        }
        .onDelete { store.send(.delete($0)) }
      }
      .navigationTitle("🐰 Diary")
      .toolbar {
        Button{
          store.send(.addButtonTapped)
        } label: {
          Image(systemName: "plus")
        }
      }.sheet(item: $store.scope(state: \.addDiary, action: \.addDiary)) { store in
        NavigationStack {
          AddDiaryView(store: store)
        }
      }
    }
  }
}
