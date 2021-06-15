1.app框架
1.0 创建默认工程的Main.storyboard只有一个ViewController,删除后，从控制库中拖一个TabBarController进来。然后在属性页中设置TabBarController is Initial View Controller前面打勾。
Main.storyboard一个主TabBarController带四个NavigationController
1.1 TabBarController只有两个ViewController,我们需要每一个TabBar都需要一个NavigationController两导航，所以用以下方法增加NavigationController。分别选中 TabBarController的右边Item1、Item2后，在xcode菜单栏
Editor->Embedin->Navigation Controller分别添加两个默认的，其它两个则复制即可。

1.2为新添加的两个Navigation Controller添加与TabBarController关联，点选TabBarController右键->ViewController-Item拖线连接到Navigation Controller即可。

1.3在属性页配置页中，分别为每个TabBar Item添加文字与图片
添加完图片之后，图片是橙色的，但是显示出来是蓝色的。则需要在 UIApplicationDelegate中添加 UITabBar.appearance().tintColor = UIColor.orange

1.4 IOS9.0 以上才支持 Refactor to StoryBoard方法 如果Main.stroyBoard太多控制器，会显得不好管理，则把他们进一步分离，方法如下：
同时选择上NavigationController与它对应的ViewController ，然后在菜单栏Editor->Refactor to Storyboard,生成一个新的StoryBoard.
同样的方法生成另外三个StoryBoard,保存路径为：Base.lproj文件夹中
为了适应 9.0以下的系统 ，则生成上面4个StoryBoard后.要使用代码来加载。

新创建一个 MainViewController 继承 UITabBarController，然后选择 Main.storyboard里面的 Main View Controller 关联这个 MainViewController类即可。

2.添加图片包，点击Assets.xcassets资源文件夹后，从示例工程中直接把图片文件夹拖进来，如Tabbar里面的图片
3.往工程添加文件夹划分，首先在本地的工程目录划分好，然后把目录拖进工程里，要选择 Copy items if needed 与 Create groups.


3.添加Home的导航栏按键
3.0 新建一个 HomeViewController类，把此类关联到 Home.storyboard中。
3.1 先扩展一个 UIBarButtonItem 类，参见代码
3.2.1 封装 PageTitileView 
自定义View,并且自定义构造函数
添加子控件：1>UIScrollView 2>设置TitleLabel 3>设置顶部的线段

3.2.2 封装 PageContentView
自定义View,并且自定义构造函数
添加子控件：1>UICollectionView 2>给UICollectionView设置内容

3.3.3 处理 PageTitileView & PageContentView的逻辑
1.PageTitleView中发生点击事件传递给PageContentView进行联动
2.同样PageContentView滚动的事件也传递给PageTitleView进行联动


3.4创建推荐控制器RecomendViewController : UIViewController
1.添加 UICollectionViewFlowLayout 与 UICollectionView布局资源
2.自定义CollectionHeaderView : UICollectionReusableView + storyboard.xib资源
3.创建xib自定义CollectionNormalCell: UICollectionViewCell 
storyboard.xib资源。主要各控制的约束设置详情，如还没有下载到图片时的default图片，在属性中加入圆角 layer.cornerRadius = 5 与超出部分进行裁剪 layer.masksToBounds = true  和 UIImage Mode content mode: scale to fill
xib约束注意事项：举例
如控件A相对于B控件，则一定要设置B控件的高度；
Label设置圆角与UIImage设置圆角方法一致；
Label设置半透明，不要设置alpha值，要设置 custom color RGB的透明值；


