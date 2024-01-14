part of medication_app;

class MedicationList {
  final List<Medication> medications;
  MedicationList(this.medications);
}

class Medication {
  String? name, description;
  bool taken = false;

  late MedicationStateMachine _machine;
  MedicationState get state => _machine.state;

  Medication() {
    _machine = CreatedMedicationState(this);
  }

  void create() => _machine.create();

  void prescribe(String name, String description) =>
      _machine.prescribe(name, description);

  void administer() => _machine.administer();
}

/// Defines a simple state machine for [Medication].
///
///  +---------+                  +------------+                   +--------------+
///  | created | -- prescribe --> | prescribed | -- administer --> | administered |
///  +---------+                  +------------+                   +--------------+
///
enum MedicationState { created, prescribed, administered }

abstract interface class MedicationStateMachine {
  Medication get medication;
  MedicationState get state;
  void create();
  void prescribe(String name, String description);
  void administer();
}

abstract class AbstractMedicationState implements MedicationStateMachine {
  @override
  Medication medication;

  AbstractMedicationState(this.medication);

  @override
  void create() =>
      throw Exception('Cannot create medication when in state: $state');

  @override
  void prescribe(String name, String description) =>
      throw Exception('Cannot prescribe medication when in state: $state');

  @override
  void administer() =>
      throw Exception('Cannot administer medication when in state: $state');
}

class CreatedMedicationState extends AbstractMedicationState {
  CreatedMedicationState(super.medication);

  @override
  MedicationState get state => MedicationState.created;

  @override
  void prescribe(String name, String description) {
    medication.name = name;
    medication.description = description;
    medication._machine = PrescribedMedicationState(medication);
  }
}

class PrescribedMedicationState extends AbstractMedicationState {
  PrescribedMedicationState(super.medication);

  @override
  MedicationState get state => MedicationState.prescribed;

  @override
  void administer() {
    medication.taken = true;
    medication._machine = AdministeredMedicationState(medication);
  }
}

class AdministeredMedicationState extends AbstractMedicationState {
  AdministeredMedicationState(super.medication);

  @override
  MedicationState get state => MedicationState.administered;

  @override
  // NoOp method, since we don't want an exception if called multiple times.
  void administer() {}
}
