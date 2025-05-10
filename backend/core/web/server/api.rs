

use rocket::form::Form;
use serde_json::json;
mod api; 

// #[derive(FromForm)]
// struct LoginForm {
//     username: String,
//     password: String,
// }

#[derive(Responder)]
#[response(status = 200, content_type = "json")]
struct RawSuccessJson(&'static str);

#[post("/login", data = "<form>")]
fn login(form: Form<LoginForm>) -> RawSuccessJson {
    RawSuccessJson("{ \"message\": \"Login successful\" }")
}


#[get("/")]
fn index() -> RawSuccessJson{
    RawSuccessJson("{ \"hi\": \"world\" }")
}

pub fn rocket() -> rocket::Rocket<rocket::Build> {
    rocket::build()
        .configure(rocket::Config {
            port: 3000,
            ..Default::default()
        })
        .mount("/", routes![index])
        .mount("/login", routes![login])
}
