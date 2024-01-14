part of medication_app;

/// A definition of what external medication systems can.
/// Works as a facade definitions for complex external systems.
abstract interface class MedicationSystem {
  /// Get a list of prescribed medication for a [patientId].
  MedicationList getMedication(String patientId);

  /// Add [medication] for a patient with id [patientId].
  void addMedication(String patientId, Medication medication);
}

/// Medication System Facade implementation for the Danish Fælles Medicin
/// Kort (FMK).
class FMKMedicationSystem implements MedicationSystem {
  @override
  void addMedication(String patientId, Medication medication) {
    // TODO: implement addMedication
    throw UnimplementedError();
  }

  @override
  MedicationList getMedication(String patientId) {
    // TODO: implement getMedication
    throw UnimplementedError();
  }
}

/// A stub for a [MedicationSystem] used for testing.
class StubMedicationSystem implements MedicationSystem {
  MedicationList medicationList = MedicationList([
    Medication()
      ..prescribe(
        'Panodil',
        'Panodil er et svagt smertestillende middel, der anvendes ved svage '
            'smerter. Midlet virker desuden febernedsættende.',
      ),
    Medication()
      ..prescribe(
        'Cipralex',
        'Cipralex® anvendes til behandling af depression, angst for samvær '
            'med andre (socialfobi), panikangst, generaliseret angst samt '
            'tvangsforestillinger og -handlinger (obsessiv-kompulsiv tilstand (OCD)).',
      ),
  ]);

  @override
  void addMedication(String patientId, Medication medication) =>
      medicationList.medications.add(medication);

  @override
  MedicationList getMedication(String patientId) => medicationList;
}
