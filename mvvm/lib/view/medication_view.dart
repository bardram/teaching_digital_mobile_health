part of medication_app;

class MedicationView extends StatefulWidget {
  final MedicationViewModel model;

  const MedicationView({required this.model, super.key});

  @override
  State<MedicationView> createState() => MedicationViewState();
}

class MedicationViewState extends State<MedicationView> {
  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          title: Text(widget.model.medication.name),
          subtitle: Text(widget.model.medication.description),
          trailing: widget.model.medication.taken
              ? const Icon(
                  Icons.check_box_outlined,
                  size: 24.0,
                  color: Colors.blue,
                )
              : const Icon(
                  Icons.check_box_outline_blank,
                  size: 24.0,
                ),
          onTap: medicationTaken,
        ),
      );

  void medicationTaken() {
    setState(() {
      widget.model.taken(widget.model.medication.taken ? false : true);
    });
  }
}
