import 'package:starwiki/app/models/character_model.dart';
import 'package:starwiki/app/repository/character_repository.dart';

class CharacterController {
  List<CharacterModel> characters = [];
  final repository = CharacterRepository();

  Future start() async{
    characters = await repository.fetchChararcter();
  }

  // ignore: missing_return
  Future<CharacterModel> search(){
    repository.fetchChararcter();
  }

}