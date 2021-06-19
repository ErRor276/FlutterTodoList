import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/providers/todo_provider.dart';

class Searchbar extends HookWidget {
  const Searchbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final search = useProvider(searchProvider);

    final searchController = useTextEditingController();
    final searchFocusNode = useFocusNode();
    useListenable(searchFocusNode);
    final isFocused = searchFocusNode.hasFocus;

    return TextField(
      focusNode: searchFocusNode,
      controller: searchController,
      decoration: InputDecoration(
        labelText: 'Search',
        labelStyle: TextStyle(
          color: isFocused ? Theme.of(context).accentColor : Colors.black45,
        ),
        border: InputBorder.none,
        icon: Icon(
          Icons.search,
          color: isFocused ? Theme.of(context).accentColor : Colors.black45,
        ),
        focusColor: Theme.of(context).accentColor,
      ),
      cursorColor: Theme.of(context).accentColor,
      onChanged: (value) => search.state = value,
      onSubmitted: (value) {
        search.state = value;
        searchFocusNode.unfocus();
      },
    );
  }
}
