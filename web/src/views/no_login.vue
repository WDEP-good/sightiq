<template>
    <div class="no_login">
        <LoginBg></LoginBg>
        <div class="from_nologin">
            <div class="nologin_header">注&nbsp;&nbsp;册&nbsp;&nbsp;用&nbsp;&nbsp;户</div>
            <div class="from-content">
                <a-steps :current="current">
                    <a-step v-for="item in steps" :key="item.title" :title="item.title" />
                </a-steps>
            </div>
            <!-- 问题内容 -->
            <div class="steps-content" v-if="current < steps.length - 1">
                <el-form ref="ruleFormRef" style="max-width: 600px" :model="ruleForm" status-icon :rules="rules"
                    label-width="auto" class="demo-ruleForm">
                    <el-form-item label="问题1" prop="an1"> <el-input v-model="ruleForm.an1" type="text" autocomplete="off" />
                    </el-form-item>
                    <el-form-item label="问题2" prop="an2">
                        <el-input v-model="ruleForm.an2" type="text" autocomplete="off" />
                    </el-form-item>
                    <el-form-item label="问题3" prop="an3">
                        <el-input v-model.number="ruleForm.an3" type="text" autocomplete="off" />
                    </el-form-item>
                </el-form>
            </div>
            <!-- 密码内容 -->
            <div class="steps-content" v-if="current == steps.length - 1">
                <el-form ref="ruleFormRef" style="max-width: 600px" :model="ruleForm" status-icon :rules="rules"
                    label-width="auto" class="demo-ruleForm">
                    <el-form-item label="用户名" prop="pass"> <el-input v-model="ruleForm.pass" type="text"
                            autocomplete="off" />
                    </el-form-item>
                    <el-form-item label="密码" prop="password">
                        <el-input v-model="ruleForm.checkPass" type="password" autocomplete="off" />
                    </el-form-item>
                    <el-form-item label="确认密码" prop="agent-password">
                        <el-input v-model.number="ruleForm.age" type="password" autocomplete="off" />
                    </el-form-item>
                </el-form>
            </div>
            <!-- 底部1 -->
            <div class="goback">已有账号?<el-link type="primary" @click="goLogin" class="gobacka">立即登录</el-link></div>
            <div class="nologin_footer2">
                <el-button v-if="current > 0" style="margin-left: 8px" @click="prev">返回上一步</el-button>
                <el-button type="primary" v-if="current == steps.length - 1"
                    @click="submitForm(ruleFormRef!)">提交</el-button>

            </div>
            <!-- 底部2 -->
            <div class="nologin_footer1">
                <el-button v-if="current < steps.length - 1" type="primary" @click="next">下一步</el-button>
            </div>

        </div>
    </div>
</template>
<script setup lang="ts">
import { message } from 'ant-design-vue';
import { ref, reactive } from 'vue';
import LoginBg from '@/components/loginBg.vue'
const current = ref<number>(0);
const next = () => {
    current.value++;
};
const prev = () => {
    current.value--;
};
const success = (text: string) => {
    message.success(text);
};
const steps = reactive([
    {
        title: '填写信息',
        content: 'First-content',
    },
    {
        title: '设置密码',
        content: 'Second-content',
    },

]);
import type { FormInstance, FormRules } from 'element-plus'
import { useRouter } from 'vue-router';
const router = useRouter()
const ruleFormRef = ref<FormInstance>()
const goLogin = () => {
    router.back();
}

const checkAge = (_rule: any, value: any, callback: any) => {
    if (!value) {
        return callback(new Error('请再次输入密码'))
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
        callback(new Error('请输入密码'))
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
        callback(new Error('Please input the password again'))
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
    an1: '',
    an2: '',
    an3: '',
})

const rules = reactive<FormRules<typeof ruleForm>>({
    pass: [{ validator: validatePass, trigger: 'blur' }],
    checkPass: [{ validator: validatePass2, trigger: 'blur' }],
    age: [{ validator: checkAge, trigger: 'blur' }],
})

const submitForm = (formEl: FormInstance) => {
    if (!formEl) return
    formEl.validate((valid: boolean) => {
        if (valid) {
            success('注册成功，请输入账号密码登录'); 
            router.back();
        } else {
            console.log('error submit!')
        }
    })
}

</script>

<style scoped lang="less">
.no_login {
    display: flex;
    min-width: 100vh;
    height: 100vh;
    justify-content: center;
    align-items: center;

    .from_nologin {
        border-radius: 30px;
        width: 100vh;
        height: 70vh;
        box-sizing: border-box;
        background-color: #fff;
        z-index: 99;
        display: flex;
        flex-direction: column;
        // align-items: center;
        // align-items: center;

        .nologin_header {
            width: 90vh;
            height: 10vh;
            line-height: 10vh;
            border-radius: 10px;
            text-align: center;
            box-sizing: border-box;
            font-size: 30px;
            margin: 5vh 5vh;
            color: #fff;
            background-color: skyblue;

        }



        .from-content {
            width: 50vh;
            height: 5vh;
            box-sizing: border-box;
            margin: 0 25vh;
            margin-bottom: 40px;

            /deep/.steps-action {
                margin-left: 10px;
            }
        }

        .steps-content {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-self: center;
        }

        .nologin_footer1 {
            display: flex;
            justify-content: center;
        }

        .nologin_footer2 {
            display: flex;
            justify-content: center;
            margin-top: 40px;
        }
        .goback{
            margin-top: 20px;
            font-size: 15px;
            display: flex;
            justify-content: center;
            .gobacka{
                font-size: 15px;
            }
        }

    }
}
</style>