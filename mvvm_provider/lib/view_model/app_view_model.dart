part of medication_app;

/// View model for the entire app holding the [title] of the app and the [list]
/// of medication to show.
///
/// This view model is a ChangeNotifier and can notify its listeners when
/// changed, using the notifyListeners() method.
class AppViewModel extends ChangeNotifier {
  String title;
  MedicationList list;

  /// Create a new AppViewModel.
  AppViewModel(this.title, this.list);

  /// The length of the [list] of medicine.
  int get length => list.medications.length;

  /// Add [medication] to the [list] of medicine.
  add(Medication medication) {
    list.medications.add(medication);
    notifyListeners();
  }
}
