import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:starwiki/app/models/character_model.dart';
import 'package:starwiki/app/repository/db_util.dart';

class CharacterRepository {

  Future<List<CharacterModel>> fetchChararcter() async {
    List<CharacterModel> characters = [];
    bool carregar = true;
    int pageId = 8;
    String _url = 'http://swapi.dev/api/people/?page=';

    while(carregar){
      var resposta = await http.get(_url + '$pageId');
      var json = jsonDecode(resposta.body);
      List list = json['results'];

      for (var json in list){
        json['planetName'] = await carregarNomePlaneta(json['homeworld']);
        json['specieName'] = await carregarNomeDaEspecie(json['species'].toString());
        final character = CharacterModel.fromJson(json);
        characters.add(character);
      }
      pageId++;
      if (pageId > 10){
        carregar = false;
        print('pageid: $pageId');
      } 
      if (json['next'] == null){
        carregar = false;
        print(json['next']);
      }
    }  
    return characters;
  }

  Future<List<CharacterModel>> fetchChararcterByPage(int pageId) async {
    print(fetchChararcterByPage);
    List<CharacterModel> characters = [];
    String _url = 'http://swapi.dev/api/people/?page=';
    var resposta = await http.get(_url + '$pageId');
    var json = jsonDecode(resposta.body);
    if(json['detail'] != 'Not found'){  // json[detail] é retornado quando a pagina não foi encontrada
      List characterList = json['results']; 
      for (var characterJson in characterList){
        //json['planetName'] = await carregarNomePlaneta(json['homeworld']);
        //json['specieName'] = await carregarNomeDaEspecie(json['species'].toString());
        final characterModel = CharacterModel.fromJson(characterJson);
        bool isFav = await DBUtil.isFavDB('characters', characterModel.url); // Verifica no banco se é favorito
        characterModel.isFav = isFav;
        characters.add(characterModel);
        // Add model to DB
        DBUtil.insert('characters', {
          'url': characterModel.url,
          'name': characterModel.name,
          'height': characterModel.mass,
          'mass': characterModel.hairColor,
          'hair_color': characterModel.hairColor,
          'skin_color': characterModel.skinColor,
          'eye_color': characterModel.eyeColor,
          'birthYear': characterModel.birthYear,
          'Homeworld': characterModel.homeworld,
          'gender': characterModel.gender,
          //'planetName': character.planetName,
          //'specieName': character.specieName,
          //'species': null,
          'isFav': characterModel.isFav,
        });
      } 
    }
    return characters;
  }


  Future<List<CharacterModel>> searchChararcter(String busca) async {
    List<CharacterModel> characters = [];
    bool carregar = true;
    int pageId = 1;
    String _url = 'http://swapi.dev/api/people/?search=$busca&page=$pageId';

    while(carregar){
      var resposta = await http.get(_url);
      print(_url);
      print('pagina: $pageId');
      var json = jsonDecode(resposta.body);
      List list = json['results'];

      for (var json in list){
        //json['planetName'] = await carregarNomePlaneta(json['homeworld']);
        //json['specieName'] = await carregarNomeDaEspecie(json['species'].toString());
        final character = CharacterModel.fromJson(json);
        characters.add(character);
      }
      print(json['next']);
      pageId++;
      _url = 'http://swapi.dev/api/people/?search=$busca&page=$pageId';
      if (pageId > 10){
        carregar = false;
        print('pageid: $pageId');
      } 
      if (json['next'] == null){
        carregar = false;
        print(json['next']);
      }
    }  
    return characters;
  }

  Future<String> carregarNomePlaneta(String url) async {
    print(url);
    var resposta = await http.get(url);
    var json = jsonDecode(resposta.body);
    print(json['name']);
    return json['name'];
  }

  Future<String> carregarNomeDaEspecie(String specie)async{
    String url = specie.replaceAll('[', '');
    url = url.replaceAll(']', '');
    print(url);

    if (url != ''){
      var resposta = await http.get(url);
      var json = jsonDecode(resposta.body);
      print(json['name'] + 'nome da especia');
      return json['name'];
    }
    return 'Sem especie';
  }

  Future<String> adicionarFavoritosAPI(String id) async{
    String url = 'http://private-782d3-starwarsfavorites.apiary-mock.com/favorite/';
    var resposta = await http.post(url+id);
    var json = jsonDecode(resposta.body);
    if (resposta.statusCode == 201)
      return json['message'];
    return 'erro ao favoritar';
  }
}