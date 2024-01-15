part of medication_app;

class MedicationViewModel extends ChangeNotifier {
  Medication medication;
  String get name => medication.name ?? 'No Name';
  String get description => medication.description ?? '...';
  bool get taken => medication.taken;

  MedicationViewModel(this.medication);

  /// The medication view card is tapped.
  void tapped() {
    medication.administer();
    notifyListeners();
  }
}
