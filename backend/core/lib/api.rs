use rocket::{Responder };
#[derive(Responder)]
#[response(status = 200, content_type = "json")]
pub struct RawSuccessJson(pub &'static str);



