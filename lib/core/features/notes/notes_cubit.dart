import 'package:bloc/bloc.dart';
import 'package:boru_crm/core/features/notes/repository/notes_repository.dart';
import 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final NoteRepository _repository;

  NotesCubit(this._repository) : super(NotesInitial());

  Future<void> loadNotes(String customerId) async {
    emit(NotesLoading());
    try {
      final notes = await _repository.fetchNotesForCustomer(customerId);
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> addNote(String customerId, String content) async {
    try {
      await _repository.addNote(customerId, content);
      await loadNotes(customerId);
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }
}
