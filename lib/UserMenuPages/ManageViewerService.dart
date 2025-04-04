// lib/UserMenuPages/manage_Viewer_service.dart

class ManageViewerService {
  // This function retrieves the specific data for a security guard based on their name.
  Future<Map<String, dynamic>> retrieveSpecificSecurityGuardRow(
      String name) async {
    // Here you would typically perform an API call or database query.
    // For demonstration purposes, we'll return mock data.
    return {
      'Name': name, // The name of the security guard.
      'VMS Report Status':
          true, // Status indicating if the VMS report is available.
      // You can add more report statuses or relevant data as needed.
    };
  }

// Add any other necessary methods related to viewer management
}
