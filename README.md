# A/B Smartly SDK

A/B Smartly - Dart SDK

## Compatibility

The A/B Smartly Dart SDK is compatible with Java versions 2.18.6 and later.

### Android

The A/B Smartly SDK is compatible with Android 4.4 and later (API level 19+).

The `android.permission.INTERNET` permission is required. To add this permission to your application ensure the following line is present in the `AndroidManifest.xml` file:
```xml
    <uses-permission android:name="android.permission.INTERNET"/>
```

If you target Android 6.0 or earlier, a few extra steps are outlined below for installation and initialization.


## Installation

#### Pubspec.yaml

To install the ABSmartly SDK, place the following in your `pubspec.yaml` and replace {VERSION} with the latest SDK version available in MavenCentral.

```
  ab_smartly:
    git:
      url: https://github.com/hamzali4642/ab_smartly
```




## Getting Started

Please follow the [installation](#installation) instructions before trying the following code:

#### Initialization
This example assumes an Api Key, an Application, and an Environment have been created in the A/B Smartly web console.
```dart

void main() async{
  final ClientConfig clientConfig = ClientConfig()
    ..setEndpoint("https://dev-1.absmartly.io/v1")
    ..setAPIKey("YOUR API KEY")
    ..setApplication("website")
    ..setEnvironment("development");


  final ABSmartlyConfig sdkConfig = ABSmartlyConfig.create()
      .setClient(Client.create(clientConfig));


  final ABSmartly sdk = ABSmartly(sdkConfig);

  final ContextConfig contextConfig = ContextConfig.create()
    ..setUnit("session_id", "bf06d8cb5d8137290c4abb64155584fbdb64d8")
    ..setUnit("user_id", "123456");



  final Context ctx = await sdk.createContext(contextConfig).waitUntilReady();


  final int treatment = await ctx.getTreatment("exp_test_ab");
  print(treatment);

  final Map<String, dynamic> properties = {};
  properties["value"] = 125;
  properties["fee"] = 125;

  ctx.track("payment", properties);

  ctx.close();
  sdk.close();
}
```

#### Creating a new Context asynchronously
```dart
// define a new context request
createNewContext() async{
  final ContextConfig contextConfig = ContextConfig.create()
      .setUnit("session_id", "5ebf06d8cb5d8137290c4abb64155584fbdb64d8"); // a unique id identifying the user

  final Context? context = await sdk.createContext(contextConfig)
      .waitUntilReady();

  if(context != null){
    print("context ready");
  }  
}

```

#### Creating a new Context with pre-fetched data
Creating a context involves a round-trip to the A/B Smartly event collector.
We can avoid repeating the round-trip on the client-side by re-using data previously retrieved.

```dart
    final ContextConfig contextConfig = ContextConfig.create()
        .setUnit("session_id", "5ebf06d8cb5d8137290c4abb64155584fbdb64d8"); // a unique id identifying the user

    final Context context = sdk.createContext(contextConfig)
        .waitUntilReady();

    final ContextConfig anotherContextConfig = ContextConfig.create()
        .setUnit("session_id", "5ebf06d8cb5d8137290c4abb64155584fbdb64d8"); // a unique id identifying the other user

    final Context anotherContext = sdk.createContextWith(anotherContextConfig, context.getData());
    assert(anotherContext.isReady()); // no need to wait

```

#### Setting extra units for a context
You can add additional units to a context by calling the `setUnit()` or the `setUnits()` method.
This method may be used for example, when a user logs in to your application, and you want to use the new unit type to the context.
Please note that **you cannot override an already set unit type** as that would be a change of identity, and will throw an exception. In this case, you must create a new context instead.
The `setUnit()` and `setUnits()` methods can be called before the context is ready.

```dart
  context.setUnit("db_user_id", "1000013");

  context.setUnits({
    "db_user_id": "1000013"
  });
```

#### Setting context attributes
The `setAttribute()` and `setAttributes()` methods can be called before the context is ready.
```dart
    context.setAttribute('user_agent', req.getHeader("User-Agent"));

    context.setAttributes({
      "customer_age": "new_customer"
    });
```

#### Selecting a treatment
```dart
  
  if((await context.getTreatment("exp_test_experiment")) == 0) {
    // user is in control group (variant 0)
  } else {
    // user is in treatment group
  }
  
```


#### Tracking a goal achievement
Goals are created in the A/B Smartly web console.
```dart
    context.track("payment",{
      "item_count": 1,
      "total_amount": 1999.99
    });
```

#### Publishing pending data
Sometimes it is necessary to ensure all events have been published to the A/B Smartly collector, before proceeding.
You can explicitly call the `publish()` or `publishAsync()` methods.
```dart
    context.publish();
```

#### Finalizing
The `close()` and `closeAsync()` methods will ensure all events have been published to the A/B Smartly collector, like `publish()`, and will also "seal" the context, throwing an error if any method that could generate an event is called.
```dart
    context.close();
```

#### Refreshing the context with fresh experiment data
For long-running contexts, the context is usually created once when the application is first started.
However, any experiments being tracked in your production code, but started after the context was created, will not be triggered.
To mitigate this, we can use the `setRefreshInterval()` method on the context config.

```dart
    final ContextConfig contextConfig = ContextConfig.create()
		.setUnit("session_id", "5ebf06d8cb5d8137290c4abb64155584fbdb64d8")
        .setRefreshInterval(TimeUnit.HOURS.toMillis(4)); // every 4 hours
```

Alternatively, the `refresh()` method can be called manually.
The `refresh()` method pulls updated experiment data from the A/B Smartly collector and will trigger recently started experiments when `getTreatment()` is called again.
```dart
    context.refresh()
```



#### Overriding treatment variants
During development, for example, it is useful to force a treatment for an experiment. This can be achieved with the `override()` and/or `overrides()` methods.
The `setOverride()` and `setOverrides()` methods can be called before the context is ready.
```dart
    context.setOverride(experimentName, variant)
    context.setOverrides({
      "exp_test_experiment": 1,
      "exp_another_experiment": 0,
    });
```

## About A/B Smartly
**A/B Smartly** is the leading provider of state-of-the-art, on-premises, full-stack experimentation platforms for engineering and product teams that want to confidently deploy features as fast as they can develop them.
A/B Smartly's real-time analytics helps engineering and product teams ensure that new features will improve the customer experience without breaking or degrading performance and/or business metrics.

### Have a look at our growing list of clients and SDKs:
- [Java SDK](https://www.github.com/absmartly/java-sdk)
- [JavaScript SDK](https://www.github.com/absmartly/javascript-sdk)
- [PHP SDK](https://www.github.com/absmartly/php-sdk)
- [Swift SDK](https://www.github.com/absmartly/swift-sdk)
- [Vue2 SDK](https://www.github.com/absmartly/vue2-sdk)
