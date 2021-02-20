import 'package:flutter/material.dart';
import 'package:starwiki/app/repository/character_repository.dart';
import 'package:starwiki/app/views/searchCharacterDetailsPage.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController _searchControler =TextEditingController();
  @override
  Widget build(BuildContext context) {
    CharacterRepository characterRepository = CharacterRepository();
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Center(
            child: Row(
          children: [
            Expanded(
              child: TextField(
                controller:  _searchControler,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    hintText: 'Pesquisar'),
              ),
            ),
            IconButton(icon: Icon(Icons.search), onPressed: () async {
              if (_searchControler.text.isNotEmpty || _searchControler.text != ''){
                final characters = await characterRepository.searchChararcter(_searchControler.text);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchDetailsPage(characters: characters,)));
              }
            }),
          ],
        )),
      ),
    );
  }
}
