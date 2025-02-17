String convertGoogleDriveLink(String sharedLink) {
  final regex = RegExp(r'd/([a-zA-Z0-9_-]+)/');
  final match = regex.firstMatch(sharedLink);

  if (match != null && match.groupCount > 0) {
    final fileId = match.group(1);
    return 'https://drive.google.com/uc?export=view&id=$fileId';
  }
  // Si no es un enlace de Google Drive, devuelve el mismo enlace original
  return sharedLink;
}