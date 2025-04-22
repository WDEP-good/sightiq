use redis::Commands;


fn connect_to_redis() -> redis::RedisResult<redis::Connection> {
    // 连接 Redis
    let client = redis::Client::open("redis://127.0.0.1/")?;
    let con = client.get_connection()?;
    Ok(con)
}

fn main() -> redis::RedisResult<()> {
    let mut con = connect_to_redis()?;

    // 设置一个键值
    let _: () = con.set("my_key", 42)?;

    // 读取这个键值
    let val: i32 = con.get("my_key")?;
    println!("got value from redis: {}", val);

    Ok(())
}
