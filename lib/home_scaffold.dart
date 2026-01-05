import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:radio_ppl/home_page.dart';
import 'package:radio_ppl/sequence.dart';

// This widget contains all the UI for the home page.
// It is stateless and receives all its data and callbacks from the parent.
class HomeScaffold extends StatelessWidget {
  final HomePageState state;

  const HomeScaffold({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    // Ecran de base (fond et appbar avec icon about)
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.headset_mic),
          onPressed: state.onSettingsPressed,
        ),
        title: Text(state.widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: state.onWaypointsPressed,
          ),
          IconButton(
            icon: const Icon(Icons.help_center_outlined),
            onPressed: state.onAboutPressed,
          ),
        ],
      ),
      body: _buildUI(context), // radio, paramètres et boutons
    );
  }

  Widget _buildUI(BuildContext context) {
    // Structure de l'interface UI
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _parametres(context), // affichage des dropbox de choix
        _radio(context), // partie gestion des fréquences et visualisation des points
        const Gap(14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // use whichever suits your need
          children: <Widget>[
            OutlinedButton( // bouton micro, on parle au contrôleur
              onPressed: state.onMicPressed,
              child: Icon(state.isMicOff() ? Icons.mic_off : Icons.mic),
            ),
            OutlinedButton( // bouton casque, on écoute le message du contrôleur
              onPressed: state.isCasqueOff() ? null : state.listenMSG,
              child: Icon(state.isCasqueOff() ? Icons.headset_off : Icons.headset_outlined),
            ),
          ],
        ),
        const Gap(36),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            OutlinedButton.icon( // demande d'aide (snap)
              onPressed: () => _showBottomSheetRepeat(context),
              icon: const Icon(Icons.live_help),
              label: const Text("J'ai rien compris !"),
              iconAlignment: IconAlignment.start,
            ),
            OutlinedButton.icon( //Affichage de la carte pour se repérer
              onPressed: () => _showBottomSheetWhere(context),
              icon: const Icon(Icons.map),
              label: const Text("C'est où ?"),
              iconAlignment: IconAlignment.start,
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            state.getBottomText(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          width: 200,
          height: 200,
          child: Visibility(
            visible: state.isFelicitationVisible(),
            child: Lottie.asset('res/lottie/thumbs-up.json'),
          ),
        ),
      ],
    );
  }

  // Paramètres : MENUS DEROULANTS
  Widget _parametres(BuildContext context) {
    // Choix de la voix du contrôleur et des autres menus déroulants
    return Card.outlined(
      color: Colors.amberAccent,
      margin: const EdgeInsets.all(20),
      elevation: 10, // The elevation determines shade.
      child: SizedBox( // height: 252.0,  // possibilité de définir la hauteur de la card
        child: Column(
          children: <Widget>[
            const Text('Paramètres :', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
            ListTile(
              title: const Text('Avion :'),
              trailing: DropdownButton(
                value: state.getSelectedAvionValue(), // valeur actuellement sélectionné
                hint: const Text('Choix'),
                onChanged: state.onAvionChanged,
                items: state.getDropDownMenuAvions(),
              ),
            ),
            ListTile(
              title: const Text('Piste en service :'),
              trailing: DropdownButton<String>(
                value: state.getSelectedPiste(),
                onChanged: state.onPisteChanged,
                items: state.getDropDownMenuPistes(),
              ),
            ),
            ListTile(
              title: const Text('Scénario du vol :'),
              trailing: DropdownButton(
                value: state.getSelectedScenarioValue(), // valeur actuellement sélectionné
                hint: const Text('Choix'),
                onChanged: state.onScenarioChanged,
                items: state.getDropDownMenuScenarios(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Affichage de la radio
  Widget _radio(BuildContext context) {
    // Gestion de l'affichage de la fréquence et du nom de la station
    return Column(
      children: <Widget>[
        Card.outlined(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          elevation: 12, // The elevation determines shade.
          color: Colors.black54,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(
                  state.getStationName(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(28, 4, 28, 4),
                color: Colors.black,
                child: Text(
                  state.getFrequency(),
                  style: GoogleFonts.handjet(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 36,
                      fontWeight: FontWeight.w300,
                      color: Colors.orangeAccent
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OverflowBar(
                  alignment: MainAxisAlignment.center,
                  spacing: 8.0,
                  overflowSpacing: 8.0,
                  children: <Widget>[
                    OutlinedButton( // bouton de changement de fréquence
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white), // Border color
                      ),
                      onPressed: state.isSwitchOff() ? null : state.changeFreq,
                      child: const Text('<>', style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Procédures d'affichage de l'aide en bas de l'écran ****************************************************************************************************************************

  void _showBottomSheetRepeat(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 4),
          borderRadius: BorderRadius.circular(0),
          color: Colors.black,
        ),
        child: ListView(
          children: <Widget>[
            const ListTile(title: Text('Dernier message reçu :'), textColor: Colors.lightBlueAccent),
            ListTile(title: Text(state.getTxtAide()), textColor: Colors.white),
          ],
        ),
      ),
    );
  }

  void _showBottomSheetWhere(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 4),
          color: Colors.black,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(state.getCartePath()),
            ),
          ],
        ),
      ),
    );
  }
}