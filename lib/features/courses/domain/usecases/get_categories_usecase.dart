import '../../../../core/network/models/paginated_data.dart';
import '../../data/models/category_model.dart';
import '../repositories/courses_repository.dart';

class GetCategoriesUseCase {
  final CoursesRepository _repository;

  GetCategoriesUseCase(this._repository);

  Future<PaginatedData<CategoryModel>> call({
    String? search,
    int? perPage,
    int? page,
  }) async {
    return await _repository.getCategories(
      search: search,
      perPage: perPage,
      page: page,
    );
  }
}
