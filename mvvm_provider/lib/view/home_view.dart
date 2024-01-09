part of medication_app;

/// The home view of the medication app, creating the [MaterialApp] widget.
class HomeView extends StatefulWidget {
  const HomeView({required this.model, super.key});

  final AppViewModel model;

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text(widget.model.title)),
          body: Consumer<AppViewModel>(
              builder: (context, viewModel, child) => ListView.builder(
                  itemCount: widget.model.length,
                  itemBuilder: (context, index) => MedicationView(
                      model: MedicationViewModel(
                          widget.model.list.medications[index])))),
          floatingActionButton: FloatingActionButton(
            onPressed: addMedication,
            tooltip: 'Add Medication',
            child: const Icon(Icons.add),
          ),
        ),
      );

  void addMedication() {
    setState(() {
      widget.model.add(Medication(
        'Hemangiol',
        'Hemangiol® anvendes til behandling af hæmangiom ("jordbærmærke"), som er en samling af ekstra blodkar, der har dannet en knude i eller under huden.',
      ));
    });
  }
}
