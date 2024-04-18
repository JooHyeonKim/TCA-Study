//
//  AddDiaryView.swift
//  JudyDiary
//
//  Created by 김주현 on 4/15/24.
//

import ComposableArchitecture
import SwiftUI

struct AddDiaryView: View {
  @Environment(\.dismiss) var dismiss
  @Bindable var store: StoreOf<AddDiary>
  
  var body: some View {
    NavigationView {
      VStack(spacing: 1) {
        TextField("제목", text: $store.title)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding()
        
        DatePicker("날짜 선택", selection: $store.date, displayedComponents: .date)
          .padding()
        
        TextEditor(text: $store.content)
          .padding()
          .background(Color.gray.opacity(0.1))
          .cornerRadius(8)
        
        Button(action: {
          store.send(.showAlert)
        }) {
          Text("저장")
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .alert(isPresented: $store.showingAlert) {
          Alert(title: Text("저장되었습니다."),
                dismissButton: .default(Text("확인"), action: {
            self.store.send(.save)
            dismiss()
          }))
        }
      }
      .navigationTitle("일기 쓰기")
    }
  }
}

