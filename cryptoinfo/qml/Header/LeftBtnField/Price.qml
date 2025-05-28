import QtQuick 2.15
import QtQuick.Controls 2.15
import "qrc:/res/qml/Base" as Base

BtnField {
    clearClickedCB: (function() {
        price_model.clear_qml();
    })
    refreshClickedCB: (function() {
        price_model.refresh_qml();
    })
    search: (function(text) {
        price_model.search_and_view_at_beginning_qml(text);
    })
    visible: _homeIsChecked
}
