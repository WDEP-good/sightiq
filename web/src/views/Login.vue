<template>
    <LoginBg></LoginBg>
    <div class="login">
        <div class="from_content">
            <div class="from_header_title">登&nbsp;&nbsp;&nbsp;&nbsp;录</div>
            <div class="from_content_text">
                <el-form ref="ruleFormRef" style="max-width: 600px" :model="ruleForm" status-icon :rules="rules"
                    label-width="auto" class="demo-ruleForm from_text">
                    <el-form-item label="账号" prop="pass">
                        <el-input v-model="ruleForm.pass" type="password" autocomplete="off" placeholder="请输入账号"
                            :prefix-icon="UserFilled" />
                    </el-form-item>
                    <el-form-item label="密码" prop="checkPass">
                        <el-input v-model="ruleForm.checkPass" type="password" autocomplete="off" placeholder="请输入密码" />

                    </el-form-item>
                    <div class="foort_text">还没有账号？<el-link type="primary" @click="gonologin">立即注册</el-link> </div>
                    <div class="from_btn">
                        <el-button type="primary" @click="submitForm(ruleFormRef)">登录</el-button>
                        <el-button @click="resetForm(ruleFormRef)">重置</el-button>
                    </div>
                    <div class="foot">
                        <a-divider plain="true">其他登录方式</a-divider>
                        <div class="icons-list">
                            <a href="#" title="github" @click="githublogin">
                                <GithubFilled style="font-size: 22px;color: #333;" />
                            </a>
                            <a href="#" title="dingding" @click="dingdinglogin">
                                <DingtalkCircleFilled style="font-size: 22px;color: #333;" />
                            </a>
                            <a href="#" title="QQ" @click="QQlogin">
                                <QqCircleFilled style="font-size: 22px;color: #333;" />
                            </a>
                            <a href="#" title="wechat" @click="wechatlogin">
                                <WechatFilled style="font-size: 22px;color: #333;" />
                            </a>
                        </div>
                    </div>
                </el-form>
            </div>
            <div class="foort">
            </div>
        </div>
    </div>
</template>
<script setup lang="ts">
import { GithubFilled, WechatFilled, QqCircleFilled, DingtalkCircleFilled } from '@ant-design/icons-vue';
import { reactive, ref } from 'vue'
import type { FormInstance, FormRules } from 'element-plus'
import { UserFilled } from '@element-plus/icons-vue'
import LoginBg from '@/components/loginBg.vue'
const ruleFormRef = ref<FormInstance>()
import { useRouter } from 'vue-router'
const router = useRouter();
const gonologin = () => {
    router.push('/nologin')
}
const checkAge = (_rule: any, value: any, callback: any) => {
    if (!value) {
        return callback(new Error('Please input the age'))
    }
    setTimeout(() => {
        if (!Number.isInteger(value)) {
            callback(new Error('Please input digits'))
        } else {
            if (value < 18) {
                callback(new Error('Age must be greater than 18'))
            } else {
                callback()
            }
        }
    }, 1000)
}

const validatePass = (_rule: any, value: any, callback: any) => {
    if (value === '') {
        callback(new Error('请正确输入账号'))
    } else {
        if (ruleForm.checkPass !== '') {
            if (!ruleFormRef.value) return
            ruleFormRef.value.validateField('checkPass', () => {})
        }
        callback()
    }
}
const validatePass2 = (_rule: any, value: any, callback: any) => {
    if (value === '') {
        callback(new Error('请正确输入密码'))
    } else if (value !== ruleForm.pass) {
        callback(new Error("Two inputs don't match!"))
    } else {
        callback()
    }
}

const ruleForm = reactive({
    pass: '',
    checkPass: '',
    age: '',
})

const rules = reactive<FormRules<typeof ruleForm>>({
    pass: [{ validator: validatePass, trigger: 'blur' }],
    checkPass: [{ validator: validatePass2, trigger: 'blur' }],
    age: [{ validator: checkAge, trigger: 'blur' }],
})

const submitForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.validate(async (valid: boolean) => {
        if (valid) {
            console.log('submit!')
        } else {
            console.log('error submit!')
        }
    })
}

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
}
const githublogin = () => {
    console.log("使用github打开");
}
const dingdinglogin = () => {
    console.log("使用钉钉打开");
}
const QQlogin = () => {
    console.log("使用QQ打开");
}
const wechatlogin = () => {
    console.log("使用微信打开");
}
</script>

<style lang="less" scoped>
.login {
    width: 100%px;
    height: 100%px;
    display: flex;
    box-sizing: border-box;
    justify-content: center;
    align-items: center;
    min-height: 100vh;

    .loginbg {
        z-index: 0;
    }

    .from_header_title {
        border-radius: 10px;
        font-size: 30px;
        color: #fff;
        background-color: skyblue;
        height: 60px;
        box-sizing: border-box;
        line-height: 60px;
        text-align: center;
        margin: 10px;
    }

    .from_content_text {
        box-sizing: border-box;
        margin: 40px;
    }

    .from_btn {
        display: flex;
        flex-direction: column;
        margin-top: 10px;

        button {
            width: 100%;
            margin-top: 30px;
            margin-left: 0;

        }
    }

    .foot {
        box-sizing: border-box;
        margin: 10px;
        margin-top: 30px;
    }

    .foort_text {
        font-size: 15px;
        display: flex;
        justify-content: right;
        align-items: center;
    }

    .from_content {
        width: 400px;
        height: 500px;
        z-index: 99;
        background-color: #fff;
        border-radius: 10px;
        animation: linew 3s infinite alternate;
        box-shadow: 0px 0px 10px 1px skyblue;

        @keyframes linew {
            0% {
                box-shadow: 0px 0px 10px 1px skyblue;
            }

            50% {
                box-shadow: 0px 0px 10px 5px skyblue;
            }

            100% {
                box-shadow: 0px 0px 10px 10px skyblue;
            }
        }
    }
}

.icons-list {
    display: flex;
    align-items: center;
    justify-content: space-around;
}</style>