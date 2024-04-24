//
//  Reducer.swift
//  JudyDiary
//
//  Created by 김주현 on 4/24/24.
//

import ComposableArchitecture
import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

@Reducer
struct Login {
  @ObservableState
  struct State: Equatable {
    var email: String = ""
    var token: OAuthToken?
    
    static func == (lhs: Login.State, rhs: Login.State) -> Bool {
      return true
    }
  }

  enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
    case kakaoLoginButtonTapped
    case loginResponse(Result<String, Error>)
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer() /// 특정 상태의 속성을 직접 바인딩하거나 업데이트하는데 사용
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .kakaoLoginButtonTapped:
        return .none
        
      case let .loginResponse(.success(response)):
        return .none
        
      case let .loginResponse(.failure(error)):
        return .none
      }
    }
  }
}
