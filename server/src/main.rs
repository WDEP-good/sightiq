#[macro_use]
extern crate rocket;

#[get("/")]
fn index() -> &'static str {
    " Hello, world! "
}


#[get("/video")]
fn video() -> &'static str {
    " Video "
}

#[launch]
fn rocket() -> _ {
    rocket::build().mount("/", routes![index, video])
}
