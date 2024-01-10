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
        home: HomeView(model: bLoc.model),
      );
}

class MedicationBLoc {
  /// A factory method used to get the model for the entire app.
  AppViewModel get model => AppViewModel(
      'Medication List',
      MedicationList([
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
      ]));
}
