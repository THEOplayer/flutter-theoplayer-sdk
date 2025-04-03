/**
 * THEOplayer
 * https://www.theoplayer.com
 *
 * Version: 9.0.0
 */
import { ChromelessPlayer, UIPlayerConfiguration, videojs, PresentationMode, UIRelatedContent } from './THEOplayer.common';
export { ABRConfiguration, ABRMetadata, ABRStrategy, ABRStrategyConfiguration, ABRStrategyType, AES128KeySystemConfiguration, AccessibilityRole, Ad, AdBreak, AdBreakEvent, AdBreakInit, AdBreakInterstitial, AdBufferingEvent, AdDescription, AdEvent, AdInit, AdIntegrationKind, AdMetadataEvent, AdPreloadType, AdReadyState, AdSkipEvent, AdSource, AdSourceType, AdType, AddCachingTaskEvent, AddTrackEvent, AddViewEvent, Ads, AdsConfiguration, AdsEventMap, AdsManagerLoadedEvent, AgamaAnalyticsIntegrationID, AgamaConfiguration, AgamaLogLevelType, AgamaPlayerConfiguration, AgamaServiceName, AgamaSourceConfiguration, AgamaStreamType, AirPlay, AnalyticsDescription, AnalyticsIntegrationID, AudioQuality, AxinomDRMConfiguration, AxinomIntegrationID, AzureDRMConfiguration, AzureIntegrationID, Base64Util, BaseSource, Boundary, BoundaryC3, BoundaryC7, BoundaryHalftime, BoundaryInfo, BufferSource, BufferedSegments, Cache, CacheEventMap, CacheStatus, CacheTaskStatus, CachingTask, CachingTaskEventMap, CachingTaskLicense, CachingTaskList, CachingTaskListEventMap, CachingTaskParameters, CanPlayEvent, CanPlayThroughEvent, Canvas, Cast, CastConfiguration, CastEventMap, CastState, CastStateChangeEvent, CertificateRequest, CertificateResponse, Chromecast, ChromecastConfiguration, ChromecastConnectionCallback, ChromecastError, ChromecastErrorCode, ChromecastErrorEvent, ChromecastEventMap, ChromecastMetadataDescription, ChromecastMetadataImage, ChromecastMetadataType, ClearkeyDecryptionKey, ClearkeyKeySystemConfiguration, Clip, ClipEventMap, ClosedCaptionFile, ComcastDRMConfiguration, ComcastIntegrationID, CommonUtils, CompanionAd, ConaxDRMConfiguration, ConaxIntegrationID, ContentProtectionError, ContentProtectionErrorCode, ContentProtectionErrorEvent, ContentProtectionIntegration, ContentProtectionIntegrationFactory, ContentProtectionRequest, ContentProtectionRequestSubType, ContentProtectionResponse, CrossOriginSetting, CsaiAdDescription, CurrentSourceChangeEvent, CustomAdIntegrationKind, CustomTextTrackMap, CustomTextTrackOptions, CustomWebVTTTextTrack, DAIAvailabilityType, DRMConfiguration, DRMTodayDRMConfiguration, DRMTodayIntegrationID, DashPlaybackConfiguration, DateRangeCue, DeliveryType, DeviceBasedTitaniumDRMConfiguration, DimensionChangeEvent, DirectionChangeEvent, DurationChangeEvent, EdgeStyle, EmptiedEvent, EmsgCue, EncryptedEvent, EndedEvent, EnterBadNetworkModeEvent, ErrorCategory, ErrorCode, ErrorEvent, Event, EventDispatcher, EventListener, EventMap, EventStreamCue, EventedList, ExitBadNetworkModeEvent, ExpressPlayDRMConfiguration, ExpressPlayIntegrationID, EzdrmDRMConfiguration, EzdrmIntegrationID, FairPlayKeySystemConfiguration, FreeWheelAdDescription, FreeWheelAdUnitType, FreeWheelCue, FullscreenOptions, Geo, GlobalCast, GlobalChromecast, GoogleDAI, GoogleDAIConfiguration, GoogleDAILiveConfiguration, GoogleDAISSAIIntegrationID, GoogleDAITypedSource, GoogleDAIVodConfiguration, GoogleImaAd, GoogleImaConfiguration, HTTPHeaders, HespApi, HespApiEventMap, HespMediaType, HespSourceConfiguration, HespTypedSource, HlsDiscontinuityAlignment, HlsPlaybackConfiguration, ID3AttachedPicture, ID3BaseFrame, ID3Comments, ID3CommercialFrame, ID3Cue, ID3Frame, ID3GenericEncapsulatedObject, ID3InvolvedPeopleList, ID3PositionSynchronisationFrame, ID3PrivateFrame, ID3SynchronizedLyricsText, ID3TermsOfUse, ID3Text, ID3UniqueFileIdentifier, ID3Unknown, ID3UnsynchronisedLyricsTextTranscription, ID3UrlLink, ID3UserDefinedText, ID3UserDefinedUrlLink, ID3Yospace, IMAAdDescription, IntentToFallbackEvent, InterceptableRequest, InterceptableResponse, Interstitial, InterstitialEvent, InterstitialType, IrdetoDRMConfiguration, IrdetoIntegrationID, JoinStrategy, KeyOSDRMConfiguration, KeyOSFairplayKeySystemConfiguration, KeyOSIntegrationID, KeyOSKeySystemConfiguration, KeySystemConfiguration, KeySystemId, Latencies, LatencyConfiguration, LatencyManager, LayoutChangeEvent, LicenseRequest, LicenseResponse, LicenseType, LinearAd, List, LoadedDataEvent, LoadedMetadataEvent, MaybeAsync, MeasurableNetworkEstimator, MediaError, MediaErrorCode, MediaFile, MediaMelonConfiguration, MediaTailorSource, MediaTrack, MediaTrackEventMap, MediaTrackList, MediaType, MetadataDescription, Metrics, MillicastMetadataCue, MillicastSource, MoatAnalyticsIntegrationID, MoatConfiguration, MultiViewPlayer, MultiViewPlayerEventMap, MultiViewPlayerLayout, MutedAutoplayConfiguration, Network, NetworkEstimator, NetworkEstimatorController, NetworkEventMap, NetworkInterceptorController, NodeStyleVoidCallback, NonLinearAd, OverlayInterstitial, OverlayPosition, OverlaySize, PauseEvent, PiPConfiguration, PiPPosition, PlayEvent, PlayReadyKeySystemConfiguration, PlayerConfiguration, PlayerEventMap, PlayerList, PlayingEvent, PreloadType, Presentation, PresentationEventMap, PresentationModeChangeEvent, ProgressEvent, PublicationLoadStartEvent, PublicationLoadedEvent, PublicationOfflineEvent, Quality, QualityEvent, QualityEventMap, QualityList, RateChangeEvent, ReadyStateChangeEvent, RelatedChangeEvent, RelatedContent, RelatedContentEventMap, RelatedContentSource, RelatedHideEvent, RelatedShowEvent, RemoveCachingTaskEvent, RemoveTrackEvent, RemoveViewEvent, Representation, RepresentationChangeEvent, Request, RequestBody, RequestInit, RequestInterceptor, RequestLike, RequestMeasurer, RequestMethod, RequestSubType, RequestType, ResponseBody, ResponseInit, ResponseInterceptor, ResponseLike, ResponseType, RetryConfiguration, SSAIIntegrationId, SeamlessPeriodSwitchStrategy, SeamlessSwitchStrategy, SeekedEvent, SeekingEvent, ServerSideAdInsertionConfiguration, ServerSideAdIntegrationController, ServerSideAdIntegrationFactory, ServerSideAdIntegrationHandler, SkippedAdStrategy, SmartSightConfiguration, SmartSightIntegrationID, Source, SourceAbrConfiguration, SourceChangeEvent, SourceConfiguration, SourceDescription, SourceIntegrationId, SourceLatencyConfiguration, Sources, SpotXAdDescription, SpotxData, SpotxQueryParameter, StateChangeEvent, StereoChangeEvent, StreamOneAnalyticsIntegrationID, StreamOneConfiguration, StreamType, StringKeyOf, StylePropertyRecord, SupportedCustomTextTrackCueTypes, THEOplayerAdDescription, THEOplayerError, TTMLCue, TTMLExtent, TargetQualityChangedEvent, TextTrack, TextTrackAddCueEvent, TextTrackCue, TextTrackCueChangeEvent, TextTrackCueEnterEvent, TextTrackCueEventMap, TextTrackCueExitEvent, TextTrackCueList, TextTrackCueUpdateEvent, TextTrackDescription, TextTrackEnterCueEvent, TextTrackError, TextTrackErrorCode, TextTrackErrorEvent, TextTrackEventMap, TextTrackExitCueEvent, TextTrackReadyState, TextTrackReadyStateChangeEvent, TextTrackRemoveCueEvent, TextTrackStyle, TextTrackStyleEventMap, TextTrackType, TextTrackTypeChangeEvent, TextTrackUpdateCueEvent, TextTracksList, TheoAdDescription, TheoAds, TheoAdsEventsMap, TheoAdsLayout, TheoAdsLayoutOverride, TheoLiveApi, TheoLiveApiEventMap, TheoLiveConfiguration, TheoLivePublication, TheoLiveSource, ThumbnailResolution, TimeRanges, TimeUpdateEvent, TitaniumDRMConfiguration, TitaniumIntegrationID, TokenBasedTitaniumDRMConfiguration, Track, TrackChangeEvent, TrackEventMap, TrackList, TrackListEventMap, TrackUpdateEvent, TypedSource, UIConfiguration, UILanguage, UIRelatedContentEventMap, UniversalAdId, UpdateQualityEvent, Uplynk, UplynkAd, UplynkAdBeginEvent, UplynkAdBreak, UplynkAdBreakBeginEvent, UplynkAdBreakEndEvent, UplynkAdBreakEventMap, UplynkAdBreakList, UplynkAdBreakListEventMap, UplynkAdBreakSkipEvent, UplynkAdCompleteEvent, UplynkAdEndEvent, UplynkAdEventMap, UplynkAdFirstQuartileEvent, UplynkAdList, UplynkAdListEventMap, UplynkAdMidpointEvent, UplynkAdThirdQuartileEvent, UplynkAddAdBreakEvent, UplynkAddAssetEvent, UplynkAds, UplynkAsset, UplynkAssetEventMap, UplynkAssetId, UplynkAssetInfoResponse, UplynkAssetInfoResponseEvent, UplynkAssetList, UplynkAssetMovieRating, UplynkAssetTvRating, UplynkAssetType, UplynkConfiguration, UplynkDRMConfiguration, UplynkEventMap, UplynkExternalId, UplynkIntegrationID, UplynkPingConfiguration, UplynkPingErrorEvent, UplynkPingResponse, UplynkPingResponseEvent, UplynkPreplayBaseResponse, UplynkPreplayLiveResponse, UplynkPreplayResponse, UplynkPreplayResponseEvent, UplynkPreplayResponseType, UplynkPreplayVodResponse, UplynkRemoveAdBreakEvent, UplynkRemoveAdEvent, UplynkRemoveAssetEvent, UplynkResponseDrm, UplynkResponseLiveAd, UplynkResponseLiveAdBreak, UplynkResponseLiveAds, UplynkResponseVodAd, UplynkResponseVodAdBreak, UplynkResponseVodAdBreakOffset, UplynkResponseVodAdPlaceholder, UplynkResponseVodAds, UplynkSource, UplynkUiConfiguration, UplynkUpdateAdBreakEvent, UserActions, VPAIDMode, VR, VRConfiguration, VRDirection, VREventMap, VRPanoramaMode, VRPlayerConfiguration, VRState, VRStereoMode, VTTAlignSetting, VTTDirectionSetting, VTTLine, VTTLineAlignSetting, VTTPosition, VTTPositionAlignSetting, VTTScrollSetting, VendorCast, VendorCastEventMap, VerimatrixDRMConfiguration, VerimatrixIntegrationID, VideoFrameCallbackMetadata, VideoFrameRequestCallback, VideoQuality, View, ViewChangeEvent, ViewPositionChangeEvent, VimondDRMConfiguration, VimondIntegrationID, Visibility, VisibilityObserver, VisibilityObserverCallback, VoidPromiseCallback, VolumeChangeEvent, VudrmDRMConfiguration, VudrmIntegrationID, WaitUntilCallback, WaitingEvent, WebAudio, WebVTTCue, WebVTTRegion, WidevineKeySystemConfiguration, XstreamDRMConfiguration, XstreamIntegrationID, YospaceId, YouboraAnalyticsIntegrationID, YouboraOptions, cache, cast, features, players, registerContentProtectionIntegration, utils, version } from './THEOplayer.common';

