use semver::Version;

fn main() {
    #[cfg(target_os = "windows")]
    set_windows_info();

    let mut config = cpp_build::Config::new();
    qt_setup(&mut config);

    _ = write_app_version();
}

#[cfg(target_os = "windows")]
fn set_windows_info() {
    _ = embed_resource::compile("./windows/icon.rc", embed_resource::NONE);
}

fn write_app_version() -> Result<(), Box<dyn std::error::Error>> {
    let tags = duct::cmd!("git", "describe", "--tags", "--abbrev=0")
        .read()?
        .split(char::is_whitespace)
        .map(|s| s.to_owned())
        .collect::<Vec<String>>();

    let output = if let Some(version) = tags.last() {
        format!(r#"pub static VERSION: &str = "{}";"#, version)
    } else {
        format!(r#"pub static VERSION: &str = "{}";"#, "0.0.1")
    };

    _ = std::fs::write("src/version.rs", output);

    Ok(())
}

fn qt_setup(config: &mut cpp_build::Config) {
    let profile = std::env::var("PROFILE").unwrap();
    let qt_include_path = std::env::var("DEP_QT_INCLUDE_PATH").unwrap();
    println!("cargo:info=qt_include_path: {:?}", qt_include_path);

    let qt_library_path = std::env::var("DEP_QT_LIBRARY_PATH").unwrap();
    println!("cargo:info=qt_library_path: {:?}", qt_library_path);

    let qt_version = std::env::var("DEP_QT_VERSION")
        .unwrap()
        .parse::<Version>()
        .expect("Parsing Qt version failed");
    println!("cargo:info=qt_version: {:?}", qt_version);

    if cfg!(target_os = "linux") && profile.as_str() == "release" {
        println!("cargo:rustc-link-arg=-Wl,-rpath=./:./lib");
    }

    for f in std::env::var("DEP_QT_COMPILE_FLAGS")
        .unwrap()
        .split_terminator(';')
    {
        config.flag(f);
    }

    if cfg!(target_os = "macos") {
        config.flag("-F");
        config.flag(&qt_library_path);
    }

    if qt_version >= Version::new(6, 0, 0) {
        config.flag_if_supported("-std=c++17");
        config.flag_if_supported("/std:c++17");
        config.flag_if_supported("/Zc:__cplusplus");
    }

    config.include(&qt_include_path);
    config.include(&format!("{}/{}", qt_include_path, "QtCore"));

    for minor in 15..=15 {
        if qt_version >= Version::new(5, minor, 0) {
            println!("cargo:rustc-cfg=qt_{}_{}", 5, minor);
        }
    }
    let mut minor = 0;
    while qt_version >= Version::new(6, minor, 0) {
        println!("cargo:rustc-cfg=qt_{}_{}", 6, minor);
        minor += 1;
    }
}
