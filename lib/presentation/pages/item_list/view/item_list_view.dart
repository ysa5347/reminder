import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/item_list/item_list_bloc.dart';
import '../../../blocs/item_list/item_list_state.dart';
import '../../../blocs/item_list/item_list_event.dart';
import '../../../blocs/category/category_bloc.dart';
import '../../../blocs/category/category_event.dart';
import '../../../widgets/item_detail_bottom_sheet.dart';
import '../../../../domain/entities/item.dart';

class ItemListView extends StatefulWidget {
  final String type;
  final int? categoryId;
  final String? categoryName;
  final String? searchQuery;

  const ItemListView({
    Key? key,
    required this.type,
    this.categoryId,
    this.categoryName,
    this.searchQuery,
  }) : super(key: key);

  @override
  State<ItemListView> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery ?? '';
    
    // Load categories for the bottom sheet
    context.read<CategoryBloc>().add(LoadCategories());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: false,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: '할 일 검색...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  onChanged: (value) {
                    if (value.trim().isNotEmpty) {
                      context.read<ItemListBloc>().add(SearchItemsEvent(value));
                    } else {
                      context.read<ItemListBloc>().add(LoadItemsByType(
                        type: widget.type,
                        categoryId: widget.categoryId,
                        categoryName: widget.categoryName,
                      ));
                    }
                  },
                ),
              ),
            ),
          ];
        },
        body: BlocConsumer<ItemListBloc, ItemListState>(
          listener: (context, state) {
            if (state is ItemListError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ItemListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ItemListError) {
              return _buildErrorView(context, state.message);
            } else if (state is ItemListLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ItemListBloc>().add(const RefreshItemList());
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // Heading
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          state.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    
                    // Item List
                    _buildItemList(context, state),
                    
                    // Add new item area
                    SliverToBoxAdapter(
                      child: _buildAddItemArea(context),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('오류가 발생했습니다: $message'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ItemListBloc>().add(const RefreshItemList());
            },
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  Widget _buildItemList(BuildContext context, ItemListLoaded state) {
    if (state.items.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                state.searchQuery != null ? '검색 결과가 없습니다' : '아이템이 없습니다',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '새 아이템을 추가해보세요',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = state.items[index];
          return _buildItemCard(context, item);
        },
        childCount: state.items.length,
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, Item item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: GestureDetector(
          onTap: () {
            context.read<ItemListBloc>().add(ToggleItemCompletion(item));
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: item.flag == 1 ? Colors.green : Colors.grey,
                width: 2,
              ),
              color: item.flag == 1 ? Colors.green : Colors.transparent,
            ),
            child: item.flag == 1
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
        title: GestureDetector(
          onTap: () {
            _showItemDetailBottomSheet(context, item);
          },
          child: Text(
            item.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: item.flag == 1 ? Colors.grey[500] : Colors.black87,
              decoration: item.flag == 1 ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
        subtitle: _buildItemSubtitle(item),
        trailing: IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.grey),
          onPressed: () {
            _showItemDetailBottomSheet(context, item);
          },
        ),
      ),
    );
  }

  Widget? _buildItemSubtitle(Item item) {
    final List<Widget> subtitleWidgets = [];
    
    // Add description if exists
    if (item.description != null && item.description!.isNotEmpty) {
      subtitleWidgets.add(
        Text(
          item.description!,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
    
    // Add due date and priority info
    final List<Widget> infoWidgets = [];
    
    if (item.due != null) {
      infoWidgets.addAll([
        Icon(
          Icons.schedule,
          size: 16,
          color: Colors.grey[500],
        ),
        const SizedBox(width: 4),
        Text(
          _formatDueDate(item.due!),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ]);
    }
    
    if (item.priority != 3) {
      if (infoWidgets.isNotEmpty) {
        infoWidgets.add(const SizedBox(width: 12));
      }
      infoWidgets.addAll([
        Icon(
          Icons.priority_high,
          size: 16,
          color: _getPriorityColor(item.priority),
        ),
        const SizedBox(width: 4),
        Text(
          '우선순위 ${item.priority}',
          style: TextStyle(
            fontSize: 12,
            color: _getPriorityColor(item.priority),
          ),
        ),
      ]);
    }
    
    if (infoWidgets.isNotEmpty) {
      if (subtitleWidgets.isNotEmpty) {
        subtitleWidgets.add(const SizedBox(height: 4));
      }
      subtitleWidgets.add(
        Row(children: infoWidgets),
      );
    }
    
    if (subtitleWidgets.isEmpty) return null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: subtitleWidgets,
    );
  }

  Widget _buildAddItemArea(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _createNewItem(context);
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              '새 아이템 추가',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createNewItem(BuildContext context) {
    // 빈 아이템을 생성하지 않고 바로 상세 편집 화면으로 이동
    _showItemDetailBottomSheet(context, null);
  }

  void _showItemDetailBottomSheet(BuildContext context, Item? item) {
    final itemListBloc = context.read<ItemListBloc>();
    final categoryBloc = context.read<CategoryBloc>();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: itemListBloc),
          BlocProvider.value(value: categoryBloc),
        ],
        child: ItemDetailBottomSheet(
          item: item,
          onSave: (item) {
            if (item.id == null) {
              // New item
              if (item.title.trim().isNotEmpty) {
                itemListBloc.add(AddNewItem(item));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('아이템이 추가되었습니다.'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } else {
              // Update existing item
              itemListBloc.add(UpdateItemEvent(item));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('아이템이 수정되었습니다.'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  String _formatDueDate(String dueString) {
    try {
      final parts = dueString.split('_');
      if (parts.length >= 5) {
        final year = parts[0];
        final month = parts[1];
        final day = parts[2];
        final hour = parts[3];
        final minute = parts[4];
        
        return '$year-$month-$day $hour:$minute';
      }
    } catch (e) {
      // ignore
    }
    return dueString;
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.green;
      case 5:
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }
}


