// ignore_for_file: non_constant_identifier_names

import 'package:theoplayer/theoplayer.dart';

final HLS = SourceDescription(sources: [
                                TypedSource(src: "https://cdn.theoplayer.com/video/big_buck_bunny/big_buck_bunny.m3u8"),
                              ]);


final HLS_FAIRPLAY = SourceDescription(sources: [
                                      TypedSource(
                                          src: "https://fps.ezdrm.com/demo/video/ezdrm.m3u8",
                                          drm: DRMConfiguration(
                                            customIntegrationId: "EzdrmDRMIntegration",
                                            fairplay: FairPlayDRMConfiguration(
                                              licenseAcquisitionURL: "https://fps.ezdrm.com/api/licenses/09cc0377-6dd4-40cb-b09d-b582236e70fe",
                                              certificateURL: "https://fps.ezdrm.com/demo/video/eleisure.cer",
                                              headers: null,
                                            ),
                                          )),
                                    ]);

final DASH_WIDEVINE_CUSTOM = SourceDescription(sources: [
                                      TypedSource(
                                          src: "https://d2jl6e4h8300i8.cloudfront.net/netflix_meridian/4k-18.5!9/keyos-logo/g180-avc_a2.0-vbr-aac-128k/r30/dash-wv-pr/stream.mpd",
                                          drm: DRMConfiguration(
                                            customIntegrationId: "KeyOSDRMIntegration",
                                            integrationParameters: {
                                                "x-keyos-authorization": "PEtleU9TQXV0aGVudGljYXRpb25YTUw+PERhdGE+PEdlbmVyYXRpb25UaW1lPjIwMTYtMTEtMTkgMDk6MzQ6MDEuOTkyPC9HZW5lcmF0aW9uVGltZT48RXhwaXJhdGlvblRpbWU+MjAyNi0xMS0xOSAwOTozNDowMS45OTI8L0V4cGlyYXRpb25UaW1lPjxVbmlxdWVJZD4wZmZmMTk3YWQzMzQ0ZTMyOWU0MTA0OTIwMmQ5M2VlYzwvVW5pcXVlSWQ+PFJTQVB1YktleUlkPjdlMTE0MDBjN2RjY2QyOWQwMTc0YzY3NDM5N2Q5OWRkPC9SU0FQdWJLZXlJZD48V2lkZXZpbmVQb2xpY3kgZmxfQ2FuUGxheT0idHJ1ZSIgZmxfQ2FuUGVyc2lzdD0iZmFsc2UiIC8+PFdpZGV2aW5lQ29udGVudEtleVNwZWMgVHJhY2tUeXBlPSJIRCI+PFNlY3VyaXR5TGV2ZWw+MTwvU2VjdXJpdHlMZXZlbD48L1dpZGV2aW5lQ29udGVudEtleVNwZWM+PEZhaXJQbGF5UG9saWN5IC8+PExpY2Vuc2UgdHlwZT0ic2ltcGxlIiAvPjwvRGF0YT48U2lnbmF0dXJlPk1sNnhkcU5xc1VNalNuMDdicU8wME15bHhVZUZpeERXSHB5WjhLWElBYlAwOE9nN3dnRUFvMTlYK1c3MDJOdytRdmEzNFR0eDQydTlDUlJPU1NnREQzZTM4aXE1RHREcW9HelcwS2w2a0JLTWxHejhZZGRZOWhNWmpPTGJkNFVkRnJUbmxxU21raC9CWnNjSFljSmdaUm5DcUZIbGI1Y0p0cDU1QjN4QmtxMUREZUEydnJUNEVVcVJiM3YyV1NueUhGeVZqWDhCR3o0ZWFwZmVFeDlxSitKbWI3dUt3VjNqVXN2Y0Fab1ozSHh4QzU3WTlySzRqdk9Wc1I0QUd6UDlCc3pYSXhKd1ZSZEk3RXRoMjhZNXVEQUVZVi9hZXRxdWZiSXIrNVZOaE9yQ2JIVjhrR2praDhHRE43dC9nYWh6OWhVeUdOaXRqY2NCekJvZHRnaXdSUT09PC9TaWduYXR1cmU+PC9LZXlPU0F1dGhlbnRpY2F0aW9uWE1MPg==",
                                            },
                                            widevine: WidevineDRMConfiguration(
                                              licenseAcquisitionURL: "https://wv-keyos.licensekeyserver.com",
                                            ),
                                          )),
                                    ]);

final DASH_WIDEVINE = SourceDescription(sources: [
                                      TypedSource(
                                          src: "https://storage.googleapis.com/wvmedia/cenc/h264/tears/tears_sd.mpd",
                                          drm: DRMConfiguration(
                                            widevine:
                                                WidevineDRMConfiguration(licenseAcquisitionURL: "https://proxy.uat.widevine.com/proxy?provider=widevine_test"),
                                          )),
                                    ]);