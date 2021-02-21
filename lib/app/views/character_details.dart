import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:starwiki/app/components/info_container.dart';
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
                IconButton(icon: Icon(
                  widget.characterModel.isFav ? Icons.favorite :
                  Icons.favorite_border,
                  color: Colors.amber,
                  ), onPressed: null)
              ],),
          body: Center(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(child: Text('Nome: \n' + widget.characterModel.name ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w200,
                  ),))),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:28.0),
                    child: ListView(children: [
                      InfoCard('Altura: ' + widget.characterModel.height.toString()),
                      InfoCard('Peso: ' + widget.characterModel.mass.toString()),
                      InfoCard('Cor do cabelo: ' + widget.characterModel.hairColor.toString()),
                      InfoCard('Cor da Pele: ' + widget.characterModel.skinColor.toString()),
                      InfoCard('Cor dos olhos: ' + widget.characterModel.eyeColor.toString()),
                      InfoCard('Data de Nascimento: ' + widget.characterModel.birthYear.toString()),
                      /*InfoCard('Nome do Planeta: ' + widget.characterModel.planetName ?? ''),
                      InfoCard('Nome da Specie: ' + widget.characterModel.specieName ?? ''),*/
                    ],),
                  ),)
              ],
            ),
          ),
      ),
    );
  }
}