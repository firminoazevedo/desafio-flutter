import 'package:flutter/material.dart';
import 'package:starwiki/app/components/card_character.dart';
import 'package:starwiki/app/components/search_widget.dart';
import 'package:starwiki/app/models/character_model.dart';
import 'package:starwiki/app/repository/character_repository.dart';
import 'package:starwiki/app/views/fav_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageId = 9;
  bool loadMore = true;
  List<CharacterModel> characters = [];
  bool carregado = false;
  CharacterRepository characterRepository = CharacterRepository();

  Future _carregarDados() async{
    var newCharacter = await characterRepository.fetchChararcterByPage(pageId);
    if (newCharacter.isEmpty){
      loadMore = false;
    }
    characters.addAll(newCharacter);
    setState(() {
      
    });
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
      appBar: AppBar(
        actions: [ GestureDetector(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => FavPage()));
          },
          child: Row(
            children: [
              Icon(Icons.favorite_border),
              Text('Favoritos')
            ],
          ),
        )],
      ),
      body: !carregado ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10,),
            Text('Carregando Dados ...')
          ],
        ))
        
        /*RaisedButton(onPressed: () async{
          characters = await characterRepository.fetchChararcter();
          setState(() {
            //carregado = !carregado;
          });
        },
        child: Text('fetch'),),
        )*/ : Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/bg.png'),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 38.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Image.asset('assets/logo.png')),
                ),
                SearchWidget(),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.builder(
                    itemCount: characters.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    ),
                    itemBuilder: (BuildContext context, int index){ 
                    if(index >= characters.length-1 && loadMore){
                      pageId++;
                      _carregarDados();
                      return Padding(
                        padding: const EdgeInsets.all(55.0),
                        child: CircularProgressIndicator(),
                      );
                    }
                    
                    return CardCharacter(characterModel: characters[index],);
                },),
                  ),
                ),
              ],
            ),
            /*Positioned(
              bottom: 0,
              child: loadMore ? CircularProgressIndicator() : Container(),),*/
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