import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'edit_event.dart';
import 'edit_state.dart';

class EditBloc extends Bloc<EditEvent, EditState>{

  @override
  // TODO: implement initialState
  EditState get initialState => null;

  @override
  Stream<EditState> mapEventToState(EditEvent event) {
    // TODO: implement mapEventToState
    if(event is InsertData){

    }
  }
}
