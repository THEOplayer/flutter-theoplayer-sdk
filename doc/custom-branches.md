# Custom branches

THEOplayer Flutter SDK is built on top of the existing THEOplayer iOS, Android, and Web SDKs. However, not all native SDK features are available in Flutter from the start.

These features will be gradually introduced to the Flutter SDK based on thoughtful prioritization.

We understand that sometimes you may need these features before they are fully implemented on the Flutter side and require a working solution as soon as possible.

To address this need, we introduced custom branches prefixed with `poc/`, showcasing sample implementations of existing native features in a custom Flutter SDK fork. These versions are stable enough to start experimenting with and making necessary modifications if needed.

(Please note that these branches may not always be up-to-date with the latest releases.)

These versions also serve as a starting point for custom integration needs. By examining the source code and reviewing changes commit by commit, you can gain a basic understanding of how to expose additional native THEOplayer APIs to Flutter, especially if you are already familiar with the underlying SDKs.

## Available custom branches

<table>
<thead>
<tr>
<th>Branch</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td><code><a href="https://github.com/THEOplayer/flutter-theoplayer-sdk/tree/poc/in-sdk-chromecast-support-7.x">poc/in-sdk-chromecast-support-7.x</a></code></td>
<td>Exposing Chromecast capabilities on Android, iOS and Web</td>
</tr>
<tr>
<td><code><a href="https://github.com/THEOplayer/flutter-theoplayer-sdk/tree/poc/in-sdk-google-ima-support-7.x">poc/in-sdk-google-ima-support-7.x</a></code></td>
<td>Exposing Google IMA capabilities on Android and iOS</td>
</tr>
</tbody>
</table>

## How to make and use your own custom fork?

1. Create a fork of the THEOplayer Flutter SDK repo on [GitHub](https://github.com/THEOplayer/flutter-theoplayer-sdk/).
2. Configure your project to use your forked custom [THEOplayer SDK as a submodule](https://github.com/THEOplayer/flutter-theoplayer-sdk/blob/main/doc/creating-minimal-app.md#option-2-adding-theoplayer-flutter-sdk-as-submodule) in your project.
3. Import THEOplayer and start using it in your application.