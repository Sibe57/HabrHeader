//
//  ScrollDetector.swift
//  Header
//
//  Created by admin on 10.05.2023.
//

import SwiftUI

struct ScrollDetector: UIViewRepresentable {
    
    //Замыкание в которое будет передаваться текущий offset
    var onScroll: (CGFloat) -> Void
    
    //Замыкание которое вызывается когда пользователь отпускает палец
    var onDraggingEnd: (CGFloat, CGFloat) -> Void
    
    
    //Класс-делегат нашего ScrollView
    class Coordinator: NSObject, UIScrollViewDelegate {
        
        var parent: ScrollDetector

        var isDelegateAdded: Bool = false
        
        init(parent: ScrollDetector) {
            self.parent = parent
        }
        
        //методы UIScrollViewDelegate
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.onScroll(scrollView.contentOffset.y)
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            parent.onDraggingEnd(targetContentOffset.pointee.y, velocity.y)
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            parent.onDraggingEnd(scrollView.contentOffset.y, 0)
        }
        
        //тут могли бы быть другие методы UIScrollViewDelegate
        //так как у нас в распоряжении ПОЛНОЦЕННЫЙ ДЕЛЕГАТ от UIKit-ового UIScrollView!
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    //При создании пустой UIView находим UIScrollView и назначаем ему в делегаты наш coordinator
    func makeUIView(context: Context) -> UIView {
        let uiView = UIView()
        DispatchQueue.main.async {
            if let scrollView = recursiveFindScrollView(view: uiView), !context.coordinator.isDelegateAdded {
                scrollView.delegate = context.coordinator
                context.coordinator.isDelegateAdded = true
            }
        }
        return uiView
    }
    
    //рекурсивно перебираем родителей нашей пустой UIView в поисках ближайшего UIScrollView
    func recursiveFindScrollView(view: UIView) -> UIScrollView? {
        if let scrollView = view as? UIScrollView {
            return scrollView
        } else {
            if let superview = view.superview {
                return recursiveFindScrollView(view: superview)
            } else {
                return nil
            }
        }
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

