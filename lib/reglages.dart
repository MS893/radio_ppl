import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:radio_ppl/son.dart';


// Affichage de la page qui permet le réglage du son du TTS
class MySettingsRoute extends StatefulWidget {
  const MySettingsRoute({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsState();

}

class _SettingsState extends State<MySettingsRoute> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Réglages du son de la synthèse vocale"),
        ),
        body: Card.outlined(
          margin: const EdgeInsets.all(20),
          elevation: 10, // The elevation determines shade.
          child: SizedBox(
            height: 470.0,
            child: Column(
              children: [
                Gap(30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('      Volume (0 à 1) :',style: TextStyle(fontSize: 18.0)),
                ),
                _volume(),
                Gap(20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('      Pitch (0,5 à 2) :',style: TextStyle(fontSize: 18.0)),
                ),
                _pitch(),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Text("Débit de parole : 1,0 est le débit de parole normal, les valeurs inférieures ralentissent la parole (0,5 est la moitié du débit de parole normal), les valeurs supérieures l'accélèrent (2,0 est le double du débit de parole normal).",style: TextStyle(fontSize: 12.0)),
                ),
                Gap(20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('      Rate (0 à 1) :',style: TextStyle(fontSize: 18.0)),
                ),
                _rate(),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Text("Hauteur de la parole : 1,0 est la hauteur normale, les valeurs inférieures abaissent le ton de la voix synthétisée, les valeurs supérieures l'augmentent.\n\nEn cas de difficulté, choisissez pitch 1,1 et rate 0,6.",style: TextStyle(fontSize: 12.0)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Réglage du volume
  Widget _volume() {
    return Slider(
        value: volume,
        onChanged: (newVolume) {
          setState(() => volume = newVolume);
        },
        min: 0.0,
        max: 1.0,
        divisions: 10,
        label: "Volume: ${volume.toStringAsFixed(1)}",
        activeColor: Colors.indigo,
    );
  }

  Widget _pitch() {
    return Slider(
      value: pitch,
      onChanged: (newPitch) {
        setState(() => pitch = newPitch);
      },
      min: 0.5,
      max: 2.0,
      divisions: 15,
      label: "Pitch: ${pitch.toStringAsFixed(1)}",
      activeColor: Colors.blue,
    );
  }

  Widget _rate() {
    return Slider(
      value: rate,
      onChanged: (newRate) {
        setState(() => rate = newRate);
      },
      min: 0.0,
      max: 1.0,
      divisions: 10,
      label: "Rate: ${rate.toStringAsFixed(1)}",
      activeColor: Colors.deepPurpleAccent,
    );
  }

}



