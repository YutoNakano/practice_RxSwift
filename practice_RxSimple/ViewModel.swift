//
//  ViewModel.swift
//  practice_RxSimple
//
//  Created by 中野湧仁 on 2019/08/03.
//  Copyright © 2019 中野湧仁. All rights reserved.
//


import RxSwift

final class ViewModel {
    let validationText: Observable<String>
    let loadLabelColor: Observable<UIColor>
    
    init(idTextObservable: Observable<String?>,
         passwordTextObservable: Observable<String?>,
         model: ModelProtocol) {

        let event = Observable
            //複数の変数のいずれかが変更された場合にそれぞれの最新の値をまとめて受け取れるようになる
            .combineLatest(idTextObservable, passwordTextObservable)
            // skip はイベントの最初から指定個を無視します
            .skip(1)
            //リクエストが複数段必要な場合も、どんどん繋げられる。前のデータストリームを維持して次のデータストリームを処理
            .flatMap { idText, passwordText -> Observable<Event<Void>> in
                return model.validate(idText: idText, passwordText: passwordText)
                    .materialize()
        }
            //わからない
        .share()
        
        self.validationText = event
            .flatMap { event -> Observable<String> in
                switch event {
                case .next:
                    return .just("OK!!!!")
                case let .error(error as ModelError):
                    return .just(error.errorText)
                case .error, .completed:
                    // 何も値を持たず、正常に終了するObservableを生成する
                    return .empty()
                }
        }
        /*オペレーター
             subscribeした際、startWithで指定した値が先に流れる。
             複数startWithをつける場合は、後に付け足したものから流れる。
        */
        .startWith("IDとPasswordを入力してください")
        
        self.loadLabelColor = event
            .flatMap { event -> Observable<UIColor> in
                switch event {
                case .next:
                    return .just(.green)
                case .error:
                    return .just(.red)
                case .completed:
                    return .empty()
                }
        }
    }
}

extension ModelError {
    fileprivate var errorText: String {
        switch self {
        case .invalidIdAndPassword:
            return "IDとPasswordが未入力です。"
        case .invalidId:
            return "IDが未入力です。"
        case .invalidPassword:
            return "Passwordが未入力です"
        }
    }
}
