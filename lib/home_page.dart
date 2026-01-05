import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:radio_ppl/about.dart';
import 'package:radio_ppl/constantes.dart';
import 'package:radio_ppl/home_scaffold.dart';
import 'package:radio_ppl/reglages.dart';
import 'package:radio_ppl/sequence.dart';
import 'package:radio_ppl/son.dart';
import 'package:radio_ppl/waypoints.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:flutter_tts/flutter_tts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // Définition des variables et constantes
  final AudioPlayer _player = AudioPlayer();
  sequence seq = seq0;
  List<sequence> etape = etape_scenario_1;
  bool _parametresOK = false;
  bool _avionOK = false;
  bool _scenarioOK = false;
  bool _speechEnabled = false;
  bool _Micro_OFF = true;
  bool _Casque_OFF = false;
  bool _Switch_OFF = true;
  String lastWords = "";
  String lastError = "last error";
  String lastStatus = "last status";
  final SpeechToText speech = SpeechToText();
  late FlutterTts flutterTts;
  List<Map> voices = [];
  Map? _currentVoice;
  final List<DropdownMenuItem<String>> _dropDownMenuAvions = menuItemsAvion.map((String value) =>
      DropdownMenuItem<String>(
          value: value,
          child: Text(value)),
  ).toList();
  final List<DropdownMenuItem<String>> _dropDownMenuPistes = menuItemsPiste.map((String value) =>
      DropdownMenuItem<String>(
          value: value,
          child: Text(value)),
  ).toList();
  final List<DropdownMenuItem<String>> _dropDownMenuScenarios = menuItemsScenario.map((String value) =>
      DropdownMenuItem<String>(
          value: value,
          child: Text(value)),
  ).toList();
  int? _selectedAvion;
  String _selectedPiste = "32";
  int? _selectedScenario;
  String _immatT = "F-GYKX";
  String _immatS = "FOX GOLF YANKEE KILO X-RAY";
  String _type = "avion";
  String? _ttsInput;
  var codeXPDR = Random().nextInt(19) + 10;
  final _stations = stations;
  final _freq = freq;
  var index_station = 0;
  var index_etape = 0;
  String _txtAide = aide1;
  var _affichageFelicitation = false;

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
    _player.dispose();
  }

  @override
  void initState() {
    super.initState();
    initSpeech();
    initTTS();
  }

  Future<void> initSpeech() async {
    try {
      bool hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        finalTimeout: const Duration(seconds: 50),
        debugLogging: true,
      );
      if (!mounted) return;
      setState(() {
        _speechEnabled = hasSpeech;
      });
    } catch (e) {
      setState(() {
        lastError = 'Speech recognition failed: ${e.toString()}';
        _speechEnabled = false;
      });
    }
  }

  Future<void> initTTS() async {
    flutterTts = FlutterTts();
    flutterTts.getVoices.then((data) {
      try {
        voices = List<Map>.from(data);
        setState(() {
          voices = voices.where((voice) => voice["locale"].contains("fr-FR")).toList();
          voices = voices.where((voice) => voice["name"].contains("local")).toList();
          _currentVoice = voices.first;
          setVoice(_currentVoice!);
        });
        flutterTts.setVolume(volume);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
      setVoice(voices.elementAt(seq.voix));
    });
  }

  void initMessages() {
    if (_selectedPiste == "32") {
      _ttsInput = ATIS_LFMA_32;
      _txtAide = T_ATIS_LFMA_32;
    } else {
      _ttsInput = ATIS_LFMA_14;
      _txtAide = T_ATIS_LFMA_14;
    }
  }

  void _playSound(String sound) async {
    try {
      await _player.play(AssetSource(sound));
    } catch (e) {
      if (kDebugMode) {
        print('Failed to play sound: $e');
      }
    }
  }

  void setVoice(Map voice) {
    flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  void _passerALaSuite() {
    index_etape++;
    seq = etape[index_etape];
    _Micro_OFF = seq.blnMicro;
    _Casque_OFF = seq.blnCasque;
    _Switch_OFF = seq.blnSwitch;
    setVoice(voices.elementAt(seq.voix));
  }

  void changeFreq() {
    if (_parametresOK) {
      flutterTts.pause();
      _playSound("freq_change.mp3");
      setState(() {
        index_station++;
        _passerALaSuite();
      });
      checkEtape();
    }
  }

  void checkEtape() {
    String newTtsInput = "";
    String newTxtAide = "";

    switch (index_etape) {
      case 1:
        newTtsInput = _immatS + seq.msgControleur[0];
        newTxtAide = seq.msgAide[0];
        break;
      case 2:
        newTtsInput = _immatS + seq.msgControleur[0];
        newTxtAide = _immatT + seq.msgAide[0];
        break;
      case 3:
        final String point = (_selectedPiste == "32")
            ? (_type == "avion" ? "papa 2" : "papa 3")
            : "bravo";
        final String aidePoint = (_selectedPiste == "32")
            ? (_type == "avion" ? " P2 " : " P3 ")
            : " B";
        newTtsInput = "${_immatS}${seq.msgControleur[0]}$codeXPDR${seq.msgControleur[1]}$point${seq.msgControleur[2]}";
        newTxtAide = "${_immatT}${seq.msgAide[0]}$codeXPDR${seq.msgAide[1]}$aidePoint${seq.msgAide[2]}";
        break;
      case 4:
      case 5: // Cases 4 and 5 are identical
        final isPiste32 = _selectedPiste == "32";
        newTtsInput = _immatS + seq.msgControleur[isPiste32 ? 0 : 1];
        newTxtAide = _immatT + seq.msgAide[isPiste32 ? 0 : 1];
        break;
      default:
        return; // No change, exit
    }

    setState(() {
      _ttsInput = newTtsInput;
      _txtAide = newTxtAide;
    });
  }

  void check_msg_radio() {
    lastWords = lastWords.toLowerCase();
    verifAlphabet();
    lastWords = lastWords.replaceFirst("goefection", "G Y");
    miseEnFormeImmat();
    miseEnFormeStation();
    _replaceSpecifics();
    if (true) { // àmodifier ensuite
      _playSound("success.mp3");
      setState(() {
        _affichageFelicitation = true;
        _passerALaSuite();
      });
      checkEtape();
    } else {
      _playSound("error.mp3");
      setState(() {
        _affichageFelicitation = false;
      });
    }
  }

  void _replaceSpecifics() {
    const Map<String, List<String>> replacements = {
      "AIX SOL": AixSol,
      "AIX TWR": AixTour,
      "S-E": sierraest,
      "DR400": DR400,
      "A22": A22,
    };
    replacements.forEach((key, value) {
      for (var i = 0; i < value.length; i++) {
        if (lastWords.contains(value.elementAt(i))) {
          lastWords = lastWords.replaceAll(value.elementAt(i), key);
        }
      }
    });
  }

  void verifAlphabet() {
    const Map<String, List<String>> alphabetReplacements = {
      "A": alpha, "B": bravo, "C": charlie, "E": echo, "F": fox, "G": golf,
      "J": juliette, "K": kilo, "L": lima, "P": papa, "R": romeo, "S": sierra,
      "T": tango, "V": victor, "X": xray, "Y": yankee,
    };
    alphabetReplacements.forEach((key, value) {
      for (var i = 0; i < value.length; i++) {
        if (lastWords.contains(value.elementAt(i))) {
          lastWords = lastWords.replaceFirst(value.elementAt(i), key);
        }
      }
    });
  }

  void miseEnFormeImmat() {
    const Map<String, List<String>> immatReplacements = {
      "F-JGTX": ["F J G T X", "F G T X", "F J G", "J G T X"],
      "F-JLPR": ["F J L P R", "F L P R", "F J L", "J L P R"],
      "F-GYKX": ["F G Y K X", "F Y K X", "F G Y", "G Y K X", "F G Y K-X"],
      "F-BVCY": ["F B V C Y", "F V C Y", "F B V", "B V C Y"],
      "F-CY": ["F C Y", "F C-Y", "focaliser", "F C", "C Y"],
      "F-TX": ["F T X", "F T-X", "T X", "T-X"],
      "F-PR": ["F P R", "F P-R", "P R", "P-R"],
      "F-KX": ["F K X", "F K-X", "K X", "K-X"],
    };
    immatReplacements.forEach((key, value) {
      for (var i = 0; i < value.length; i++) {
        if (lastWords.contains(value.elementAt(i))) {
          lastWords = lastWords.replaceFirst(value.elementAt(i), key);
        }
      }
    });
  }

  void miseEnFormeStation() {
    lastWords = lastWords.replaceFirst("AIX SOL une", "AIX SOL");
  }

  void listenMSG() async {
    if (_parametresOK) {
      if (_ttsInput?.isEmpty ?? true) initMessages();
      await flutterTts.speak(_ttsInput!);
      setState(() {
        if (index_etape != 0) _Micro_OFF = false;
        _Switch_OFF = false;
        _affichageFelicitation = false;
      });
    } else {
      // This part remains as it depends on the context, which is available here.
      showModalBottomSheet(
        context: context,
        builder: (ctx) => _buildBottomSheetRepeat(ctx),
      );
    }
  }

  void startListening() {
    if (_parametresOK) {
      lastWords = "";
      lastError = "";
      speech.listen(
        onResult: resultListener,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
      );
      setState(() {});
    }
  }

  void stopListening() {
    speech.stop();
    setState(() {});
  }

  void cancelListening() {
    speech.cancel();
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = '${result.recognizedWords}';
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = status;
      if (lastStatus == "done") check_msg_radio();
    });
  }

  Container _buildBottomSheetRepeat(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 4),
        borderRadius: BorderRadius.circular(0),
        color: Colors.black,
      ),
      child: ListView(
        children: <Widget>[
          const ListTile(title: Text('Dernier message reçu :'), textColor: Colors.lightBlueAccent),
          ListTile(title: Text(_txtAide), textColor: Colors.white),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(state: this);
  }

  // UI-related callbacks and getters
  void onSettingsPressed() async {
    await flutterTts.pause();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MySettingsRoute()),
    );
    setState(() {
      flutterTts.setVolume(volume);
      flutterTts.setPitch(pitch);
      flutterTts.setSpeechRate(rate);
    });
  }

  void onWaypointsPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyWaypointsRoute()),
    );
  }

  void onAboutPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyAboutRoute()),
    );
  }

  void onMicPressed() {
    _Micro_OFF ? null : speech.isNotListening ? startListening() : cancelListening();
  }

  bool isMicOff() => _Micro_OFF;

  bool isCasqueOff() => _Casque_OFF;

  String getBottomText() {
    if (speech.isListening) return '$lastWords';
    return _speechEnabled ? '$lastWords' : 'Reconnaissance vocale non disponible !';
  }

  bool isFelicitationVisible() => _affichageFelicitation;

  String? getSelectedAvionValue() => _selectedAvion != null ? menuItemsAvion[_selectedAvion!] : null;

  void onAvionChanged(String? newValue) {
    if (newValue != null) {
      setState(() => _selectedAvion = menuItemsAvion.indexOf(newValue));
      switch (_selectedAvion) {
        case 0:
          _type = "avion";
          _immatT = "F-GYKX";
          _immatS = "FOX GOLF YANKEE KILO X-RAY";
          break;
        case 1:
          _type = "avion";
          _immatT = "F-BVCY";
          _immatS = "FOX BRAVO VICTOR CHARLIE YANKEE";
          break;
        case 2:
          _type = "ulm";
          _immatT = "F-JGTX";
          _immatS = "FOX JULIETTE GOLF TANGO X-RAY";
          break;
        case 3:
          _type = "ulm";
          _immatT = "F-JLPR";
          _immatS = "FOX JULIETTE LIMA PAPA ROMEO";
          break;
      }
      _avionOK = true;
      if (_scenarioOK) {
        _parametresOK = true;
        _txtAide = aide2;
      }
    }
  }

  List<DropdownMenuItem<String>> getDropDownMenuAvions() => _dropDownMenuAvions;

  String getSelectedPiste() => _selectedPiste;

  void onPisteChanged(String? newValue) {
    if (newValue != null) {
      setState(() => _selectedPiste = newValue);
    }
  }

  List<DropdownMenuItem<String>> getDropDownMenuPistes() => _dropDownMenuPistes;

  String? getSelectedScenarioValue() => _selectedScenario != null ? menuItemsScenario[_selectedScenario!] : null;

  void onScenarioChanged(String? newValue) {
    if (newValue != null) {
      setState(() => _selectedScenario = menuItemsScenario.indexOf(newValue));
      _scenarioOK = true;
      if (_avionOK) {
        _parametresOK = true;
        _txtAide = aide2;
      }
      etape = etape_scenario_1;
      switch (_selectedScenario) {
        case 0:
          etape = etape_scenario_1;
          break;
        case 1:
          etape = etape_scenario_2;
          break;
        case 2:
          etape = etape_scenario_3;
          break;
        case 3:
          etape = etape_scenario_4;
          break;
        case 4:
          etape = etape_scenario_5;
          break;
      }
    }
  }

  List<DropdownMenuItem<String>> getDropDownMenuScenarios() => _dropDownMenuScenarios;

  String getStationName() => _stations[index_station];

  String getFrequency() => _freq[index_station];

  bool isSwitchOff() => _Switch_OFF;

  String getTxtAide() => _txtAide;

  String getCartePath() => seq.carte;
}
