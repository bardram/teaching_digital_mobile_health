part of medication_app;

/// View model for the entire app holding the [title] of the app and the [list]
/// of medication to show.
class AppViewModel {
  String title;
  MedicationList list;

  /// The length of the [list] of medicine.
  int get length => list.medications.length;

  AppViewModel(this.title, this.list);

  /// Add [medication] to the [list] of medicine.
  add(Medication medication) => list.medications.add(medication);
}
