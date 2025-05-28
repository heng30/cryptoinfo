use crate::config::Config;
use crate::price::{PriceAddition, PriceModel};
use crate::tool::{
    AddrBookModel, BookMarkModel, ContractStatsModel, FundBookModel, HandBookModel, NoteModel,
};
use crate::translator::Translator;
use crate::utility::Utility;
use log::warn;
use modeldata::{qcast_to, qcast_to_mut};
use platform_dirs::AppDirs;
use qmetaobject::QObjectPinned;
use qmetaobject::prelude::*;
use std::cell::RefCell;
use std::collections::HashMap;
use std::fs;
use std::sync::Mutex;

lazy_static! {
    static ref OBJMAP: Mutex<HashMap<NodeType, Node>> = Mutex::new(HashMap::new());
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub enum NodeType {
    Utility = 0,
    AppDir = 1,
    Config = 2,
    FundBookModel = 3,
    BookMarkModel = 4,
    ContractStatsModel = 5,
    Translator = 6,
    PriceAddition = 7,
    AddrBookModel = 8,
    HandBookModel = 9,
    PriceModel = 10,
    NoteModel = 11,
}

#[derive(Clone, Copy, Debug)]
struct Node {
    pub ptr: usize,
}

impl Node {
    fn new<T>(ptr: &T) -> Node {
        return Node {
            ptr: ptr as *const T as usize,
        };
    }
}

pub fn qobj<'a, T>(ntype: NodeType) -> &'a T {
    let ptr = OBJMAP.lock().unwrap().get(&ntype).unwrap().ptr;
    return qcast_to::<T>(ptr);
}

pub fn qobj_mut<'a, T>(ntype: NodeType) -> &'a mut T {
    let ptr = OBJMAP.lock().unwrap().get(&ntype).unwrap().ptr;
    return qcast_to_mut::<T>(ptr);
}

#[allow(unused)]
pub fn contain_obj(ntype: NodeType) -> bool {
    return OBJMAP.lock().unwrap().contains_key(&ntype);
}

pub fn init_app_dir() {
    let app_dirs = Box::new(RefCell::new(
        AppDirs::new(Some("cryptoinfo"), true).unwrap(),
    ));

    if fs::create_dir_all(&app_dirs.borrow().data_dir).is_err() {
        warn!("create {:?} failed!!!", &app_dirs.borrow().data_dir);
    }

    if fs::create_dir_all(app_dirs.borrow().data_dir.join("addrbook")).is_err() {
        warn!("create {:?} failed!!!", &app_dirs.borrow().data_dir);
    }

    if fs::create_dir_all(app_dirs.borrow().data_dir.join("notes")).is_err() {
        warn!("create {:?} failed!!!", &app_dirs.borrow().data_dir);
    }

    if fs::create_dir_all(&app_dirs.borrow().config_dir).is_err() {
        warn!("create {:?} failed!!!", &app_dirs.borrow().config_dir);
    }

    OBJMAP
        .lock()
        .unwrap()
        .insert(NodeType::AppDir, Node::new(&*(app_dirs.borrow())));

    Box::leak(app_dirs);
}

pub fn init_utility(engine: &mut QmlEngine) {
    let utility = Box::new(RefCell::new(Utility::default()));
    Utility::init_from_engine(engine, unsafe { QObjectPinned::new(&utility) });
    OBJMAP
        .lock()
        .unwrap()
        .insert(NodeType::Utility, Node::new(&*(utility.borrow())));
    Box::leak(utility);
}

// 加载配置文件
pub fn init_config(engine: &mut QmlEngine) {
    let config = Box::new(RefCell::new(Config::default()));
    Config::init_from_engine(engine, unsafe { QObjectPinned::new(&config) });
    config.borrow_mut().init();
    OBJMAP
        .lock()
        .unwrap()
        .insert(NodeType::Config, Node::new(&*(config.borrow())));
    Box::leak(config);
}

// 加载翻译文件
pub fn init_translator(engine: &mut QmlEngine) {
    let translator = Box::new(RefCell::new(Translator::default()));
    Translator::init_from_engine(engine, unsafe { QObjectPinned::new(&translator) });
    translator.borrow_mut().init();
    OBJMAP
        .lock()
        .unwrap()
        .insert(NodeType::Translator, Node::new(&*(translator.borrow())));
    Box::leak(translator);
}

pub fn init_addrbook_model(engine: &mut QmlEngine) {
    let model = Box::new(RefCell::new(AddrBookModel::default()));
    AddrBookModel::init_from_engine(
        engine,
        unsafe { QObjectPinned::new(&model) },
        "addrbook_model",
    );
    model.borrow_mut().init();

    OBJMAP
        .lock()
        .unwrap()
        .insert(NodeType::AddrBookModel, Node::new(&*(model.borrow())));

    Box::leak(model);
}

pub fn init_handbook_model(engine: &mut QmlEngine) {
    let model = Box::new(RefCell::new(HandBookModel::default()));
    HandBookModel::init_from_engine(
        engine,
        unsafe { QObjectPinned::new(&model) },
        "handbook_model",
    );
    model.borrow_mut().init();

    OBJMAP
        .lock()
        .unwrap()
        .insert(NodeType::HandBookModel, Node::new(&*(model.borrow())));
    Box::leak(model);
}

pub fn init_fundbook_model(engine: &mut QmlEngine) {
    let model = Box::new(RefCell::new(FundBookModel::default()));
    FundBookModel::init_from_engine(
        engine,
        unsafe { QObjectPinned::new(&model) },
        "fundbook_model",
    );
    model.borrow_mut().init();

    OBJMAP
        .lock()
        .unwrap()
        .insert(NodeType::FundBookModel, Node::new(&*(model.borrow())));
    Box::leak(model);
}

pub fn init_bookmark_model(engine: &mut QmlEngine) {
    let model = Box::new(RefCell::new(BookMarkModel::default()));
    BookMarkModel::init_from_engine(
        engine,
        unsafe { QObjectPinned::new(&model) },
        "bookmark_model",
    );
    model.borrow_mut().init();

    OBJMAP
        .lock()
        .unwrap()
        .insert(NodeType::BookMarkModel, Node::new(&*(model.borrow())));
    Box::leak(model);
}

// 加载笔记
pub fn init_note_model(engine: &mut QmlEngine) {
    let model = Box::new(RefCell::new(NoteModel::default()));
    NoteModel::init_from_engine(engine, unsafe { QObjectPinned::new(&model) }, "note_model");
    model.borrow_mut().init();
    OBJMAP
        .lock()
        .unwrap()
        .insert(NodeType::NoteModel, Node::new(&*(model.borrow())));
    Box::leak(model);
}

// 价格面板
pub fn init_price_model(engine: &mut QmlEngine) {
    let model = Box::new(RefCell::new(PriceModel::default()));
    PriceModel::init_from_engine(engine, unsafe { QObjectPinned::new(&model) }, "price_model");
    model.borrow_mut().init();
    OBJMAP
        .lock()
        .unwrap()
        .insert(NodeType::PriceModel, Node::new(&*(model.borrow())));
    Box::leak(model);
}

// 贪婪指数和时间（面板头信息)
pub fn init_price_addition(engine: &mut QmlEngine) {
    let price_addition = Box::new(RefCell::new(PriceAddition::default()));
    PriceAddition::init_from_engine(engine, unsafe { QObjectPinned::new(&price_addition) });

    price_addition.borrow_mut().init();
    OBJMAP.lock().unwrap().insert(
        NodeType::PriceAddition,
        Node::new(&*(price_addition.borrow())),
    );
    Box::leak(price_addition);
}

pub fn init_contract_stats_model(engine: &mut QmlEngine) {
    let model = Box::new(RefCell::new(ContractStatsModel::default()));
    ContractStatsModel::init_from_engine(
        engine,
        unsafe { QObjectPinned::new(&model) },
        "contract_stats_model",
    );
    model.borrow_mut().init();

    OBJMAP
        .lock()
        .unwrap()
        .insert(NodeType::ContractStatsModel, Node::new(&*(model.borrow())));
    Box::leak(model);
}
