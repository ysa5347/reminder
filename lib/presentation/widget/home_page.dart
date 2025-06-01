class _HomePageState extends State<HomePage> {
  // 유스케이스 인스턴스가 있어야겠죠
  final GetMostUrgentPendingItemUsecase getMostUrgentPendingItemUsecase = ...;

  @override
  void initState() {
    super.initState();
    refreshWidget();  // 화면 열릴 때 위젯 데이터 갱신 호출
  }

  Future<void> refreshWidget() async {
    final item = await getMostUrgentPendingItemUsecase.execute();
    if (item != null) {
      await updateHomeWidget(item.title, item.due ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // UI 구성
    );
  }
}
