//
//  DiaryList.swift
//  JudyDiary
//
//  Created by 김주현 on 4/15/24.
//

import ComposableArchitecture
import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

@Reducer
struct DiaryList {
  @ObservableState
  struct State: Equatable {
    var diaryList: IdentifiedArrayOf<Diary.State> = []
    var loginSucceed: Bool = false
    var loginToken: OAuthToken?
    @Presents public var addDiary: AddDiary.State?
    
    static func == (lhs: DiaryList.State, rhs: DiaryList.State) -> Bool {
      return true
    }
  }
  
  /// DiaryList 리듀서에서 처리할 수 있는 모든 액션들
  enum Action: BindableAction, Sendable {
    case addButtonTapped
    case binding(BindingAction<State>)
    case delete(IndexSet)
    case diaryList(IdentifiedActionOf<Diary>)
    case addDiary(PresentationAction<AddDiary.Action>)
    case kakaoLoginButtonTapped
    case loginResponse(Result<String, Error>)
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .addButtonTapped:
        state.addDiary = AddDiary.State(id: UUID())
        return .none
        
      case .binding:
        return .none
        
      case let .delete(indexSet):
        let diaryList = state.diaryList
        for index in indexSet {
          state.diaryList.remove(id: diaryList[index].id)
        }
        return .none
        
        
      case .addDiary(.presented(.save)):
        if let addDiary = state.addDiary {
          let newDiary = Diary.State(
            id: addDiary.id,
            title: addDiary.title,
            content: addDiary.content)
          state.diaryList.insert(newDiary, at: 0)
        }
        return .none
        
      case .kakaoLoginButtonTapped:
        state.loginSucceed = true
        var token: OAuthToken?
        if UserApi.isKakaoTalkLoginAvailable() {
          UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
            if let error = error {
              print("Kakao Login Error: \(error)")
            } else {
              print("Kakao Login Success.")
              token = oauthToken
              ///클로저 내에서는 state에 접근할 수 없구나ㅏ,,
              ///카카오로그인이 성공했을 때 여기서 state.loginSucceed = true 를 해줄수가 없다...
            }
          }
        } else {
          print("KakaoTalk is not available.")
        }
        
        guard let token = token else { return .none }
        state.loginToken = token
        return .none
        
      case let .loginResponse(.success(response)):
        print(response)
        return .none
        
      case let .loginResponse(.failure(error)):
        print(error)
        return .none
        
      case .diaryList:
        return .none
        
      case .addDiary:
        return .none
        
      }
    }.forEach(\.diaryList, action: \.diaryList) { ///scoping을 위한것
      Diary()
    }
    .ifLet(\.$addDiary, action: \.addDiary) {
      AddDiary()
    }
  }
}
