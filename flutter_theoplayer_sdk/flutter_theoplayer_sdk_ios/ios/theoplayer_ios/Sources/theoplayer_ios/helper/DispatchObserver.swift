import Foundation
import THEOplayerSDK

public protocol RemovableEventListenerProtocol {
    func remove(from dispatcher: EventDispatcherProtocol)

    var description: String {get}
}

public struct RemovableEventListener<Event: EventProtocol>: RemovableEventListenerProtocol {
    let type: EventType<Event>
    let listener: EventListener

    public init(type: EventType<Event>, listener: EventListener) {
        self.type = type
        self.listener = listener
    }

    public func remove(from dispatcher: EventDispatcherProtocol) {
        dispatcher.removeEventListener(type: type, listener: listener)
    }

    public var description: String {
        type.name
    }
}

extension THEOplayerSDK.EventDispatcherProtocol {
    public func addRemovableEventListener<Event: EventProtocol>(type: EventType<Event>, listener: @escaping (Event)->Void) -> RemovableEventListener<Event> {
        RemovableEventListener(
            type: type,
            listener: addEventListener(type: type, listener: listener)
        )
    }

   public func remove(eventListener: RemovableEventListenerProtocol) {
       eventListener.remove(from: self)
    }
}


public class DispatchObserver {
    weak var _dispatcher: AnyObject?
    let eventListeners: [RemovableEventListenerProtocol]

    public init(dispatcher: EventDispatcherProtocol, eventListeners: [RemovableEventListenerProtocol]) {
        _dispatcher = dispatcher as AnyObject
        self.eventListeners = eventListeners
    }

    deinit {
        if let dispatcher = _dispatcher as! EventDispatcherProtocol? {
            for listener in eventListeners {
                dispatcher.remove(eventListener: listener)
            }
        }
    }
}
