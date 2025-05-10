mod server; 

use server::api::rocket; 

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
