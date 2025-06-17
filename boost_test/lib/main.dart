import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:super_player/super_player.dart';

void main() {
  ///这里的CustomFlutterBinding调用务必不可缺少，用于控制Boost状态的resume和pause
  ///

  // 使用 runZonedGuarded 包装 runApp
  runZonedGuarded<Future<void>>(() async {
    // 确保 Flutter 绑定已经初始化
    CustomFlutterBinding();
    // 在这里设置 Flutter 框架本身的错误处理
    // FlutterError.onError 捕获由 Flutter 框架抛出的错误 (例如布局错误, 渲染错误)
    FlutterError.onError = (FlutterErrorDetails details) {
      // 在 debug 模式下，Flutter 会将错误打印到控制台
      // 在 release 模式下，你需要手动处理这些错误
      // 这里我们把 Flutter 框架的错误也传递给我们的 Zone 错误处理
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    };

    // 设置 Dart 异步错误处理（例如，Future.error, Stream.error）
    // 通常 runZonedGuarded 已经覆盖了大部分，但显式设置有时有帮助
    // Isolate.current.addErrorListener(RawReceivePort((pair) async {
    //   final List<dynamic> errorAndStacktrace = pair;
    //   await Zone.current.handleUncaughtError(
    //       errorAndStacktrace[0],
    //       errorAndStacktrace[1] as StackTrace,
    //   );
    // }).sendPort);
   await initPlayerLicense();
    // 运行你的 Flutter 应用
    runApp(MyApp());
  }, (Object error, StackTrace stack) {
    // 这是 Zone 捕获到未处理错误时调用的回调
    debugPrint('--- 捕获到未处理的错误！---');
    debugPrint('错误类型/信息: $error');
    debugPrint('错误堆栈:');
    debugPrint(stack.toString()); // 打印完整的堆栈信息

    // 生产环境中，你可能会将这些信息发送到错误报告服务，如 Sentry, Firebase Crashlytics
    // Sentry.captureException(error, stackTrace: stack);
    // FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    debugPrint('--- 错误处理完毕 ---');

    // 在这里你还可以做一些UI上的处理，比如显示一个错误页面
    // 但通常不推荐在 onError 中直接修改 UI 树，因为可能导致二次崩溃
    // 更常见的做法是设置一个 StreamBuilder 监听错误报告，然后构建错误 UI
  });
}

Future<void> initPlayerLicense() async {
 await SuperPlayerPlugin.setGlobalLicense(
      "https://license.vod2.myqcloud.com/license/v2/1306316007_1/v_cube.license",
      "e09a3fc2d3e6d3910843b624260057b7");
 await SuperPlayerPlugin.setLogLevel(0);
  SuperPlayerPlugin.instance
      .setSDKListener(licenceLoadedListener: (res, str) {});
}

