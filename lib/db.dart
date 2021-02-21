import 'package:flutter/material.dart';
import 'package:starwiki/app/models/character_model.dart';
import 'package:starwiki/app/repository/character_repository.dart';
import 'package:starwiki/app/repository/db_util.dart';

class DBtestePage extends StatefulWidget {
  @override
  _DBtestePageState createState() => _DBtestePageState();
}

class _DBtestePageState extends State<DBtestePage> {
  CharacterRepository characterRepository = CharacterRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(onPressed: () async{
          await characterRepository.fetchChararcterByPage(9);
          var db = await DBUtil.getData('characters');
          print(db);
          List<CharacterModel> characters = db.map((json) => CharacterModel.fromJson(json)).toList();
          for (int i = 0; i < characters.length; i++){
            print(characters[i].name);
            print(characters[i].url);
            print(characters[i].skinColor);
          }
        },
        child: Text('Apertar'),
        ),
      ),
    );
  }
}