import 'dart:html';

import 'package:polymer/polymer.dart';

import 'package:paper_elements/paper_icon_button.dart';
import 'package:paper_elements/paper_input.dart';

import 'package:bwu_datagrid/datagrid/helpers.dart' show Column, GridOptions,
MapDataItem, MapDataItemProvider;
import 'package:bwu_datagrid/bwu_datagrid.dart' show BwuDatagrid;
import 'package:bwu_datagrid/formatters/formatters.dart' show CheckmarkFormatter;
import 'package:bwu_datagrid/editors/editors.dart' show CheckboxEditor,
IntegerEditor, TextEditor, Validator, ValidationResult, EditorArgs;
import 'package:bwu_datagrid/core/core.dart' show AddNewRow, ActiveCellChanged,
ItemBase, ValidationError;
import 'package:bwu_datagrid/plugins/row_selection_model.dart' show RowSelectionModel;

//import 'package:epimss_podo/reg.dart' show Email, EMAIL_FORM_EVENT;
//import 'package:epimss_shared/shared.dart' show toggleCoreCollapse, onBwuCellChangeHandler;
//import 'package:epimss_shared/validators.dart' show BwuRequiredEmailValidator,
//BwuRequiredNounValidator;

class BwuRequiredEmailValidator extends Validator {
  ValidationResult call(dynamic value) {
    if (value == null || (value is String && value.isNotEmpty && !value.contains('@'))) {
      return new ValidationResult(false, 'This is not a valid email address');
    } else {
      return new ValidationResult(true);
    }
  }
}

class BwuRequiredNounValidator extends Validator {
  ValidationResult call(dynamic value) {
    if (value == null || (value is String && value.isNotEmpty && new RegExp('[A-Z]+.*').firstMatch(value) != null)) {
      return new ValidationResult(false, 'The value must start with an upper case character');
    } else {
      return new ValidationResult(true);
    }
  }
}

//import 'package:jsonx/jsonx.dart';

class AddressEditor extends TextEditor {
  @override
  TextEditor newInstance(EditorArgs args) {
    return new AddressEditor._(args);
  }

  AddressEditor._(EditorArgs args) {
    this.args = args;
    $input = new TextInputElement()
      ..classes.add('editor-text');
    args.container.append($input);
    $input
      ..onKeyDown.listen((KeyboardEvent e) {
      if (e.keyCode == KeyCode.LEFT || e.keyCode == KeyCode.RIGHT) {
        e.stopImmediatePropagation();
      }
    })
      ..focus()
      ..select();
  }
}

class TypeEditor extends TextEditor {
  @override
  TextEditor newInstance(EditorArgs args) {
    return new AddressEditor._(args);
  }

  TypeEditor._(EditorArgs args) {
    this.args = args;
    $input = new TextInputElement()
      ..classes.add('editor-text');
    args.container.append($input);
    $input
      ..onKeyDown.listen((KeyboardEvent e) {
      if (e.keyCode == KeyCode.LEFT || e.keyCode == KeyCode.RIGHT) {
        e.stopImmediatePropagation();
      }
    })
      ..focus()
      ..select();
  }
}


@CustomTag('email-form')
class EmailForm extends PolymerElement {
//  @observable Email email = new Email();
  @observable String label = 'EMAIL';
  @observable String icon = 'communication:email';

  String errorMsg;
  String receiver = '';
  PaperIconButton addBtn;

  BwuDatagrid grid;
  MapDataItemProvider data = new MapDataItemProvider();
  MapDataItemProvider dataItemsProvider;
  List<MapDataItem> _dataItems = <MapDataItem>[];

  List<Column> columns = [
      new Column(name: "Type",
      id: "type",
      field: "type",
      editor: new TypeEditor(),
      validator: new BwuRequiredNounValidator(),
      sortable: true),

      new Column(name: "Address",
      id: "address",
      field: "address",
      editor: new AddressEditor(),
      validator: new BwuRequiredEmailValidator(),
      sortable: true,
      minWidth: 200),
  ];

  var gridOptions = new GridOptions(
      editable: true,
      enableAddRow: true,
      enableCellNavigation: true,
      asyncEditorLoading: false,
      autoEdit: false,
      forceFitColumns: true,
      autoHeight: false
  );

