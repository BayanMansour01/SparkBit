import '../../../../core/network/models/paginated_data.dart';
import '../../data/models/notification_model.dart';

abstract class NotificationsRepository {
  Future<PaginatedData<NotificationModel>> getNotifications({int page = 1});
  Future<int> getUnreadCount();
}
