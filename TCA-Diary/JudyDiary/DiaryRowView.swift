//
//  DiaryRowView.swift
//  JudyDiary
//
//  Created by 김주현 on 4/15/24.
//

import ComposableArchitecture
import SwiftUI

struct DiaryRowView: View {
  @Bindable var store: StoreOf<Diary>
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(store.title)
        .font(.headline)
      
      Text(store.content)
        .lineLimit(1)
        .font(.subheadline)
      
      Text(store.dateString)
        .font(.caption)
        .foregroundColor(.gray)
    }
  }
}