///创建一个自定义的Binding，继承和with的关系如下，里面什么都不用写
class CustomFlutterBinding extends WidgetsFlutterBinding
    with BoostFlutterBinding {}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// 由于很多同学说没有跳转动画，这里是因为之前exmaple里面用的是 [PageRouteBuilder]，
  /// 其实这里是可以自定义的，和Boost没太多关系，比如我想用类似iOS平台的动画，
  /// 那么只需要像下面这样写成 [CupertinoPageRoute] 即可
  /// (这里全写成[MaterialPageRoute]也行，这里只不过用[CupertinoPageRoute]举例子)
  ///
  /// 注意，如果需要push的时候，两个页面都需要动的话，
  /// （就是像iOS native那样，在push的时候，前面一个页面也会向左推一段距离）
  /// 那么前后两个页面都必须是遵循CupertinoRouteTransitionMixin的路由
  /// 简单来说，就两个页面都是CupertinoPageRoute就好
  /// 如果用MaterialPageRoute的话同理

  Map<String, FlutterBoostRouteFactory> routerMap = {
    '/': (settings, uniqueId) {
      return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return const MainPage(
              data: "",
            );
          });
    },
    'mainPage': (settings, uniqueId) {
      return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return const MainPage(
              data: "",
            );
          });
    },
    'live': (settings, uniqueId) {
      return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return const Live();
          });
    },
  };

  Route<dynamic>? routeFactory(RouteSettings settings, String? uniqueId) {
    print("routeFactory $settings  $uniqueId");
    FlutterBoostRouteFactory? func = routerMap[settings.name];
    if (func == null) {
      return null;
    }
    return func(settings, uniqueId);
  }

  Widget appBuilder(Widget home) {
    return MaterialApp(
      home: home,
      debugShowCheckedModeBanner: true,

      ///必须加上builder参数，否则showDialog等会出问题
      builder: (_, __) {
        return home;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterBoostApp(
      routeFactory,
      appBuilder: appBuilder,
    );
  }
}

class Live extends StatefulWidget {
  const Live({super.key});

  @override
  State<Live> createState() => _LiveState();
}

class _LiveState extends State<Live> {
  TXLivePlayerController txLivePlayerController = TXLivePlayerController();

  @override
  Widget build(BuildContext context) {
    print("buildbuildbuildbuildbuildbuild");
    return Scaffold(
      body: Container(
          width: 200,
          height: 200,
          child: TXPlayerVideo(
            onRenderViewCreatedListener: (viewId) {
              print("onRenderViewCreatedListener $viewId");
              txLivePlayerController.setPlayerView(viewId);
              txLivePlayerController.startLivePlay(
                  "https://www.bilibili.com/video/BV19RMBzBE4M");
            },
          )),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({required Object data});

  @override
  Widget build(BuildContext context) {
    print("MainPage");
    return const Scaffold(
      body: DynamicTabBarExample(),
    );
  }
}

class TabBarExample extends StatelessWidget {
  const TabBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    // DefaultTabController 管理 TabBar 和 TabBarView 的状态。
    // 它的 length 属性必须与 tabs 的数量一致。
    return DefaultTabController(
      length: 4, // 我们将有 4 个标签页
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TabBarView 示例'),
          backgroundColor: Colors.deepPurple,
          // TabBar 通常放在 AppBar 的 bottom 属性中
          bottom: const TabBar(
            isScrollable: true,
            // 如果标签很多，可以设置为可滚动
            indicatorColor: Colors.white,
            // 选中标签的下划线颜色
            labelColor: Colors.white,
            // 选中标签的文本颜色
            unselectedLabelColor: Colors.purpleAccent,
            // 未选中标签的文本颜色
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontStyle: FontStyle.italic),
            tabs: [
              Tab(text: '首页', icon: Icon(Icons.home)),
            ],
          ),
        ),
        body: const TabBarView(
          // TabBarView 的 children 列表顺序必须与 TabBar 的 tabs 列表顺序一致
          children: [
            TabContent(title: '首页内容', color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }
}

// 这是一个简单的自定义 Tab 内容组件
class TabContent extends StatelessWidget {
  final String title;
  final Color color;

  const TabContent({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withOpacity(0.2), // 稍微透明的背景色
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star,
              size: 80,
              color: color.withOpacity(0.7),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '这是关于 "$title" 的详细内容。',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class DynamicTabBarExample extends StatefulWidget {
  const DynamicTabBarExample({super.key});

  @override
  State<DynamicTabBarExample> createState() => _DynamicTabBarExampleState();
}

class _DynamicTabBarExampleState extends State<DynamicTabBarExample>
    with SingleTickerProviderStateMixin {
  // 混入 SingleTickerProviderStateMixin

  late TabController _tabController; // 声明 TabController
  late Color _currentAppBarColor; // 用于存储当前 AppBar 的背景颜色

  // 定义所有 Tab 的数据，包括文本、图标、内容和对应的颜色
  final List<_TabData> _tabData = [
    _TabData(
      text: '首页',
      icon: Icons.home,
      color: Colors.deepPurple,
      content: const TabContent2(title: '首页内容', color: Colors.deepPurple),
    ),
    _TabData(
      text: '探索',
      icon: Icons.explore,
      color: Colors.teal,
      content: const TabContent2(title: '探索内容', color: Colors.teal),
    ),
    _TabData(
      text: '消息',
      icon: Icons.message,
      color: Colors.orange,
      content: const TabContent2(title: '消息内容', color: Colors.orange),
    ),
    _TabData(
      text: '我的',
      icon: Icons.person,
      color: Colors.blueGrey,
      content: const TabContent2(title: '我的内容', color: Colors.blueGrey),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // 初始化 TabController
    _tabController = TabController(length: _tabData.length, vsync: this);

    // 设置 AppBar 的初始颜色为第一个 Tab 的颜色
    _currentAppBarColor = _tabData.first.color;

    // 监听 TabController 的索引变化
    _tabController.addListener(() {
      // 只有当用户完成了 Tab 的选择（而不是滑动过程中），才更新颜色
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentAppBarColor = _tabData[_tabController.index].color;
          print(
              'Tab switched to: ${_tabData[_tabController.index].text}, color: $_currentAppBarColor');
        });
        if (_tabController.index == 3) {
          BoostNavigator.instance.push("native", withContainer: true);
          Future.delayed(const Duration(seconds: 1), () {
            _tabController.index = 0;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose(); // 释放 TabController 资源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('动态 TabBar 颜色示例'),
        backgroundColor: _currentAppBarColor, // 使用动态颜色
        // TabBar 放在 AppBar 的 bottom 属性中
        bottom: TabBar(
          controller: _tabController,
          // 关联 TabController
          isScrollable: true,
          indicatorColor: Colors.white,
          // 选中标签的下划线颜色
          labelColor: Colors.white,
          // 选中标签的文本颜色
          unselectedLabelColor: Colors.white70,
          // 未选中标签的文本颜色
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontStyle: FontStyle.italic),
          tabs: _tabData
              .map((data) => Tab(text: data.text, icon: Icon(data.icon)))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController, // 关联 TabController
        children: _tabData.map((data) => data.content).toList(),
      ),
    );
  }
}

// 辅助类，用于存储每个 Tab 的数据
class _TabData {
  final String text;
  final IconData icon;
  final Widget content;
  final Color color;

  _TabData({
    required this.text,
    required this.icon,
    required this.content,
    required this.color,
  });
}

// 这是一个简单的自定义 Tab 内容组件
class TabContent2 extends StatelessWidget {
  final String title;
  final Color color;

  const TabContent2({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withOpacity(0.1), // 稍微透明的背景色
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star,
              size: 80,
              color: color.withOpacity(0.7),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            CachedNetworkImage(
              width: 100,
              height: 100,
              imageUrl:
                  'https://img.soogif.com/XMpNQPHjSPNtgdTyvyzXS0PUGxCQoQfr.gif',
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '这是关于 "$title" 的详细内容。',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
