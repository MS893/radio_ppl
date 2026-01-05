import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:radio_ppl/sequence.dart';


// CONSTANTES DE L'APPLICATION

const APP_NAME = 'RADIO PPL';
final AppIcon = Image.asset('res/images/app_icon.png', height: 64.0, width: 64.0);
late final PackageInfo kPackageInfo;
const APP_DESCRIPTION = "Entraînement à la radio pour les élèves LAPL, PPL et ULM."
                      "\nLFMA - Aix les Milles."
                    "\n\nDéveloppée par Christian FI/FE/IULM.";
const APP_AIDE = "Avec cette application vous pouvez vous entraîner à la radio (écouter le contrôleur et parler à la radio), sur l'aérodrome d'Aix les Milles (LFMA)."
             "\n\nUtilise les fonctionnalités de reconnaissance vocale et de synthèse vocale de Google.";
const TAF_LFMA_URL = 'https://metar-taf.com/fr/LFMA';
const MTO_LFMA_URL = 'http://qfu.free.fr/requete.php?code=LFMA';

// Phraséologie

// Scénario 1 - TdP à Aix
const etape_scenario_1 = [seq0, seq1, seq2, seq3, seq4, seq5, seq6];
// Scénario 2 - Vol local sortie AT
const etape_scenario_2 = [seq0, seq1, seq2, seq3, seq4];
// Scénario 3 - Nav La Fare
const etape_scenario_3 = [seq0, seq1, seq2, seq3, seq4];
// Scénario 2 - Nav Avignon
const etape_scenario_4 = [seq0, seq1, seq2, seq3, seq4];
// Scénario 2 - Nav Vinon
const etape_scenario_5 = [seq0, seq1, seq2, seq3, seq4];

// seq 0
const sequence seq0 = sequence( // ATIS
  voix: 0,
  msgControleur: ["$ATIS_LFMA_32"], // valeur initialisée qui peut êtr modifiée si on choisi la 14
  msgAttendu: [""],
  msgPossibles: [""],
  msgAide: ["$T_ATIS_LFMA_32"],
  carte: "res/images/LFMA.jpeg",
  blnMicro: true, // micro désactivé
  blnCasque: false,
  blnSwitch: true,
);
// seq 1
const sequence seq1 = sequence( // 1er contact sur sol : bonjour (de l'élève)
  voix: 1,
  msgControleur: [" bonjour"],
  msgAttendu: ["Aix sol ", " bonjour"], // inclure l'immat
  msgPossibles: [""], //.....
  msgAide: ["Contactez le sol, donnez votre immatriculation, et dites bonjour"],
  carte: "res/images/LFMA.jpeg",
  blnMicro: false,
  blnCasque: true,  // casque désactivé
  blnSwitch: true,
);
// seq 2
const sequence seq2 = sequence( // 1er contact sur sol : réponse du contrôleur (bonjour)
  voix: 1,
  msgControleur: [" bonjour"],
  msgAttendu: [""],
  msgPossibles: [""], //.....
  msgAide: [" bonjour"],
  carte: "res/images/LFMA.jpeg",
  blnMicro: true,
  blnCasque: false,
  blnSwitch: true,
);
// seq 2
const sequence seq3 = sequence( // intentions et réponse du contrôleur
  voix: 1,
  msgControleur: [" transpondeur 61 ", " roulez point d'attente ", " et rappelez prêt sur 118 décimal 750"],
  msgAttendu: ["F-KX DR400, 2 personnes à bord, au parking Sierra Est, information A, pour quelques tours de piste, je suis prêt à rouler"],
  msgPossibles: [""],
  msgAide: [" transpondeur 61", " roulez point d'attente ", " et rappelez prêt sur 118.750"],
  carte: "res/images/Points_attente.png",
  blnMicro: true,
  blnCasque: false,
  blnSwitch: true,
);
// seq 3
const sequence seq4 = sequence( // 1er contact sur sol : intentions
  voix: 1,
  msgControleur: [""],
  msgAttendu: [""],
  msgPossibles: [""],
  msgAide: ["Changez de fréquence"],
  carte: "res/images/Points_attente.png",
  blnMicro: true,
  blnCasque: true,
  blnSwitch: false,
);
// seq 4
const sequence seq5 = sequence( // point d'attente P2 vers A ou B pour remontée de piste
  voix: 1,
  msgControleur: [""],
  msgAttendu: ["FKY j'avance A et je rappelle prêt"],
  msgPossibles: [""],
  msgAide: [""],
  carte: "res/images/Points_attente.png",
  blnMicro: false,
  blnCasque: false,
  blnSwitch: false,
);
// seq 5
const sequence seq6 = sequence( // autorisation décollage
  voix: 1,
  msgControleur: [""],
  msgAttendu: ["FKX je m'aligne et je décolle piste "],
  msgPossibles: [""],
  msgAide: [""],
  carte: "res/images/Points_attente.png",
  blnMicro: false,
  blnCasque: false,
  blnSwitch: false,
);


