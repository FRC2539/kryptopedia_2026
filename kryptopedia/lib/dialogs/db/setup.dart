import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kryptopedia/dialogs/notification.dart';
import 'package:kryptopedia/models/event.dart';
import 'package:kryptopedia/models/team.dart';
import 'package:kryptopedia/models/team_member.dart';
import 'package:kryptopedia/util/api.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/db/sync.dart';
import 'package:kryptopedia/util/db/team_members.dart';
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
  @override
  void initState() {
    super.initState();
    apiDataChanged();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int teamNumber = 2539;
  String serverURL = "https://2539scouting.userexe.me";
  Map<String, dynamic>? event;
  String deviceId = "";

  bool submitEnabled = true;
  void submit() async {
    setState(() {
      submitEnabled = false;
    });
    if (!_formKey.currentState!.validate() || apiError != null) {
      setState(() {
        submitEnabled = true;
      });
      return;
    }
    _formKey.currentState!.save();

    dynamic sessionRequest = await Api.startSessionRequest(
      serverURL,
      teamNumber,
      event!["id"],
      deviceId,
    );

    if (!mounted) return;
    bool dialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return NotificationDialog(
          title: "Awaiting confirmation",
          body:
              "Confirmation is required- log into the dashboard to authorize this device.\n"
              "Request ID: ${sessionRequest.data["request_id"]}",
          okButtonText: "Cancel",
        );
      },
    ).then((value) {
      dialogOpen = false;
    });

    bool approved = false;
    String? token;
    while (!approved && dialogOpen) {
      await Future.delayed(Duration(seconds: 3));
      dynamic pokeResponse = await Api.pokeSessionRequest(
        serverURL,
        teamNumber,
        sessionRequest.data["request_id"],
      );
      if (pokeResponse.success &&
          pokeResponse.data["session_auth_token"] != null) {
        approved = true;
        token = pokeResponse.data["session_auth_token"];
      }
      if (pokeResponse.data == 404) {
        //request was denied
        if (!mounted) return;
        submitEnabled = true;
        Navigator.pop(context);
        return;
      }
    }

    //canceled
    if (!dialogOpen && !approved) {
      Api.cancelSessionRequest(
        serverURL,
        teamNumber,
        sessionRequest.data["request_id"],
      );
      setState(() {
        submitEnabled = true;
      });
      return;
    }

    if (!mounted) return;
    Navigator.pop(context);

    Event eventData = Event(
      0,
      event!["name"],
      event!["code"],
      event!["year"],
      serverURL,
      token,
      teamNumber,
      0,
      null,
    );
    DbEvents dbEvents = DbEvents();
    await dbEvents.insertEvent(eventData);

    if (!mounted) return;
    Navigator.pop(context);

    await syncDataFlow(context);
  }

  String? apiError;
  List<DropdownMenuItem<String>> eventsOptions = [];
  List<DropdownMenuItem<String>> devicesOptions = [];
  Map<String, dynamic> eventsMap = {};
  void apiDataChanged() async {
    APIResponse data = await Api.preauthInfo(serverURL, teamNumber);
    if (!data.success) {
      return setState(() {
        apiError = data.data.toString();
      });
    }

    List<dynamic> events = data.data["events"];
    List<dynamic> devices = data.data["devices"];

    if (events.isEmpty) {
      return setState(() {
        apiError = "no events exist!";
      });
    }
    if (devices.isEmpty) {
      return setState(() {
        apiError = "no teams exist!";
      });
    }

    eventsOptions = events.map((e) {
      eventsMap[e["id"]] = e;
      return DropdownMenuItem<String>(value: e["id"], child: Text(e["name"]));
    }).toList();
    devicesOptions = devices
        .map(
          (e) =>
              DropdownMenuItem<String>(value: e["id"], child: Text(e["name"])),
        )
        .toList();

    setState(() {
      apiError = null;
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
            onChanged: (v) => teamNumber = int.tryParse(v) ?? 0,
            autovalidateMode: AutovalidateMode.onUnfocus,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'must be present';
              }
              apiDataChanged();
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              label: Text("Server URL"),
              errorText: apiError,
            ),
            initialValue: serverURL,
            onChanged: (v) => serverURL = v,
            autovalidateMode: AutovalidateMode.onUnfocus,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'must be present';
              }
              if (value.endsWith("/")) {
                return "don't end it with a slash";
              }
              if (!RegExp(r"https?:\/\/.+").hasMatch(value)) {
                return "must be an https url";
              }
              apiDataChanged();
              return null;
            },
          ),

          DropdownButtonFormField(
            decoration: InputDecoration(label: Text("Event")),
            items: eventsOptions,
            onChanged: (v) => event = eventsMap[v],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null) {
                return 'must be present';
              }
              return null;
            },
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(label: Text("Device")),
            items: devicesOptions,
            onChanged: (v) => deviceId = v ?? "",
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
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
  int numberOfTeamMembers = 3;

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
      null,
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
    await Future.wait(teams.map((t) => dbTeams.upsertTeam(t)));

    //TODO add test matches

    DbTeamMembers dbTeamMembers = DbTeamMembers();

    List<TeamMember> members = [TeamMember(id: "1", name: "Dominic")];
    for (int i = 1; i < numberOfTeamMembers; i++) {
      members.add(TeamMember(id: "${i + 1}", name: "Team Member ${i + 1}"));
    }
    await Future.wait(members.map((m) => dbTeamMembers.upsertTeamMember(m)));

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
            label: "# of team members",
            minValue: 1,
            maxValue: 10,
            startValue: numberOfTeamMembers,
            callback: (v) => numberOfTeamMembers = v,
          ),
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