/**
 * The social sharing API which can supplement the UI with a social sharing panel.
 *
 * @remarks
 * <br/> - Available since v2.14.5.
 *
 * @category UI
 * @public
 */
interface SocialSharing {
    /**
     * Whether the social sharing panel is showing.
     */
    showing: boolean;
    /**
     * List of social sharing items which can be shown.
     */
    items: SocialSharingItem[];
    /**
     * The URL that will be shared.
     */
    url: string;
    /**
     * Show the social sharing panel.
     */
    show(): void;
    /**
     * Hide the social sharing panel.
     */
    hide(): void;
}
/**
 * Represents a social media to which the player can share content.
 *
 * @remarks
 * <br/> - Available since v2.14.5.
 *
 * @category UI
 * @public
 */
interface SocialSharingItem {
    /**
     * The icon which is displayed as a clickable sharing option.
     *
     * @remarks
     * <br/> - It cannot be combined with {@link SocialSharingItem.text}.
     */
    icon?: string;
    /**
     * The label of the clickable sharing option.
     *
     * @remarks
     * <br/> - For example, to add the title.
     */
    label?: string;
    /**
     * The URL that will be shared.
     *
     * @remarks
     * <br/> - Overrides {@link SocialSharing.url}.
     * <br/> - This can also be a string with the `<URL>` token. The token will be replaced by {@link SocialSharing.url}.
     * <br/> - It can not be combined with {@link SocialSharingItem.text}.
     *
     * @defaultValue {@link SocialSharing.url} if present, else `location.href`.
     */
    src: string;
    /**
     * The text which is displayed as a clickable sharing option.
     *
     * @remarks
     * <br/> - For example, to add embed codes.
     * <br/> - It cannot be combined with {@link SocialSharingItem.icon} or {@link SocialSharingItem.src}.
     */
    text?: string;
}

