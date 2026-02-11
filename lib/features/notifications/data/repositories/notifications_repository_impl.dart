import '../../../../core/network/api/student_api.dart';
import '../../../../core/network/models/paginated_data.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../../data/models/notification_model.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final StudentApi _api;

  NotificationsRepositoryImpl(this._api);

  @override
  Future<PaginatedData<NotificationModel>> getNotifications({int page = 1}) {
    return _api.getNotifications(page: page);
  }

  @override
  Future<int> getUnreadCount() {
    return _api.getUnreadCount();
  }
}
