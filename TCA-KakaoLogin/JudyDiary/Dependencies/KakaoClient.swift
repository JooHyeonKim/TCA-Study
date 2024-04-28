//
//  KakaoClient.swift
//  JudyDiary
//
//  Created by 김주현 on 4/24/24.
//
import ComposableArchitecture
import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

@DependencyClient
struct KakaoClient {
  var login: @Sendable () async -> AsyncThrowingStream< OAuthToken, Error> = { .finished() }
}
///Q. DependencyKey???
extension KakaoClient: DependencyKey {
  static var liveValue: KakaoClient {
    let kakaoLogin = KaKaoLogin()
    return KakaoClient(login: {
      await kakaoLogin.login()
    })
  }
}

private actor KaKaoLogin {
  private var kakaoLoginContinuation: AsyncThrowingStream<OAuthToken, Error>.Continuation?
  
  func login() -> AsyncThrowingStream<OAuthToken, Error> {
    AsyncThrowingStream { continuation in
      self.kakaoLoginContinuation = continuation
      Task {
        await MainActor.run {
          UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
            switch(oauthToken, error) {
            case let (.some(result), _):
              continuation.yield(result)
              continuation.finish()
            case (_, .some):
              continuation.finish(throwing: error)
              print("Kakao Login Error: \(error)")
              
            case (.none, .none):
              fatalError("It should not be possible to have both a nil result and nil error.")
            }
          }
        }
      }
    }
  }
}

extension DependencyValues {
  var kakaoClient: KakaoClient {
    get { self[KakaoClient.self] }
    set { self[KakaoClient.self] = newValue }
  }
}

public enum KaKaoLoginError: Equatable, LocalizedError, Sendable {
  case TokenNotFound
  public var errorDescription: String? {
    switch self {
    case .TokenNotFound:
      return "api eror: ClientFailed(reason:  KakaoSDKCommon.ClientFailureReason.TokenNotFound)"
    }
  }
}
