import 'package:appflowy_backend/protobuf/flowy-database/row_entities.pb.dart';
import 'package:flutter/foundation.dart';

import '../../../application/cell/cell_service.dart';
import '../../../application/row/row_cache.dart';
import '../../presentation/card/card_cell_builder.dart';

typedef OnCardChanged = void Function(CellByFieldId, RowsChangedReason);

class CardDataController extends BoardCellBuilderDelegate {
  final RowPB rowPB;
  final RowCache _rowCache;
  final List<VoidCallback> _onCardChangedListeners = [];

  CardDataController({
    required this.rowPB,
    required RowCache rowCache,
  }) : _rowCache = rowCache;

  CellByFieldId loadData() {
    return _rowCache.loadGridCells(rowPB.id);
  }

  void addListener({OnCardChanged? onRowChanged}) {
    _onCardChangedListeners.add(_rowCache.addListener(
      rowId: rowPB.id,
      onCellUpdated: onRowChanged,
    ));
  }

  void dispose() {
    for (final fn in _onCardChangedListeners) {
      _rowCache.removeRowListener(fn);
    }
  }

  @override
  CellCache get cellCache => _rowCache.cellCache;
}