  EmailForm.created() : super.created();

  void toggle() {
//    toggleCoreCollapse($["core-collapse"]);
  }


  void validateInstance() {

//    ( email.isAddressValid && email.isTypeValid )
//    ? email.isValid = true
//    : email.isValid = false;
//
//
//    //print( encode ( email ) );
//
//    onBwuCellChangeHandler(email, _dataItems);

    //grid.onBwuValidationError.listen( validationErrorHandler );

    //errorMsg = validate( email, addBtn );
    //print( errorMsg );

    if (errorMsg == null /*&& email.isValid*/) {
      addBtn.icon = 'check-circle';
      addBtn.querySelector('* /deep/ #icon')
      .style
        ..setProperty('fill', 'green')
        ..setProperty('stroke', 'green')
        ..setProperty('stroke-width', '1px');
    }

    if (errorMsg != null) {
      label = errorMsg;
      addBtn.icon = 'warning';
      addBtn.querySelector('* /deep/ #icon')
      .style
        ..setProperty('fill', 'red')
        ..setProperty('stroke', 'white')
        ..setProperty('stroke-width', '1px');
    }


  }

  void validationErrorHandler(ValidationError e) {
    errorMsg = e.validationResults.message;
    var editor = e.editor;
    print('valResult valid |' + e.validationResults.isValid.toString());

    var result = e.validationResults;


    if (e.validationResults.isValid) {
      errorMsg = 'EMAIL';

    }
    else {
      errorMsg = result.message;
    }

    print(editor.runtimeType); // aslways print TextEditor

    if (editor != null) {
      //var colId = editor.column.id;

      if (editor is TextEditor)
        print('editor is TEXTEDITOR');

      if (editor is TypeEditor) {
        //email.isTypeValid = true;
        print(editor.runtimeType);

      }

      if (editor is AddressEditor) {
        //email.isAddressValid = false;
        print(editor.runtimeType);

      }

      //print( encode ( email ) );
    }
  }


  void publishInstance() {
//    if (email.isValid) {
//      email.list = _dataItems;
//
//      fire(EMAIL_FORM_EVENT,
//      detail: {
//          'email': email, 'receiver': receiver
//      });
//    }
  }

  @override
  void attached() {
    super.attached();
    addBtn = $[ 'add-btn' ];
    receiver = dataset['receiver'];

    try {
      grid = $['grid'];

      _dataItems
        ..add(
          new MapDataItem(
              {
                  'type': 'Home',
                  'address': ''
              }));

      dataItemsProvider = new MapDataItemProvider(_dataItems);

      grid.setup(
          dataProvider: dataItemsProvider,
          columns: columns,
          gridOptions: gridOptions)
      .then((_) {
        //grid.setSelectionModel = new CellSelectionModel();
        grid.setSelectionModel = new RowSelectionModel();
        grid.onBwuAddNewRow
        .listen(addnewRowHandler);
        grid.onBwuValidationError
        .listen(validationErrorHandler);
        grid.onBwuActiveCellChanged
        .listen(activeCellChangedHandler);
      });
    }
    on NoSuchMethodError
    catch (e) {
      print('$e\n\n${e.stackTrace}');
    }

    on RangeError catch (e) {
      print('$e\n\n${e.stackTrace}');
    }

    on TypeError
    catch (e) {
      print('$e\n\n${e.stackTrace}');
    }

    catch (e) {
      print('$e');
    }
  }

  void enableAutoEdit(MouseEvent e, dynamic details, HtmlElement target) {
    grid.setGridOptions =
    new GridOptions.unitialized()
      ..autoEdit = true;
  }

  void disableAutoEdit(MouseEvent e, dynamic details, HtmlElement target) {
    grid.setGridOptions =
    new GridOptions.unitialized()
      ..autoEdit = false;
  }

  void addnewRowHandler(AddNewRow e) {
    var item = e.item;
    grid.invalidateRow(dataItemsProvider.items.length);
    dataItemsProvider.items.add(item);
    grid.updateRowCount();
    grid.render();
  }


  void activeCellChangedHandler(ActiveCellChanged e) {
    errorMsg = null;
    validateInstance();
  }
}
