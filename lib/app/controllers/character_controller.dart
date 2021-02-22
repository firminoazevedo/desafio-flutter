import 'package:flutter/cupertino.dart';
import 'package:starwiki/app/models/character_model.dart';
import 'package:starwiki/app/repository/character_repository.dart';
import 'package:starwiki/app/repository/db_util.dart';

class CharacterController with ChangeNotifier{
  List<CharacterModel> characters = [];
  List<CharacterModel> charactersFav = [];
  bool isLoading = true;
  final repository = CharacterRepository();

  Future start(int pageId) async {
    var newCharacter = await repository.fetchChararcterByPage(pageId);
    characters.addAll(newCharacter);
    isLoading = false;
    notifyListeners();
  }

  loadFavCharacters() async {
    var favoritesListFromDB = await DBUtil.getFavorites('characters');
    if(favoritesListFromDB.isNotEmpty)
    charactersFav = favoritesListFromDB.map((json) => CharacterModel(
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
    notifyListeners();
  }
  List<CharacterModel> get getCharactersFav => [...charactersFav];

}