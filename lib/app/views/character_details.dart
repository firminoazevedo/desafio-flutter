import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:starwiki/app/animation/FadeAnimation.dart';
import 'package:starwiki/app/components/info_container.dart';
import 'package:starwiki/app/models/character_model.dart';
import 'package:starwiki/app/repository/character_repository.dart';
import 'package:starwiki/app/repository/db_util.dart';

class CharacterDetailsPage extends StatefulWidget {
  final CharacterModel characterModel;
  const CharacterDetailsPage({Key key, this.characterModel}) : super(key: key);
  @override
  _CharacterDetailsPageState createState() => _CharacterDetailsPageState();
}
class _CharacterDetailsPageState extends State<CharacterDetailsPage> {

  carregarDados()async {
    try {
      widget.characterModel.planetName
      = await CharacterRepository()
          .carregarNomePlaneta(
            widget.characterModel.homeworld
          );
    } catch (e) {
      widget.characterModel.planetName = '{Falied to Loading}';
    }
    try {
      widget.characterModel.specieName = await CharacterRepository()
        .carregarNomeDaEspecie(widget.characterModel.species.toString());
    } catch (e) {
      widget.characterModel.specieName = '{Falied to Loading}';
    }
    setState(() {});
  }

  @override
  void initState() {
    carregarDados();
    super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // final CharacterModel characterModel = Provider.of<CharacterModel>(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Character'),
          actions: [
            IconButton(icon: Icon(
              widget.characterModel.isFav ? Icons.favorite :
              Icons.favorite_border,
              color: Colors.amber,
              ), onPressed: () async {
                DBUtil.favoriteUpdate('characters', widget.characterModel.url, !widget.characterModel.isFav);
                CharacterRepository characterRepository = CharacterRepository();
                if(widget.characterModel.isFav == false){
                  try {
                    widget.characterModel.toggleIsFav();
                    setState(() {});
                    String resposta = await characterRepository.adicionarFavoritosAPI(widget.characterModel.name);
                    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(resposta),));
                    DBUtil.delete('fav_requests', 'url', [widget.characterModel.url]);
                    setState(() {});
                  } catch (e) {
                    widget.characterModel.toggleIsFav();
                    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Failed to add to favorites on server'),));
                    DBUtil.insert('fav_requests', { 
                      'url': widget.characterModel.url,
                      'name': widget.characterModel.name
                    });
                    var db =  await DBUtil.executeSQL('SELECT * FROM fav_requests');
                    print(db);
                    setState(() {});                             
                  }
                } else {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Removed from favorites'),));
                }
                widget.characterModel.toggleIsFav();
                setState(() {});
              })
          ],),
      body: Center(
        child: Column(
          children: [
              Expanded(
                flex: 1,
                child: FadeAnimation(
                  1.4,
                  Center(child: Text('Nome: \n' + widget.characterModel.name ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w200,
                  ),)),
                )),
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
                  InfoCard('Nome do Planeta: ' + (widget.characterModel.planetName.isEmpty ? 'Carregando ...' : widget.characterModel.planetName)),
                  InfoCard('Nome da Specie: ' + (widget.characterModel.specieName.isEmpty ? 'Carregando ...' : widget.characterModel.specieName)),
                ],),
              ),)
          ],
        ),
      ),
        ),
      );
  }
}