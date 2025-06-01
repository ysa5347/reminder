import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/main/main_bloc.dart';
import '../../../blocs/main/main_state.dart';
import '../../../blocs/main/main_event.dart';
import '../../../../domain/entities/category.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
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
                    context.read<MainBloc>().add(SearchItems(value));
                  },
                ),
              ),
            ),
          ];
        },
        body: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            if (state is MainLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MainError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('오류가 발생했습니다: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MainBloc>().add(RefreshMainData());
                      },
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              );
            } else if (state is MainLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<MainBloc>().add(RefreshMainData());
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatisticsSection(context, state),
                      const SizedBox(height: 24),
                      _buildCategoriesSection(context, state.categories),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(BuildContext context, MainLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        const Text(
          '통계',
          style: TextStyle( 
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          padding: EdgeInsets.zero,
          children: [
            _buildStatCard(
              context,
              title: '오늘 할 일',
              count: state.todayItemsCount,
              icon: Icons.today,
              color: Colors.blue,
              onTap: () => _navigateToItemList(context, 'today'),
            ),
            _buildStatCard(
              context,
              title: '미완료',
              count: state.incompleteItemsCount,
              icon: Icons.pending_actions,
              color: Colors.orange,
              onTap: () => _navigateToItemList(context, 'incomplete'),
            ),
            _buildStatCard(
              context,
              title: '중요 표시',
              count: state.flaggedItemsCount,
              icon: Icons.flag,
              color: Colors.red,
              onTap: () => _navigateToItemList(context, 'flagged'),
            ),
            _buildStatCard(
              context,
              title: '높은 우선순위',
              count: state.highPriorityItemsCount,
              icon: Icons.priority_high,
              color: Colors.purple,
              onTap: () => _navigateToItemList(context, 'highPriority'),
            ),
          ],
        ),
      ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                  Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context, List<Category> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '카테고리',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(context, category);
          },
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category) {
    final color = _parseColor(category.color ?? '#2196F3');
    final iconData = _parseIcon(category.icon ?? 'category');

    return GestureDetector(
      onTap: () => _navigateToCategoryItems(context, category),
      child: Container(
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
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              iconData,
              color: color,
              size: 24,
            ),
          ),
          title: Text(
            category.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          subtitle: category.description != null
              ? Text(
                  category.description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                )
              : null,
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  IconData _parseIcon(String iconString) {
    switch (iconString) {
      case 'work':
        return Icons.work;
      case 'person':
        return Icons.person;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'fitness_center':
        return Icons.fitness_center;
      default:
        return Icons.category;
    }
  }

  void _navigateToItemList(BuildContext context, String type) {
    // TODO: Implement navigation to item list page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$type 항목 리스트로 이동 (구현 예정)')),
    );
  }

  void _navigateToCategoryItems(BuildContext context, Category category) {
    // TODO: Implement navigation to category items page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${category.name} 카테고리로 이동 (구현 예정)')),
    );
  }
}
