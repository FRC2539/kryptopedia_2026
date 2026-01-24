import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:kryptopedia/dialogs/db/sync.dart';
import 'package:kryptopedia/util/device.dart';
import 'package:kryptopedia/widgets/menu/main_menu.dart';

const Color cougarOrange = Color.fromARGB(225, 242, 101, 34);
const Color cougarOffBlack = Color.fromARGB(225, 47, 45, 45);

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    // DbHelper dbHelper = DbHelper();
    // dbHelper.initializeDb();

    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );
  }

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
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            ConfettiWidget(
              key: UniqueKey(),
              confettiController: _confettiController,
              numberOfParticles: 20,
              colors: const [cougarOrange, cougarOffBlack],
            ),
            SyncDialogButton(),
            IconButton(
              splashColor: cougarOrange,
              icon: Image.asset('assets/images/gearpaw.png'),
              onPressed: () {
                _confettiController.play();
              },
            ),
          ],
          // backgroundColor: Colors.grey.shade900,
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
              // color: Colors.grey.shade900,
              width: landscape(context)
                  ? MediaQuery.of(context).size.width / 3.0
                  : MediaQuery.of(context).size.width,
              child: const MainMenu(),
            ),
            Visibility(
              visible: landscape(context),
              child: Expanded(
                child: Container(
                  // color: Colors.white,
                  child: const Align(
                    alignment: Alignment.center,
                    child: Image(
                      image: AssetImage('assets/images/REBUILT.png'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//separate widget the `showDialog` builder needs a `context` that has stuff added
//to it by the `MaterialApp` already?
class SyncDialogButton extends StatelessWidget {
  const SyncDialogButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: cougarOrange,
      icon: Icon(Icons.cloud_sync),
      onPressed: () {
        showDialog(context: context, builder: (context) => SyncPopup());
      },
    );
  }
}
