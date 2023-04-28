import 'package:ab_smartly/ab_smartly.dart';
import 'package:ab_smartly/ab_smartly_config.dart';
import 'package:ab_smartly/client.dart';
import 'package:ab_smartly/client_config.dart';
import 'package:ab_smartly/context.dart';
import 'package:ab_smartly/context_config.dart';
import 'package:ab_smartly/default_http_client.dart';
import 'package:ab_smartly/default_http_client_config.dart';
import 'package:ab_smartly/helper/funtions.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const AbSmartlyScreen(),
    );
  }
}

class AbSmartlyScreen extends StatefulWidget {
  const AbSmartlyScreen({Key? key}) : super(key: key);

  @override
  State<AbSmartlyScreen> createState() => _AbSmartlyScreenState();
}

class _AbSmartlyScreenState extends State<AbSmartlyScreen> {
  @override
  void initState() {
    super.initState();
  }

  String res = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          initData();
        },
        child: Icon(Icons.send),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text(res),
          ),
        ),
      ),
    );
  }

  initData() async {
    final ClientConfig clientConfig = ClientConfig()
      ..setEndpoint("https://dev-1.absmartly.io/v1")
      ..setAPIKey(
          "XdDXJsGNk-yfpDS32eUNgA53Di4hIidK6TSxMs8UHiJFwnJLF_toKwPhup34p9l0")
      ..setApplication("web")
      ..setEnvironment("prod");

    final ABSmartlyConfig sdkConfig =
        ABSmartlyConfig.create().setClient(Client.create(clientConfig));
    final ABSmartly sdk = ABSmartly(sdkConfig);
    final ContextConfig contextConfig = ContextConfig.create()

      ..setUnit("user_id", "123456");
    final Context ctx = await sdk.createContext(contextConfig).waitUntilReady();

    print(ctx.units_);

    final int treatment = await ctx.getTreatment("exp_test_ab");
    print(treatment);

    final Map<String, dynamic> properties = {};
    properties["value"] = 125;
    properties["fee"] = 125;

    ctx.track("payment", properties);


    ctx.close();
    sdk.close();
    res = Helper.response ?? "";
    setState(() {});
    Helper.response = null;
  }
}