// ATIS
const ATIS_LFMA_32 = "Aix tour bonjour information Alpha enregistrée à 7 heures U T C, piste en service 32 vent du 310 degrés pour hui noeu rafales à di noeu, visibilité 7 kilomètres température 6 degrés Q N H 1023, au premier contact confirmez l'information Alpha reçue";
const T_ATIS_LFMA_32 = "Aix TWR bonjour\nInformation A enregistrée à 7 heures UTC\nPiste en service 32\nVent 310/8-10\nVisibilité 7 km\nTempérature 6°C\nQNH 1023\nAu 1er contact confirmez l'information A reçue";
const ATIS_LFMA_14 = "Aix tour bonjour, information Charlie enregistrée à 9 heures U T C, piste en service 14 vent du 170 degrés pour neuf noeu, visibilité di kilomètres, température 12 degrés, Q N H 1017, au premier contact confirmez l'information Charlie reçue";
const T_ATIS_LFMA_14 = "Aix TWR bonjour\nInformation C enregistrée à 9 heures UTC\nPiste en service 14\nVent 170/9\nVisibilité 10 km\nTempérature 12°C\nQNH 1017\nAu 1er contact confirmez l'information C reçue";


const attenduIntentions1 = "fox juliette golf tango x-ray un A22 au parking novembre est 2 personnes à bord avec l'information A pour un vol à destination de La Fare sortie AW je suis prêt à rouler";


// séquences d'aide
const aide1 = "Tout d'abord, choisissez votre avion, la piste souhaitée et le scénario de travail";
const aide2 = "Commencez par écouter l'ATIS...";
const aide3 = "Contactez le sol et dites bonjour";
const aide4 = "Indiquez maintenant vos intentions";
const aide5 = "Collationnez";


// reconnaissance vocale
const alpha = ["alpha"];
const bravo = ["bravo"];
const charlie = ["charlie", "siri", "uri", "chérie", "chéri", "chali", "cherry", "charrier"];
const echo = ["echo"];
const fox = ["fox", "f***", "faut que je", "faut que", "fois que", "portugal", "fatigue", "école", "comme", "box", "faute", "coque", "femme du"];
const golf = ["golfe", "golf et", "golf", "god", "goal"];
const juliette = ["juliette", "tu viennes", "vienne"];
const kilo = ["kilos", "kilo", "kg", "kiko", "qui veut", "qui l'eau"];
const lima = ["lima", "limas", "climat"];
const papa = ["papa"];
const romeo = ["romeo", "roméo"];
const sierra = ["sierra", "cira"];
const tango = ["tango", "tu as envoyé ça", "t'envoie"];
const victor = ["victor", "victoire"];
const xray = ["x-ray", "x ray", "x-", "xra", 'extrême', "exprès", "extrait", "écris", "il serait", "israël", "le trait", "serait", "écrit", "-kai", "écrire"];
const yankee = ["yankee", "anti", "chien qui", "chien kiki", "en kiki", "chien", "scientifique", "entier", "chiant qui", "ion kiki", "faire 10", "ok", "en 10", "en qui"];
const deux = ["deux", "de", "2"];
const AixSol = ["aix sol", "aix seul", "aix sonne", "aiXam", "aiX seul", "aiX au sol", "aiX sol", "aiX sale", "aiX sonne", "eXosol", "aixe sur le", "aixoll", "aixol", "exol", "aiXol",
                "eXol", "eX sol", "ex sol", "eXeter un sol", "tu es seul", "et que ce soit le", "et que ce soit", "et que ce sol", "et ce sol", "et que c'est sale", "et que c'est sol",
                "eXosal", "exosal", "exosol", "accessoires", "accessoire", "aix au sol", "aiXe au sol", "aiXe sol", "et que ça", "eXceptionnel"];
const AixTour = ["aix tour", "ex tour", "avec ce tour", "aiX tour", "aiX autour", "et ce tour", "ce tour"

];
const sierraest = ["sierra est", "cire as", "sierest"];
const A22 = ["a22", "A22", "a 22", "à 22", "A 22", "avant de"];
const WT9 = ["wt9", "w t 9", "double v t 9"];
const DR400 = ["dr400", "dr 400"];


// Autres constantes

const stations = [
  'ATIS Aix                    Aix Sol',
  'Aix sol                     Aix tour',
  '    Aix tour               Provence tour',
  '  Provence tour          Berre La Fare',
  '  Berre La Fare          Provence tour',
  '     Aix tour               Provence info',
  ' Provence info         Marseille info',
  'Marseille info         Avignon tour',
  'Marseille info                   Vinon',
];
const freq = [
  '136.230    <>    121.605',
  '121.605    <>    118.750',
  '118.750    <>    133.100',
  '133.100    <>    118.330',
  '118.330    <>    133.100',
  '118.750    <>    124.350',
  '124.350    <>    120.550',
  '120.550    <>    122.600',
  '120.550    <>    118.155',
];


// listes des menus déroulants

const menuItemsAvion = <String>[
  'DR400 F-GYKX',
  'DR400 F-BVCY',
  'A22 F-JGTX',
  'WT9 F-JLPR'
];

const menuItemsPiste = <String>[
  '32',
  '14',
];

const menuItemsScenario = <String>[
  'Tours de piste à Aix',
  'Vol local sortie AT',
  'Navigation la Fare',
  'Navigation Avignon',
  'Navigation Vinon',
];
