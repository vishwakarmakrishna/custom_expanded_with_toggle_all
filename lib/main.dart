import 'package:flutter/material.dart';

import 'custom_expanded.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late ValueNotifier<bool> _toggleExpandedContanier;
  late ScrollController _scrollController;
  late List<AnimationController> controller;
  late List<AnimationController> globalKeys;
  @override
  void initState() {
    super.initState();
    _toggleExpandedContanier = ValueNotifier(false);
    _scrollController = ScrollController();
    controller = List.generate(
        100,
        (index) => AnimationController(
            vsync: this, duration: const Duration(milliseconds: 200)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: controller.length,
        itemBuilder: (context, index) {
          return CustomExpanded(
            headercolor: Colors.blue,
            controller: controller[index],
            titleChild: Text('Title$index'),
            children: const [
              Text('Hello'),
              Text('World'),
              Text('Hello'),
              Text('World'),
              Text('Hello'),
              Text('World'),
              Text('Hello'),
              Text('World'),
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ValueListenableBuilder(
          valueListenable: _toggleExpandedContanier,
          builder: (context, isExpanded, child) {
            return Switch(
              value: isExpanded,
              onChanged: (value) {
                _toggleExpandedContanier.value = value;

                if (value) {
                  for (AnimationController element in controller) {
                    element.forward();
                  }
                } else {
                  for (AnimationController element in controller) {
                    element.reverse();
                  }
                }
              },
            );
          }),
    );
  }
}
