import 'package:flutter_bloc/flutter_bloc.dart';
import 'category_event.dart';
import 'category_state.dart';
import '../../../domain/usecase/category/get_categories_usecase.dart';
import '../../../domain/usecase/category/save_category_usecase.dart';
import '../../../domain/usecase/category/update_category_usecase.dart';
import '../../../domain/usecase/category/delete_category_usecase.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUsecase getCategoriesUsecase;
  final SaveCategoryUsecase saveCategoryUsecase;
  final UpdateCategoryUsecase updateCategoryUsecase;
  final DeleteCategoryUsecase deleteCategoryUsecase;

  CategoryBloc({
    required this.getCategoriesUsecase,
    required this.saveCategoryUsecase,
    required this.updateCategoryUsecase,
    required this.deleteCategoryUsecase,
  }) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<RefreshCategories>(_onRefreshCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    
    try {
      final categories = await getCategoriesUsecase();
      emit(CategoryLoaded(categories));
    } catch (error) {
      emit(CategoryError(error.toString()));
    }
  }

  Future<void> _onAddCategory(
    AddCategory event,
    Emitter<CategoryState> emit,
  ) async {
    print('CategoryBloc: Adding category: ${event.category.name}');
    try {
      final savedCategory = await saveCategoryUsecase(event.category);
      print('CategoryBloc: Category saved successfully: ${savedCategory.name}');
      emit(const CategoryOperationSuccess('카테고리가 추가되었습니다.'));
      add(LoadCategories()); // 목록 새로고침
    } catch (error) {
      print('CategoryBloc: Error adding category: $error');
      emit(CategoryError('카테고리 추가 실패: ${error.toString()}'));
    }
  }

  Future<void> _onUpdateCategory(
    UpdateCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      await updateCategoryUsecase(event.category);
      emit(const CategoryOperationSuccess('카테고리가 수정되었습니다.'));
      add(LoadCategories()); // 목록 새로고침
    } catch (error) {
      emit(CategoryError('카테고리 수정 실패: ${error.toString()}'));
    }
  }

  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      await deleteCategoryUsecase(event.categoryId);
      emit(const CategoryOperationSuccess('카테고리가 삭제되었습니다.'));
      add(LoadCategories()); // 목록 새로고침
    } catch (error) {
      emit(CategoryError('카테고리 삭제 실패: ${error.toString()}'));
    }
  }

  Future<void> _onRefreshCategories(
    RefreshCategories event,
    Emitter<CategoryState> emit,
  ) async {
    add(LoadCategories());
  }
}
