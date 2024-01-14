library medication_app;

import 'package:flutter/material.dart';

part 'model/model.dart';
part 'view_model/app_view_model.dart';
part 'view_model/medication_view_model.dart';
part 'view/home_view.dart';
part 'view/medication_view.dart';

void main() => runApp(MedicationApp());

class MedicationApp extends StatelessWidget {
  MedicationApp({super.key});

  final MedicationBLoc bLoc = MedicationBLoc();

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: HomeView(model: AppViewModel(bLoc.title, bLoc.model)),
      );
}

/// A factory BLoc used to get the models for the entire app.
class MedicationBLoc {
  /// The title of the app.
  String get title => 'Medication List';

  /// The list of [Medication] to be shown in the app.
  MedicationList get model => MedicationList([
        Medication(
          'Panodil',
          'Panodil er et svagt smertestillende middel, der anvendes ved svage '
              'smerter. Midlet virker desuden febernedsættende.',
        ),
        Medication(
          'Cipralex',
          'Cipralex® anvendes til behandling af depression, angst for samvær '
              'med andre (socialfobi), panikangst, generaliseret angst samt '
              'tvangsforestillinger og -handlinger (obsessiv-kompulsiv tilstand (OCD)).',
        ),
      ]);
}
