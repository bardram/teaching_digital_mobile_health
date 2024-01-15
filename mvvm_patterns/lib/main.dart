library medication_app;

import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

part 'model/model.dart';
part 'view_model/app_view_model.dart';
part 'view_model/medication_view_model.dart';
part 'view/home_view.dart';
part 'view/medication_view.dart';
part 'util/medication_systems.dart';

void main() => runApp(const MedicationApp());

class MedicationApp extends StatelessWidget {
  const MedicationApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: HomeView(
          model: AppViewModel(
            MedicationBLoc().title,
            MedicationBLoc().medications,
          ),
        ),
      );
}

/// A BLoc singleton that can be used across the entire app.
class MedicationBLoc {
  static final MedicationBLoc _instance = MedicationBLoc._();
  MedicationBLoc._();

  /// Create a singleton [MedicationBLoc].
  factory MedicationBLoc() => _instance;

  /// The title of the app.
  String get title => 'Medication for $patientId';

  /// The id of the patient using this app.
  String patientId = '123456-0011';

  /// The medication system to use.
  MedicationSystem system = StubMedicationSystem();

  /// The [MedicationList] to be shown in the app.
  MedicationList get medications => system.getMedication(patientId);
}
