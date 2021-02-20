import 'package:flutter/material.dart';
import 'package:starwiki/app/components/card_character.dart';
import 'package:starwiki/app/models/character_model.dart';

class SearchDetailsPage extends StatefulWidget {
  final List<CharacterModel> characters;
  const SearchDetailsPage({Key key, this.characters}) : super(key: key);
  @override
  _SearchDetailsPageState createState() => _SearchDetailsPageState();
}

class _SearchDetailsPageState extends State<SearchDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text('Resultados da busca'),),
      body: GridView.builder(
        itemCount: widget.characters.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext context, int index) {
          return CardCharacter(
            characterModel: widget.characters[index],
          );
        },
      ),
    );
  }
}
