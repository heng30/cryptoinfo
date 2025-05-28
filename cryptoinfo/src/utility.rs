use crate::version;
use ::log::{debug, warn};
use chrono::{FixedOffset, Local, TimeZone};
use clipboard::ClipboardContext;
use clipboard::ClipboardProvider;
use fs_extra::dir::{CopyOptions, copy as dir_copy, remove as dir_remove};
use qmetaobject::*;
use std::fs;
use std::path::Path;
use std::process::Command;

#[derive(QObject, Default)]
pub struct Utility {
    base: qt_base_class!(trait QObject),

    local_time_now_qml: qt_method!(fn(&mut self, format: QString) -> QString),
    get_time_from_utc_seconds_qml: qt_method!(fn(&self, sec: i64) -> QString),
    utc_seconds_to_local_string_qml: qt_method!(fn(&self, sec: i64, format: QString) -> QString),
    copy_to_clipboard_qml: qt_method!(fn(&self, text: QString) -> bool),

    move_file_qml: qt_method!(fn(&self, src: QString, dst: QString) -> bool),
    move_files_qml: qt_method!(fn(&self, src_dir: QString, dst_dir: QString) -> bool),
    remove_dir_qml: qt_method!(fn(&self, dir: QString) -> bool),

    copy_dir_qml: qt_method!(fn(&self, src_dir: QString, dst_dir: QString) -> bool),
    exit_qml: qt_method!(fn(&self, code: i32)),
    process_cmd_qml: qt_method!(fn(&self, cmd: QString, args: QString) -> bool),
    app_version_qml: qt_method!(fn(&self) -> QString),
}

impl Utility {
    pub fn init_from_engine(engine: &mut QmlEngine, utility: QObjectPinned<Utility>) {
        engine.set_object_property("utility".into(), utility);
    }

    pub fn local_time_now(format: &str) -> String {
        return Local::now().format(format).to_string();
    }

    #[allow(unused)]
    pub fn utc_seconds_to_local_string(sec: i64, format: &str) -> String {
        let time = FixedOffset::east_opt(8 * 3600)
            .unwrap()
            .timestamp_opt(sec, 0)
            .unwrap();
        return format!("{}", time.format(format));
    }

    pub fn local_time_now_qml(&mut self, format: QString) -> QString {
        return Local::now()
            .format(format.to_string().as_str())
            .to_string()
            .into();
    }

    pub fn get_time_from_utc_seconds_qml(&self, sec: i64) -> QString {
        let time = FixedOffset::east_opt(8 * 3600)
            .unwrap()
            .timestamp_opt(sec, 0)
            .unwrap();
        return format!("{}", time.format("%Y-%m-%d %H:%M")).into();
    }

    // "%y-%m-%d %H:%M"
    pub fn utc_seconds_to_local_string_qml(&self, sec: i64, format: QString) -> QString {
        let time = FixedOffset::east_opt(8 * 3600)
            .unwrap()
            .timestamp_opt(sec, 0)
            .unwrap();
        return format!("{}", time.format(format.to_string().as_ref())).into();
    }

    pub fn copy_to_clipboard_qml(&self, text: QString) -> bool {
        let ctx: Result<ClipboardContext, _> = ClipboardProvider::new();
        if ctx.is_err() {
            return false;
        }
        let mut ctx = ctx.unwrap();
        if let Err(e) = ctx.set_contents(text.to_string()) {
            debug!("copy to clipboard error: {:?}", e);
            return false;
        }

        return true;
    }

    pub fn move_file_qml(&self, src: QString, dst: QString) -> bool {
        return fs::rename(src.to_string(), dst.to_string()).is_ok();
    }

    pub fn remove_dir_qml(&self, dir: QString) -> bool {
        dir_remove(&dir.to_string()).is_ok()
    }

    pub fn copy_dir_qml(&self, src_dir: QString, dst_dir: QString) -> bool {
        let s_dir = src_dir.to_string();
        let s_dir = Path::new(&s_dir);
        let d_dir = dst_dir.to_string();
        let d_dir = Path::new(&d_dir);

        if !d_dir.exists() && fs::create_dir_all(&d_dir).is_err() {
            return false;
        }
        let mut op = CopyOptions::new();
        op.overwrite = true;
        match dir_copy(s_dir, d_dir, &op) {
            Err(e) => {
                warn!(
                    "copy dir {} => {} failed. error: {:?}",
                    src_dir.to_string(),
                    dst_dir.to_string(),
                    e
                );
                return false;
            }
            _ => {
                debug!(
                    "copy dir {} => {} successfully",
                    src_dir.to_string(),
                    dst_dir.to_string()
                );
                return true;
            }
        }
    }

    pub fn move_files_qml(&self, src_dir: QString, dst_dir: QString) -> bool {
        let src_dir = src_dir.to_string();
        let src_dir = Path::new(&src_dir);
        let dst_dir = dst_dir.to_string();
        let dst_dir = Path::new(&dst_dir);

        if !dst_dir.exists() && fs::create_dir_all(&dst_dir).is_err() {
            return false;
        }

        let dirs = fs::read_dir(&src_dir);
        if dirs.is_err() {
            return false;
        }

        for entry in dirs.unwrap() {
            if entry.is_err() {
                return false;
            }

            let entry = entry.unwrap();
            let metadata = entry.metadata();
            if metadata.is_err() {
                return false;
            }

            if metadata.unwrap().is_dir() {
                let src_dir = src_dir
                    .join(entry.file_name())
                    .to_str()
                    .unwrap()
                    .to_string()
                    .into();
                let dst_dir = dst_dir
                    .join(entry.file_name())
                    .to_str()
                    .unwrap()
                    .to_string()
                    .into();
                if !self.move_files_qml(src_dir, dst_dir) {
                    return false;
                }
            } else {
                let dst_path = dst_dir.join(entry.file_name());
                // debug!("{:?} -> {:?}", entry.path(), &dst_path);
                match fs::rename(entry.path(), &dst_path) {
                    Err(e) => {
                        warn!(
                            "{:?} -> {:?} failed! error: {:?} ",
                            entry.path(),
                            &dst_path,
                            e
                        );
                        return false;
                    }
                    _ => (),
                }
            }
        }

        return true;
    }

    pub fn exit_qml(&self, code: i32) {
        std::process::exit(code);
    }

    pub fn process_cmd_qml(&self, cmd: QString, args: QString) -> bool {
        let args = args.to_string();
        let args = args.split(',');
        return Command::new(cmd.to_string()).args(args).spawn().is_ok();
    }

    pub fn app_version_qml(&self) -> QString {
        return version::VERSION.to_string().into();
    }
}
