import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starwiki/app/components/card_character.dart';
import 'package:starwiki/app/controllers/character_controller.dart';
import 'package:starwiki/app/repository/character_repository.dart';

class FavPage extends StatefulWidget {
  @override
  _FavPageState createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  bool _loading = true;
  CharacterRepository characterRepository = CharacterRepository();


  @override
  Widget build(BuildContext context) {
    Provider.of<CharacterController>(context).loadFavCharacters();
      setState(() {
        _loading = false;
      });
    final characters = Provider.of<CharacterController>(context).getCharactersFav;
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
      ),
      body: _loading ? Center(child: CircularProgressIndicator())
      : characters == null ? Center(child: Text('Você ainda não adicionou nenhuma favorito'),)
      : Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: GridView.builder(
            itemCount: characters.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              return ChangeNotifierProvider(
                create: (context) => characters[index],
                child: CardCharacter(characterModel: characters[index],));
            },
          ),
        ),
      ),
    );
  }
}
