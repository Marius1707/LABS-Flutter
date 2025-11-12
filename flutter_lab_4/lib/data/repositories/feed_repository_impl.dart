import '../services/api_service.dart';

class FeedRepositoryImpl {
  final ApiService apiService;

  FeedRepositoryImpl(this.apiService);

  Future<Map<String, dynamic>> getFeedData() async {
    return await apiService.getFeed();
  }

  Future<Map<String, dynamic>> getDoctorDetailsData() async {
    return await apiService.getDoctorDetails();
  }
}
