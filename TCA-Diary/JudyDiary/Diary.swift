//
//  Diary.swift
//  JudyDiary
//
//  Created by 김주현 on 4/15/24.
//
import ComposableArchitecture
import SwiftUI

@Reducer
struct Diary {
  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID
    var title: String = ""
    var content: String = ""
    var date: Date
    
    var dateString: String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      return dateFormatter.string(from: date)
    }
  }
  
  ///Reducer에서 처리할 수 있는 액션을 정의
  enum Action: BindableAction, Sendable {
    ///상태의 바인딩액션. 상태의 특정 속성을 바인딩할 수 있다.
    ///양방향 통신할 때 사용
    ///지금 프로젝트에서는 사용되지 않는 부분이다. 즉, Action 자체가 없어도 되는 상황.
    case binding(BindingAction<State>)
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer() /// 특정 상태의 속성을 직접 바인딩하거나 업데이트하는데 사용
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      }
    }
  }
}
