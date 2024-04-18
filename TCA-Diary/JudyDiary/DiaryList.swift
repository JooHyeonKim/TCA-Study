//
//  DiaryList.swift
//  JudyDiary
//
//  Created by 김주현 on 4/15/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct DiaryList {
  @ObservableState
  struct State: Equatable {
    var diaryList: IdentifiedArrayOf<Diary.State> = []
    @Presents public var addDiary: AddDiary.State?
  }
  
  /// DiaryList 리듀서에서 처리할 수 있는 모든 액션들
  enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
    //case addDiary(title: String, content: String, date: Date)
    case delete(IndexSet)
    case diaryList(IdentifiedActionOf<Diary>)
    case addDiary(PresentationAction<AddDiary.Action>)
    /// IdentifiedActionOf: TCA에서 제공하는 Action 유형
    /// Diary항목을 식별하는 데 사용되며,
    /// Action을 캡슐화
  }
  
  @Dependency(\.continuousClock) var clock
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
//      case let .addDiary(title, content, date):
//        state.diaryList.insert(Diary.State(id: UUID(), title: title, content: content, date: date), at: 0)
//        return .none
        
      case let .delete(indexSet):
        let diaryList = state.diaryList
        for index in indexSet {
          state.diaryList.remove(id: diaryList[index].id)
        }
        return .none

      case .diaryList:
        return .none
        
      case .addDiary:
        return .none
        
      }
    }.forEach(\.diaryList, action: \.diaryList) { ///scoping을 위한것
      Diary() ///Reducer
      ///1. null인 경우
      ///2. null이 아닌 경우
      ///3. 리스트인 경우
    }
    .ifLet(\.$addDiary, action: \.addDiary) {
      AddDiary()
    }
  }
}
