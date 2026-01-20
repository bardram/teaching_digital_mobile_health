part of '../main.dart';

class MedicationList {
  List<Medication> medications;

  MedicationList(this.medications);
}

class Medication {
  String name, description;
  bool taken;
  Medication(this.name, this.description, [this.taken = false]);
}