/**
 * The up next API.
 *
 * @remarks
 * <br/> - Available since v2.15.0.
 *
 * @category UI
 * @public
 */
interface UpNextManager {
    /**
     * The up next source.
     */
    source: UpNextSource | undefined;
    /**
     * The up next bar UI component.
     * The bar property can be used to get or set an UpNextBar that contains information on the up next bar that
     * will be shown, such as the offset from which the up next bar will be displayed.
     */
    bar: UpNextBar;
    /**
     * The up next panel UI component.
     *
     * The panel property can be used to get or set an UpNextPanel that contains information on the up next panel that
     * will be shown at the end of the video, such as the duration of the countdown.
     */
    panel: UpNextPanel;
    /**
     * Transition to the page of the {@link UpNextManager.source}.
     */
    next(): void;
}
/**
 * Describes an up next source.
 *
 * @remarks
 * <br/> - Available since v2.15.
 *
 * @category UI
 * @public
 */
interface UpNextSource {
    /**
     * The URL to the thumbnail of the source.
     */
    image: string;
    /**
     * The title of the source.
     */
    title?: string;
    /**
     * The URL of the source.
     */
    link: string;
    /**
     * The duration of the source.
     */
    duration?: string;
}
/**
 * A bar which displays the up next source.
 *
 * @remarks
 * <br/> - The bar should be shown briefly before the current content ends.
 * <br/> - The bar covers a small part of the player.
 * <br/> - Available since v2.15.
 *
 * @category UI
 * @public
 */
