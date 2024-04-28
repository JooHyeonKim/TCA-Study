//
//  JudyDiaryApp.swift
//  JudyDiary
//
//  Created by 김주현 on 4/15/24.
//

import SwiftUI
import ComposableArchitecture
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

@main
struct JudyDiaryApp: App {
  
  init() {
    KakaoSDK.initSDK(appKey: "2ac9efa5e9e5401c201a4749bc6e89e4")
  }
  
  var body: some Scene {
    WindowGroup {
      LoginView(
        store: Store(initialState: DiaryList.State()) {
          DiaryList()
        }
      ).onOpenURL(perform: { url in
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
          AuthController.handleOpenUrl(url: url)
        }
      })
    }
  }
}
