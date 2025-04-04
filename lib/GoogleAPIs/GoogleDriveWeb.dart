import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class GoogleDriveWeb {
  final _credentials = ServiceAccountCredentials.fromJson({
    "type": "service_account",
    "project_id": "pb-security-system-b3f0a",
    "private_key_id": "b2ba460d4c123e68ef47dc82707b6a39ebfc10f6",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDipeCy5YkHybWE\n4d7IfRoklz75AQ9SVM4M/wFbIqAUCGTAoqO7X0gDFFCZkBOexyLC4nFr6xvdX5MZ\nDiLBSCyfaeXClse+F+A5LZsLKcKrkxeKrtBR9mEQlTkSH1PG8TIDeFFFYD0ZYsvw\nMMD/3r0MPsIOaXHGrtq13frYcLxpnw+bkZinU5f0sZ8RRzLfykHcJP4sbrEMdNRT\n2wkH7PrAbk8kAtLvdtAsHXNMjyw//oygPCdHnm3wy1W89EX/I4yXWMVS0Iy9pc5h\nUTzWlHXKzZIcppditnjTUMLxQR4vsjldvlBffUyCPBXWwBm99g94Nn6FNorpoIlN\nbYRua9ePAgMBAAECggEAH6QIUaFBYeYdzQPFWMLnlpUgyZ1aw2PVx4hawEYosoiW\nHDMjCCJIni7ErnN9MbeGLvkdhsiHQX6OvWWKTOZjswuTHk5zayJ6fzD9NJqWCTgw\nhgAFUslCYBDHq16BO8Q/TFm3KtLBJN1J2unLf80GIlf+j7QrxJDI4AaHIZaMzx0O\nGvzYXaICkkjNl4rNH/XWMTW2gwbfC9/Oodb1dmX6DHmK2avXhsPKZJonsOuXg08I\ndhrIHkJeqxyZPhCqLvGKcNNlT9hamX3aZw4WTDk6QKN+SbapVHC5aOJexxVR7Reu\nbC/iRa0L7ZW7BZVPblHRQ3nZfLQXvcX+depgczNhSQKBgQD38Yh1MgJ01Van1dD/\nXpnPTS+X4oKW9mcaEaYK2lN2aV5+ADktKIVoR4Gc+M9HjCp7JAKag/ID8hK9PR5t\nD/Glr0/09x8hh00DMsJbzOskYRyFKkQ8QF/uh/QT69/vBIs6C/odcf0afHc9pJJh\nsk8QhTU/SvsXcw6BrNFkN5SJBwKBgQDqAzPEOzRbpjPUMgkED4v30xInIS+HVaTS\nuA3xKWnhnXVqQhXchxY7u6+F0xiE+CRXjeui1KTk2EEPxZRuUMkJyu82Xnj0j1FD\n4kFMITrResRWAzmvUg2NV1uhPxne22sY5b43hQHdRR9Bp+EgRRu/ZsuNlf4fodE8\nfXdMNP/DOQKBgQDf9C7JjM5jMYAAQUVyJMTRVmqyykoiiZY/Gcnc66+PuUU8kn8S\npxM5Sb1tR+ASRCzq5W/kmWG05qa+f8JHyKsAeQXDwqM/6bJKPUMJIGMUjRLxxWe0\n9ICyN+LjS58NihEn8UGN7zQrBFnAODJwRFreFTQvY07Bs49a2fqYhwuHaQKBgCYP\nXUUGKA7b6kQR2zuI18f30VUB5bwKJuOKweG+TZU/SdB9bRbP9cLDVNncKnm97hM7\nZt613RfHQFWzWd/TTc9E7UEXfm6wPJRg4SPjp7BYWkRvA9vK6Z9aXPHN1IRVhYao\nHxbikBoP2vSPvGLGOqwXqPWfNpSoeeJvuY5wdESpAoGBANruXprMigFr+yNbZExf\ncptzBNveh5x5ZzGvBxwePdRF4tIXI8ZUxwQ2KbWW91ESah958CZg6e5L9RMKe2Ty\nRr2bGF7O6hWDBXnf6fuDijxUaOJRseAA0zPbLlKOVTv3XMWCNMF2aSYC5FTyrGLZ\n7H3Wgv/mlhMCwfKvVgKNELim\n-----END PRIVATE KEY-----\n",
    "client_email": "firebase-adminsdk-gwryx@pb-security-system-b3f0a.iam.gserviceaccount.com",
    "client_id": "107350847642804765683",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-gwryx%40pb-security-system-b3f0a.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  });

  final _scopes = [drive.DriveApi.driveScope];

  Future<List<String>> getGoogleDriveFilesUrlWeb(
      List<XFile> files, String? folderID) async {
    try {
      final client = await clientViaServiceAccount(_credentials, _scopes);
      var driveApi = drive.DriveApi(client);

      // Create a list to hold the futures
      List<Future<String>> futures = [];

      for (var pickedFile in files) {
        // Create a future for each file upload
        futures.add(() async {
          final file = drive.File();
          file.name = pickedFile.name;
          file.parents = [folderID!];

          Uint8List fileBytes;

          // For web, use http package to read the file bytes
          final response = await http.get(Uri.parse(pickedFile.path));
          fileBytes = response.bodyBytes;

          // Convert fileBytes to a Stream<List<int>>
          Stream<List<int>> fileByteStream = Stream.fromIterable([fileBytes]);

          final result = await driveApi.files.create(
            file,
            uploadMedia: drive.Media(fileByteStream, fileBytes.length),
          );

          // Return the file's webContentLink
          return result.id!;
        }());
      }

      // Wait for all futures to complete and return the results
      return await Future.wait(futures);
    } catch (e) {
      print('An error occurred: $e');
      rethrow;
    }
  }
}
