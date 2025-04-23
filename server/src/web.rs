use serde_json::json;

#[get("/")]
fn index() -> String {
    json!({ "message": "Hello, world!" }).to_string()
}

#[get("/video")]
fn video() -> String {
    json!({ "message": "Video" }).to_string()
}

pub fn launch_rocket() -> rocket::Rocket<rocket::Build> {
    rocket::build().mount("/", routes![index, video])
}
