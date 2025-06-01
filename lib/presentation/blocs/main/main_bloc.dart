import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_event.dart';
import 'main_state.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/item.dart';
import '../../../domain/usecase/category/get_categories_usecase.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final GetCategoriesUsecase getCategoriesUsecase;

  MainBloc({required this.getCategoriesUsecase}) : super(MainInitial()) {
    on<LoadMainData>(_onLoadMainData);
    on<RefreshMainData>(_onRefreshMainData);
    on<SearchItems>(_onSearchItems);
  }

  Future<void> _onLoadMainData(
    LoadMainData event,
    Emitter<MainState> emit,
  ) async {
    emit(MainLoading());
    
    try {
      // 실제 카테고리 데이터 조회
      var categories = await getCategoriesUsecase();
      
      // 카테고리가 비어있으면 목 데이터 사용 (개발 시에만)
      if (categories.isEmpty) {
        categories = _getMockCategories();
      }
      
      final statistics = _getMockStatistics();
      
      emit(MainLoaded(
        categories: categories,
        todayItemsCount: statistics['today']!,
        incompleteItemsCount: statistics['incomplete']!,
        flaggedItemsCount: statistics['flagged']!,
        highPriorityItemsCount: statistics['highPriority']!,
      ));
    } catch (error) {
      emit(MainError(error.toString()));
    }
  }

  Future<void> _onRefreshMainData(
    RefreshMainData event,
    Emitter<MainState> emit,
  ) async {
    await _onLoadMainData(LoadMainData(), emit);
  }

  Future<void> _onSearchItems(
    SearchItems event,
    Emitter<MainState> emit,
  ) async {
    // TODO: Implement search functionality
    // This will be used for the search bar
    print('Searching for: ${event.query}');
  }

  // 기본 카테고리가 비어있을 때를 위한 목 데이터 (개발 시에만 사용)
  List<Category> _getMockCategories() {
    return [
      const Category(
        id: 1,
        name: '업무',
        description: '업무 관련 할일',
        color: '#FF5722',
        icon: 'work',
      ),
      const Category(
        id: 2,
        name: '개인',
        description: '개인적인 할일',
        color: '#2196F3',
        icon: 'person',
      ),
      const Category(
        id: 3,
        name: '쇼핑',
        description: '쇼핑 리스트',
        color: '#4CAF50',
        icon: 'shopping_cart',
      ),
      const Category(
        id: 4,
        name: '건강',
        description: '건강 관리',
        color: '#9C27B0',
        icon: 'fitness_center',
      ),
    ];
  }

  Map<String, int> _getMockStatistics() {
    return {
      'today': 5,
      'incomplete': 12,
      'flagged': 3,
      'highPriority': 7,
    };
  }
}
