part of medication_app;

class MedicationViewModel extends ChangeNotifier {
  Medication medication;
  String get name => medication.name ?? 'No Name';
  String get description => medication.description ?? '...';
  MedicationViewModel(this.medication);

  /// Mark if this medication has been taken or not.
  void taken(bool value) {
    // medication.taken = value;
    medication.administer();
    notifyListeners();
  }
}
