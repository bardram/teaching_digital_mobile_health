part of medication_app;

class MedicationList {
  final List<Medication> medications = [
    Medication(
      'Panodil',
      'Panodil er et svagt smertestillende middel, der anvendes ved svage smerter. Midlet virker desuden febernedsættende.',
    ),
    Medication(
      'Cipralex',
      'Cipralex® anvendes til behandling af depression, angst for samvær med andre (socialfobi), panikangst, generaliseret angst samt tvangsforestillinger og -handlinger (obsessiv-kompulsiv tilstand (OCD)).',
    ),
  ];
}

class Medication {
  String name, description;
  bool taken;
  Medication(this.name, this.description, [this.taken = false]);
}
