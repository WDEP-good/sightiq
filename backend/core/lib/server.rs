use rocket::routes;
use crate::login;
use login::{login_handle,index};

pub fn rocket() -> rocket::Rocket<rocket::Build> {
    rocket::build()
        .configure(rocket::Config {
            port: 3000,
            ..Default::default()
        })
        .mount("/", routes![index,login_handle])
}
