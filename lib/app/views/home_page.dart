import 'package:flutter/material.dart';
import 'package:starwiki/app/components/card_character.dart';
import 'package:starwiki/app/components/loading_widget.dart';
import 'package:starwiki/app/components/search_widget.dart';
import 'package:starwiki/app/models/character_model.dart';
import 'package:starwiki/app/repository/character_repository.dart';
import 'package:starwiki/app/repository/db_util.dart';
import 'package:starwiki/app/views/fav_page.dart';
import 'package:starwiki/app/views/search_Character_Details_Page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchControler = TextEditingController();
  int pageId = 8;
  bool loadMore = true;
  List<CharacterModel> characters = [];
  bool carregado = false;
  CharacterRepository characterRepository = CharacterRepository();

  Future _carregarDados() async {
    try {
      var newCharacter =
          await characterRepository.fetchChararcterByPage(pageId);
      if (newCharacter.isEmpty) {
        loadMore = false;
      }
      characters.addAll(newCharacter);
      setState(() {});
    } catch (e) {
      var favoritesListFromDB = await DBUtil.getData('characters');
      if (favoritesListFromDB.isNotEmpty)
        characters = favoritesListFromDB
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
            .toList();
      loadMore = false;
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Verify your internet conection'),
      ));
    }
  }

  _search() async {
    if (searchControler.text.isNotEmpty || searchControler.text != '') {
      carregado = false;
      setState(() {});
      try {
        final characters =
            await characterRepository.searchChararcter(searchControler.text);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SearchDetailsPage(
                  characters: characters,
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
    _carregarDados().then((_) {
      setState(() {
        carregado = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => FavPage()));
              },
              child: Row(
                children: [
                  Icon(Icons.favorite_border),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Favoritos'),
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
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Image.asset('assets/logo.png')),
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
                            itemCount: characters.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              if (index >= characters.length - 1 && loadMore) {
                                pageId++;
                                _carregarDados();
                                return Padding(
                                  padding: const EdgeInsets.all(55.0),
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return CardCharacter(
                                characterModel: characters[index],
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
