class sequence {
// objet contenant tous les éléments pour chaque étape du vol

  final int voix;              // voix des contrôleurs, de 0 à 6
  final List<String> msgControleur;
  final List<String> msgAttendu;
  final List<String> msgPossibles;
  final List<String> msgAide;
  final String carte; // nom du fichier carte
  final bool blnMicro; // indique si le micro doit être désactivé
  final bool blnCasque; // indique si le casque doit être désactivé
  final bool blnSwitch; // indique si le switch de fréquence doit être désactivé

  const sequence({
    required this.voix,
    required this.msgControleur,
    required this.msgAttendu,
    required this.msgPossibles,
    required this.msgAide,
    required this.carte,
    required this.blnMicro,
    required this.blnCasque,
    required this.blnSwitch,
  });

}