use rocket::{get,post,FromForm,form::Form };
use crate::api;
use api::RawSuccessJson;

#[derive(FromForm)]
pub(crate) struct LoginForm {
    username: String,
    // password: String,
}


#[get("/")]
pub fn index() -> RawSuccessJson{
    RawSuccessJson("{ \"hi\": \"world\" }")
}




#[post("/login", data = "<form>")]
pub fn login_handle(form: Form<LoginForm>) -> RawSuccessJson {
    let _username = form.username.clone();
    RawSuccessJson("{ \"message\": \"Login successful\" }")
}