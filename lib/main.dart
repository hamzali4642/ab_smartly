import 'package:flutter/material.dart';

import 'ab_smartly.dart';
import 'ab_smartly_config.dart';
import 'client.dart';
import 'client_config.dart';
import 'context.dart';
import 'context_config.dart';
import 'default_http_client.dart';
import 'default_http_client_config.dart';

main(){
  var c = Check();
  c.intItLib();
}


class Check{
  void intItLib() {
    debugPrint("api key");

    final ClientConfig clientConfig = ClientConfig()
      ..setEndpoint("https://dev-1.absmartly.io/v1")
      ..setAPIKey(
          "XdDXJsGNk-yfpDS32eUNgA53Di4hIidK6TSxMs8UHiJFwnJLF_toKwPhup34p9l0")
      ..setApplication("www")
      ..setEnvironment("dev");
    final Client abSmartlyClient = Client.create(clientConfig);

    final ABSmartlyConfig sdkConfig =
    ABSmartlyConfig.create().setClient(abSmartlyClient);
    final ABSmartly sdk = ABSmartly(sdkConfig);
    debugPrint("api key = ${clientConfig.apiKey_.toString()} ");
    newContextAsync(sdk: sdk);
  }

  void intItLibAndroid6() {
    final ClientConfig clientConfig = ClientConfig()
      ..setEndpoint("http://httpbin.org/post")
      ..setAPIKey(
          "XdDXJsGNk-yfpDS32eUNgA53Di4hIidK6TSxMs8UHiJFwnJLF_toKwPhup34p9l0")
      ..setApplication("web")
      ..setEnvironment("production");
    // final DefaultHTTPClientConfig httpClientConfig =
    //     DefaultHTTPClientConfig.create()
    //         .setSecurityProvider(Conscrypt.newProvider());

    final DefaultHTTPClientConfig httpClientConfig =
    DefaultHTTPClientConfig.create();

    final DefaultHTTPClient httpClient =
    DefaultHTTPClient.create(httpClientConfig);

    final Client abSmartlyClient =
    Client.create(clientConfig, httpClient: httpClient);

    final ABSmartlyConfig sdkConfig =
    ABSmartlyConfig.create().setClient(abSmartlyClient);

    final ABSmartly sdk = ABSmartly(sdkConfig);
  }

  void newContextSync({required ABSmartly sdk}) {
    final ContextConfig contextConfig = ContextConfig.create().setUnit(
        "session_id",
        "5ebf06d8cb5d8137290c4abb64155584fbdb64d8"); // a unique id identifying the user
    final context = sdk.createContext(contextConfig).waitUntilReady();
  }

  Future<void> newContextAsync({required ABSmartly sdk}) async {
    // final ContextConfig contextConfig = ContextConfig.create().setUnit(
    //     "session_id",
    //     "5ebf06d8cb5d8137290c4abb64155584fbdb64d8"); // a unique id identifying the user
    // final context = await sdk.createContext(contextConfig).waitUntilReady();
    debugPrint("getting");
    var contextData = sdk
        .getContextData()
        .then((value) => {debugPrint("context data : ${value.toString()}")});
    return;
  }

  Future<void> newContextPreFetch({required ABSmartly sdk}) async {
    final ContextConfig contextConfig = ContextConfig.create().setUnit(
        "session_id",
        "5ebf06d8cb5d8137290c4abb64155584fbdb64d8"); // a unique id identifying the user

    final context = await sdk.createContext(contextConfig).waitUntilReady();

    final ContextConfig anotherContextConfig = ContextConfig.create().setUnit(
        "session_id",
        "5ebf06d8cb5d8137290c4abb64155584fbdb64d8"); // a unique id identifying the other user

    final Context anotherContext =
    sdk.createContextWith(anotherContextConfig, context.getData());
    assert(anotherContext.isReady());
  }

  void extraUnits({required Context context}) {
    context.setUnit("db_user_id", "1000013");

    context.setUnits(Map.of({"db_user_id": "", "1000013": ""}));

    //Setting context attributes
    // context.setAttribute('user_agent', req.getHeader("User-Agent"));
    // context.setAttributes(Map.of(
    //     "customer_age", "new_customer"
    // ));

    //Selecting a treatment
  }
}