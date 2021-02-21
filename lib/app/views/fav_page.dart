import 'package:flutter/material.dart';
import 'package:starwiki/app/components/card_character.dart';
import 'package:starwiki/app/models/character_model.dart';
import 'package:starwiki/app/repository/character_repository.dart';
import 'package:starwiki/app/repository/db_util.dart';

class FavPage extends StatefulWidget {
  @override
  _FavPageState createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  bool _loading = true;
  CharacterRepository characterRepository = CharacterRepository();
  List<CharacterModel> characters;
  var db2;
  _loadFromDB() async {
    var db = await DBUtil.getFavorites('characters');
    db2 = db;
    characters = db.map((json) => CharacterModel(
              name: json['name'],
              height: json['height'],
              mass: json['mass'],
              hairColor: json['hair_color'],
              skinColor: json['skin_color'],
              eyeColor: json['eye_color'],
              birthYear: json['birthYear'],
              gender: json['gender'],
              homeworld: json['homeworld'],
              //planetName: json['planetName'],
              //specieName: json['specieName'],
              url: json['url'],
              //species: json['species'] ?? [],
              isFav: json['isFav'] == 1 ? true : false,
            ))
        .toList();
        _loading = false;
        setState(() {});
  }

  @override
  void initState() {
    super.initState();
      _loadFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(icon: Icon(Icons.favorite), onPressed: (){
          print(db2);
        })],
        title: Text('Favoritos'),
      ),
      body: _loading ? Center(child: CircularProgressIndicator()) : Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: GridView.builder(
            itemCount: characters.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              return CardCharacter(
                characterModel: characters[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
