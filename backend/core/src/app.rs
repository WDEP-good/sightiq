use backend::server;

#[rocket::main]
async fn main() {
    if let Err(e) = server::rocket().launch().await {
        println!("start server failed: {}", e);
    } else {
        println!("start server success");
    }
}
