#!/bin/bash

set -e

echo "🟡 更新系统..."
# sudo apt update

##########################
# 安装 Oracle JDK 21
##########################
echo "📦 下载 Oracle JDK 21 DEB 包..."
sudo apt install maven
wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb

echo "📂 安装 Oracle JDK 21..."
sudo dpkg -i jdk-21_linux-x64_bin.deb

# 处理依赖问题
sudo apt --fix-broken install

echo "🔧 配置 JAVA_HOME..."
echo 'export JAVA_HOME=/usr/lib/jvm/jdk-21' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc

##########################
# 安装 nvm 并使用它安装 Node.js
##########################
echo "📦 安装 NVM（Node Version Manager）..."
sudo apt install curl
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# 加载 nvm 环境（立即生效）
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"

echo "📦 使用 nvm 安装 Node.js v20.16.0..."
nvm install 20.16.0
nvm use 20.16.0
nvm alias default 20.16.0

##########################
# 应用环境变量 & 验证
##########################
echo "🔁 重新加载 shell..."
source ~/.bashrc
source "$NVM_DIR/nvm.sh"

echo "✅ Java 版本："
java -version

echo "✅ Node.js 版本："
node -v
npm -v

echo "🎉 安装完成！Oracle JDK 21 和 Node.js v20.16.0（via nvm）已就绪。"
