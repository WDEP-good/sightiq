#[macro_use]
extern crate rocket;

mod db_manager;
mod web;
#[rocket::main]
async fn main() {
    // 启动 Redis 操作
    match db_manager::run_redis() {
        Ok(_) => println!("Redis operation successful"),
        Err(e) => println!("Redis operation failed: {}", e),
    }

    // 启动 Rocket 服务器
    if let Err(e) = web::launch_rocket().launch().await {
        println!("Rocket launch failed: {}", e);
    }
}
