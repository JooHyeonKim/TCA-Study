//
//  EditDiaryView.swift
//  JudyDiary
//
//  Created by 김주현 on 4/17/24.
//

import ComposableArchitecture
import SwiftUI

struct EditDiaryView: View {
  @Environment(\.dismiss) var dismiss
  @Bindable var store: StoreOf<Diary>
  @State private var showingAlert: Bool = false
  
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
          showingAlert = true
        }) {
          Text("저장")
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .alert(isPresented: $showingAlert) {
          Alert(title: Text("수정이 완료되었습니다."),
                dismissButton: .default(Text("확인"), action: {

            dismiss()
          }))
        }
      }
      .navigationTitle("일기 수정")
    }
  }
}