interface UpNextBar {
    /**
     * Whether the bar is showing.
     */
    showing: boolean;
    /**
     * The offset, from the end of the video, after which the bar is shown.
     *
     * @remarks
     * Possible formats:
     * <br/> - A number or "number" for the offset in seconds.
     * <br/> - Percentage string (XX%) for a proportion of the duration.
     *
     * @defaultValue `10`
     */
    offset?: string | number;
    /**
     * Show the bar.
     */
    show(): void;
    /**
     * Hide the bar.
     */
    hide(): void;
}
/**
 * A panel which displays the up next source.
 *
 * @remarks
 * <br/> - The panel should be shown after the current source has ended.
 * <br/> - The panel covers the entire player.
 * <br/> - Available since v2.15.
 *
 * @category UI
 * @public
 */
interface UpNextPanel {
    /**
     * Whether the panel is showing.
     */
    showing: boolean;
    /**
     * The countdown after which the up next source is started.
     *
     * @remarks
     * <br/> - Countdown starts from the moment the panel is shown.
     *
     * Possible formats:
     * <br/> - number or "number": the countdown will be number seconds.
     * <br/> - Infinity: no countdown will happen, only the play button will appear to go to the video that is up next.
     *
     * @defaultValue `10`
     */
    countdownDuration?: string | number;
    /**
     * Whether the panel should be shown after the current source has ended.
     *
     * @defaultValue `true`
     */
    showUpNextPanel?: boolean;
    /**
     * Show the panel.
     */
    show(): void;
    /**
     * Hide the panel.
     */
    hide(): void;
}

