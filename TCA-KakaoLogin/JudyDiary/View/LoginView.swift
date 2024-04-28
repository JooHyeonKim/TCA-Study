//
//  LoginView.swift
//  JudyDiary
//
//  Created by 김주현 on 4/24/24.
//

import ComposableArchitecture
import SwiftUI

struct LoginView: View {
  @Bindable var store: StoreOf<DiaryList>
  
  var body: some View {
    NavigationView {
      VStack {
        Spacer()
        ///$store.loginSucceed 가 true가 되면 ContentView로 이동하도록
        NavigationLink(destination: ContentView(store: store), isActive: $store.loginSucceed) {
          Button(action: {
            print("Button Tapped")
            store.send(.kakaoLoginButtonTapped)
            
          }, label: {
            Text("Kakao Login")
              .foregroundColor(.white)
              .padding()
              .background(Color.orange)
              .cornerRadius(8)
          })
        }
        Spacer()
      }
      .padding()
    }
  }
}
