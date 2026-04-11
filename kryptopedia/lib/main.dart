import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:kryptopedia/dialogs/db/setup.dart';
import 'package:kryptopedia/dialogs/db/sync.dart';
import 'package:kryptopedia/util/db/events.dart';
import 'package:kryptopedia/util/device.dart';
import 'package:kryptopedia/widgets/menu/main_menu.dart';
import 'dart:math';

const Color cougarOrange = Color.fromARGB(225, 242, 101, 34);
const Color cougarOffBlack = Color.fromARGB(225, 47, 45, 45);
int? index;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kryptopedia - Rebuilt",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: cougarOrange,
          brightness: Brightness.dark,
        ),
      ),
      //this little dance with a scaffold and another navigator
      //is needed to let snackbars show up on top of dialogs!
      //see https://stackoverflow.com/a/68446126/17675751
      home: Scaffold(
        body: Navigator(
          onGenerateRoute: (setting) {
            return MaterialPageRoute(builder: (context) => MainScreen());
          },
        ),
      )
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      DbEvents dbEvents = DbEvents();
      bool event = await dbEvents.doesEventExist();

      if (!mounted) return;
      if (!event) {
        showDialog(
          context: context,
          barrierDismissible: false,
          useRootNavigator: false,
          builder: (c) => EventSetupDialog(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: index != null
          ? Colors.accents[index!]
          : Colors.transparent,
      appBar: AppBar(
        actions: <Widget>[
          ConfettiWidget(
            key: UniqueKey(),
            confettiController: _confettiController,
            numberOfParticles: 20,
            colors: const [cougarOrange, cougarOffBlack],
          ),
          IconButton(
            color: index != null ? Colors.accents[index!] : Colors.transparent,
            splashColor: cougarOffBlack,
            icon: Icon(Icons.format_color_reset),
            onPressed: () {
              setState(() {
                index = null;
              });
            },
          ),
          IconButton(
            color: index != null ? Colors.accents[index!] : Colors.transparent,
            splashColor: cougarOrange,
            icon: Icon(Icons.colorize),
            onPressed: () {
              setState(() {
                int? nindex = index;
                while (index == nindex) {
                  nindex = Random().nextInt(Colors.accents.length);
                }
                index = nindex;
              });
            },
          ),
          IconButton(
            splashColor: cougarOrange,
            icon: Icon(Icons.cloud_sync),
            onPressed: () {
              showDialog(context: context, builder: (context) => SyncPopup());
            },
          ),
          IconButton(
            splashColor: cougarOrange,
            icon: Image.asset('assets/images/gearpaw.png'),
            onPressed: () {
              _confettiController.play();
            },
          ),
        ],
        title: Text(
          "Kryptopedia - Rebuilt",
          style: TextStyle(fontSize: Device.fontHeader(context)),
          maxLines: 1,
        ),
        centerTitle: true,
      ),
      body: Row(
        children: [
          SizedBox(
            width: landscape(context)
                ? MediaQuery.of(context).size.width / 3.0
                : MediaQuery.of(context).size.width,
            child: const MainMenu(),
          ),
          Visibility(
            visible: landscape(context),
            child: Expanded(
              child: const Align(
                alignment: Alignment.center,
                child: Image(image: AssetImage('assets/images/REBUILT.png')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
