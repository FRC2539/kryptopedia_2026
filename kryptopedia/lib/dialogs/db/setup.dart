import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kryptopedia/dialogs/notification.dart';
import 'package:kryptopedia/models/event.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/teams.dart';
import 'package:kryptopedia/util/device.dart';
import 'package:kryptopedia/widgets/common/number_field.dart';

class EventSetupDialog extends StatefulWidget {
  const EventSetupDialog({super.key});

  @override
  State<EventSetupDialog> createState() => _EventSetupDialogState();
}

class _EventSetupDialogState extends State<EventSetupDialog>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: kDebugMode ? 2 : 1,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Database Setup"),
      content: Column(
        children: [
          Text("The event configuration is missing. Please initialize one:"),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "Personal device"),
              Tab(text: "Team shared device"),
              Tab(text: "Local-only testing setup"),
            ],
          ),
          SizedBox(
            height: Screen.height(context) * 0.6,
            width: 500,
            child: TabBarView(
              controller: _tabController,
              children: [Placeholder(), TeamDeviceForm(), TestDataForm()],
            ),
          ),
        ],
      ),
    );
  }
}

class TeamDeviceForm extends StatefulWidget {
  const TeamDeviceForm({super.key});

  @override
  State<TeamDeviceForm> createState() => _TeamDeviceFormState();
}

class _TeamDeviceFormState extends State<TeamDeviceForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int teamNumber = 2539;
  String serverURL = "https://2539scouting.userexe.me";
  String deviceName = "Red 1";

  bool submitEnabled = true;
  void submit() {
    setState(() {
      submitEnabled = false;
    });
    if (!_formKey.currentState!.validate()) {
      setState(() {
        submitEnabled = true;
      });
      return;
    }
    _formKey.currentState!.save();

    return errorOut("uh this doesnt work yet");
  }

  void errorOut(String message) async {
    await showDialog(
      context: context,
      builder: (context) =>
          NotificationDialog(title: "Uh oh, pop-up", body: message),
    );
    setState(() {
      submitEnabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 8,
        children: [
          TextFormField(
            decoration: const InputDecoration(label: Text("Team #")),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(5),
            ],
            initialValue: teamNumber.toString(),
            onSaved: (newValue) => teamNumber = int.parse(newValue!),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'must be present';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(label: Text("Server URL")),
            initialValue: serverURL,
            onSaved: (newValue) => serverURL = newValue!,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'must be present';
              }
              if (value.endsWith("/")) {
                return "don't end it with a slash";
              }
              if (!value.startsWith("https://")) {
                return "must be an https url";
              }
              return null;
            },
          ),
          //TODO should be a dropdown after the server url is entered?
          TextFormField(
            decoration: const InputDecoration(label: Text("Device name")),
            initialValue: deviceName,
            onSaved: (newValue) => deviceName = newValue!,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'must be present';
              }
              return null;
            },
          ),
          Spacer(),
          Align(
            alignment: AlignmentGeometry.bottomRight,
            child: ElevatedButton.icon(
              onPressed: submitEnabled ? submit : null,
              label: Text("Continue"),
              icon: Icon(Icons.arrow_forward),
              iconAlignment: IconAlignment.end,
            ),
          ),
        ],
      ),
    );
  }
}

class TestDataForm extends StatefulWidget {
  const TestDataForm({super.key});

  @override
  State<TestDataForm> createState() => _TestDataFormState();
}

class _TestDataFormState extends State<TestDataForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int teamNumber = 2539;
  String teamNickname = "Krypton Cougars";
  int numberOfTeams = 6;
  int numberOfMatches = 5;

  bool submitEnabled = true;
  void submit() async {
    setState(() {
      submitEnabled = false;
    });
    if (!_formKey.currentState!.validate()) {
      setState(() {
        submitEnabled = true;
      });
      return;
    }
    _formKey.currentState!.save();

    Event event = Event(
      0,
      "Hatboro Horsham",
      "PAHAT",
      DateTime.now().year,
      null,
      null,
      teamNumber,
      0,
    );

    DbEvents dbEvents = DbEvents();
    await dbEvents.insertEvent(event);

    DbTeams dbTeams = DbTeams();

    List<Team> teams = [Team(teamNumber, teamNickname)];
    for (int i = 1; i < (numberOfTeams); i++) {
      if (i == teamNumber) {
        numberOfTeams++;
        continue;
      }
      teams.add(Team(i, "Test Team $i"));
    }
    await Future.wait(teams.map((t) => dbTeams.insertTeam(t)));

    //TODO add test matches

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 8,
        children: [
          TextFormField(
            decoration: const InputDecoration(label: Text("Team #")),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(5),
            ],
            initialValue: teamNumber.toString(),
            onSaved: (newValue) => teamNumber = int.parse(newValue!),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'must be present';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(label: Text("Team Nickname")),
            initialValue: teamNickname,
            onSaved: (newValue) => teamNickname = newValue!,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'must be present';
              }
              return null;
            },
          ),
          SizedBox(height: 20), //hides that the padding is all off
          NumberField(
            label: "# of test teams",
            minValue: 6,
            maxValue: 120,
            startValue: numberOfTeams,
            callback: (v) => numberOfTeams = v,
          ),
          NumberField(
            label: "# of matches",
            minValue: 0,
            maxValue: 120,
            startValue: numberOfMatches,
            callback: (v) => numberOfMatches = v,
          ),
          Spacer(),
          Align(
            alignment: AlignmentGeometry.bottomRight,
            child: ElevatedButton.icon(
              onPressed: submitEnabled ? submit : null,
              label: Text("Continue"),
              icon: Icon(Icons.arrow_forward),
              iconAlignment: IconAlignment.end,
            ),
          ),
        ],
      ),
    );
  }
}
