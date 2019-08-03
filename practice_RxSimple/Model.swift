//
//  Model.swift
//  practice_RxSimple
//
//  Created by 中野湧仁 on 2019/08/03.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import RxSwift

enum ModelError: Error {
    case invalidId
    case invalidPassword
    case invalidIdAndPassword
}

protocol ModelProtocol {
    func validate(idText: String?, passwordText: String?) -> Observable<Void>
}


// サーバーにユーザーの登録状況を確認してもらうことを想定
final class Model: ModelProtocol {
    func validate(idText: String?, passwordText: String?) -> Observable<Void> {
        switch (idText, passwordText) {
        case (.none, .none):
            return Observable.error(ModelError.invalidIdAndPassword)
        case (.none, .some):
            return Observable.error(ModelError.invalidId)
        case (.some, .none):
            return Observable.error(ModelError.invalidPassword)
        case (let idText?, let passwordText?):
            switch (idText.isEmpty, passwordText.isEmpty){
            case (true, true):
                return Observable.error(ModelError.invalidIdAndPassword)
            case (false, false):
                return Observable.create { observer in
                    observer.onNext(())
                    observer.onCompleted()
                    return Disposables.create()
                    /*
                     上記のObservable.createと同じ処理を1行でしてくれる
                     return Observable.just(())
                     */
                }
            case (true, false):
                return Observable.error(ModelError.invalidId)
            case (false, true):
                return Observable.error(ModelError.invalidPassword)
            }
        }
    }
}
