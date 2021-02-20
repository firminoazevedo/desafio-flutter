import 'package:flutter/material.dart';
import 'package:starwiki/app/models/character_model.dart';

class CharacterDetailsPage extends StatefulWidget {
  final CharacterModel characterModel;
  const CharacterDetailsPage({Key key, @required this.characterModel}) : super(key: key);
  @override
  _CharacterDetailsPageState createState() => _CharacterDetailsPageState();
}

class _CharacterDetailsPageState extends State<CharacterDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Character'),
              actions: [
                IconButton(icon: Icon(Icons.favorite), onPressed: null)
              ],),
          body: Center(
            child: Column(
              children: [
                Text('Nome: ' + widget.characterModel.name),
                Text('Altura:  ' + widget.characterModel.height),
                Text('Peso: ' + widget.characterModel.mass),
                Text('Cor do cabelo: ' + widget.characterModel.hairColor),
                Text('Cor da Pele: ' + widget.characterModel.skinColor),
                Text('Cor dos olhos: ' + widget.characterModel.eyeColor),
                Text('Data de Nascimento: ' + widget.characterModel.birthYear),
                Text('Nome do Planeta: ' + widget.characterModel.planetName),
                Text('Nome da Specie: ' + widget.characterModel.specieName),
              ],
            ),
          ),
      ),
    );
  }
}