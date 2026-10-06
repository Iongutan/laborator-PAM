import 'package:flutter_bloc/flutter_bloc.dart';

/// Id-urile programelor favorite. E global (la nivelul aplicației),
/// ca inima să fie sincronizată pe toate ecranele.
class FavoritesCubit extends Cubit<Set<String>> {
  FavoritesCubit() : super(const <String>{});

  bool isFavorite(String id) => state.contains(id);

  void toggle(String id) {
    final Set<String> next = Set<String>.of(state);
    if (!next.remove(id)) next.add(id);
    emit(Set<String>.unmodifiable(next));
  }
}
