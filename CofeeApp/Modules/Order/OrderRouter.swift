//
//  OrderRouter.swift
//
//  Created by Сергеев Александр on 21.02.2024
//

protocol OrderRouterProtocol: AnyObject {
}

class OrderRouter {
    weak var view: OrderViewController?
}

extension OrderRouter: OrderRouterProtocol {
}
