import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController _searchControler =TextEditingController();
  @override
  Widget build(BuildContext context) {
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
            IconButton(icon: Icon(Icons.search), onPressed: () {
              
            }),
          ],
        )),
      ),
    );
  }
}
