enum StateType {
  idle,
  pendingCommandMode,
  commandMode,
  pendingSetConfig,
  setConfig,
  pendingGetConfig,
  getConfig,
  pendingLiveMode,
  liveMode,
  error,
  calibration,
}