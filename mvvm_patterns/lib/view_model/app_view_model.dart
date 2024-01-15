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

  /// Called when the plus button is tapped.
  plus() {
    Medication medication = Medication()
      ..prescribe(
        'Hemangiol',
        'Hemangiol® anvendes til behandling af hæmangiom ("jordbærmærke"), som er en samling af ekstra blodkar, der har dannet en knude i eller under huden.',
      );
    list.medications.add(medication);
    notifyListeners();
  }
}
