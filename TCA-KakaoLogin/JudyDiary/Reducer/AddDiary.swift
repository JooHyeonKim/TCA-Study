//
//  AddDiary.swift
//  JudyDiary
//
//  Created by 김주현 on 4/17/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AddDiary {
  @ObservableState
  struct State: Equatable {
    let id: UUID
    var title: String = ""
    var content: String = ""
    var date: Date = .now
    var showingAlert: Bool = false
  }
  
  enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
    case save
    case showAlert
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .save:
        return .none
        
      case .showAlert:
        state.showingAlert.toggle()
        return .none
      }
    }
  }
}
