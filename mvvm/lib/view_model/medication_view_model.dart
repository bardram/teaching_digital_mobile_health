part of medication_app;

class MedicationViewModel {
  Medication medication;
  MedicationViewModel(this.medication);

  /// Mark if this medication has been taken or not.
  void taken(bool value) => medication.taken = value;
}
