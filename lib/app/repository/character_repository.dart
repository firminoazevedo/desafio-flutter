import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:starwiki/app/models/character_model.dart';

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
    List<CharacterModel> characters = [];
    String _url = 'http://swapi.dev/api/people/?page=';
    var resposta = await http.get(_url + '$pageId');
    var json = jsonDecode(resposta.body);

    if(json['detail'] != 'Not found'){
      List list = json['results'];
      for (var json in list){
        json['planetName'] = await carregarNomePlaneta(json['homeworld']);
        json['specieName'] = await carregarNomeDaEspecie(json['species'].toString());
        final character = CharacterModel.fromJson(json);
        print(character.name);
        characters.add(character);
      } 
    } else {
        print('deeeetais');
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
        json['planetName'] = await carregarNomePlaneta(json['homeworld']);
        json['specieName'] = await carregarNomeDaEspecie(json['species'].toString());
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
}