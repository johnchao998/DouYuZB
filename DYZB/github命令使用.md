1.首先在github主面上创建代码仓库，然后拿到代码仓库URL,然后在本地终端使用命令下载仓库,
先 cd 到 /Users/john/projects 输入如下命令：
git clone https://github.com/johnchao998/DouYuZB.git


2.
Xcode创建工程，保存工程到 DouYuZB目录下
git命令提交代码：
cd 到 /Users/john/projects/DouYuZB
git add .  添加到本地仓库
git commit -m "初始化项目说明信息". 到这一步只是在本地仓库操作

3.把本地仓库修改的内容提交到远程仓库

git push  可能提示输入github账号与密码
完成提交



4.pod使用
1.终端进入项目目录后：pod init 创建 Podfile
2.xcode打开 Podfile,  添加 pod 'Alamofire' 与 'Kingfisher'图片加载框架
3.终端： pod install --no-repo-update   进行安装 Alamofire  目前是 4.9.1版本
IOS9.0 如果需要请求 http ，则在项目 info.list 添加 App Transport Security Settings->Allow Arbitrary Loads 设置为：YES
