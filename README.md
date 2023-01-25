# Frigade Flutter SDK

The official Flutter SDK for [Frigade](https://frigade.com).

## Getting started

````
final publicApiKey = "YOUR_PUBLIC_API_KEY";
final userId = "OPTIONAL_USER_ID";

/// Create a new instance of [FrigadeClient] passing the public api key obtained from 
/// your project dashboard.
final client = FrigadeClient(
    publicApiKey
);
/// Optionally, you can identify the user to view the flows through.
await client.identify(userId);
````
