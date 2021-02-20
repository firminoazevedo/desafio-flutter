import 'package:flutter/material.dart';
import 'package:starwiki/app/components/card_character.dart';
import 'package:starwiki/app/components/search_widget.dart';
import 'package:starwiki/app/models/character_model.dart';
import 'package:starwiki/app/repository/character_repository.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CharacterModel> characters;
  bool carregado = false;
  CharacterRepository characterRepository = CharacterRepository();

  Future _carregarDados() async{
    characters = await characterRepository.fetchChararcter();
  }

  @override
  void initState(){
    super.initState();
    _carregarDados().then((_){
      setState(() {
        carregado = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !carregado ? Center(
        child: RaisedButton(onPressed: () async{
          characters = await characterRepository.fetchChararcter();
          setState(() {
            //carregado = !carregado;
          });
        },
        child: Text('fetch'),),
        ) : Column(
          children: [
            SearchWidget(),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                itemCount: characters.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                ),
                itemBuilder: (BuildContext context, int index) { 
                return CardCharacter(characterModel: characters[index],);
            },),
              ),
            ),
          ],
        )
        
        
        
        /*ListView.builder(
        itemCount: characters.length,
        itemBuilder: (BuildContext context, int i) {
          return GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CharacterDetailsPage(characterModel: characters[i],)));
            },
            child: Column(
              children: [
                Text('' + characters[i].name),
                Text('' + characters[i].height),
                Text('' + characters[i].gender),
                Text('' + characters[i].mass),
                Divider(),
              ],
            ),
          );
        },
      ),*/
    );
  }
}