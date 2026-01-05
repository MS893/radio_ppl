import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'constantes.dart';

// Affichage de la page ABOUT
class MyAboutRoute extends StatelessWidget {
  const MyAboutRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final header = ListTile(
      leading: AppIcon,
      title: Text(APP_NAME, style: TextStyle(fontWeight: FontWeight.bold)),
      trailing: IconButton(
        icon: const Icon(Icons.info),
        onPressed: () {
          showAboutDialog(
            context: context,
            applicationName: APP_NAME,
            applicationVersion: "1.0",
            // applicationVersion: kPackageInfo.version,
            applicationIcon: AppIcon,
            children: <Widget>[const Text(APP_DESCRIPTION)],
          );
        },
      ),
    );
    return new Scaffold(backgroundColor: Colors.grey, body:
      ListView(
        children: <Widget>[
          header,
          ListTile(
            title: Text(APP_AIDE, textAlign: TextAlign.center),
            textColor: Colors.white,
          ),
          const Divider(),
          ListTile(
              leading: Icon(Icons.headset_mic),
              title: Text("Bouton de réglage du son de la synthèse vocale (il n'est pas nécessaire de modifier ces paramètres)."),
              onTap: () {}
          ),
          ListTile(
            leading: Icon(Icons.mic),
            title: Text("Bouton micro, il ne faut pas appuyer en continu comme dans l'avion, mais faire un simple clic sur le bouton."
                "\nUn double beep indique que le message est bon, un triple beep grave indique que le message n'est pas bon."),
            onTap: () {}
          ),
          ListTile(
            leading: Icon(Icons.headphones_outlined),
            title: Text("Bouton écoute de la radio : permet d'écouter, et éventuellement réécouter à volonté le message du contrôleur."),
              onTap: () {}
          ),
          ListTile(
            leading: Icon(Icons.live_help),
            title: Text("Bouton pour afficher le texte du message du contrôleur, ou une aide utile."),
              onTap: () {}
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text("Permet d'afficher une carte indiquant la position de l'avion à cet instant."),
            onTap: () => url_launcher.launchUrl(Uri.parse(TAF_LFMA_URL)),
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text("Permet d'afficher les points d'entrée de la CTR d'Aix."),
            onTap: () => url_launcher.launchUrl(Uri.parse(MTO_LFMA_URL)),
          ),
        ],
      )
    );
  }
}