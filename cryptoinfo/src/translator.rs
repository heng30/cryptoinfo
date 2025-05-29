use crate::config::Config;
use crate::qobjmgr::{qobj_mut, NodeType as QNodeType};
use qmetaobject::*;
use std::collections::HashMap;

#[derive(QObject, Default)]
pub struct Translator {
    base: qt_base_class!(trait QObject),
    lang_map: HashMap<String, String>,
    use_chinese: qt_property!(bool),
    tr: qt_method!(fn(&mut self, text: QString) -> QString),
}

impl Translator {
    pub fn init_from_engine(engine: &mut QmlEngine, translator: QObjectPinned<Translator>) {
        engine.set_object_property("translator".into(), translator);
    }

    pub fn init(&mut self) {
        let config = qobj_mut::<Config>(QNodeType::Config);
        self.use_chinese = config.use_chinese;

        // TODO: add translations
        // self.lang_map.insert();
    }

    pub fn tr(&self, text: QString) -> QString {
        if self.use_chinese {
            return text;
        }
        if let Some(value) = self.lang_map.get(&text.to_string()) {
            return value.to_string().into();
        }
        return text;
    }
}
