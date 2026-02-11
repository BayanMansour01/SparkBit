import '../../../../core/network/models/paginated_data.dart';
import '../../data/models/sub_category_model.dart';
import '../repositories/courses_repository.dart';

class GetSubCategoriesUseCase {
  final CoursesRepository _repository;

  GetSubCategoriesUseCase(this._repository);

  Future<PaginatedData<SubCategoryModel>> call({
    int? categoryId,
    String? search,
    int? perPage,
    int? page,
  }) async {
    return await _repository.getSubCategories(
      categoryId: categoryId,
      search: search,
      perPage: perPage,
      page: page,
    );
  }
}
