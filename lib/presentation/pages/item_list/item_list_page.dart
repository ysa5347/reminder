import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/item_list/item_list_bloc.dart';
import '../../blocs/item_list/item_list_event.dart';
import '../../blocs/category/category_bloc.dart';
import 'view/item_list_view.dart';
import '../../../core/injection_container.dart';

class ItemListPage extends StatelessWidget {
  final String type;
  final int? categoryId;
  final String? categoryName;
  final String? searchQuery;

  const ItemListPage({
    Key? key,
    required this.type,
    this.categoryId,
    this.categoryName,
    this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ItemListBloc>(
          create: (context) => getIt<ItemListBloc>()
            ..add(searchQuery != null
                ? SearchItemsEvent(searchQuery!)
                : LoadItemsByType(
                    type: type,
                    categoryId: categoryId,
                    categoryName: categoryName,
                  )),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => getIt<CategoryBloc>(),
        ),
      ],
      child: ItemListView(
        type: type,
        categoryId: categoryId,
        categoryName: categoryName,
        searchQuery: searchQuery,
      ),
    );
  }
}
