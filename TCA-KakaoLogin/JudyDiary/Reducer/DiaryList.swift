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
    case loginResponse(Result<OAuthToken?, Error>)
  }
  
  @Dependency(\.kakaoClient) var kakaoClient
  
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
        return .run { send in
          do {
            if let token = try await self.kakaoClient.login().first(where: { _ in true }) {
              await send(.loginResponse(.success(token)))
            }
          } catch {
            await send(.loginResponse(.failure(KaKaoLoginError.TokenNotFound)))
          }
        }
        
        ///로그인 성공 실패 처리할때 이 케이스를 어떻게 활용해야할지 모르겠다
      case let .loginResponse(.success(response)):
        state.loginSucceed = true
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

extension OAuthToken: @unchecked Sendable {}
