/// Enumerates the available routes in the app.
///
/// Each route is associated with a specific path.
enum Routes {
  login('/login'),
  home('/home'),
  helloWorld('/hello-world'),
  map('/map'),
  timer('/timer'),
  viewSampleGpsData('/view-sample-gps-data'),
  antennaSystem('/antenna-system'),
  antennaDebug('/antenna-debug'),
  antennaControl('/antenna-control'),
  dashboard('/'),
  data('/data'),
  groups('/groups'),
  groupDetails('/groups/:id'),
  groupSessionDetails('/groups/:id/:sessionId'),
  groupsCreate('/groups/create'),
  groupsEdit('/groups/:id/edit'),
  athletes('/athletes'),
  athleteDetails('/athletes/:id'),
  athletesCreate('/athletes/create'),
  athletesEdit('/athletes/:id/edit'),
  reports('/reports'),
  liveSession('/live-session'),
  sessions('/sessions'),
  sessionDetails('/sessions/:id'),
  videoExport('/video-export'),
  alerts('/alerts'),
  settings('/settings');

  /// The path associated with the route.
  final String path;

  const Routes(this.path);
}
