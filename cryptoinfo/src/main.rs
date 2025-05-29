#[macro_use]
extern crate lazy_static;

use log::debug;
use qmetaobject::prelude::*;
use qmetaobject::QUrl;
use std::io::Write;

mod config;
mod httpclient;
mod price;
mod qobjmgr;
mod res;
mod tool;
mod translator;
mod utility;
mod version;

#[tokio::main]
async fn main() {
    init_logger();

    debug!("{}", "start...");

    res::resource_init();
    let mut engine = QmlEngine::new();

    qobjmgr::init_app_dir();
    qobjmgr::init_utility(&mut engine);
    qobjmgr::init_config(&mut engine);
    qobjmgr::init_translator(&mut engine);
    qobjmgr::init_addrbook_model(&mut engine);
    qobjmgr::init_handbook_model(&mut engine);
    qobjmgr::init_fundbook_model(&mut engine);
    qobjmgr::init_bookmark_model(&mut engine);
    qobjmgr::init_note_model(&mut engine);
    qobjmgr::init_price_model(&mut engine);
    qobjmgr::init_price_addition(&mut engine);
    qobjmgr::init_contract_stats_model(&mut engine);

    engine.load_url(QUrl::from(QString::from("qrc:/res/qml/Main.qml")));
    engine.exec();

    // 保证UI部分先被析构
    drop(engine);

    debug!("{}", "exit...");
}

// 初始化日志
fn init_logger() {
    qmetaobject::log::init_qt_to_rust();
    env_logger::builder()
        .format(|buf, record| {
            let style = buf.default_level_style(record.level());
            let ts = chrono::Local::now().format("%m-%d %H:%M:%S");

            writeln!(
                buf,
                "[{} {style}{}{style:#} {} {}] {}",
                ts,
                record.level().to_string(),
                record
                    .file()
                    .unwrap_or("None")
                    .split('/')
                    .last()
                    .unwrap_or("None"),
                record.line().unwrap_or(0),
                record.args()
            )
        })
        .init();
}
