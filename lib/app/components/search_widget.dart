import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final Function f;
  final TextEditingController searchControler;
  const SearchWidget({Key key, this.searchControler, this.f}) : super(key: key);
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
                controller:  searchControler,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    hintText: '  Search'),
              ),
            ),
            IconButton(icon: Icon(Icons.search), onPressed: f),
          ],
        )),
      ),
    );
  }
}