/**
 * The player API extended with UI functionality.
 *
 * @remarks
 * <br/> - Only available with the feature `'ui'`.
 *
 * @category API
 * @category Player
 * @public
 */
declare class Player extends ChromelessPlayer {
    constructor(element: HTMLElement, configuration?: UIPlayerConfiguration);
    /**
     * Whether the player controls are visible.
     */
    controls: boolean;
    /**
     * The Video.js player on which the UI is built.
     */
    readonly ui: videojs.Player;
    /**
     * The presentation mode of the player.
     *
     * @deprecated Superseded by {@link Presentation.currentMode} and {@link Presentation.requestMode}.
     *
     * @defaultValue `'inline'`
     */
    presentationMode?: PresentationMode;
    /**
     * The related content UI API.
     *
     * @remarks
     * <br/> - Only available with the feature `'relatedcontent'`.
     */
    readonly related?: UIRelatedContent;
    /**
     * The social sharing UI API.
     *
     * @remarks
     * <br/> - Only available with the feature `'social'`.
     */
    readonly social?: SocialSharing;
    /**
     * The up next UI API.
     *
     * @remarks
     * <br/> - Only available with the feature `'upnext'`.
     */
    readonly upnext?: UpNextManager;
}

export { ChromelessPlayer, Player, PresentationMode, SocialSharing, SocialSharingItem, UIPlayerConfiguration, UIRelatedContent, UpNextBar, UpNextManager, UpNextPanel, UpNextSource, videojs };
export as namespace THEOplayer;
