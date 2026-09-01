abstract class IDB {
  Future<void> init();
  Future<void> open(String path);
  Future<void> close();
}
