library medication_app;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'model/model.dart';
part 'view_model/app_view_model.dart';
part 'view_model/medication_view_model.dart';
part 'view/home_view.dart';
part 'view/medication_view.dart';

void main() => runApp(const MedicationApp());

class MedicationApp extends StatelessWidget {
  const MedicationApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: HomeView(
          model: AppViewModel(
            'Medication List',
            MedicationList(),
          ),
        ),
      );
}
