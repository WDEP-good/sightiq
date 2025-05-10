include!("D:\\Project\\sightiq\\backend\\core\\web\\server\\mod.rs");

#[macro_use]
extern crate rocket;

#[rocket::main]
async fn main() {
    if let Err(e) = rocket().launch().await {
        println!("start server failed: {}", e);
    } else {
        println!("start server success");
    }
}
