import 'package:flutter/cupertino.dart';
import 'package:starwiki/app/models/character_model.dart';
import 'package:starwiki/app/repository/character_repository.dart';
import 'package:starwiki/app/repository/db_util.dart';

class CharacterController with ChangeNotifier{
  List<CharacterModel> characters = [];
  List<CharacterModel> charactersFav = [];
  bool isLoading = true;
  final repository = CharacterRepository();
  
  List<CharacterModel> get getCharactersFav => [...charactersFav];

  Future start(int pageId) async {
    print('start');
    try {
      var newCharacter = await repository.fetchChararcterByPage(pageId);
      characters.addAll(newCharacter);
    } catch (e) {
      getCharactersFromBD();
    }
    notifyListeners();
  }

  Future getCharactersFromBD() async {
    var favoritesListFromDB = await DBUtil.getData('characters');
    if (favoritesListFromDB.isNotEmpty)
      characters.addAll(favoritesListFromDB
          .map((json) => CharacterModel(
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
          .toList());
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

  search(String name){
    if (name.isNotEmpty && name != ''){
      print(name);
      characters = characters.where((char) => (char.name.toLowerCase().contains(name.toLowerCase()))).toList();
      notifyListeners();
    }
  }

  Future<List<CharacterModel>> searchOnAPI(String search)async{
    final charactersSearch = await repository.searchChararcter(search);
    return charactersSearch;
  }

  sendResquestsFailed()async{
    final favRequests = await DBUtil.getData('fav_requests');
    print(favRequests);
    favRequests.forEach((e) async {
      try {
        final results = await repository.adicionarFavoritosAPI(e['name']);
        if(results == 'erro ao favoritar'){
      } else {
        String url = e['url'];
        await DBUtil.delete('fav_requests', 'url', ['$url']);
      }
      } catch (e) {
      }
    });
    
  }

}