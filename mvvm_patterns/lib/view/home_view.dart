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
          body: ListenableBuilder(
              listenable: widget.model,
              builder: (BuildContext context, Widget? child) =>
                  ListView.builder(
                      itemCount: widget.model.length,
                      itemBuilder: (context, index) => MedicationView(
                          model: MedicationViewModel(
                              widget.model.list.medications[index])))),
          floatingActionButton: FloatingActionButton(
            onPressed: widget.model.plus(),
            tooltip: 'Add Medication',
            child: const Icon(Icons.add),
          ),
        ),
      );
}
