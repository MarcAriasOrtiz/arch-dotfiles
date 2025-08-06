// Based on https://github.com/Keyitdev/sddm-astronaut-theme
// Based on https://github.com/MarianArlt/sddm-sugar-dark

import QtQuick 2.15
import QtQuick.VirtualKeyboard 2.3

InputPanel {
    id: virtualKeyboard
    
    property bool activated: false
    active: activated && Qt.inputMethod.visible
    visible: active
}
