/// An object that maintains a list of observers.
/// Implements the Observer GoF pattern.
class Subject {
  final List<Observer> _observers = [];

  /// Add the [observer] to the list of observers for this subject.
  void adObserver(Observer observer) => _observers.add(observer);

  /// Remove the [observer].
  bool removeObserver(Observer observer) => _observers.remove(observer);

  /// Notify all the registered observers by calling their [update] method.
  /// Call this method whenever this subject changes, to notify any observers
  /// that this object may have changed.
  void notify() {
    for (var observer in _observers) {
      observer.update();
    }
  }
}

/// Defines classes that can observer a [Subject].
/// Implements the Observer GoF pattern.
abstract interface class Observer {
  /// Call-back method called when the subject that this observer observes, changes.
  void update();
}
