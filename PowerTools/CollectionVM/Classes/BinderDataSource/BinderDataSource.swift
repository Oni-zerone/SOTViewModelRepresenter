//
//  BinderDataSource.swift
//  SOTViewModelRepresenter
//
//  Created by Andrea Altea on 28/10/18.
//

import UIKit

extension DispatchQueue {
    
    static let binderUpdate = DispatchQueue(label: "BinderDataSource.queue", qos: DispatchQoS.background)
}

public protocol AbstractBinderDataSource: class {
    
    associatedtype View: UpdatableView
    associatedtype ASectionViewModel: SectionViewModel
    
    var model: [ASectionViewModel] { get set }
    
    var view: View? { get set }
}

open class BinderDataSource<View: UpdatableView, ASectionViewModel: SectionViewModel>: NSObject, AbstractBinderDataSource {
    
    private var _model: [ASectionViewModel]
    
    open var model: [ASectionViewModel] {
        set {
            self.update(model: newValue, forceReload: true)
        }
        get {
            return self._model
        }
    }
    
    public weak var view: View?
    
    public init(view: View?, model: [ASectionViewModel] = []) {
        self.view = view
        self._model = model
    }
    
    public func update(model newModel: [ASectionViewModel], forceReload reloadData: Bool = false) {
        
        guard !reloadData, let batchUpdateView = self.view as? BatchUpdateView else {
            self._model = newModel
            self.view?.forceReload()
            return
        }
        
        DispatchQueue.binderUpdate.async {
            
            let oldModel = self._model
            let updates = ModelUpdate(from: oldModel, to: newModel, forceReload: reloadData)
            self.performSyncUpdate(updates, in: batchUpdateView)
        }
    }
    
    private func performSyncUpdate(_ updates: ModelUpdate<ASectionViewModel>, in view: BatchUpdateView) {
        
        DispatchQueue.main.sync {
            view.perform(updates, modelUpdates: {
                self._model = updates.model
            }, completion: nil)
        }
    }
}
