import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starwiki/app/animation/FadeAnimation.dart';
import 'package:starwiki/app/components/card_character.dart';
import 'package:starwiki/app/components/loading_widget.dart';
import 'package:starwiki/app/components/search_widget.dart';
import 'package:starwiki/app/controllers/character_controller.dart';
import 'package:starwiki/app/models/character_model.dart';
import 'package:starwiki/app/views/search_Character_Details_Page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchControler = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  CharacterController characterController = CharacterController();
  List<CharacterModel> characters = [];
  List<CharacterModel> charactersFav;
  int pageId = 8;
  bool loadMore = true;
  bool carregado = false;
  bool favorites = false;
  

  Future _carregarDados(context) async {
    int i = characters.length;
    await Provider.of<CharacterController>(context, listen: false).start(pageId).then((_){
      setState(() {
        carregado = true;
      });      
    });
    if(characters.length == i){
      loadMore = false;
    }
    if (pageId == 1 && characters.isEmpty){
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Verify your internet conection'),
      ));
    }
    }
    /*try {
      var newCharacter =
          await characterRepository.fetchChararcterByPage(pageId);
      if (newCharacter.isEmpty) {
        loadMore = false;
      }
      characters.addAll(newCharacter);
      setState(() {});
    } catch (e) {
      await getCharactersFromBD();
      loadMore = false;
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Verify your internet conection'),
      ));
    }
  }*/

  _search() async {
    if (searchControler.text.isNotEmpty || searchControler.text != '') {
      carregado = false;
      setState(() {});
      try {
        List<CharacterModel> characterSearch = await CharacterController().searchOnAPI(searchControler.text);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SearchDetailsPage(
                  characters: characterSearch,
                )));
      } catch (e) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Verify your internet conection'),
        ));
      }
    }
    carregado = true;
    setState(() {});
  }

  @override
  void initState() {
    Provider.of<CharacterController>(context, listen: false).sendResquestsFailed();
    _carregarDados(context).then((_) {
      setState(() {
        carregado = true;
      });
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    characters = Provider.of<CharacterController>(context).characters;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          actions: [
            GestureDetector(
              onTap: () {
                /*Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => FavPage()));*/
                if (favorites){
                  favorites = !favorites;
                  setState(() {});
                } else {
                  print('favorites');
                  favorites = !favorites;
                  charactersFav = characters.where((char) => char.isFav == true).toList();
                  setState(() {});
                }
              },
              child: Row(
                children: [
                  Icon(favorites ? Icons.favorite : Icons.favorite_border),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Favorites', style: TextStyle(
                    color: favorites ? Colors.amber : Colors.white,
                    fontWeight : favorites ? FontWeight.w700 : FontWeight.w300,
                  ),),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
            )
          ],
        ),
        body: !carregado
            ? Center(child: LoadingWidget())
            : Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/bg.png'),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 38.0),
                        child: FadeAnimation(
                          1.4,
                          Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Image.asset('assets/logo.png')),
                        ),
                      ),
                      SearchWidget(
                        searchControler: searchControler,
                        f: _search,
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GridView.builder(
                            itemCount: favorites ? charactersFav.length : characters.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              if (index >= characters.length - 1 && loadMore && !favorites) {
                                pageId++;
                                _carregarDados(context);
                                return Padding(
                                  padding: const EdgeInsets.all(55.0),
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return CardCharacter(
                                characterModel: favorites ? charactersFav[index] : characters[index],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ));
  }
}
