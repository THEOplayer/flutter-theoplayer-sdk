/**
 * Fired when an event occurs.
 *
 * @category Events
 * @public
 */
interface Event<TType extends string = string> {
    /**
     * The type of the event.
     */
    type: TType;
    /**
     * The creation date of the event.
     */
    date: Date;
}

/**
 * The function to be executed when an event occurred.
 *
 * @category Events
 * @public
 */
type EventListener<TEvent extends Event> = (event: TEvent) => void;

/**
 * A record used to map events.
 * Each entry contains an event name with associated event interface.
 *
 * @example
 * ```
 * {
 *   'statechange': StateChangeEvent,
 *   'error': ErrorEvent
 * }
 * ```
 *
 * @category Events
 * @public
 */
type EventMap<TType extends string> = {
    [type in TType]: Event;
};
/**
 * Helper type to extract string keys from type objects.
 *
 * @public
 */
type StringKeyOf<T> = Extract<keyof T, string>;
/**
 * Dispatches events that are fired.
 *
 * @category Events
 * @public
 */
interface EventDispatcher<TEventMap extends EventMap<StringKeyOf<TEventMap>>> {
    /**
     * Add the given listener for the given event type(s).
     *
     * @param type - The type of the event.
     * @param listener - The callback which is executed when the event occurs.
     */
    addEventListener<TType extends StringKeyOf<TEventMap>>(type: TType | readonly TType[], listener: EventListener<TEventMap[TType]>): void;
    /**
     * Remove the given listener for the given event type(s).
     *
     * @param type - The type of the event.
     * @param listener - The callback which will be removed.
     */
    removeEventListener<TType extends StringKeyOf<TEventMap>>(type: TType | readonly TType[], listener: EventListener<TEventMap[TType]>): void;
}

/**
 * Fired when the ad has stalled playback to buffer.
 *
 * @category Ads
 * @category Events
 * @public
 */
interface AdBufferingEvent extends AdEvent<'adbuffering'> {
    /**
     * The ad which is buffered.
     */
    readonly ad: GoogleImaAd;
}

/**
 * Fired when an ads list is loaded.
 *
 * @category Ads
 * @category Events
 * @public
 */
interface AdMetadataEvent extends Event<'admetadata'> {
}

/**
 * The Google DAI API.
 *
 * @remarks
 * <br/> - Available since v3.7.0.
 *
 * @category Ads
 * @public
 */
interface GoogleDAI {
    /**
     * Returns the content time without ads for a given stream time. Returns the given stream time for live streams.
     *
     * @param time - The stream time with inserted ads (in seconds).
     */
    contentTimeForStreamTime(time: number): number;
    /**
     * Returns the stream time with ads for a given content time. Returns the given content time for live streams.
     *
     * @param time - The content time without any ads (in seconds).
     */
    streamTimeForContentTime(time: number): number;
    /**
     * Replaces all the ad tag parameters used for upcoming ad requests for a live stream.
     *
     * @param adTagParameters - The new ad tag parameters.
     */
    replaceAdTagParameters(adTagParameters?: Record<string, string>): void;
    /**
     * Whether snapback is enabled. When enabled and the user seeks over multiple ad breaks, the last ad break that was seeked past will be played.
     */
    snapback: boolean;
    /**
     * A source transformer which will receive the source as returned from Google DAI before loading it in the player. This capability can be useful
     * if you need to add authentication tokens or signatures to the source URL as returned by Google.
     */
    sourceTransformer: (url: string) => string | Promise<string>;
}

/**
 * A synchronous or asynchronous return type
 *
 * @public
 */
type MaybeAsync<T> = T | PromiseLike<T>;

/**
 * A code that indicates the type of error that has occurred.
 *
 * @category Errors
 * @public
 */
declare enum ErrorCode {
    /**
     * The configuration provided is invalid.
     */
    CONFIGURATION_ERROR = 1000,
    /**
     * The license provided is invalid.
     */
    LICENSE_ERROR = 2000,
    /**
     * The provided license does not contain the current domain.
     */
    LICENSE_INVALID_DOMAIN = 2001,
    /**
     * The current source is not allowed in the license provided.
     */
    LICENSE_INVALID_SOURCE = 2002,
    /**
     * The license has expired.
     */
    LICENSE_EXPIRED = 2003,
    /**
     * The provided license does not contain the necessary feature.
     */
    LICENSE_INVALID_FEATURE = 2004,
    /**
     * The source provided is not valid.
     */
    SOURCE_INVALID = 3000,
    /**
     * The provided source is not supported.
     */
    SOURCE_NOT_SUPPORTED = 3001,
    /**
     * The manifest could not be loaded.
     */
    MANIFEST_LOAD_ERROR = 4000,
    /**
     * An Error related to Cross-origin resource sharing (CORS).
     *
     * @remarks
     * <br/> - See {@link https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS | Cross-Origin Resource Sharing (CORS)}.
     */
    MANIFEST_CORS_ERROR = 4001,
    /**
     * The manifest could not be parsed.
     */
    MANIFEST_PARSE_ERROR = 4002,
    /**
     * The media is not supported.
     */
    MEDIA_NOT_SUPPORTED = 5000,
    /**
     * The media could not be loaded.
     */
    MEDIA_LOAD_ERROR = 5001,
    /**
     * The media could not be decoded.
     */
    MEDIA_DECODE_ERROR = 5002,
    /**
     * An error related to playback through AVPlayer in the iOS or tvOS SDK.
     */
    MEDIA_AVPLAYER_ERROR = 5003,
    /**
     * The fetching process for the media resource was aborted by the user agent at the user's request.
     */
    MEDIA_ABORTED = 5004,
    /**
     * An error related to network has been detected.
     */
    NETWORK_ERROR = 6000,
    /**
     * The network has timed out.
     */
    NETWORK_TIMEOUT = 6001,
    /**
     * An error related to the content protection.
     */
    CONTENT_PROTECTION_ERROR = 7000,
    /**
     * The DRM provided is not supported on this platform.
     */
    CONTENT_PROTECTION_NOT_SUPPORTED = 7001,
    /**
     * The media is DRM protected, but no content protection configuration was provided.
     */
    CONTENT_PROTECTION_CONFIGURATION_MISSING = 7002,
    /**
     * The content protection configuration is invalid.
     */
    CONTENT_PROTECTION_CONFIGURATION_INVALID = 7003,
    /**
     * The DRM initialization data could not be parsed.
     */
    CONTENT_PROTECTION_INITIALIZATION_INVALID = 7004,
    /**
     * The content protection's certificate could not be loaded.
     */
    CONTENT_PROTECTION_CERTIFICATE_ERROR = 7005,
    /**
     * The content protection's certificate is invalid.
     */
    CONTENT_PROTECTION_CERTIFICATE_INVALID = 7006,
    /**
     * The content protection's license could not be loaded.
     */
    CONTENT_PROTECTION_LICENSE_ERROR = 7007,
    /**
     * The content protection's license is invalid.
     */
    CONTENT_PROTECTION_LICENSE_INVALID = 7008,
    /**
     * The content protection's key has expired.
     */
    CONTENT_PROTECTION_KEY_EXPIRED = 7009,
    /**
     * The content protection's key is missing.
     */
    CONTENT_PROTECTION_KEY_MISSING = 7010,
    /**
     * All qualities require HDCP, but the current output does not fulfill HDCP requirements.
     */
    CONTENT_PROTECTION_OUTPUT_RESTRICTED = 7011,
    /**
     * Something went wrong in the internal logic of the content protection system.
     */
    CONTENT_PROTECTION_INTERNAL_ERROR = 7012,
    /**
     * Loading subtitles has failed.
     */
    SUBTITLE_LOAD_ERROR = 8000,
    /**
     * Loading subtitles has failed due to CORS.
     *
     * @remarks
     * <br/> - See {@link https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS | Cross-Origin Resource Sharing (CORS)}.
     */
    SUBTITLE_CORS_ERROR = 8001,
    /**
     * Parsing subtitles has failed.
     */
    SUBTITLE_PARSE_ERROR = 8002,
    /**
     * This error occurs when VR is not supported on the current platform.
     */
    VR_PLATFORM_UNSUPPORTED = 9000,
    /**
     * Changing the presentation to VR was not possible.
     */
    VR_PRESENTATION_ERROR = 9001,
    /**
     * Something went wrong with an ad.
     */
    AD_ERROR = 10000,
    /**
     * An ad blocker has been detected.
     */
    AD_BLOCKER_DETECTED = 10001,
    /**
     * Changing the presentation to fullscreen was not possible.
     */
    FULLSCREEN_ERROR = 11000,
    /**
     * Changing the presentation to picture-in-picture was not possible.
     */
    PICTURE_IN_PICTURE_ERROR = 11001,
    /**
     * Something went wrong while caching a source.
     */
    CACHE_SOURCE_ERROR = 12000,
    /**
     * Something went wrong while caching content protection's license.
     */
    CACHE_CONTENT_PROTECTION_ERROR = 12001,
    /**
     * Something went wrong with THEOlive playback.
     */
    THEO_LIVE_UNKNOWN_ERROR = 13000,
    /**
     * The THEOlive channel could not be played because it was not found. This can be because it was never created, it has been deleted or locked.
     */
    THEO_LIVE_CHANNEL_NOT_FOUND = 13001,
    /**
     * The THEOlive channel is a demo channel and the demo window has expired.
     */
    THEO_LIVE_END_OF_DEMO = 13002,
    /**
     * A fatal error occurred regarding THEOlive analytics.
     */
    THEO_LIVE_ANALYTICS_ERROR = 13003
}
/**
 * The category of an error.
 *
 * @category Errors
 * @public
 */
declare enum ErrorCategory {
    /**
     * This category clusters all errors related to the configuration.
     */
    CONFIGURATION = 1,
    /**
     * This category clusters all errors related to the license.
     */
    LICENSE = 2,
    /**
     * This category clusters all errors related to the source.
     */
    SOURCE = 3,
    /**
     * This category clusters all errors related to the manifest.
     */
    MANIFEST = 4,
    /**
     * This category clusters all errors related to the media.
     */
    MEDIA = 5,
    /**
     * This category clusters all errors related to the network.
     */
    NETWORK = 6,
    /**
     * This category clusters all errors related to the content protection.
     */
    CONTENT_PROTECTION = 7,
    /**
     * This category clusters all errors related to the subtitles.
     */
    SUBTITLE = 8,
    /**
     * This category clusters all errors related to VR.
     */
    VR = 9,
    /**
     * This category clusters all errors related to ads.
     */
    AD = 10,
    /**
     * This category clusters all errors related to fullscreen.
     */
    FULLSCREEN = 11,
    /**
     * This category clusters all errors related to caching.
     */
    CACHE = 12,
    /**
     * This category clusters all errors related to THEOlive.
     */
    THEOLIVE = 13
}
/**
 * The category of an error.
 *
 * @category Errors
 * @public
 */
declare namespace ErrorCategory {
    /**
     * Determine the `ErrorCategory` of the given {@link ErrorCode}.
     *
     * @param code - The {@link ErrorCode} to determine the `ErrorCategory` of.
     */
    function fromCode(code: ErrorCode): ErrorCategory;
}

/**
 * A handler for a server-side ad integration.
 *
 * You can implement one or more of these methods to hook into various parts
 * of the player's lifecycle and perform your integration-specific ad handling.
 *
 * Use the {@link ServerSideAdIntegrationController} provided by {@link ServerSideAdIntegrationFactory}
 * to update the state of your integration.
 *
 * @see {@link Ads.registerServerSideIntegration}
 *
 * @category Ads
 */
interface ServerSideAdIntegrationHandler {
    /**
     * Handler which will be called when a new source is loaded into the player.
     *
     * This allows the integration to transform the source description,
     * e.g. by calling an external service to replace {@link TypedSource.src | the content URL},
     * or by adding a fixed pre-roll linear ad to {@link SourceDescription.ads | the list of ads}.
     *
     * @remarks
     * - If this handler throws an error, the player fires a fatal {@link PlayerEventMap.error | `error`} event
     *   (as if by calling {@link ServerSideAdIntegrationController.fatalError}).
     *
     * @param source
     */
    setSource?(source: SourceDescription): MaybeAsync<SourceDescription>;
    /**
     * Handler which will be called when an ad is requested to be skipped.
     *
     * To skip the ad, the handler should call {@link ServerSideAdIntegrationController.skipAd}.
     *
     * @remarks
     * - This is only called for ads whose {@link Ad.integration}
     *   matches {@link ServerSideAdIntegrationController.integration}.
     * - If this handler is missing, the player will always skip the ad
     *   by calling {@link ServerSideAdIntegrationController.skipAd}.
     * - If this handler throws an error, the player fires a non-fatal {@link AdsEventMap.aderror | `aderror`} event
     *   (as if by calling {@link ServerSideAdIntegrationController.error}).
     *
     * @param ad
     */
    skipAd?(ad: Ad): void;
    /**
     * Handler which will be called before a new source is loaded into the player,
     * or before the player is destroyed.
     *
     * This allows the integration to clean up any source-specific resources,
     * such as scheduled ads or pending HTTP requests.
     *
     * @remarks
     * - If this handler is missing, the player will remove all remaining ads
     *   by calling {@link ServerSideAdIntegrationController.removeAllAds}.
     * - If this handler throws an error, the player fires a fatal {@link PlayerEventMap.error | `error`} event
     *   (as if by calling {@link ServerSideAdIntegrationController.fatalError}).
     */
    resetSource?(): MaybeAsync<void>;
    /**
     * Handler which will be called when the player is {@link ChromelessPlayer.destroy | destroyed}.
     *
     * This allows the integration to clean up any resources, such as DOM elements or event listeners.
     */
    destroy?(): MaybeAsync<void>;
}
/**
 * A controller to be used by your {@link ServerSideAdIntegrationHandler}
 * to update the state of your custom server-side ad integration.
 *
 * @see {@link Ads.registerServerSideIntegration}
 *
 * @category Ads
 */
interface ServerSideAdIntegrationController {
    /**
     * The identifier for this integration, as it was passed to {@link Ads.registerServerSideIntegration}.
     */
    readonly integration: CustomAdIntegrationKind;
    /**
     * The scheduled ads managed by this integration.
     *
     * @remarks
     * Use {@link ServerSideAdIntegrationController.createAd} and {@link ServerSideAdIntegrationController.removeAd} to add or remove ads.
     */
    readonly ads: readonly Ad[];
    /**
     * The scheduled ad breaks managed by this integration.
     *
     * @remarks
     * Use {@link ServerSideAdIntegrationController.createAdBreak} and {@link ServerSideAdIntegrationController.removeAdBreak} to add or remove ad breaks.
     */
    readonly adBreaks: readonly AdBreak[];
    /**
     * Create a new ad.
     *
     * @remarks
     * - The ad will be added to {@link Ads.scheduledAds}.
     *
     * @param init
     *   The initial properties to be set on the created ad.
     * @param [adBreak]
     *   If given, appends the ad to the given existing {@link AdBreak}.
     *   Otherwise, appends the ad to a new or existing {@link AdBreak} with the configured {@link AdInit.timeOffset}.
     */
    createAd(init: AdInit, adBreak?: AdBreak): Ad;
    /**
     * Update the given ad.
     *
     * @param ad
     *   The ad to be updated.
     * @param init
     *   The properties to be updated on the ad.
     */
    updateAd(ad: Ad, init: Partial<AdInit>): void;
    /**
     * Update the playback progression of the given ad.
     *
     * @remarks
     * - The player will fire progression events such as {@link AdsEventMap.adfirstquartile},
     *   {@link AdsEventMap.admidpoint} and {@link AdsEventMap.adthirdquartile}.
     *
     * @param ad
     *   The ad to be updated.
     * @param progress
     *   The playback progress, as a number between 0 (at the start of the ad) and 1 (at the end of the ad).
     * @throws Error
     *   If the ad is not {@link ServerSideAdIntegrationController.beginAd | started}.
     */
    updateAdProgress(ad: Ad, progress: number): void;
    /**
     * Begin the given ad.
     *
     * @remarks
     * - The ad will be added to {@link Ads.currentAds}.
     * - An {@link AdsEventMap.adbegin} event will be fired.
     *
     * @param ad
     */
    beginAd(ad: Ad): void;
    /**
     * End the given ad.
     *
     * @remarks
     * - The ad will be removed from {@link Ads.currentAds}.
     * - If the ad was currently playing, an {@link AdsEventMap.adend} event will be fired.
     *
     * @param ad
     */
    endAd(ad: Ad): void;
    /**
     * Skip the given ad.
     *
     * @remarks
     * - The ad will be removed from {@link Ads.currentAds}.
     * - If the ad was currently playing, an {@link AdsEventMap.adskip} event will be fired.
     *
     * @param ad
     */
    skipAd(ad: Ad): void;
    /**
     * Remove the given ad.
     *
     * @remarks
     * - The ad will be removed from {@link Ads.currentAds} and {@link Ads.scheduledAds}.
     * - If the ad was currently playing, it will first be {@link ServerSideAdIntegrationController.endAd | ended}.
     *
     * @param ad
     */
    removeAd(ad: Ad): void;
    /**
     * Create a new ad break.
     *
     * This can be used to indicate where ad breaks can be expected in advance,
     * before populating those ad breaks with ads.
     *
     * @remarks
     * - The ad break will be added to {@link ServerSideAdIntegrationController.adBreaks} and {@link Ads.scheduledAdBreaks}.
     *
     * @param init
     *   The initial properties to be set on the created ad break.
     * @throws Error
     *   If there is already an existing ad break with the given {@link AdBreakInit.timeOffset}.
     */
    createAdBreak(init: AdBreakInit): AdBreak;
    /**
     * Update the given ad break.
     *
     * @param adBreak
     *   The ad break to be updated.
     * @param init
     *   The properties to be updated on the ad break.
     */
    updateAdBreak(adBreak: AdBreak, init: Partial<AdBreakInit>): void;
    /**
     * Remove the given ad break and all of its ads.
     *
     * @remarks
     * - The ad break will be removed from {@link ServerSideAdIntegrationController.adBreaks} and {@link Ads.scheduledAdBreaks}.
     * - Any remaining ads in the ad break will be {@link ServerSideAdIntegrationController.removeAd | removed}.
     *
     * @param adBreak
     *   The ad break to be removed.
     */
    removeAdBreak(adBreak: AdBreak): void;
    /**
     * Remove all ads and ad breaks.
     *
     * @remarks
     * - This is a shorthand for calling {@link ServerSideAdIntegrationController.removeAdBreak}
     *   on all ad breaks in {@link ServerSideAdIntegrationController.adBreaks}.
     */
    removeAllAds(): void;
    /**
     * Fire an {@link AdsEventMap.aderror | `aderror`} event on the player.
     *
     * This does not stop playback.
     *
     * @param error - The error.
     */
    error(error: Error): void;
    /**
     * Fire a fatal {@link PlayerEventMap.error | `error`} event on the player.
     *
     * This stops playback immediately. Use {@link ChromelessPlayer.source} to load a new source.
     *
     * @param error
     *   The error.
     * @param [code]
     *   The error code. By default, this is set to {@link ErrorCode.AD_ERROR}.
     */
    fatalError(error: Error, code?: ErrorCode): void;
}
/**
 * An initializer for a custom {@link Ad}.
 *
 * @see {@link ServerSideAdIntegrationController.createAd}
 * @see {@link ServerSideAdIntegrationController.updateAd}
 *
 * @category Ads
 */
interface AdInit extends Omit<Partial<Ad>, 'integration' | 'adBreak'> {
    /**
     * The type of the ad.
     */
    type: AdType;
    /**
     * The time offset at which content will be paused to play the ad, in seconds.
     */
    timeOffset?: number;
    /**
     * Additional integration-specific data associated with this ad.
     */
    customData?: unknown;
}
/**
 * An initializer for a custom {@link AdBreak}.
 *
 * @see {@link ServerSideAdIntegrationController.createAdBreak}
 * @see {@link ServerSideAdIntegrationController.updateAdBreak}
 *
 * @category Ads
 */
interface AdBreakInit {
    /**
     * The time offset at which content will be paused to play the ad break, in seconds.
     */
    timeOffset: number;
    /**
     * The duration of the ad break, in seconds.
     */
    maxDuration?: number | undefined;
    /**
     * Additional integration-specific data associated with this ad break.
     */
    customData?: unknown;
}
/**
 * Factory to create an {@link ServerSideAdIntegrationHandler}.
 *
 * @param controller
 *   The controller to use.
 * @return The new server-side ad integration handler.
 *
 * @see {@link Ads.registerServerSideIntegration}
 *
 * @category Ads
 */
type ServerSideAdIntegrationFactory = (controller: ServerSideAdIntegrationController) => ServerSideAdIntegrationHandler;

/**
 * Fired when the {@link https://developers.google.com/interactive-media-ads/docs/sdks/html5/client-side/reference/js/google.ima.AdsManager | google.ima.AdsManager} is created.
 *
 * @category Ads
 * @category Events
 * @public
 */
interface AdsManagerLoadedEvent extends Event<'adsmanagerloaded'> {
    /**
     * The {@link https://developers.google.com/interactive-media-ads/docs/sdks/html5/client-side/reference/js/google.ima.AdsManager | google.ima.AdsManager}
     */
    readonly adsManager: any;
}

/**
 * Represents a VAST creative. It is either a linear or non-linear ad.
 *
 * @category Ads
 * @public
 */
interface Ad {
    /**
     * The source ad server information included in the ad response.
     *
     * @remarks
     * <br/> - Available when the {@link Ad.readyState} is `'ready'`.
     */
    adSystem: string | undefined;
    /**
     * The integration of the ad, represented by a value from {@link AdIntegrationKind}
     * or {@link CustomAdIntegrationKind | the identifier of a custom integration} added with {@link Ads.registerServerSideIntegration}.
     *
     * @defaultValue `'csai'`
     *
     * @remarks
     * <br/> - The `'theo'` integration naming is deprecated and has been replaced with `'csai'`.
     */
    integration?: AdIntegrationKind | CustomAdIntegrationKind;
    /**
     * The type of the ad.
     */
    type: AdType;
    /**
     * The identifier of the creative.
     *
     * @remarks
     * <br/> - Available when the {@link Ad.readyState} is `'ready'`.
     */
    id: string | undefined;
    /**
     * The ready state of the ad.
     */
    readyState?: AdReadyState;
    /**
     * The ad break which the ad is part of.
     *
     * @remarks
     * <br/> - Available for VAST-ads.
     */
    adBreak: AdBreak;
    /**
     * The duration of the ad, in seconds.
     *
     * @remarks
     * <br/> - Available when the {@link Ad.readyState} is `'ready'`.
     * <br/> - Only available for LinearAd.
     */
    duration: number | undefined;
    /**
     * The width of the ad, in pixels.
     *
     * @remarks
     * <br/> - Available when the {@link Ad.readyState} is `'ready'`.
     */
    width: number | undefined;
    /**
     * The height of the ad.
     *
     * @remarks
     * <br/> - Available when the {@link Ad.readyState} is `'ready'`.
     */
    height: number | undefined;
    /**
     * The URI of the ad content.
     *
     * @remarks
     * <br/> - Available when the {@link Ad.readyState} is `'ready'`.
     */
    resourceURI: string | undefined;
    /**
     * The website of the advertisement.
     *
     * @remarks
     * <br/> - Available when the {@link Ad.readyState} is `'ready'`.
     */
    clickThrough: string | undefined;
    /**
     * List of companions which can be displayed outside the player.
     *
     * @remarks
     * <br/> - Available when the {@link Ad.readyState} is `'ready'`.
     * <br/> - Only supported for `'csai'` and `'google-dai'`.
     */
    companions: CompanionAd[];
    /**
     * Offset after which the ad break may be skipped, in seconds.
     *
     * @remarks
     * <br/> - Available when the {@link Ad.readyState} is `'ready'`.
     * <br/> - If the offset is -1, the ad is unskippable.
     * <br/> - If the offset is 0, the ad is immediately skippable.
     * <br/> - Otherwise it must be a positive number indicating the offset.
     */
    skipOffset: number | undefined;
    /**
     * The identifier of the selected creative for the ad.
     *
     * @remarks
     * <br/> - Available when the {@link Ad.readyState} is `'ready'`.
     */
    creativeId: string | undefined;
    /**
     * The list of universal ad ID information of the selected creative for the ad.
     *
     * @remarks
     * <br/> - Only supported for `'csai'` and `'google-ima'`.
     */
    universalAdIds: UniversalAdId[];
    /**
     * Additional integration-specific data associated with this ad.
     */
    customData: unknown;
    /**
     * Whether the ad is a slate or not.
     *
     * @remarks
     * </br> - Only used for THEOads ads.
     */
    isSlate: boolean;
}
/**
 * The type of the ad, represented by a value from the following list:
 * <br/> - `'linear'`
 * <br/> - `'nonlinear'`
 *
 * @category Ads
 * @public
 */
type AdType = 'linear' | 'nonlinear';
/**
 * The ad preloading strategy, represented by a value from the following list:
 * <br/> - `'none'`: Ads are not preloaded.
 * <br/> - `'midroll-and-postroll'`: Media files of mid- and postrolls are preloaded.
 *
 * @remarks
 * <br/> - For Google IMA, preloading starts 8 seconds before ad playback.
 *
 * @category Ads
 * @public
 */
type AdPreloadType = 'none' | 'midroll-and-postroll';
/**
 * The ad readiness state, represented by a value from the following list:
 * <br/> - `'none'`: The ad not loaded state.
 * <br/> - `'ready'`: The ad loaded state.
 *
 * @remarks
 * <br/> - An ad is loaded when the ad resource (e.g. VAST file) is downloaded.
 *
 * @category Ads
 * @public
 */
type AdReadyState = 'none' | 'ready';
/**
 * Describes the configuration of advertisement.
 *
 * @category Ads
 * @public
 */
interface AdsConfiguration {
    /**
     * Allows configuring which mime types are allowed during ad playback.
     *
     * @remarks
     * <br/> - If set to an array, all ads with another mime types will be ignored.
     * <br/> - If set to `undefined`:
     *   - for Google IMA, the ad system will pick media based on the browser's capabilities.
     *   - for the other integrations, the ad system will ignore all streaming ads.
     *
     * @defaultValue `undefined`
     */
    allowedMimeTypes?: string[];
    /**
     * Whether an advertisement duration countdown will be shown in the UI.
     *
     * @deprecated use {@link GoogleImaConfiguration.uiElements} instead
     *
     * @remarks
     * <br/> - Available since v2.22.9.
     * <br/> - This feature is only available for Google IMA.
     *
     * @defaultValue `true`
     */
    showCountdown?: boolean;
    /**
     * Whether media files of mid- and postrolls are preloaded.
     *
     * @remarks
     * <br/> - This feature is only available for Google IMA.
     *
     * @defaultValue `'midroll-and-postroll'`
     */
    preload?: AdPreloadType;
    /**
     * The iframe policy for VPAID ads.
     *
     * @remarks
     * <br/> - This feature is only available for Google IMA and SpotX.
     *
     * @defaultValue `'enabled'`
     */
    vpaidMode?: VPAIDMode;
    /**
     * The Google IMA configuration.
     */
    googleIma?: GoogleImaConfiguration;
    /**
     * Whether to enable THEOads support.
     *
     * @remarks
     * <br/> - Available since 8.2.0.
     * <br/> - This must be set to `true` in order to schedule a {@link TheoAdDescription}.
     *
     * @defaultValue `false`
     */
    theoads?: boolean;
}
/**
 * Describes the configuration of Google IMA.
 *
 * @category Ads
 * @public
 */
interface GoogleImaConfiguration {
    /**
     * Whether the native (mobile) IMA implementation will be used.
     *
     * @internal
     */
    useNativeIma: boolean;
    /**
     * Whether to use an ad UI element for clickthrough and displaying other ad UI.
     *
     * @remarks
     * <br/> - Optional toggle for turning on usage of the adUiElement when using Google DAI SSAI. This is
     * necessary for showing ads if they have UI specified, such as UI for GDPR compliance. If ads have extra
     * UI elements specified and this is not enabled, ads with UI will not play. Enabling this option will
     * remove the Learn More button and disable keyboard interactions with the ad.
     * <br/> - This only applies to Google DAI SSAI content. IMA CSAI always uses the adUiElement.
     */
    useAdUiElementForSsai?: boolean;
    /**
     * The maximum recommended bitrate in kbit/s. Ads with a bitrate below the specified maximum will be picked.
     *
     * @remarks
     * <br/> - When set to -1, it will select the ad with the highest bitrate.
     * <br/> - If there is no ad below the specified maximum, the ad closest to the bitrate will be picked.
     *
     * @defaultValue -1
     */
    bitrate?: number;
    /**
     * The language code of the UI elements. See {@link https://developers.google.com/interactive-media-ads/docs/sdks/html5/client-side/localization | localization docs} for more information.
     *
     * @remarks
     * <br/> - This will default to {@link UIConfiguration.language} when not specified.
     *
     */
    language?: string;
    /**
     * The UI elements passed to Google IMA. See {@link https://developers.google.com/interactive-media-ads/docs/sdks/html5/client-side/reference/js/google.ima#.UiElements | Google IMA docs} for more information.
     *
     * @remarks
     * <br/> - Available since v6.13.0.
     */
    uiElements?: string[];
}
/**
 * Represents a non-linear ad in the VAST specification.
 *
 * @category Ads
 * @public
 */
interface NonLinearAd extends Ad {
    /**
     * The alternative description for the ad.
     *
     * @remarks
     * <br/> - Available when the {@link Ad.readyState} is `'ready'`.
     */
    altText: string | undefined;
    /**
     * The website of the ad.
     *
     * @remarks
     * <br/> - Available when the {@link Ad.readyState} is `'ready'`.
     */
    clickThrough: string | undefined;
    /**
     * The HTML-string with the content of the ad.
     *
     * @remarks
     * <br/> - Available when the {@link Ad.readyState} is `'ready'`.
     */
    contentHTML: string | undefined;
}
/**
 * The delivery type of the ad content file, represented by a value from the following list:
 * <br/> - `'progressive'`: Delivered through progressive download protocols (e.g. HTTP).
 * <br/> - `'streaming'`: Delivered through streaming download protocols.
 *
 * @category Ads
 * @public
 */
type DeliveryType = 'progressive' | 'streaming';
/**
 * Represents metadata of a media file with ad content.
 *
 * @remarks
 * <br/> - This metadata is retrieved from the VAST file.
 *
 * @category Ads
 * @public
 */
interface MediaFile {
    /**
     * The delivery type of the video file.
     */
    delivery: DeliveryType;
    /**
     * The MIME type for the file container.
     */
    type: string;
    /**
     * The native width of the video file, in pixels.
     */
    width: number;
    /**
     * The native height of the video file, in pixels.
     */
    height: number;
    /**
     * The URI of the VAST content.
     */
    contentURL: string;
}
/**
 * Represents metadata of a closed caption for a media file with ad content.
 *
 * @remarks
 * <br/> - This metadata is retrieved from the VAST file.
 *
 * @category Ads
 * @public
 */
interface ClosedCaptionFile {
    /**
     * The MIME type for the file.
     */
    type: string;
    /**
     * The language of the Closed Caption file using ISO 631-1 codes. An optional locale
     * suffix can also be provided.
     *
     * @example
     * "en", "en-US", "zh-TW"
     */
    language: string;
    /**
     * The URI of the file providing Closed Caption info for the media file.
     */
    contentURL: string;
}
/**
 * Represents a linear ad in the VAST specification.
 *
 * @category Ads
 * @public
 */
interface LinearAd extends Ad {
    /**
     * The duration of the ad, in seconds.
     *
     * @remarks
     * <br/> - Available when the {@link Ad.readyState} is `'ready'`.
     */
    duration: number;
    /**
     * List of media files which contain metadata about ad video files.
     */
    mediaFiles: MediaFile[];
    /**
     * The URL of the media file loaded for ad playback. Returns undefined if no URL is available yet.
     *
     * @remarks
     * <br/> - Available when the ad break has started.
     */
    mediaUrl?: string;
    /**
     * List of closed caption files which contain metadata about the closed captions that accompany any media files.
     */
    closedCaptionFiles: ClosedCaptionFile[];
}
/**
 * Represents a Google IMA creative compliant to the VAST specification.
 *
 * @remarks
 * <br/> - Available since v2.60.0.
 *
 * @category Ads
 * @public
 */
interface GoogleImaAd extends Ad {
    /**
     * The bitrate of the currently playing creative as listed in the VAST response or 0.
     */
    readonly bitrate: number;
    /**
     * Record of custom parameters for the ad at the time of ad trafficking.
     * Each entry contains a parameter name with associated value.
     *
     * @remarks
     * <br/> - Available when the {@link Ad.readyState} is `'ready'`.
     */
    traffickingParameters: {
        [parameterKey: string]: string;
    } | undefined;
    /**
     * Return title of the advertisement.
     *
     * @remarks
     * <br/> - Available when the {@link Ad.readyState} is `'ready'`.
     */
    title: string | undefined;
    /**
     * The custom parameters for the ad at the time of ad trafficking, as a string.
     *
     * @remarks
     * <br/> - A parsed version is available as {@link GoogleImaAd.traffickingParameters}.
     * <br/> - Available when the {@link Ad.readyState} is `'ready'`.
     */
    traffickingParametersString: string | undefined;
    /**
     * List of wrapper ad identifiers as specified in the VAST response.
     */
    wrapperAdIds: string[];
    /**
     * List of wrapper ad systems as specified in the VAST response.
     */
    wrapperAdSystems: string[];
    /**
     * List of wrapper creative identifiers.
     *
     * @remarks
     * <br/> - Starts with the first wrapper ad.
     */
    wrapperCreativeIds: string[];
    /**
     * The url of the chosen media file.
     *
     * @remarks
     * <br/> - Available when the {@link Ad.readyState} is `'ready'`.
     */
    mediaUrl: string | undefined;
    /**
     * The content type of the ad.
     *
     * @remarks
     * <br/> - Available when the {@link Ad.readyState} is `'ready'`.
     * <br/> - For linear ads, the content type is only going to be available after the `'adbegin'` event, when the media file is selected.
     */
    contentType: string | undefined;
    /**
     * The identifier of the API framework needed to execute the ad.
     *
     * @remarks
     * <br/> - Available when the {@link Ad.readyState} is `'ready'`.
     * <br/> - This corresponds with the apiFramework specified in vast.
     */
    apiFramework: string | undefined;
    /**
     * The description of the ad from the VAST response.
     *
     * @remarks
     * <br/> - Available since 8.6.0.
     * <br/> - Available for `google-ima` and `google-dai` integrations only.
     */
    description: string | undefined;
}
/**
 * Represents the information regarding the universal identifier of an ad.
 *
 * @category Ads
 * @public
 */
interface UniversalAdId {
    /**
     * The registry associated with cataloging the UniversalAdId of the selected creative for the ad.
     *
     * @remarks
     * <br/> - Returns the registry value, or "unknown" if unavailable.
     */
    adIdRegistry: string;
    /**
     * The UniversalAdId of the selected creative for the ad.
     *
     * @remarks
     * <br/> - Returns the id value or "unknown" if unavailable.
     */
    adIdValue: string;
}
/**
 * Represents an ad break in the VMAP specification or an ad pod in the VAST specification.
 *
 * @category Ads
 * @public
 */
interface AdBreak {
    /**
     * The integration of the ad break, represented by a value from {@link AdIntegrationKind}
     * or {@link CustomAdIntegrationKind | the identifier of a custom integration} registered with {@link Ads.registerServerSideIntegration}.
     *
     * @remarks
     * <br/> - The `'theo'` integration naming is deprecated and has been replaced with `'csai'`.
     */
    integration: AdIntegrationKind | CustomAdIntegrationKind | undefined;
    /**
     * List of ads which will be played sequentially at the ad break's time offset.
     */
    ads: Ad[] | undefined;
    /**
     * The time offset at which content will be paused to play the ad break, in seconds.
     */
    timeOffset: number;
    /**
     * The duration of the ad break, in seconds.
     *
     * @remarks
     * <br/> - Ads are lazily loaded. This property becomes available when all ads are loaded.
     */
    maxDuration: number | undefined;
    /**
     * The remaining duration of the ad break, in seconds.
     *
     * @remarks
     * <br/> - Ads are lazily loaded. This property becomes available when all ads are loaded.
     * <br/> - This feature is not available in the Google IMA integration and will default to -1.
     */
    maxRemainingDuration: number | undefined;
    /**
     * Additional integration-specific data associated with this ad.
     */
    customData: unknown;
}
/**
 * Represents a companion ad which is displayed near the video player.
 *
 * @category Ads
 * @public
 */
interface CompanionAd {
    /**
     * The identifier of the element in which the companion ad should be appended, if available.
     *
     * @remarks
     * <br/> Only available for Google DAI and THEO ads if provided in the VAST.
     */
    adSlotId?: string;
    /**
     * The alternative description for the ad.
     *
     * @remarks
     * <br/> - Returns value as reported in the VAST StaticResource. If not specified, it returns an empty string.
     * <br/> - Returns an empty string for THEO ads if not available.
     * <br/> - Returns an empty string for Google IMA / Google DAI integrations.
     */
    altText: string;
    /**
     * The content of the ad, as HTML.
     *
     * @remarks
     * <br/> - Available for StaticResource and HTMLResource in THEO ad system.
     * <br/> - Available in the DAI ad system.
     */
    contentHTML: string;
    /**
     * The website of the advertisement.
     *
     * @remarks
     * <br/> - Only available for StaticResource if specified by the VAST. Otherwise returns an empty string.
     */
    clickThrough?: string;
    /**
     * The height of the ad, in pixels.
     *
     * @remarks
     * <br/> - Only available for IMA ad system and THEO ad system.
     */
    height: number;
    /**
     * The URI of the ad content as specified in the VAST file.
     *
     * @remarks
     * <br/> - Only available in the THEO ad system for StaticResource. Otherwise returns an empty string.
     */
    resourceURI: string;
    /**
     * The width of the ad, in pixels.
     *
     * @remarks
     * <br/> - Only available for IMA ad system and THEO ad system.
     */
    width: number;
}
/**
 * The events fired by the {@link Ads | ads API}.
 *
 * @category Ads
 * @public
 */
interface AdsEventMap {
    /**
     * Fired when an ad break is added.
     *
     * @remarks
     * <br/> - Available since v2.60.0.
     */
    addadbreak: AdBreakEvent<'addadbreak'>;
    /**
     * Fired when an ad break is removed.
     *
     * @remarks
     * <br/> - Available since v2.60.0.
     */
    removeadbreak: AdBreakEvent<'removeadbreak'>;
    /**
     * Fired when an ad break begins.
     */
    adbreakbegin: AdBreakEvent<'adbreakbegin'>;
    /**
     * Fired when an ad break ends.
     */
    adbreakend: AdBreakEvent<'adbreakend'>;
    /**
     * Fired when an ad break changes.
     */
    adbreakchange: AdBreakEvent<'adbreakchange'>;
    /**
     * Fired when an ad is added.
     *
     * @remarks
     * <br/> - Available since v2.60.0.
     */
    addad: AdEvent<'addad'>;
    /** @internal */
    adadded: Event<'adadded'>;
    /**
     * Fired when an ad is updated.
     *
     * @remarks
     * <br/> - Available since v2.60.0.
     */
    updatead: AdEvent<'updatead'>;
    /**
     * Fired when an AdBreak is updated.
     *
     * @remarks
     * <br/> - Available since v2.66.0.
     */
    updateadbreak: AdBreakEvent<'updateadbreak'>;
    /**
     * Fired when an ad is loaded.
     */
    adloaded: Event<'adloaded'>;
    /**
     * Fired when an ad begins.
     */
    adbegin: AdEvent<'adbegin'>;
    /**
     * Fired when an ad ends.
     */
    adend: AdEvent<'adend'>;
    /**
     * Fired when an ad is skipped.
     */
    adskip: AdSkipEvent;
    /**
     * Fired when an ad errors.
     */
    aderror: Event<'aderror'>;
    /**
     * Fired when an ad counts as an impression.
     */
    adimpression: AdEvent<'adimpression'>;
    /**
     * Fired when an ad reaches the first quartile.
     */
    adfirstquartile: AdEvent<'adfirstquartile'>;
    /**
     * Fired when an ad reaches the mid point.
     */
    admidpoint: AdEvent<'admidpoint'>;
    /**
     * Fired when an ad reaches the third quartile.
     */
    adthirdquartile: AdEvent<'adthirdquartile'>;
    /**
     * Fired when the ad has stalled playback to buffer.
     *
     * @remarks
     * <br/> - only available in the Google IMA integration.
     */
    adbuffering: AdBufferingEvent;
    /**
     * Fired when an ads list is loaded.
     *
     * @remarks
     * <br/> - only available in the Google IMA integration.
     */
    admetadata: AdMetadataEvent;
    /**
     * Fired when the {@link https://developers.google.com/interactive-media-ads/docs/sdks/html5/client-side/reference/js/google.ima.AdsManager | google.ima.AdsManager} is created.
     *
     * @remarks
     * <br/> - only available in the Google IMA integration.
     */
    adsmanagerloaded: AdsManagerLoadedEvent;
}
/**
 * Base type for events related to a single ad.
 *
 * @category Ads
 * @category Events
 * @public
 */
interface AdEvent<TType extends string> extends Event<TType> {
    /**
     * The ad.
     */
    readonly ad: Ad;
}
/**
 * Fired when an ad is skipped.
 *
 * @category Ads
 * @category Events
 * @public
 */
interface AdSkipEvent extends AdEvent<'adskip'> {
    /**
     * The amount of time that was played before the ad was skipped, as a fraction between 0 and 1.
     */
    readonly playedPercentage: number;
}
/**
 * Base type for events related to an ad break.
 *
 * @category Ads
 * @category Events
 * @public
 */
interface AdBreakEvent<TType extends string> extends Event<TType> {
    /**
     * The ad break.
     */
    readonly adBreak: AdBreak;
    /**
     * The ad break.
     *
     * @deprecated use {@link AdBreakEvent.adBreak}
     */
    readonly ad: AdBreak;
}
/**
 * The API for advertisements.
 *
 * @remarks
 * <br/> - Integrates with `'csai'`, `'google-ima'`, `'google-dai'`, `'freewheel'` or `'theoads'`.
 *
 * @category Ads
 * @public
 */
interface Ads extends EventDispatcher<AdsEventMap> {
    /**
     * Whether a linear ad is currently playing.
     */
    playing: boolean;
    /**
     * The currently playing ad break.
     */
    readonly currentAdBreak: AdBreak | null;
    /**
     * List of currently playing ads.
     */
    readonly currentAds: Ad[];
    /**
     * List of ad breaks which still need to be played.
     */
    readonly scheduledAdBreaks: AdBreak[];
    /**
     * List of ads which still need to be played.
     */
    readonly scheduledAds: Ad[];
    /**
     * The Google DAI API.
     *
     * @remarks
     * <br/> - Only available with the feature `'google-dai'`.
     */
    readonly dai?: GoogleDAI;
    /**
     * Add an ad break request.
     *
     * @remarks
     * <br/> - Available since v2.18.0.
     * <br/> - Prefer scheduling ad breaks up front through {@link SourceConfiguration.ads}.
     *
     * @param adDescription - Describes the ad break to be scheduled.
     */
    schedule(adDescription: AdDescription): void;
    /**
     * Skip the current linear ad.
     *
     * @remarks
     * <br/> - This will have no effect when the current linear ad is (not yet) skippable.
     */
    skip(): void;
    /**
     * Register a custom advertisement integration.
     *
     * This allows you to integrate with third-party advertisement providers,
     * and have them report their ads and ad-related events through the THEOplayer {@link Ads} API.
     *
     * @param integrationId
     *   An identifier of the integration.
     * @param integrationFactory
     *   Factory that will construct an {@link ServerSideAdIntegrationHandler} for this integration.
     */
    registerServerSideIntegration(integrationId: CustomAdIntegrationKind, integrationFactory: ServerSideAdIntegrationFactory): void;
}
/**
 * The type of ad source:
 * <br/> - `'vast'`: The source is a VAST resource.
 * <br/> - `'vmap'`: The source is a VMAP resource.
 * <br/> - `'adrule'`: The source is a Ad Rule resource.
 *
 * @remarks
 * <br/> - An ad rule is a simplified VMAP alternative only available in the Google IMA integration.
 *
 * @category Ads
 * @public
 */
type AdSourceType = 'vast' | 'vmap' | 'adrule';
/**
 * Describes the source of the ad.
 *
 * @category Ads
 * @public
 */
interface AdSource {
    /**
     * The URL of the ad resource.
     */
    src: string;
    /**
     * The type of ad resource.
     *
     * @defaultValue 'vmap' when set through {@link SourceConfiguration.ads} without a time offset, otherwise 'vast'.
     */
    type?: AdSourceType;
}
/**
 * Describes an ad break request.
 *
 * @category Ads
 * @public
 */
interface AdDescription {
    /**
     * The integration of the ad, represented by a value from {@link AdIntegrationKind}
     * or {@link CustomAdIntegrationKind | the identifier of a custom integration} registered with {@link Ads.registerServerSideIntegration}.
     *
     * @defaultValue `'csai'`
     */
    integration?: AdIntegrationKind | CustomAdIntegrationKind;
    /**
     * Whether the ad replaces playback of the content.
     *
     * @remarks
     * <br/> - When the ad ends, the content will resume at the ad break's offset plus its duration.
     *
     * @defaultValue
     * <br/> - `true` for live content,
     * <br/> - `false` for VOD content.
     */
    replaceContent?: boolean;
    /**
     * A source which contains the location of ad resources to be scheduled.
     *
     * @remarks
     * <br/> - Important: This should *not* be an array of sources.
     * <br/> - VPAID support is limited to the `'google-ima'` integration.
     * <br/> - Not specifying this property should only happen when using a third party ad integration that uses an other system of specifying which ads to schedule
     */
    sources?: string | AdSource;
    /**
     * Offset after which the ad break will start.
     *
     * Possible formats:
     * <br/> - A number for the offset in seconds.
     * <br/> - `'start'` for a preroll.
     * <br/> - `'end'` for a postroll.
     * <br/> - `'HH:MM:SS.mmm'` for a timestamp in the playback window.
     * <br/> - A percentage string (XX%) for a proportion of the content duration.
     *
     * @remarks
     * <br/> - A timestamp which is not in the playback window will result in the ad break not being started.
     * <br/> - Do NOT set for VMAP ads. VMAP resources will ignore this value as they contain an internal offset. https://www.theoplayer.com/docs/theoplayer/how-to-guides/ads/how-to-set-up-vast-and-vmap/#vmap
     * <br/> - Since 2.18, numbers are supported for the Google IMA integration, since 2.21 other formats as well.
     *
     * @defaultValue `'start'`
     *
     */
    timeOffset?: string | number;
}
/**
 * Describes a SpotX ad break request.
 *
 * @remarks
 * <br/> - Available since v2.13.0.
 *
 * @example
 * ```
 * {
 *     integration: 'spotx',
 *     id: 123456,
 *     cacheBuster: true,
 *     app: {
 *         bundle: 'com.exampleapps.example',
 *         name: 'My CTV App'
 *     },
 *     device: {
 *         ifa: '38400000-8cf0-11bd-b23e-10b96e40000d',
 *         ua: 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) CriOS/56.0.2924.75 Mobile/14E5239e Safari/602.1',
 *         geo: {
 *             lat: -24.378528,
 *             lon: -128.325119
 *         },
 *         dnt: 1,
 *         lmt: 1,
 *     },
 *     custom: {
 *         category: ['category1', 'category2'],
 *         somekey: 'somevalue'
 *     }
 *     user: {
 *         yob: 1984,
 *         gender: 'm'
 *     }
 * }
 * ```
 *
 * @category Ads
 * @public
 */
interface SpotXAdDescription extends AdDescription {
    /**
     * The integration of the ad break.
     */
    integration: 'spotx';
    /**
     * The identifier of the ad break requested from SpotX.
     */
    id: number | string;
    /**
     * The maximum duration of the ad, in seconds.
     *
     * @defaultValue No maximum duration.
     */
    maximumAdDuration?: number | string;
    /**
     * The URL of the content page.
     */
    contentPageUrl?: string;
    /**
     * The IP address of the viewer.
     */
    ipAddress?: string;
    /**
     * Whether the ad break request should contain a cache buster.
     *
     * @remarks
     * <br/> - A cache buster adds a query parameter 'cb' with a random value to circumvent browser caching mechanisms.
     */
    cacheBuster?: boolean;
    /**
     * A source URL which contains the location of ad resources to be scheduled.
     *
     * @remarks
     * <br/> - This will override the generated URL.
     */
    sources?: string;
    /**
     * A record of query string parameters added to the SpotX ad break request.
     * Each entry contains the parameter name with associated value.
     *
     * @remarks
     * <br/> - Available since v2.38.0.
     */
    queryParameters?: SpotxQueryParameter;
    /**
     * Custom SpotX data.
     *
     * @deprecated Superseded by {@link SpotXAdDescription.queryParameters | queryParameters.custom}.
     */
    custom?: SpotxData;
    /**
     * Application specific SpotX data.
     *
     * @deprecated Superseded by {@link SpotXAdDescription.queryParameters | queryParameters.app}.
     */
    app?: SpotxData;
    /**
     * Device specific SpotX data.
     *
     * @deprecated Superseded by {@link SpotXAdDescription.queryParameters | queryParameters.device}.
     */
    device?: SpotxData;
    /**
     * User specific SpotX data.
     *
     * @deprecated Superseded by {@link SpotXAdDescription.queryParameters | queryParameters.user}.
     */
    user?: SpotxData;
}
/**
 * Describes a Google IMA ad break request.
 *
 * @category Ads
 * @public
 */
interface IMAAdDescription extends AdDescription {
    /**
     * The integration of the ad break.
     */
    integration: 'google-ima';
    /**
     * The source of the ad
     *
     * @remarks
     * <br/> - VAST, VMAP and VPAID are supported.
     * <br/> - Overlay ads and banners are only displayed if the container element (the player) is big enough in pixels.
     */
    sources: string | AdSource;
    /**
     * Optional settings object for mapping verification vendors (google.ima.OmidVerificationVendor) to OMID Access Modes (google.ima.OmidAccessMode).
     */
    omidAccessModeRules?: Record<number, string>;
}
/**
 * The possible ad unit types, represented by a value from the following list:
 * <br/> - `'preroll'`: The linear ad will play before the content started.
 * <br/> - `'midroll'`: The linear ad will play at a time offset during the content.
 * <br/> - `'postroll'`: The linear ad will play after the content ended.
 * <br/> - `'overlay'`: The non-linear ad.
 *
 * @category Ads
 * @public
 */
type FreeWheelAdUnitType = 'preroll' | 'midroll' | 'postroll' | 'overlay';
/**
 * Represents a FreeWheel cue.
 *
 * @category Ads
 * @public
 */
interface FreeWheelCue {
    /**
     * The ad unit type.
     */
    adUnit: FreeWheelAdUnitType;
    /**
     * Offset after which the ad break will start, in seconds.
     */
    timeOffset: number;
}
/**
 * Describes a FreeWheel ad break request.
 *
 * @remarks
 * <br/> - Available since v2.42.0.
 *
 * @category Ads
 * @public
 */
interface FreeWheelAdDescription extends AdDescription {
    /**
     * The integration of the ad break.
     */
    integration: 'freewheel';
    /**
     * The FreeWheel ad server URL.
     */
    adServerUrl: string;
    /**
     * The duration of the asset, in seconds.
     *
     * @remarks
     * <br/> - Optional for live assets.
     */
    assetDuration?: number;
    /**
     * The identifier of the asset.
     *
     * @remarks
     * <br/> - Generated by FreeWheel CMS when an asset is uploaded.
     */
    assetId?: string;
    /**
     * The network identifier which is associated with a FreeWheel customer.
     */
    networkId: number;
    /**
     * The server side configuration profile.
     *
     * @remarks
     * <br/> - Used to indicate desired player capabilities.
     */
    profile: string;
    /**
     * The identifier of the video player's location.
     */
    siteSectionId?: string;
    /**
     * List of cue points.
     *
     * @remarks
     * <br/> - Not available in all FreeWheel modes.
     */
    cuePoints?: FreeWheelCue[];
    /**
     * A record of query string parameters added to the FreeWheel ad break request.
     * Each entry contains the parameter name with associated value.
     */
    customData?: Record<string, string>;
}
/**
 * Represents a geographical location.
 *
 * @category Ads
 * @public
 */
interface Geo {
    /**
     * The latitude of this location.
     */
    readonly lat: number;
    /**
     * The longitude of this location.
     */
    readonly lon: number;
}
/**
 * A record of SpotX query string parameters.
 * Each entry contains the parameter name with associated value.
 *
 * @category Ads
 * @public
 */
interface SpotxData {
    [key: string]: string | number | boolean | string[] | Geo;
}
/**
 * A record of SpotX query string parameters which can be a nested structure.
 * Each entry contains the parameter name with associated value.
 *
 * @category Ads
 * @public
 */
interface SpotxQueryParameter {
    [key: string]: string | number | boolean | string[] | Geo | SpotxData | SpotxData[];
}
/**
 * The integration of an ad or ad break, represented by a value from the following list:
 * <br/> - `'csai'`: Default CSAI ad playback.
 * <br/> - `'theo'`: Old naming for `'csai'` - Default ad playback. (Deprecated)
 * <br/> - `'google-ima'`: {@link https://developers.google.com/interactive-media-ads/docs/sdks/html5/client-side | Google IMA} pre-integrated ad playback.
 * <br/> - `'google-dai'`: {@link https://developers.google.com/ad-manager/dynamic-ad-insertion/sdk/html5 | Google DAI} pre-integrated ad playback.
 * <br/> - `'spotx'`: {@link https://developer.spotxchange.com/ | SpotX} pre-integrated ad playback.
 * <br/> - `'freewheel'`: {@link https://vi.freewheel.tv/ | FreeWheel} pre-integrated ad playback.
 * <br/> - `'mediatailor'`: {@link https://aws.amazon.com/mediatailor/ | MediaTailor} pre-integrated ad playback.
 * <br/> - `'chromecast'`: {@link https://developers.google.com/cast/docs/web_receiver/ad_breaks | Chromecast} ads playing on a remote receiver.
 * <br/> - `'theoads'`: [Experimental] - API under development, do not use without consulting THEO Technologies.
 *
 * @remarks
 * <br/> - An empty string will default to `'csai'`.
 *
 * @category Ads
 * @public
 */
type AdIntegrationKind = '' | 'csai' | 'theo' | 'google-ima' | 'spotx' | 'freewheel' | 'theoads';
/**
 * The identifier of a custom ad integration registered with {@link Ads.registerServerSideIntegration}.
 *
 * @category Ads
 */
type CustomAdIntegrationKind = string & {};
/**
 * The iframe policies for VPAID ads, represented by a value from the following list:
 * <br/> - `'enabled'`: Ads will load in a cross domain iframe. This disables access to the site via JavaScript. Ads that require a friendly iframe will fail to play.
 * <br/> - `'insecure'`: Ads will load in a friendly iframe. This allows access to the site via JavaScript.
 * <br/> - `'disabled'`: Ads will error when requested.
 *
 * @category Ads
 * @public
 */
type VPAIDMode = 'enabled' | 'insecure' | 'disabled';
/**
 * Describes an ad break request.
 *
 * @category Ads
 * @public
 * @deprecated Replaced by {@link CsaiAdDescription}.
 */
type THEOplayerAdDescription = CsaiAdDescription;
/**
 * Describes an ad break request.
 *
 * @category Ads
 * @public
 */
interface CsaiAdDescription extends AdDescription {
    /**
     * The integration of the ad break.
     *
     * @defaultValue `'csai'`
     * @remarks
     * <br/> - The `'theo'` integration naming is deprecated and has been replaced with `'csai'`.
     */
    integration?: 'csai' | 'theo';
    /**
     * The source of the ad
     *
     * @remarks
     * <br/> - Only supports VAST and VMAP.
     */
    sources: string | AdSource;
    /**
     * Offset after which the ad break can be skipped.
     *
     * @remarks
     * <br/> - A timestamp which is not in the playback window will result in the ad break not being started.
     * <br/> - VMAP resources will ignore this value as they contain an internal offset.
     *
     * Possible formats:
     * <br/> - A number for the offset in seconds.
     * <br/> - `'start'` for a preroll.
     * <br/> - `'end'` for a postroll.
     * <br/> - `'HH:MM:SS.mmm'` for a timestamp in the playback window.
     * <br/> - A percentage string (XX%) for a proportion of the content duration.
     *
     * @defaultValue `'start'`
     */
    skipOffset?: string | number;
}

/**
 * Helper type that represents either an ArrayBuffer or an ArrayBufferView.
 * Inspired by {@link https://webidl.spec.whatwg.org/#common-BufferSource}.
 *
 * @public
 */
type BufferSource = ArrayBufferView | ArrayBuffer;

/**
 * Describes the key system configuration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface KeySystemConfiguration {
    /**
     * Property to indicate whether the ability to persist state is required. This includes session data and any other type of state. The player will forward this information to the CDM when requesting access to the media key system.
     *
     * Available values are:
     * - "required": This will instruct the player to make the key sessions persistent.
     * - "optional": Choice of making use of a persistent key session is up to the player.
     * - "not-allowed": A temporary key session will be used.
     */
    persistentState?: 'required' | 'optional' | 'not-allowed';
    /**
     * Used to indicate if media key sessions can be shared across different instances, for example different browser profiles, player instances or applications. The player will forward this information to the CDM when requesting access to the media key system.
     * Available values are:
     * - “required”
     * - “optional”
     * - “not-allowed”
     */
    distinctiveIdentifier?: 'required' | 'optional' | 'not-allowed';
    /**
     * Allows to configure the robustness level required for audio data. The robustness level can be used to define the DRM security level. If the security level requested is not available on the platform, playback will fail.
     *
     * Following values are supported for Widevine:
     * - "": Lowest security level
     * - "SW_SECURE_CRYPTO": Secure decryption in software is required. This matches Widevine L3.
     * - "SW_SECURE_DECODE": Media data is to be decoded securely in software. This matches Widevine L3.
     * - "HW_SECURE_CRYPTO": Secure decryption in hardware is required. This matches Widevine L2.
     * - "HW_SECURE_DECODE": Media data is to be decoded securely in hardware. This matches Widevine L1.
     * - "HW_SECURE_ALL": The media pipeline must be decrypted and decoded securely in hardware. This matches Widevine L1.
     */
    audioRobustness?: string;
    /**
     * Allows to configure the robustness level required for video data. The robustness level can be used to define the DRM security level. If the security level requested is not available on the platform, playback will fail.
     *
     * Following values are supported for Widevine:
     *
     * - "": Lowest security level
     * - "SW_SECURE_CRYPTO": Secure decryption in software is required. This matches Widevine L3.
     * - "SW_SECURE_DECODE": Media data is to be decoded securely in software. This matches Widevine L3.
     * - "HW_SECURE_CRYPTO": Secure decryption in hardware is required. This matches Widevine L2.
     * - "HW_SECURE_DECODE": Media data is to be decoded securely in hardware. This matches Widevine L1.
     * - "HW_SECURE_ALL": The media pipeline must be decrypted and decoded securely in hardware. This matches Widevine L1.
     */
    videoRobustness?: string;
    /**
     * The licence acquisition URL.
     *
     * @remarks
     * <br/> - If provided, the player will send license requests for the intended DRM scheme to the provided value.
     * <br/> - If not provided, the player will use the default license acquisition URLs.
     */
    licenseAcquisitionURL?: string;
    /**
     * The licence type.
     *
     * @internal
     */
    licenseType?: LicenseType;
    /**
     * Record of HTTP headers for the licence acquisition request.
     * Each entry contains a header name with associated value.
     */
    headers?: {
        [headerName: string]: string;
    };
    /**
     * Whether the player is allowed to use credentials for cross-origin requests.
     *
     * @remarks
     * <br/> - Credentials are cookies, authorization headers or TLS client certificates.
     *
     * @defaultValue `false`
     */
    useCredentials?: boolean;
    /**
     * Record of query parameters for the licence acquisition request.
     * Each entry contains a query parameter name with associated value.
     */
    queryParameters?: {
        [key: string]: any;
    };
    /**
     * The certificate for the key system. This can be either an ArrayBuffer or Uint8Array containing the raw certificate bytes or a base64-encoded variant of this.
     */
    certificate?: BufferSource | string;
}
/**
 * The type of the licence, represented by a value from the following list:
 * <br/> - `'temporary'`
 * <br/> - `'persistent'`
 *
 * @category Source
 * @category Content Protection
 * @public
 */
type LicenseType = 'temporary' | 'persistent';
/**
 * Describes the FairPlay key system configuration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface FairPlayKeySystemConfiguration extends KeySystemConfiguration {
    /**
     * The URL of the certificate.
     */
    certificateURL?: string;
}
/**
 * Describes the PlayReady key system configuration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface PlayReadyKeySystemConfiguration extends KeySystemConfiguration {
    /**
     * Custom data which will be passed to the CDM.
     */
    customData?: string;
}
/**
 * Describes the Widevine key system configuration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
type WidevineKeySystemConfiguration = KeySystemConfiguration;
/**
 * Describes the ClearKey key system configuration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface ClearkeyKeySystemConfiguration extends KeySystemConfiguration {
    /**
     * List of decryption keys.
     */
    keys?: ClearkeyDecryptionKey[];
}
/**
 * Describes the ClearKey decryption key.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface ClearkeyDecryptionKey {
    /**
     * The identifier of the key.
     *
     * @remarks
     * <br/> - This is a base64url encoding of the octet sequence containing the key ID.
     * <br/> - See {@link https://www.w3.org/TR/encrypted-media/#clear-key-license-format | Clear Key License Format}.
     */
    id: string;
    /**
     * The value of the key.
     *
     * @remarks
     * <br/> - The base64url encoding of the octet sequence containing the symmetric key value.
     * <br/> - See {@link https://www.w3.org/TR/encrypted-media/#clear-key-license-format | Clear Key License Format}.
     */
    value: string;
}
/**
 * Describes the AES128 key system configuration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface AES128KeySystemConfiguration {
    /**
     * Whether the player is allowed to use credentials for cross-origin requests.
     *
     * @remarks
     * <br/> - Credentials are cookies, authorization headers or TLS client certificates.
     *
     * @defaultValue `false`
     */
    useCredentials?: true;
}
/**
 * Describes the configuration of the DRM.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface DRMConfiguration {
    /**
     * The identifier of the DRM integration.
     */
    integration?: string;
    /**
     * The configuration of the FairPlay key system.
     */
    fairplay?: FairPlayKeySystemConfiguration;
    /**
     * The configuration of the PlayReady key system.
     */
    playready?: PlayReadyKeySystemConfiguration;
    /**
     * The configuration of the Widevine key system.
     */
    widevine?: WidevineKeySystemConfiguration;
    /**
     * The configuration of the ClearKey key system.
     */
    clearkey?: ClearkeyKeySystemConfiguration;
    /**
     * The configuration of the AES key system.
     */
    aes128?: AES128KeySystemConfiguration;
    /**
     * An object of key/value pairs which can be used to pass in specific parameters related to a source into a
     * {@link ContentProtectionIntegration}.
     */
    integrationParameters?: {
        [parameterName: string]: any;
    };
    /**
     * An ordered list of URNs of key systems as specified by {@link https://dashif.org/identifiers/content_protection/}, or one of the following identifiers:
     *
     * `"widevine"` alias for `"urn:uuid:edef8ba9-79d6-4ace-a3c8-27dcd51d21ed"`
     * `"fairplay"` alias for `"urn:uuid:94ce86fb-07bb-4b43-adb8-93d2fa968ca2"`
     * `"playready"` alias for `"urn:uuid:9a04f079-9840-4286-ab92-e65be0885f95"`
     *
     * The first key system in this list which is supported on the given platform will be used for playback.
     *
     * Default value is ['widevine', 'playready', 'fairplay'].
     */
    preferredKeySystems?: Array<KeySystemId | (string & {})>;
    /**
     * A flag that affects HbbTV enabled devices and indicates whether the OIPF DRM agent should be used for handling DRM protection,
     * even when EME is available.
     *
     * Default value is false.
     */
    useOipfDrmAgent?: boolean;
}
/**
 * The id of a key system. Possible values are 'widevine', 'fairplay' and 'playready'.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
type KeySystemId = 'widevine' | 'fairplay' | 'playready';

/**
 * The identifier of the Google DAI integration.
 *
 * @category Source
 * @category SSAI
 * @public
 */
type GoogleDAISSAIIntegrationID = 'google-dai';
/**
 * The type of the stream requested from Google DAI, represented by a value from the following list:
 * <br/> - `'live'`: The requested stream is a live stream.
 * <br/> - `'vod'`: The requested stream is a video-on-demand stream.
 *
 * @category Source
 * @category SSAI
 * @public
 */
type DAIAvailabilityType = 'vod' | 'live';
/**
 * Represents a configuration for server-side ad insertion with the Google DAI pre-integration.
 *
 * @remarks
 * <br/> - Available since v2.30.0.
 *
 * @category Source
 * @category SSAI
 * @public
 */
interface GoogleDAIConfiguration extends ServerSideAdInsertionConfiguration {
    /**
     * The type of the requested stream.
     */
    readonly availabilityType?: DAIAvailabilityType;
    /**
     * The identifier for the SSAI pre-integration.
     */
    integration: GoogleDAISSAIIntegrationID;
    /**
     * The authorization token for the stream request.
     *
     * @remarks
     * <br/> - If present, this token is used instead of the API key for stricter content authorization.
     * <br/> - The publisher can control individual content streams authorizations based on this token.
     * <br/> - See {@link https://developers.google.com/ad-manager/dynamic-ad-insertion/sdk/html5/reference/js/StreamRequest#authToken}
     *         for more information.
     */
    authToken?: string;
    /**
     * The API key for the stream request.
     *
     * @remarks
     * <br/> - This key is used to verify applications that are attempting to access the content.
     * <br/> - This key is configured through the Google Ad Manager UI.
     * <br/> - See {@link https://developers.google.com/ad-manager/dynamic-ad-insertion/sdk/html5/reference/js/StreamRequest#apiKey}
     *         for more information.
     */
    apiKey: string;
    /**
     * The ad tag parameters added to stream request.
     *
     * @remarks
     * <br/> - Each entry contains the parameter name with associated value.
     * <br/> - See {@link https://developers.google.com/ad-manager/dynamic-ad-insertion/sdk/html5/reference/js/StreamRequest#adTagParameters}
     *         for more information.
     *
     * Valid parameters:
     * <br/> - {@link https://support.google.com/admanager/answer/7320899 | Supply targeting parameters to your stream}
     * <br/> - {@link https://support.google.com/admanager/answer/7320898 | Override stream variant parameters}
     */
    adTagParameters?: Record<string, string>;
    /**
     * The identifier for a stream activity monitor session.
     *
     * @remarks
     * <br/> - See {@link https://developers.google.com/ad-manager/dynamic-ad-insertion/sdk/html5/reference/js/StreamRequest#streamActivityMonitorId}
     *         for more information.
     */
    streamActivityMonitorID?: string;
    /**
     * The network code for the publisher making this stream request.
     *
     * @remarks
     * <br/> - See {@link https://developers.google.com/ad-manager/dynamic-ad-insertion/sdk/html5/reference/js/StreamRequest#networkCode}
     *         for more information.
     */
    networkCode?: string;
    /**
     * Optional settings object for mapping verification vendors (google.ima.OmidVerificationVendor) to OMID Access Modes (google.ima.OmidAccessMode).
     *
     * @remarks
     * <br/> - See {@link https://developers.google.com/ad-manager/dynamic-ad-insertion/sdk/html5/reference/js/StreamRequest#omidAccessModeRules}
     *         for more information.
     */
    omidAccessModeRules?: Record<number, string>;
}
/**
 * Represents a configuration for server-side ad insertion with the Google DAI pre-integration for a Live media stream.
 *
 * @remarks
 * <br/> - Available since v2.30.0.
 *
 * @category Source
 * @category SSAI
 * @public
 */
interface GoogleDAILiveConfiguration extends GoogleDAIConfiguration {
    /**
     * The type of the requested stream.
     */
    readonly availabilityType: 'live';
    /**
     * The identifier for the video content source for live streams.
     *
     * @remarks
     * <br/> - This property is required for live streams.
     * <br/> - The asset key can be found in the Google Ad Manager UI.
     */
    assetKey: string;
}
/**
 * Represents a configuration for server-side ad insertion with the Google DAI pre-integration for a VOD media stream.
 *
 * @remarks
 * <br/> - Available since v2.30.0.
 *
 * @category Source
 * @category SSAI
 * @public
 */
interface GoogleDAIVodConfiguration extends GoogleDAIConfiguration {
    /**
     * The type of the requested stream.
     */
    readonly availabilityType: 'vod';
    /**
     * The identifier for the publisher content for on-demand streams.
     *
     * @remarks
     * <br/> - The publisher content comes from a CMS.
     * <br/> - This property is required for on-demand streams.
     */
    contentSourceID: string;
    /**
     * The identifier for the video content source for on-demand streams.
     *
     * @remarks
     * <br/> - This property is required for on-demand streams.
     */
    videoID: string;
}
/**
 * Represents a media resource with a Google DAI server-side ad insertion request.
 *
 * @category Source
 * @category SSAI
 * @public
 */
interface GoogleDAITypedSource extends TypedSource {
    /**
     * The content type (MIME type) of the media resource, represented by a value from the following list:
     * <br/> - `'application/dash+xml'`: The media resource is an MPEG-DASH stream.
     * <br/> - `'application/x-mpegURL'` or `'application/vnd.apple.mpegurl'`: The media resource is an HLS stream.
     */
    type: string;
    ssai: GoogleDAIVodConfiguration | GoogleDAILiveConfiguration;
}

/**
 * The identifier of a server-side ad insertion pre-integration, represented by a value from the following list:
 * <br/> - `'google-dai'`: The configuration with this identifier is a {@link GoogleDAIConfiguration}
 *
 * @category Source
 * @category SSAI
 * @public
 */
type SSAIIntegrationId = GoogleDAISSAIIntegrationID;
/**
 * Represents a configuration for server-side ad insertion (SSAI).
 *
 * @remarks
 * <br/> - Available since v2.12.0.
 *
 * @category Source
 * @category SSAI
 * @public
 */
interface ServerSideAdInsertionConfiguration {
    /**
     * The identifier for the SSAI integration.
     */
    integration: SSAIIntegrationId | CustomAdIntegrationKind;
}

/**
 * The stereo mode of the VR integration, represented by a value from the following list:
 * <br/> - `''`: No stereo mode
 * <br/> - `'horizontal'`: The two viewpoints are in a side-by-side layout. The view for the left eye is in the left half of the video frame, the view for the right eye is in the right half of the video frame.
 * <br/> - `'vertical'`: The two viewpoints are in a top-bottom layout. The view for the left eye is in the upper half of the video frame, the view for the right eye is in the lower half of the video frame.
 *
 * @category VR
 * @public
 */
type VRStereoMode = '' | 'horizontal' | 'vertical';
/**
 * The panorama mode of the VR content, represented by a value from the following list:
 * <br/> - `''`: No panorama mode.
 * <br/> - `'360'`: The video contains content with a full 360 degree field of view.
 * <br/> - `'180'`: The video contains content with a 180 degree field of view.
 *
 * @category VR
 * @public
 */
type VRPanoramaMode = '' | '360' | '180';
/**
 * Describes the configuration of the virtual reality feature of a source.
 *
 * @remarks
 * <br/> - Available since v2.12.0.
 * <br/> - See {@link VR | the VR API} to control display of VR videos.
 *
 * @category VR
 * @public
 */
interface VRConfiguration {
    /**
     * Whether the source contains 360° video content.
     *
     * @defaultValue `false`
     */
    '360'?: boolean;
    /**
     * The panorama mode of the media.
     *
     * @remarks
     * <br/> - If the "360" property is set to true, panoramaMode is ignored and the content will be displayed as 360 degrees panorama.
     *
     * @defaultValue `undefined`
     */
    panoramaMode?: VRPanoramaMode;
    /**
     * The stereoscopic mode of the media.
     *
     * @defaultValue `''`
     */
    stereoMode?: VRStereoMode;
    /**
     * Whether the source plays using native VR.
     *
     * @remarks
     * <br/> - This property is only available for iOS.
     *
     * @defaultValue `false`
     */
    nativeVR?: boolean;
}

/**
 * Describes the configuration of the Cast integrations.
 *
 * @category Casting
 * @public
 */
interface CastConfiguration {
    /**
     * The Chromecast configuration.
     *
     * @defaultValue A {@link ChromecastConfiguration} with default values.
     */
    chromecast?: ChromecastConfiguration;
    /**
     * The join strategy of the player.
     *
     * @defaultValue `'manual'`
     */
    strategy?: JoinStrategy;
}
/**
 * The join strategy, represented by a value from the following list:
 * <br/> - `'auto'` : The player will automatically join a cast session if one exists when play is called. Otherwise it will prompt the user with all available devices.
 * <br/> - `'manual'` : The player will take over an existing session if there is one and the cast button is clicked. Otherwise it will prompt the user with all available devices.
 * <br/> - `'disabled'` : The player is not affected by cast sessions and is not castable.
 *
 * @category Casting
 * @public
 */
type JoinStrategy = 'auto' | 'manual' | 'disabled';
/**
 * Describes the configuration of the Chromecast integration.
 *
 * @category Casting
 * @public
 */
interface ChromecastConfiguration {
    /**
     * The identifier of a custom Chromecast receiver app.
     *
     * @defaultValue The default THEOplayer receiver app ID: 8E80B9CE.
     */
    appID?: string;
}

/**
 * The strategy of the action after skipping ads, represented by a value from the following list:
 * <br/> - `'play-all'`: Plays all the ad breaks skipped due to a seek.
 * <br/> - `'play-none'`: Plays none of the ad breaks skipped due to a seek.
 * <br/> - `'play-last'`: Plays the last ad break skipped due to a seek.
 *
 * @category Uplynk
 * @public
 */
type SkippedAdStrategy = 'play-all' | 'play-none' | 'play-last';
/**
 * Describes the configuration of the Uplynk integration.
 *
 * @category Uplynk
 * @public
 */
interface UplynkConfiguration {
    /**
     * The offset after which an ad break may be skipped, in seconds.
     *
     * @remarks
     * If the offset is -1, the ad is unskippable.
     * If the offset is 0, the ad is immediately skippable.
     * Otherwise it must be a positive number indicating the offset.
     *
     * @defaultValue `-1`
     */
    defaultSkipOffset?: number;
    /**
     * The ad skip strategy which is used when seeking over ads.
     *
     * @defaultValue `'play-none'`.
     */
    onSeekOverAd?: SkippedAdStrategy;
    /**
     * The Uplynk UI configuration.
     *
     * @remarks
     * Only available with the features `'uplynk'` and `'ui'`.
     */
    ui?: UplynkUiConfiguration;
}
/**
 * Describes the UI configuration of the Uplynk integration.
 *
 * @category Uplynk
 * @public
 */
interface UplynkUiConfiguration {
    /**
     * Whether an up next content countdown is shown on the UI.
     *
     * @remarks
     * <br/> - This countdown starts ten seconds before the up next asset starts.
     *
     * @defaultValue `true`
     */
    contentNotification?: boolean;
    /**
     * Whether an ad break skip button is shown on the UI.
     *
     * @remarks
     * <br/> - When unskippable, a banner with countdown is shown instead.
     *
     * @defaultValue `true`
     */
    adNotification?: boolean;
    /**
     * Whether the seek bar is supplemented with asset dividers on the UI.
     *
     * @defaultValue `true`
     */
    assetMarkers?: boolean;
    /**
     * Whether the seek bar is supplemented with marked areas in which ad breaks are present on the UI.
     *
     * @defaultValue `true`
     */
    adBreakMarkers?: boolean;
}

/**
 * Describes the ABR configuration for a specific source.
 *
 * @category Source
 * @category ABR
 * @public
 */
interface SourceAbrConfiguration {
    /**
     * A list of preferred audio codecs which will be used by the ABR algorithm for track selection, if the codec is supported.
     *
     */
    preferredAudioCodecs?: string[];
    /**
     * A list of preferred video codecs which will be used by the ABR algorithm for track selection, if the codec is supported.
     */
    preferredVideoCodecs?: string[];
    /**
     * Whether to restrict the ABR algorithm to only select qualities whose resolution fits within the player's rendered size.
     *
     * @remarks
     * <br/> - If `true`, only select qualities that fit within the player's size.
     * <br/> - If `false`, allow selecting qualities that are larger than the player's size.
     * <br/> - If unset (default), then apply the restriction only when playing on a mobile device.
     *
     * @defaultValue `undefined`
     */
    restrictToPlayerSize?: boolean;
}

/**
 * Describes the VR configuration
 *
 * @category VR
 * @public
 * @deprecated Ignored.
 */
interface VRPlayerConfiguration {
    /**
     * Whether to use the {@link https://immersiveweb.dev/ | WebXR API}.
     *
     * @deprecated Ignored, always assumed to be `true`.
     */
    useWebXR?: boolean;
}

/**
 * Object containing values used for the player's retry mechanisms.
 *
 * @category Player
 * @public
 */
interface RetryConfiguration {
    /**
     * The maximum amount of retries before the player throws a fatal error.
     * Defaults to `Infinity`.
     */
    maxRetries?: number;
    /**
     * The initial delay in milliseconds before a retry request occurs.
     * Exponential backoff will be applied on this value.
     * Defaults to `200`.
     */
    minimumBackoff?: number;
    /**
     * The maximum amount of delay in milliseconds between retry requests.
     * Defaults to `30000`.
     */
    maximumBackoff?: number;
}

/**
 * Describes a player's configuration.
 *
 * @category Player
 * @public
 */
interface PlayerConfiguration {
    /**
     * A unique identifier for the player.
     *
     * @internal
     */
    uid?: number;
    /**
     * The directory in which the THEOplayer library worker files are located.
     * These worker files are theoplayer.d.js, theoplayer.e.js, theoplayer.p.js.
     *
     * @remarks
     * <br/> - This parameter is required when using a HLS source and has no default.
     *
     * @example
     * `'/lib/theoplayer/'`
     */
    libraryLocation?: string;
    /**
     * Whether THEOplayer will be used in an iframe.
     *
     * @defaultValue `false`
     */
    isEmbeddable?: boolean;
    /**
     * The muted autoplay policy.
     *
     * @remarks
     * <br/> - The muted autoplay policy is impacted by this property and {@link SourceConfiguration.mutedAutoplay}.
     *
     * @defaultValue `'none'`.
     */
    mutedAutoplay?: MutedAutoplayConfiguration;
    /**
     * Whether the native video element's fullscreen should be used whenever THEOplayer's fullscreen is unsupported.
     *
     * @remarks
     * <br/> - Available since 2.21.0.
     * <br/> - It should be considered for older Android devices and iOS.
     * <br/> - It is limited to the platform's controls, custom UI and interactions are not possible.
     * <br/> - Together with the Google IMA integration, media preloading is unavailable on iOS devices.
     * <br/> - Together with the Google IMA integration, the current time is set to the live point when returning to the content after an ad.
     *
     * @defaultValue `false`
     */
    allowNativeFullscreen?: boolean;
    /**
     * Whether mixed HTTP/HTTPS content is allowed.
     *
     * @remarks
     * <br/> - Available since 2.22.0.
     * <br/> - By default, the player assumes that it cannot load HTTP URLs when inside a HTTPS page because of {@link https://developer.mozilla.org/en-US/docs/Web/Security/Mixed_content | mixed content restrictions}. Therefore, the player will automatically convert HTTP URLs to HTTPS before loading them.
     * <br/> - When this option is set to true, the player may assume that mixed content is allowed on the current platform, and will not automatically convert HTTP URLs to HTTPS.
     *
     * @defaultValue `false`
     */
    allowMixedContent?: boolean;
    /**
     * Whether volume preferences will be persisted across player sessions.
     *
     * @remarks
     * Available since 2.27.0.
     *
     * @defaultValue `false`
     */
    persistVolume?: boolean;
    /**
     * The offset in seconds used to determine the live point.
     * This live point is the end of the manifest minus the provided offset.
     *
     * @remarks
     * <br/> - Available since v2.35.0.
     *
     * @defaultValue Three times the target duration of a segment, as specified by the manifest.
     */
    liveOffset?: number;
    /**
     * Whether date ranges will be parsed from HLS manifests.
     *
     * @remarks
     * Available since 2.61.
     *
     * @defaultValue `false`
     */
    hlsDateRange?: boolean;
    /**
     * The ads configuration for the player.
     */
    ads?: AdsConfiguration;
    /**
     * List of analytics configurations for the player.
     *
     * @remarks
     * Multiple integrations can be enabled at once.
     */
    analytics?: AnalyticsDescription[];
    /**
     * The cast configuration for the player.
     */
    cast?: CastConfiguration;
    /**
     * The Verizon Media configuration for the player.
     *
     * @deprecated Superseded by {@link uplynk}
     */
    verizonMedia?: UplynkConfiguration;
    /**
     * The Uplynk configuration for the player.
     */
    uplynk?: UplynkConfiguration;
    /**
     * Whether `playbackRate` is retained across sources. When `false`, `playbackRate` will be reset to 1 on each source change.
     * Defaults to `false`.
     */
    retainPlaybackRateOnSourceChange?: boolean;
    /**
     * The license for the player
     */
    license?: string;
    /**
     * The url to fetch the license for the player
     */
    licenseUrl?: string;
    /**
     * The player's ABR configuration.
     *
     * @remarks
     * <br/> - Available since v3.1.0.
     * <br/> - Used for DASH and LL-HLS streams.
     */
    abr?: SourceAbrConfiguration;
    /**
     * The vr configuration for the player.
     *
     * @deprecated Ignored.
     */
    vr?: VRPlayerConfiguration;
    /**
     * The retry configuration for the player.
     */
    retryConfiguration?: RetryConfiguration;
    /**
     * If set, hides all deprecation warnings.
     *
     * @remarks
     * <br/> - Available since v5.5.0.
     */
    hideDeprecationWarnings?: boolean;
    /**
     * The THEOlive configuration for the player.
     */
    theoLive?: TheoLiveConfiguration;
}
/**
 * The muted autoplay policy of a player.
 * <br/> - `'none'`: Disallow muted autoplay. If the player is requested to autoplay while unmuted, and the platform does not support unmuted autoplay, the player will not start playback.
 * <br/> - `'all'`: Allow muted autoplay. If the player is requested to autoplay while unmuted, and the platform supports muted autoplay, the player will start muted playback.
 * <br/> - `'content'`: Allow muted autoplay only for the main content. Disallow muted autoplay for e.g. advertisements. (Not yet supported.)
 *
 * @category Player
 * @public
 */
type MutedAutoplayConfiguration = 'none' | 'all' | 'content';
/**
 * A configuration to configure THEOlive playback.
 *
 * @public
 */
interface TheoLiveConfiguration {
    /**
     * An id used to report usage analytics, if not explicitely given a random UUID is used.
     */
    readonly externalSessionId?: string;
    /**
     * Whether this player should fallback or not when it has a fallback configured.
     */
    readonly fallbackEnabled?: boolean;
    readonly discoveryHeader?: string;
}

/**
 * Describes the metadata of a Chromecast image.
 *
 * @remarks
 * <br/> - Available since v2.21.0.
 *
 * @category Source
 * @category Casting
 * @public
 */
interface ChromecastMetadataImage {
    /**
     * The URL of the image.
     */
    readonly src: string;
    /**
     * The width of the image, in pixels.
     */
    readonly width?: number;
    /**
     * The height of the image, in pixels.
     */
    readonly height?: number;
}
/**
 * The Chromecast's metadata type, represented by a value from the following list:
 * <br/> - `'movie'`
 * <br/> - `'audio'`
 * <br/> - `'tv-show'`
 * <br/> - `'generic'`
 *
 * @category Source
 * @category Casting
 * @public
 */
type ChromecastMetadataType = 'movie' | 'audio' | 'tv-show' | 'generic';
/**
 * Describes the metadata of a Chromecast source.
 *
 * @remarks
 * <br/> - Available since v2.21.0.
 *
 * @category Source
 * @public
 */
interface MetadataDescription {
    [metadataKey: string]: any;
    /**
     * The title of the content.
     */
    readonly title?: string;
}
/**
 * Describes the metatadata used by Chromecast.
 *
 * @remarks
 * <br/> - Available since v2.21.0.
 * <br/> - Do not use metadata key `images` if its value doesn't adhere to {@link ChromecastMetadataImage} or `string[]` (where the strings are image URLs).
 * <br/> - All values will be provided with the Media Info's {@link https://developers.google.com/cast/docs/reference/web_sender/chrome.cast.media.MediaInfo#metadata | metadata}.
 *
 * @category Source
 * @category Casting
 * @public
 */
interface ChromecastMetadataDescription extends MetadataDescription {
    /**
     * List of content images, e.g. a thumbnail for a video, a poster for movie or the cover art for a music album.
     *
     * @remarks
     * <br/> - The string must be a valid URL.
     * <br/> - Multiple images can be specified for multiple resolutions.
     * <br/> - If a poster is set in {@link SourceConfiguration}, it will be passed along with the images.
     */
    readonly images?: string[] | ChromecastMetadataImage[];
    /**
     * The release date of the content.
     *
     * @remarks
     * <br/> - The format is "YYYY-MM-DD".
     */
    readonly releaseDate?: string;
    /**
     * The release year of the content.
     *
     * @deprecated Superseded by {@link ChromecastMetadataDescription.releaseDate}.
     */
    readonly releaseYear?: number;
    /**
     * The subtitle of the content.
     *
     * @remarks
     * <br/> - This should be a short explanation about the content.
     */
    readonly subtitle?: string;
    /**
     * The studio that produced the movie.
     *
     * @remarks
     * <br/> - Only valid when {@link ChromecastMetadataDescription."type"} is `'movie'`.
     */
    readonly studio?: string;
    /**
     * The series title of the TV show.
     *
     * @remarks
     * <br/> - Only valid when {@link ChromecastMetadataDescription."type"} is `'tv-show'`.
     */
    readonly seriesTitle?: string;
    /**
     * The season number of the TV show.
     *
     * @remarks
     * <br/> - Only valid when {@link ChromecastMetadataDescription."type"} is `'tv-show'`.
     */
    readonly season?: number;
    /**
     * The episode number of the TV show.
     *
     * @remarks
     * <br/> - Only valid when {@link ChromecastMetadataDescription."type"} is `'tv-show'`.
     */
    readonly episode?: number;
    /**
     * The original air date of the TV show.
     *
     * @remarks
     * <br/> - Only valid when {@link ChromecastMetadataDescription."type"} is `'tv-show'`.
     * <br/> - The format is "YYYY-MM-DD".
     */
    readonly originalAirdate?: string;
    /**
     * The episode title of the TV show.
     *
     * @remarks
     * <br/> - Only valid when {@link ChromecastMetadataDescription."type"} is `'tv-show'`.
     *
     * @deprecated Superseded by {@link MetadataDescription.title}.
     */
    readonly episodeTitle?: string;
    /**
     * The season number of the TV show.
     *
     * @remarks
     * <br/> - Only valid when {@link ChromecastMetadataDescription."type"} is `'tv-show'`.
     *
     * @deprecated Superseded by {@link ChromecastMetadataDescription.season}.
     */
    readonly seasonNumber?: number;
    /**
     * The episode number of the TV show.
     *
     * @remarks
     * <br/> - Only valid when {@link ChromecastMetadataDescription."type"} is `'tv-show'`.
     *
     * @deprecated Superseded by {@link ChromecastMetadataDescription.episode}.
     */
    readonly episodeNumber?: number;
    /**
     * The album name of the music track.
     *
     * @remarks
     * <br/> - Only valid when {@link ChromecastMetadataDescription."type"} is `'audio'`.
     */
    readonly albumName?: string;
    /**
     * The album artist of the music track.
     *
     * @remarks
     * <br/> - Only valid when {@link ChromecastMetadataDescription."type"} is `'audio'`.
     */
    readonly albumArtist?: string;
    /**
     * The artist of the music track.
     *
     * @remarks
     * <br/> - Only valid when {@link ChromecastMetadataDescription."type"} is `'audio'`.
     */
    readonly artist?: string;
    /**
     * The composer of the music track.
     *
     * @remarks
     * <br/> - Only valid when {@link ChromecastMetadataDescription."type"} is `'audio'`.
     */
    readonly composer?: string;
    /**
     * The song name of the music track.
     *
     * @remarks
     * <br/> - Only valid when {@link ChromecastMetadataDescription."type"} is `'audio'`.
     */
    readonly songName?: string;
    /**
     * The track number of the music track.
     *
     * @remarks
     * <br/> - Only valid when {@link ChromecastMetadataDescription."type"} is `'audio'`.
     */
    readonly trackNumber?: number;
    /**
     * The disc number of the music track.
     *
     * @remarks
     * <br/> - Only valid when {@link ChromecastMetadataDescription."type"} is `'audio'`.
     */
    readonly discNumber?: number;
    /**
     * The artist name of the music track.
     *
     * @remarks
     * <br/> - Only valid when {@link ChromecastMetadataDescription."type"} is `'audio'`.
     *
     * @deprecated Superseded by {@link ChromecastMetadataDescription.artist}.
     */
    readonly artistName?: string;
    /**
     * The metadata type of the current source.
     *
     * @defaultValue `'generic'`
     */
    readonly type?: ChromecastMetadataType;
}

/**
 * Represents a media resource which is found on the Uplynk Platform.
 *
 * @category Source
 * @category Uplynk
 * @public
 */
interface UplynkSource extends BaseSource {
    /**
     * The integration ID of the source, represented by a value from the following list:
     * <br/> - `'uplynk'`: The source is an {@link UplynkSource}.
     * <br/> - `'verizon-media'`: The source is an {@link UplynkSource}. (Deprecated, superseded by `'uplynk'`)
     */
    integration: 'uplynk' | 'verizon-media';
    /**
     * One or multiple asset identifiers for the source.
     *
     * @remarks
     * <br/> - The order of a list of asset identifiers is the order their corresponding assets will be played in.
     */
    id: UplynkAssetId | UplynkAssetId[] | UplynkExternalId;
    /**
     * The prefix to use for Uplynk Preplay API and Asset Info API requests.
     *
     * @defaultValue `'https://content.uplynk.com'`
     */
    prefix?: string;
    /**
     * The query string parameters added to Uplynk Preplay requests.
     *
     * @remarks
     * Each entry contains the parameter name with associated value.
     *
     * Valid parameters:
     * <br/> - {@link https://api-docs.uplynk.com/index.html#Develop/Preplayv2.htm | Uplynk Preplay parameters}
     * <br/> - {@link https://api-docs.uplynk.com/index.html#AdIntegration/AOL-One-Video.htm | Uplynk ads with Yahoo SSP (formerly AOL One Video) parameters}
     * <br/> - {@link https://api-docs.uplynk.com/index.html#AdIntegration/DoubleClick.htm | Uplynk ads with Google Ad Manager (formerly known as DoubleClick for Publishers) parameters}
     * <br/> - {@link https://api-docs.uplynk.com/index.html#AdIntegration/Freewheel.htm | Uplynk ads with FreeWheel parameters}
     */
    preplayParameters?: Record<string, string> | Array<[string, string]>;
    /**
     * The query string parameters added to Uplynk playback URL requests.
     *
     * @remarks
     * Each entry contains the parameter name with associated value.
     *
     * Valid parameters:
     * <br/> - {@link https://api-docs.uplynk.com/index.html#Setup/Customizing-Playback.htm | Uplynk Playback Customization parameters}
     * <br/> - {@link https://api-docs.uplynk.com/index.html#Setup/Playback-URLs.htm | Uplynk Playback URLs}
     */
    playbackUrlParameters?: Record<string, string>;
    /**
     * The asset content type of the source.
     *
     * @defaultValue `'asset'`
     */
    assetType?: UplynkAssetType;
    /**
     * Whether the assets of the source are content protected.
     *
     * @defaultValue `false`
     */
    contentProtected?: boolean;
    /**
     * The Ping API feature configuration of the source.
     *
     * @remarks
     * <br/> - A configuration with all features disabled will prevent Ping requests being sent.
     *
     * @defaultValue
     * A configuration with all features `false` except for `linearAdData`, which will be `true` if {@link UplynkSource.assetType} is
     * `'channel'` or `'event'` and `false` otherwise.
     */
    ping?: UplynkPingConfiguration;
    /**
     * Whether asset info will be fetched from the Verizon Media Asset Info API and exposed on the player API.
     *
     * @remarks
     * <br/> - This feature is only available if {@link UplynkSource.assetType} is `'asset'`
     *
     * @defaultValue `true` if {@link UplynkSource.assetType} is `'asset'` and `false` otherwise
     */
    assetInfo?: boolean;
}
/**
 * Represents a unique asset identifier for an Uplynk asset.
 *
 * @remarks
 * <br/> - This asset identifier determines a unique asset on the Uplynk Platform.
 *
 * @category Source
 * @category Uplynk
 * @public
 */
type UplynkAssetId = string;
/**
 * Represents a combination of user identifier and one or more external identifiers for Uplynk assets.
 *
 * @remarks
 * <br/> - Each combination of the user identifier and external identifier determines a unique asset on the Uplynk Platform.
 *
 * @category Source
 * @category Uplynk
 * @public
 */
interface UplynkExternalId {
    /**
     * The user identifier for the asset(s).
     */
    userId: string;
    /**
     * The external identifier(s) for the asset(s).
     */
    externalId: string | string[];
}
/**
 * Describes the configuration of Uplynk Ping features.
 *
 * @category Source
 * @category Uplynk
 * @public
 */
interface UplynkPingConfiguration {
    /**
     * Whether to increase the accuracy of ad events by passing the current playback time in Ping requests.
     *
     * @remarks
     * <br/> - Only available when {@link UplynkSource.assetType} is `'asset'`.
     *
     * @defaultValue `false`
     *
     */
    adImpressions?: boolean;
    /**
     * Whether to enable FreeWheel's Video View by Callback feature to send content impressions to the FreeWheel server.
     *
     * @remarks
     * <br/> - Only available when {@link UplynkSource.assetType} is `'asset'`.
     *
     * @defaultValue `false`
     */
    freeWheelVideoViews?: boolean;
    /**
     * Whether to request information about upcoming ad breaks in the Ping responses.
     *
     * @remarks
     * <br/> - This feature will update the exposed ads found on {@link Uplynk.ads | player.uplynk.ads }.
     * <br/> - Only available when {@link UplynkSource.assetType} is `'event'` or `'channel'`.
     *
     * @defaultValue `true` if {@link UplynkSource.assetType} is `'event'` or `'channel'`, otherwise `false`.
     */
    linearAdData?: boolean;
}
/**
 * The type of an asset on the Uplynk Platform, represented by a value from the following list:
 * <br/> - `'asset'`: A Video-on-demand content asset.
 * <br/> - `'channel'`: A Live content channel.
 * <br/> - `'event'`: A Live event.
 *
 * @category Source
 * @category Uplynk
 * @public
 */
type UplynkAssetType = 'asset' | 'channel' | 'event';

/**
 * The strategy for period switches (see {@link DashPlaybackConfiguration.useSeamlessPeriodSwitch}), represented by a value from the following list:
 * <br/> - `'auto'`: The player uses seamless switches if the platform supports it, and hard switches otherwise.
 *                   This is the default.
 * <br/> - `'never'`: The player never uses a seamless switch, and always uses a hard switch.
 *                    Use this if you notice that the player is attempting but failing to preload the next period on the current platform.
 * <br/> - `'always'`: The player always uses a seamless switch, and never uses a hard switch.
 *                     Use this if you notice that the player never preloads the next period, even though you know that the current platform
 *                     should support it.
 * <br/> - `'clear-only'`: The player only uses a seamless switch when no content protection is used in the current and next period. Otherwise
 *                      it always uses a hard switch.
 *                      Use this if you notice that the player is attempting but failing to preload the next period on the current platform only when
 *                      content protection is involved.
 * <br/> - `'same-drm-only'`: The player only uses a seamless switch when the same or no content protection is used in the current and next period. Otherwise
 *                      it always uses a hard switch.
 *                      Use this if you notice that the player is attempting but failing to preload the next period on the current platform only when
 *                      content protection is different between periods.
 *
 * @category Source
 * @public
 */
type SeamlessPeriodSwitchStrategy = 'auto' | 'always' | 'never' | 'clear-only' | 'same-drm-only';
/**
 * Represents a configuration for controlling playback of an MPEG-DASH stream.
 *
 * @remarks
 * <br/> - Available since v2.79.0.
 *
 * @category Source
 * @public
 */
interface DashPlaybackConfiguration {
    /**
     * Whether to seamlessly switch between DASH periods.
     *
     * @remarks
     * The player supports two strategies for handling a switch between two periods in an MPEG-DASH stream:
     * <br/> - <strong>Seamless</strong>: Once the player is done buffering the current period, it immediately starts buffering the next period.
     *         This requires that the current period and the next period have compatible codecs and content protection, or that the platform
     *         supports buffering different codecs in a single player. Because the next period is preloaded ahead of time, this makes the actual
     *         switch between periods (almost) completely seamless.
     * <br/> - <strong>Hard</strong>: The player waits until playback reaches the end of the current period before buffering and playing the next
     *         period. Because the buffering is not done ahead of time, this may result in a noticeable stall at the start of the next period.
     *         However, this strategy does not require any special platform support, so it works on any platform or device.
     *
     * By default, the player will automatically choose between a seamless or a hard period switch based on the codecs and content protection of
     * the two periods, and the support information reported by the platform. However, if you notice that the player makes an incorrect decision
     * on certain streams or platforms, you can use this option to override its behavior as a stopgap solution. (You should still report this
     * problem to THEOplayer support, so we can improve the player's default behavior and you can remove this override.)
     *
     * @defaultValue `'auto'`
     *
     * @deprecated use {@link BaseSource.seamlessSwitchStrategy} instead.
     */
    useSeamlessPeriodSwitch?: SeamlessPeriodSwitchStrategy;
    /**
     * (Experimental) Whether the timescales of the media data need to be shifted,
     * in order to work around platform-specific issues on certain smart TV platforms.
     *
     * @remarks
     * <br/> - Available since v4.1.0.
     * <br/> - On certain smart TV platforms (such as Tizen 2), playback issues may arise when
     *         the timescale of the media data changes across periods or discontinuities.
     *         In that case, the player may need to shift all the timescales first,
     *         however this strategy may not work for all streams.
     * <br/> - When not specified, the player will decide whether or not to shift timescales
     *         based on the platform.
     * <br/> - This is an experimental option. It should only be used after consulting with
     *         THEOplayer support or engineering.
     */
    needsTimescaleShifting?: boolean | null;
    /**
     * (Experimental) The desired timescale to which the media data should be shifted.
     *
     * @remarks
     * <br/> - Available since v4.11.0.
     * <br/> - When specified, if the player decides to shift the timescale (see {@link DashPlaybackConfiguration.needsTimescaleShifting}), the timescale will be set to the
     *         given desired timescale.
     * <br/> - When not specified, if the player decides to shift timescale, the player will decide the timescale to which it should shift.
     * <br/> - This is an experimental option. It should only be used after consulting with
     *         THEOplayer support or engineering.
     */
    desiredTimescale?: number;
    /**
     * Whether the player should try to force the seek on period switching to realign video and audio.
     *
     * @internal
     */
    forceSeekToSynchronize?: boolean;
    /**
     * (Experimental) Force the player to ignore the availability window of individual segments in the MPD,
     * and instead consider every listed segment to be immediately available.
     *
     * @remarks
     * <br/> - Available since v5.2.0.
     * <br/> - This only applies to livestreams (with `<MPD type="dynamic">`).
     * <br/> - This only applies to streams that use `<SegmentTimeline>`.
     */
    ignoreAvailabilityWindow?: boolean;
    /**
     * Whether the player should perform a hard switch when seeking backwards.
     *
     * @internal
     */
    forceHardSwitchWhenSeekingBackwards?: boolean;
    /**
     * A flag to indicate whether or not timestamps of segmented WebVTT subtitles are relative to the segment start time.
     *
     * @remarks
     * <br/> - Available since v8.9.0.
     *
     *  @defaultValue `true`
     */
    segmentRelativeVttTiming?: boolean;
    /**
     * A flag to force re-creation of the MediaSource when switching audio tracks.
     *
     * @remarks
     * <br/> - Available since v8.14.0.
     *
     *  @defaultValue `false`
     *
     *  @internal
     */
    forceRecreateMediaSourceOnAudioSwitch?: boolean;
}

/**
 * The strategy for aligning HLS discontinuities, represented by a value from the following list:
 * <br/> - `'playlist'`: The first segment after a discontinuity is aligned with the segment's start time according to the HLS playlist,
 *                       i.e. the sum of the `#EXTINF` durations preceding the segment.
 *                       This ensures that the media time is synchronized with the playlist time, allowing for frame-accurate seeking across
 *                       discontinuities. However, if the `#EXTINF` durations from the playlist do not closely match the actual durations
 *                       from the media segments, then this might lead to overlap or gaps at a discontinuity, which can result in glitches or skips
 *                       during playback.
 * <br/> - `'media'`: The first segment after a discontinuity is aligned with the last media frame of the previous discontinuity.
 *                    This ensures that there is no overlap or gap at a discontinuity, resulting in smooth playback.
 *                    However, this may lead to drift between the playlist time and the actual media time, which can result in less accurate seeking.
 * <br/> - `'auto'`: The player aligns discontinuities using the `'playlist'` strategy for VOD and event streams,
 *                   and using the `'media'` strategy for live and DVR streams.
 *                   This is the default.
 *
 * @remarks
 * <br/> - See {@link HlsPlaybackConfiguration.discontinuityAlignment}.
 *
 * @category Source
 * @public
 */
type HlsDiscontinuityAlignment = 'auto' | 'playlist' | 'media';
/**
 * Represents a configuration for controlling playback of an HLS stream.
 *
 * @remarks
 * <br/> - Available since v2.82.0.
 *
 * @category Source
 * @public
 */
interface HlsPlaybackConfiguration {
    /**
     * The strategy for aligning HLS discontinuities.
     *
     * @defaultValue `'auto'`
     */
    discontinuityAlignment?: HlsDiscontinuityAlignment;
    /**
     * Flag for delaying preloading of subtitles until after video/audio for HLS streams, intended to be used for MediaTailor streams.
     *
     * A bug on the MediaTailor server side is currently causing them to return manifests without ads if the subtitle request is handled before
     * video/audio. Enabling this flag will cause the player to delay starting subtitle loading until after video/audio manifests have successfully
     * been requested, in order to work around the issue.
     *
     * @defaultValue `false`
     */
    delaySubtitlePreload?: boolean;
}

/**
 * Fired when a text track cue is entered.
 *
 * @category Media and Text Tracks
 * @category Events
 * @public
 */
interface TextTrackCueEnterEvent extends Event<'enter'> {
    /**
     * The text track cue that is entered.
     */
    readonly cue: TextTrackCue;
}
/**
 * Fired when a text track cue is exited.
 *
 * @category Media and Text Tracks
 * @category Events
 * @public
 */
interface TextTrackCueExitEvent extends Event<'exit'> {
    /**
     * The text track cue that is exited.
     */
    readonly cue: TextTrackCue;
}
/**
 * Fired when a text track cue is updated.
 *
 * @category Media and Text Tracks
 * @category Events
 * @public
 */
interface TextTrackCueUpdateEvent extends Event<'update'> {
    /**
     * The text track cue that is updated.
     */
    readonly cue: TextTrackCue;
}
/**
 * The events fired by the {@link TextTrackCue}.
 *
 * @category Media and Text Tracks
 * @public
 */
interface TextTrackCueEventMap {
    /**
     * Fired when the cue is entered.
     */
    enter: TextTrackCueEnterEvent;
    /**
     * Fired when the cue is exited.
     */
    exit: TextTrackCueExitEvent;
    /**
     * Fired when the cue is updated.
     */
    update: TextTrackCueUpdateEvent;
}
/**
 * Represents a cue of a text track.
 *
 * @category Media and Text Tracks
 * @public
 */
interface TextTrackCue extends EventDispatcher<TextTrackCueEventMap> {
    /**
     * @internal
     */
    _internalCue: unknown;
    /**
     * The text track of the cue.
     */
    track: TextTrack;
    /**
     * The identifier of the cue.
     */
    id: string;
    /**
     * A unique identifier of the text track cue.
     *
     * @remarks
     * <br/> - This identifier is unique across text track cues of a THEOplayer instance and can be used to distinguish between cues.
     * <br/> - This identifier is a randomly generated number.
     */
    readonly uid: number;
    /**
     * The playback position at which the cue becomes active, in seconds.
     */
    startTime: number;
    /**
     * The playback position at which the cue becomes inactive, in seconds.
     */
    endTime: number;
    /**
     * The content of the cue.
     *
     * @remarks
     * The content differs depending on the {@link TextTrackCue.track}'s {@link TextTrack."type" | type }:
     * <br/> - `'emsg'`: Content is a Uint8Array representing the binary message data from the `emsg` box.
     * <br/> - `'eventstream'`: Content is the value of the `messageData` attribute which was specified in the manifest.
     * <br/> - `'ttml'`: Content is an intermediate TTML document’s body element. This is a view of a TTML document where all nodes in the document are active during the cue’s startTime and endTime. As a result, all begin, dur and end properties have been removed. TTML Styles, Regions and Metadata are stored in cue.styles, cue.regions, cue.metadata respectively. Combining those properties with the given content should suffice to render a TTML cue.
     * <br/> - `'webvtt'`: Content is the cue text in raw unparsed form.
     */
    content: any;
}

/**
 * List of text track cues.
 *
 * @category Media and Text Tracks
 * @public
 */
interface TextTrackCueList extends ReadonlyArray<TextTrackCue> {
    /**
     * The number of text track cues in the list.
     */
    readonly length: number;
    /**
     * Return the text track cue at the requested index in the list.
     *
     * @param index - A `number` representing the index of a text track cue in the list.
     * @returns The text track cue with index `index` in the list.
     */
    item(index: number): TextTrackCue;
    /**
     * Index signature to get the text track cue at the requested index in the list.
     */
    readonly [index: number]: TextTrackCue;
}

/**
 * Fired when a new track has been added to this list.
 *
 * @category Media and Text Tracks
 * @category Events
 * @public
 */
interface AddTrackEvent extends Event<'addtrack'> {
    /**
     * The track that has been added.
     */
    readonly track: Track;
}
/**
 * Fired when a track has been removed to this list.
 *
 * @category Media and Text Tracks
 * @category Events
 * @public
 */
interface RemoveTrackEvent extends Event<'removetrack'> {
    /**
     * The track that has been removed.
     */
    readonly track: Track;
}
/**
 * Fired when a track has been changed.
 *
 * @category Media and Text Tracks
 * @category Events
 * @public
 */
interface TrackChangeEvent extends Event<'change'> {
    /**
     * The track that has changed.
     */
    readonly track: Track;
}
/**
 * The events fired by a {@link TrackList}.
 *
 * @category Media and Text Tracks
 * @public
 */
interface TrackListEventMap {
    /**
     * Fired when a track is added.
     */
    addtrack: AddTrackEvent;
    /**
     * Fired when a track is removed.
     */
    removetrack: RemoveTrackEvent;
    /**
     * Fired when a track is activated or deactivated.
     */
    change: TrackChangeEvent;
}

/**
 * Fired when one or more properties of a track have been updated.
 *
 * @category Media and Text Tracks
 * @category Events
 * @public
 */
interface TrackUpdateEvent extends Event<'update'> {
    /**
     * The track that has been updated.
     */
    readonly track: Track;
}
/**
 * The events fired by a {@link Track}.
 *
 * @category Media and Text Tracks
 * @public
 */
interface TrackEventMap {
    /**
     * Fired when a media track's {@link MediaTrack.enabled | enabled} or a text track's {@link TextTrack.mode | mode} changes.
     */
    change: TrackChangeEvent;
    /**
     * Fired when the track updates.
     *
     * @remarks
     * <br/> - A track might update because a change propagated from a remote player (e.g. Chromecast).
     */
    update: TrackUpdateEvent;
}
/**
 * Represents a track of a media resource.
 *
 * @remarks
 * <br/> - A specific track type (e.g. {@link TextTrack}) will always be used.
 *
 * @category Media and Text Tracks
 * @public
 */
interface Track extends EventDispatcher<TrackEventMap> {
    /**
     * The kind of the track.
     *
     * @remarks
     * <br/> - The values for this property depend on the specific type of the track.
     */
    kind: string;
    /**
     * The identifier of the track.
     *
     * @remarks
     * <br/> - This identifier can be used to distinguish between related tracks, e.g. tracks in the same list.
     */
    id: string;
    /**
     * A unique identifier of the track.
     *
     * @remarks
     * <br/> - This identifier is unique across tracks of a THEOplayer instance and can be used to distinguish between tracks.
     * <br/> - This identifier is a randomly generated number.
     */
    uid: number;
    /**
     * The label of the track.
     */
    label: string;
    /**
     * The language of the track.
     */
    language: string;
    /**
     * The accessibility settings of the track.
     *
     * @remarks
     * <br/> - For DASH: the accessibility descriptors for the corresponding AdaptationSet.
     * <br/> - For HLS: the CHARACTERISTICS for the corresponding #EXT-X-MEDIA tag.
     */
    readonly accessibility: AccessibilityRole[];
}
/**
 * Possible accessibility roles.
 *
 * @category Media and Text Tracks
 * @public
 */
type AccessibilityRole = 'caption' | 'sign' | 'description' | 'enhanced audio intelligibility' | 'easy reader' | 'transcribes spoken dialog' | 'describes music and sound' | 'describes video';

/**
 * An error that is thrown by THEOplayer.
 *
 * @category Errors
 * @public
 */
interface THEOplayerError extends Error {
    /**
     * An {@link ErrorCode} that indicates the type of error that has occurred.
     */
    readonly code: ErrorCode;
    /**
     * An `ErrorCategory` that indicates the category of the error that has occurred.
     *
     * @remarks
     * <br/> - Equivalent to `ErrorCategory.fromCode(error.code)`
     */
    readonly category: ErrorCategory;
    /**
     * The underlying cause of this error, if known.
     */
    readonly cause: Error | undefined;
}

/**
 * Fired when an error occurs.
 *
 * @category Errors
 * @category Events
 * @public
 */
interface ErrorEvent extends Event<'error'> {
    /**
     * The error that occurred.
     *
     * @deprecated use {@link ErrorEvent.errorObject | errorObject.message} instead
     */
    error: string;
    /**
     * An error object containing additional information about the error.
     */
    errorObject: THEOplayerError;
}

/**
 * An error code whose category is `ErrorCategory.SUBTITLE`.
 *
 * @category Media and Text Tracks
 * @category Errors
 * @public
 */
type TextTrackErrorCode = ErrorCode.SUBTITLE_LOAD_ERROR | ErrorCode.SUBTITLE_CORS_ERROR | ErrorCode.SUBTITLE_PARSE_ERROR;
/**
 * An error thrown by a text track.
 *
 * @category Media and Text Tracks
 * @category Errors
 * @public
 */
interface TextTrackError extends THEOplayerError {
    /**
     * {@inheritDoc THEOplayerError.code}
     */
    readonly code: TextTrackErrorCode;
    /**
     * The URL of the (sideloaded) text track.
     */
    readonly url: string;
    /**
     * The status code from the HTTP response.
     */
    readonly status: number;
}

/**
 * The content type of a text track, represented by a value from the following list:
 * <br/> - `'srt'`: The track contains SRT (SubRip Text) content.
 * <br/> - `'ttml'`: The track contains TTML (Timed Text Markup Language) content.
 * <br/> - `'webvtt'`: The track contains WebVTT (Web Video Text Tracks) content.
 * <br/> - `'emsg'`: The track contains emsg (Event Message) content.
 * <br/> - `'eventstream'`: The track contains Event Stream content.
 * <br/> - `'id3'`: The track contains ID3 content.
 * <br/> - `'cea608'`: The track contains CEA608 content.
 * <br/> - `'daterange'`: The track contains HLS EXT-X-DATERANGE content.
 * <br/> - `'millicast'`: The track contains Millicast metadata content.
 * <br/> - `''`: The type of the track contents is unknown.
 *
 * @category Media and Text Tracks
 * @public
 */
type TextTrackType = 'srt' | 'ttml' | 'webvtt' | 'emsg' | 'eventstream' | 'id3' | 'cea608' | 'daterange' | 'millicast' | '';
/**
 * The ready state of a text track, represented by a value from the following list:
 * <br/> - `0`: Indicates that the text track's cues have not been obtained.
 * <br/> - `1`: The text track is loading. Further cues might still be added to the track by the parser.
 * <br/> - `2`: The text track has been loaded with no fatal errors.
 * <br/> - `3`: An error occurred obtaining the cues for the track. Some or all of the cues are likely missing and will not be obtained.
 *
 * @category Media and Text Tracks
 * @public
 */
type TextTrackReadyState = 0 | 1 | 2 | 3;
/**
 * An error event fired by a {@link TextTrack}.
 *
 * @category Media and Text Tracks
 * @category Errors
 * @category Events
 * @public
 */
interface TextTrackErrorEvent extends ErrorEvent {
    /**
     * {@inheritDoc ErrorEvent.errorObject}
     */
    readonly errorObject: TextTrackError;
}
/**
 * Fired when a cue is added to the text track.
 *
 * @category Media and Text Tracks
 * @category Events
 * @public
 */
interface TextTrackAddCueEvent extends Event<'addcue'> {
    /**
     * The cue that is added to the text track.
     */
    readonly cue: TextTrackCue;
}
/**
 * Fired when a cue is removed from the text track.
 *
 * @category Media and Text Tracks
 * @category Events
 * @public
 */
interface TextTrackRemoveCueEvent extends Event<'removecue'> {
    /**
     * The cue that is removed from the text track.
     */
    readonly cue: TextTrackCue;
}
/**
 * Fired when a cue from the text track is updated.
 *
 * @category Media and Text Tracks
 * @category Events
 * @public
 */
interface TextTrackUpdateCueEvent extends Event<'updatecue'> {
    /**
     * The cue from the text track that is updated.
     */
    readonly cue: TextTrackCue;
}
/**
 * Fired when a cue of the text track has entered.
 *
 * @category Media and Text Tracks
 * @category Events
 * @public
 */
interface TextTrackEnterCueEvent extends Event<'entercue'> {
    /**
     * The cue from the text track that has entered.
     */
    readonly cue: TextTrackCue;
}
/**
 * Fired when a cue of the text track has exited.
 *
 * @category Media and Text Tracks
 * @category Events
 * @public
 */
interface TextTrackExitCueEvent extends Event<'exitcue'> {
    /**
     * The cue from the text track that has exited.
     */
    readonly cue: TextTrackCue;
}
/**
 * Fired when the displaying cues of the text track has changed.
 *
 * @category Media and Text Tracks
 * @category Events
 * @public
 */
interface TextTrackCueChangeEvent extends Event<'cuechange'> {
    /**
     * The text track which displaying cues has changed.
     */
    readonly track: TextTrack;
}
/**
 * Fired when the {@link TextTrack.readyState | ready state} of the text track has changed.
 *
 * @category Media and Text Tracks
 * @category Events
 * @public
 */
interface TextTrackReadyStateChangeEvent extends Event<'readystatechange'> {
    /**
     * The text track which ready state has changed.
     */
    readonly track: TextTrack;
    /**
     * The new {@link TextTrack.readyState | ready state} of the text track.
     */
    readonly readyState: TextTrackReadyState;
}
/**
 * Fired when the {@link TextTrack."type" | type} of the text track has changed.
 *
 * @category Media and Text Tracks
 * @category Events
 * @public
 */
interface TextTrackTypeChangeEvent extends Event<'typechange'> {
    /**
     * The text track which type has changed.
     */
    readonly track: TextTrack;
}
/**
 * The events fired by a {@link TextTrack}.
 *
 * @category Media and Text Tracks
 * @public
 */
interface TextTrackEventMap extends TrackEventMap {
    /**
     * Fired when a cue is added to the track.
     */
    addcue: TextTrackAddCueEvent;
    /**
     * Fired when a cue of the track is removed.
     */
    removecue: TextTrackRemoveCueEvent;
    /**
     * Fired when a cue of the track is updated.
     */
    updatecue: TextTrackUpdateCueEvent;
    /**
     * Fired when a cue of the track enters.
     */
    entercue: TextTrackEnterCueEvent;
    /**
     * Fired when a cue of the track exits.
     */
    exitcue: TextTrackExitCueEvent;
    /**
     * Fired when the displaying cues of the text track changes.
     */
    cuechange: TextTrackCueChangeEvent;
    /**
     * Fired when the text track's {@link TextTrack.readyState | ready state} changes.
     */
    readystatechange: TextTrackReadyStateChangeEvent;
    /**
     * Fired when the text track's {@link TextTrack."type" | type} changes.
     */
    typechange: TextTrackTypeChangeEvent;
    /**
     * Fired when an error occurred while loading or parsing the track.
     */
    error: TextTrackErrorEvent;
}
/**
 * Represents a text track of a media resource.
 *
 * @category Media and Text Tracks
 * @public
 */
interface TextTrack extends Track, EventDispatcher<TextTrackEventMap> {
    /**
     * The kind of the text track, represented by a value from the following list:
     * <br/> - `'subtitles'`: The track contains subtitles.
     * <br/> - `'captions'`: The track contains closed captions, a translation of dialogue and sound effects.
     * <br/> - `'descriptions'`: The track contains descriptions, a textual description of the video.
     * <br/> - `'chapters'`: The track contains chapter titles.
     * <br/> - `'metadata'`: The track contains metadata. This track will not serve display purposes.
     */
    readonly kind: string;
    /**
     * The label of the text track.
     */
    label: string;
    /**
     * The language of the text track.
     */
    readonly language: string;
    /**
     * The identifier of the text track.
     *
     * @remarks
     * <br/> - This identifier can be used to distinguish between related tracks, e.g. tracks in the same list.
     * <br/> - For a text track embedded within an MPEG-DASH stream, this returns the Representation’d id attribute.
     * <br/> - For MPEG-DASH streams a Representation's ID is preferred over the AdaptationSet's ID.
     */
    readonly id: string;
    /**
     * A unique identifier of the text track.
     *
     * @remarks
     * <br/> - This identifier is unique across tracks of a THEOplayer instance and can be used to distinguish between tracks.
     * <br/> - This identifier is a randomly generated number.
     */
    readonly uid: number;
    /**
     * The in-band metadata track dispatch type of the text track.
     */
    readonly inBandMetadataTrackDispatchType: string;
    /**
     * The mode of the text track, represented by a value from the following list:
     * <br/> - `'disabled'`: The track is disabled.
     * <br/> - `'hidden'`: The track is hidden.
     * <br/> - `'showing'`: The track is showing.
     *
     * @remarks
     * <br/> - A disabled track is not displayed and exposes no active cues, nor fires cue events.
     * <br/> - A hidden track is not displayed but exposes active cues and fires cue events.
     * <br/> - A showing track is displayed, exposes active cues and fires cue events.
     */
    mode: string;
    /**
     * The ready state of the text track.
     */
    readonly readyState: TextTrackReadyState;
    /**
     * The content type of the text track.
     */
    readonly type: TextTrackType;
    /**
     * The list of cues of the track.
     *
     * @remarks
     * <br/> - If the {@link TextTrack.mode} is `'disabled'`, this property is `null`.
     */
    readonly cues: TextTrackCueList | null;
    /**
     * The list of active cues of the track.
     *
     * @remarks
     * <br/> - A cue is active if the current playback position falls within the time bounds of the cue.
     * <br/> - This list dynamically updates based on the current playback position.
     * <br/> - If the {@link TextTrack.mode} is `'disabled'`, this property is `null`.
     */
    readonly activeCues: TextTrackCueList | null;
    /**
     * The source of the text track.
     */
    readonly src: string;
    /**
     * Indicates whether the track contains Forced Narrative cues.
     * This may only be true for subtitle tracks where
     * <br/> - For DASH: the corresponding AdaptationSet contains a child Role with its value attribute equal to `'forced_subtitle'`
     * <br/> - For HLS: the corresponding #EXT-X-MEDIA tag contains the attributes TYPE=SUBTITLES and FORCED=YES (not supported yet)
     */
    readonly forced: boolean;
    /**
     * {@inheritDoc EventDispatcher.addEventListener}
     */
    addEventListener<TType extends StringKeyOf<TextTrackEventMap>>(type: TType | readonly TType[], listener: EventListener<TextTrackEventMap[TType]>): void;
    /**
     * {@inheritDoc EventDispatcher.removeEventListener}
     */
    removeEventListener<TType extends StringKeyOf<TextTrackEventMap>>(type: TType | readonly TType[], listener: EventListener<TextTrackEventMap[TType]>): void;
}

/**
 * Represents a source for the THEOlive integration.
 *
 * @category Source
 * @public
 */
interface TheoLiveSource extends TypedSource {
    type: 'theolive';
    /**
     * @deprecated use {@link TheoLiveSource.type} instead.
     */
    integration?: 'theolive';
}

/**
 * Represents a source for a {@link https://dolby.io/products/real-time-streaming/ | Millicast} live stream.
 *
 * @category Source
 * @category Millicast
 * @public
 */
interface MillicastSource extends TypedSource {
    /**
     * The content type.
     *
     * Must be `"millicast"`.
     */
    type: 'millicast';
    /**
     * The name of the Millicast stream to subscribe to.
     *
     * @see https://millicast.github.io/millicast-sdk/global.html#DirectorSubscriberOptions
     */
    src: string;
    /**
     * The Millicast account identifier.
     *
     * @see https://millicast.github.io/millicast-sdk/global.html#DirectorSubscriberOptions
     */
    streamAccountId: string;
    /**
     * Token to subscribe to secure streams.
     *
     * - If you are subscribing to an unsecure stream, you can omit this param.
     *
     * @see https://millicast.github.io/millicast-sdk/global.html#DirectorSubscriberOptions
     */
    subscriberToken?: string;
    /**
     * An optional configuration object to set additional subscriber options.
     *
     * - The available options are listed in the link below.
     *
     * @see https://millicast.github.io/millicast-sdk/View.html#connect
     */
    connectOptions?: Record<string, any>;
    /**
     * The URL of the API endpoint that the SDK communicates with for authentication.
     *
     * @see https://millicast.github.io/millicast-sdk/module-Director.html#~setEndpoint
     */
    apiUrl?: string;
}

/**
 * The latency configuration for managing the live offset of the player.
 *
 * @remarks
 * <br/> - The player might change the latency configuration based on playback events like stalls.
 * <br/> - The current latency configuration can be monitored at {@link LatencyManager.currentConfiguration}.
 *
 * @category Source
 * @public
 */
interface SourceLatencyConfiguration {
    /**
     * The start of the target live window.
     * If the live offset becomes smaller than this value, the player will slow down in order to increase the latency.
     *
     * @defaultValue 0.66 times the {@link targetOffset}.
     */
    minimumOffset?: number;
    /**
     * The end of the target live window.
     * If the live offset becomes higher than this value, the player will speed up in order to decrease the latency.
     *
     * @defaultValue 1.5 times the {@link targetOffset}.
     */
    maximumOffset?: number;
    /**
     * The live offset that the player will aim for. When correcting the offset by tuning the playbackRate,
     * the player will stop correcting when it reaches this value.
     *
     * @remarks
     * <br/> - This will override the {@link BaseSource.liveOffset} value.
     */
    targetOffset: number;
    /**
     * The live offset at which the player will automatically trigger a live seek.
     *
     * @defaultValue 3 times the {@link targetOffset}.
     */
    forceSeekOffset?: number;
    /**
     * Indicates the minimum playbackRate used to slow down the player.
     *
     * @defaultValue `0.92`
     */
    minimumPlaybackRate?: number;
    /**
     * Indicates the maximum playbackRate used to speed up the player.
     *
     * @defaultValue `1.08`
     */
    maximumPlaybackRate?: number;
    /**
     * The amount of seconds that target latency can be temporarily increased to counteract unstable
     * network conditions.
     *
     * @remarks
     * <br/> - This only works for HESP and THEOlive streams.
     */
    leniency?: number;
}

/**
 * Represents a media resource.
 *
 * @remarks
 * <br/> - Can be a string value representing the URL of a media resource, a {@link TypedSource} or an {@link UplynkSource}.
 *
 * @category Source
 * @public
 */
type Source = string | TypedSource | UplynkSource | TheoLiveSource | MillicastSource;
/**
 * A media resource or list of media resources.
 *
 * @remarks
 * <br/> - The order of sources when using a list determines their priority when attempting playback.
 *
 * @category Source
 * @public
 */
type Sources = Source | Source[];
/**
 * The cross-origin setting of a source, represented by a value from the following list:
 * <br/> - `'anonymous'`: CORS requests will have the credentials flag set to 'same-origin'.
 * <br/> - `'use-credentials'`: CORS requests will have the credentials flag set to 'include'.
 * <br/> - `''`: Setting the empty string is the same as `'anonymous'`
 *
 * @remarks
 * <br/> - See {@link https://developer.mozilla.org/en-US/docs/Web/HTML/CORS_settings_attributes | The crossorigin attribute: Requesting CORS access to content}
 *
 * @category Source
 * @public
 */
type CrossOriginSetting = '' | 'anonymous' | 'use-credentials';
/**
 * Describes the configuration of a player's source.
 *
 * @category Source
 * @public
 */
interface SourceConfiguration {
    /**
     * List of {@link AdDescription}s to be queued for playback.
     */
    ads?: AdDescription[];
    /**
     * Whether the player should be blocked when an ad-related error occurs.
     *
     * @remarks
     * <br/> - A blocked player is not usable anymore. This has the same effect as invoking {@link ChromelessPlayer.destroy}.
     *
     * @defaultValue `false`
     */
    blockContentIfAdError?: boolean;
    /**
     * If set, only allow ads to play that are scheduled after this time.
     *
     * @remarks
     * <br/> - This setting is strictly after - e.g. setting `playAdsAfterTime` to 15 will cause the player to ignore an ad break scheduled to play at 15s.
     * <br/> - When scheduling a VMAP, it is required to set the {@link AdSource} type to `vmap`.
     *
     */
    playAdsAfterTime?: number;
    /**
     * Content protection configuration.
     */
    contentProtection?: DRMConfiguration;
    /**
     * {@inheritDoc SourceConfiguration.contentProtection}
     * @deprecated Superseded by {@link SourceConfiguration.contentProtection}.
     */
    drm?: DRMConfiguration;
    /**
     * The poster of the media source.
     *
     * @remarks
     * <br/> - An empty string (`''`) clears the current poster.
     * <br/> - This poster has priority over {@link ChromelessPlayer.poster}.
     */
    poster?: string;
    /**
     * The stream type.
     *
     * @remarks
     * <br/> - Available since 6.9.0.
     * <br/> - This is used as a hint for the player to show the correct UI while loading the stream,
     *         for example to avoid showing a seek bar when the stream is known in advance to be live.
     * <br/> - This is **required** for live and DVR streams when casting to Chromecast,
     *         in order for the Chromecast receiver to show the correct UI.
     */
    streamType?: StreamType;
    /**
     * List of text tracks to be side-loaded with the media source.
     *
     * @remarks
     * <br/> - A source change will reset side-loaded text tracks.
     */
    textTracks?: TextTrackDescription[];
    /**
     * Virtual reality configuration.
     */
    vr?: VRConfiguration;
    /**
     * List of {@link AnalyticsDescription}s to configure analytics integrations for the media source.
     */
    analytics?: AnalyticsDescription[];
    /**
     * The muted autoplay policy.
     *
     * @remarks
     * <br/> - The muted autoplay policy is impacted by this property and {@link PlayerConfiguration.mutedAutoplay}.
     *
     * @defaultValue `'none'`
     */
    mutedAutoplay?: MutedAutoplayConfiguration;
    /**
     * The URL of a time server used by the player to synchronise the time in DASH sources.
     *
     * @remarks
     * <br/> - The time server should return time in ISO-8601 format.
     * <br/> - Overrides the time server provided the DASH manifest's `<UTCTiming>`.
     * <br/> - All sources will use the time server. Alternatively, for one source use {@link BaseSource.timeServer}.
     */
    timeServer?: string;
    /**
     * Chromecast metadata configuration.
     *
     * @remarks
     * <br/> - Available since v2.21.0.
     */
    metadata?: ChromecastMetadataDescription;
}
/**
 * Describes the configuration of a player's source.
 *
 * @category Source
 * @public
 */
interface SourceDescription extends SourceConfiguration {
    /**
     * One or more media resources for playback.
     *
     * @remarks
     * <br/> - Multiple media sources should be used to increase platform compatibility. See examples below for important use cases.
     * <br/> - The player will try each source in the provided order.
     *
     * @example
     * In this example, the player will first try to play the DASH source.
     * This might fail if the browser does not support the {@link https://www.widevine.com/ | Widevine} or {@link https://www.microsoft.com/playready/ | PlayReady} CDM, for example on Safari.
     * In that case, the player will try to play the HLS source instead.
     *
     * ```
     * [{
     *   src: 'dash-source-with-drm.mpd'
     *   contentProtection: {
     *     widevine: {
     *       licenseAcquisitionURL: 'https://license.company.com/wv'
     *     },
     *     playready: {
     *       licenseAcquisitionURL: 'https://license.company.com/pr'
     *     }
     *   }
     * },{
     *   src: 'hls-source-with-drm.m3u8',
     *   contentProtection: {
     *     fairplay: {
     *       certificateURL: 'https://license.company.com/fp'
     *     }
     *   }
     * }]
     * ```
     *
     * @example
     * In this example, the player will first try to play the DASH source.
     * This might fail if the browser does not support the {@link https://developer.mozilla.org/en-US/docs/Web/API/Media_Source_Extensions_API | Media Source Extensions API}.
     * In that case, the player will try to play the MP4 source instead, though without features such as adaptive bitrate switching.
     *
     * ```
     * [{
     *   src: 'source.mpd'
     * },{
     *   src: 'source.mp4'
     * }]
     * ```
     */
    sources?: Sources;
}
/**
 * Describes the configuration of a side-loaded text track.
 *
 * @category Source
 * @public
 */
interface TextTrackDescription {
    /**
     * Whether the text track should be enabled by default.
     *
     * @remarks
     * <br/> - Only one text track per {@link TextTrack.kind} may be marked as default.
     *
     * @defaultValue `false`
     */
    default?: boolean;
    /**
     * The kind of the text track, represented by a value from the following list:
     * <br/> - `'subtitles'`: The track provides subtitles, used to display subtitles in a video.
     * <br/> - `'captions'`: The track provides a translation of dialogue and sound effects (suitable for users with a hearing impairment).
     * <br/> - `'descriptions'`: The track provides a textual description of the video (suitable for users with a vision impairment).
     * <br/> - `'chapters'`: The track provides chapter titles (suitable for navigating the media resource).
     * <br/> - `'metadata'`: The track provides content used by scripts and is not visible for users.
     *
     * @remarks
     * <br/> -  If an unrecognized value is provided, the player will interpret it as `'metadata'`.
     *
     * @defaultValue `'subtitles'`
     */
    kind?: string;
    /**
     * The format of the track, represented by a value from the following list:
     * <br/> - `'srt'`: The track contains SRT (SubRip Text) content.
     * <br/> - `'ttml'`: The track contains TTML (Timed Text Markup Language) content.
     * <br/> - `'webvtt'`: The track contains WebVTT (Web Video Text Tracks) content.
     * <br/> - `''` (default): The format is auto-detected based on its content.
     *
     * @defaultValue `''`
     * @see {@link TextTrackType}
     */
    format?: '' | 'srt' | 'ttml' | 'webvtt';
    /**
     * The source URL of the text track.
     */
    src: string;
    /**
     * The language of the text track.
     */
    srclang?: string;
    /**
     * A label for the text track.
     *
     * @remarks
     * <br/> - This will be used as an identifier on the player API and in the UI.
     */
    label?: string;
    /**
     * The identifier of this text track.
     *
     * @internal
     */
    id?: string;
}
/**
 * Represents the common properties of a media resource.
 *
 * @category Source
 * @public
 */
interface BaseSource {
    /**
     * The integration ID of the source.
     *
     * @remarks
     * <br/> - This can be used to signal that a source is specific to an integration.
     */
    integration?: SourceIntegrationId;
    /**
     * The cross-origin setting of the source.
     *
     * @defaultValue `''`
     *
     * @remarks
     * <br/> - Available since v2.9.0.
     */
    crossOrigin?: CrossOriginSetting;
    /**
     * Whether the player is allowed to use credentials for cross-origin requests.
     *
     * @remarks
     * <br/> - Credentials are cookies, authorization headers or TLS client certificates.
     *
     * @defaultValue `false`
     */
    useCredentials?: boolean;
    /**
     * The offset in seconds used to determine the live point.
     * This live point is the end of the manifest minus the provided offset.
     *
     * @remarks
     * <br/> - Available since v2.35.0.
     * <br/> - Will be overridden by {@link SourceLatencyConfiguration.targetOffset} if it is specified.
     *
     * @defaultValue Three times the segment's target duration.
     */
    liveOffset?: number;
    /**
     * The URL of a time server used by the player to synchronise the time in DASH sources.
     *
     * @remarks
     * <br/> - Available since v2.47.0.
     * <br/> - The time server should return time in ISO-8601 format.
     * <br/> - Overrides the time server provided the DASH manifest's `<UTCTiming>`.
     * <br/> - Only this source will use the time server. Alternatively, for all source use {@link SourceConfiguration.timeServer}.
     */
    timeServer?: string;
    /**
     * Whether the player should parse and expose date ranges from HLS manifests.
     *
     * @defaultValue `false`
     *
     * @remarks
     * <br/> - Available since v2.61.0.
     */
    hlsDateRange?: boolean;
    /**
     * Whether to use an experimental rendering pipeline for playback.
     *
     * @remarks
     * <br/> - The availability of an experimental rendering pipeline depends on the platform.
     * <br/> - Only use after specifically being advised to.
     *
     * @internal
     */
    experimentalRendering?: boolean;
    /**
     * Whether to use native ui rendering.
     *
     * @internal
     */
    nativeUiRendering?: boolean;
    /**
     * Whether the source should be played in the low-latency-mode of the player.
     *
     * @defaultValue `false`
     *
     * @remarks
     * <br/> - This setting must be `true` when using Low-Latency CMAF with ABR.
     * <br/> - Available since v2.62.0.
     */
    lowLatency?: boolean;
    /**
     * Whether this source should be played using native playback.
     *
     * @defaultValue `false`
     *
     * @remarks
     * <br/> - Available since v2.68.0.
     * <br/> - Ignored for DASH streams.
     * <br/> - Only supported on browsers that can play HLS streams natively, will error otherwise.
     */
    useNativePlayback?: boolean;
    /**
     * (Experimental) Whether to use `ManagedMediaSource` if available.
     *
     * @defaultValue `false`
     *
     * @remarks
     * <br/> - Available since v6.2.0.
     * <br/> - At the moment, this requires iOS 17.1 beta 2 or higher, with the "Managed Media Source API" feature flag
     *         turned on in the Advanced settings of Safari.
     * <br/> - Ignored if {@link BaseSource.useNativePlayback} is `true`.
     *
     * @see https://github.com/w3c/media-source/issues/320
     */
    useManagedMediaSource?: boolean;
    /**
     * The configuration for controlling playback of an MPEG-DASH stream.
     *
     * @remarks
     * <br/> - Available since v2.79.0.
     * <br/> - Ignored for non-DASH streams.
     */
    dash?: DashPlaybackConfiguration;
    /**
     * The configuration for controlling playback of an HLS stream.
     *
     * @remarks
     * <br/> - Available since v2.82.0.
     * <br/> - Ignored for non-HLS streams.
     */
    hls?: HlsPlaybackConfiguration;
    /**
     * The source's ABR configuration.
     *
     * @remarks
     * <br/> - Available since v3.1.0.
     * <br/> - Overrides {@link PlayerConfiguration.abr}.
     * <br/> - Used for DASH and LL-HLS streams.
     */
    abr?: SourceAbrConfiguration;
    /**
     * Whether this source should be played using the LCEVC sdk.
     *
     * @remarks
     * <br/> - Requires the LCEVC feature to be enabled.
     * <br/> - Requires the V-Nova LCEVC SDK to be loaded on the page.
     * <br/> - Only available for DASH and HLS streams.
     */
    lcevc?: boolean;
    /**
     * A list of embedded {@link TextTrackType}s to ignore when parsing media segments.
     *
     * @remarks
     * <br/> - Available since v5.9.0
     * <br/> - Only 'cea608' and 'emsg' can currently be ignored.
     * <br/> - Only for DASH and HLS playback.
     *
     */
    ignoreEmbeddedTextTrackTypes?: TextTrackType[];
    /**
     * Whether to seamlessly switch between discontinuities or periods.
     *
     * @remarks
     * The player supports two strategies for handling a switch between two discontinuities in an HLS stream or two periods in an MPEG-DASH stream:
     * <br/> - <strong>Seamless</strong>: Once the player is done buffering the current discontinuity/period, it immediately starts buffering the next
     *         discontinuity/period. This requires that the current discontinuity/period and the next discontinuity/period have compatible codecs and content protection,
     *         or that the platform supports buffering different codecs in a single player.
     *         Because the next discontinuity/period is preloaded ahead of time, this makes the actual switch between discontinuities/periods (almost) completely seamless.
     * <br/> - <strong>Hard</strong>: The player waits until playback reaches the end of the current discontinuity/period before buffering and playing the next
     *         discontinuity/period. Because the buffering is not done ahead of time, this may result in a noticeable stall at the start of the next discontinuity/period.
     *         However, this strategy does not require any special platform support, so it works on any platform or device.
     *
     * By default, the player will automatically choose between a seamless or a hard discontinuity/period switch based on the codecs and content protection of
     * the two discontinuities/periods, and the support information reported by the platform. However, if you notice that the player makes an incorrect decision
     * on certain streams or platforms, you can use this option to override its behavior as a stopgap solution. (You should still report this
     * problem to THEOplayer support, so we can improve the player's default behavior and you can remove this override.)
     *
     * @defaultValue `'auto'`
     */
    seamlessSwitchStrategy?: SeamlessSwitchStrategy;
    /**
     * The source's latency configuration.
     *
     * @remarks
     * <br/> - Available since v7.4.0.
     * <br/> - Ignored for VOD playback.
     */
    latencyConfiguration?: SourceLatencyConfiguration;
}
/**
 * The strategy for period or discontinuity switches (see {@link BaseSource.seamlessSwitchStrategy}), represented by a value from the following list:
 * <br/> - `'auto'`: The player uses seamless switches if the platform supports it, and hard switches otherwise.
 *                   This is the default.
 * <br/> - `'never'`: The player never uses a seamless switch, and always uses a hard switch.
 *                    Use this if you notice that the player is attempting but failing to preload the next period or discontinuity on the current platform.
 * <br/> - `'always'`: The player always uses a seamless switch, and never uses a hard switch.
 *                     Use this if you notice that the player never preloads the next discontinuity or period, even though you know that the current platform
 *                     should support it.
 * <br/> - `'clear-only'`: The player only uses a seamless switch when no content protection is used in the current and next period. Otherwise
 *                      it always uses a hard switch.
 *                      Use this if you notice that the player is attempting but failing to preload the next period on the current platform only when
 *                      content protection is involved.
 *                      This is only supported for MPEG-DASH.
 * <br/> - `'same-drm-only'`: The player only uses a seamless switch when the same or no content protection is used in the current and next period. Otherwise
 *                      it always uses a hard switch.
 *                      Use this if you notice that the player is attempting but failing to preload the next period on the current platform only when
 *                      content protection is different between discontinuities.
 *                      This is only supported for MPEG-DASH.
 * @category Source
 * @public
 */
type SeamlessSwitchStrategy = 'auto' | 'always' | 'never' | 'clear-only' | 'same-drm-only';
/**
 * Represents a media resource characterized by a URL to the resource and optionally information about the resource.
 *
 * @category Source
 * @public
 */
interface TypedSource extends BaseSource {
    /**
     * The source URL of the media resource.
     *
     * @remarks
     * <br/> - Required if the `ssai` property is absent.
     * <br/> - Available since v2.4.0.
     */
    src?: string;
    /**
     * The content type (MIME type) of the media resource, represented by a value from the following list:
     * <br/> - `'application/dash+xml'`: The media resource is an MPEG-DASH stream.
     * <br/> - `'application/x-mpegURL'` or `'application/vnd.apple.mpegurl'`: The media resource is an HLS stream.
     * <br/> - `'video/mp4'`, `'video/webm'` and other formats: The media resource should use native HTML5 playback if supported by the browser.
     * <br/> - `'application/vnd.theo.hesp+json'`: The media resource is an HESP stream.
     * <br/> - `'millicast'`: The media resource is a {@link MillicastSource | Millicast stream}.
     * <br/> - `'theolive'`: The media resource is a {@link TheoLiveSource | THEOlive stream}.
     *
     * @remarks
     * <br/> - Available since v2.4.0.
     */
    type?: string;
    /**
     * The content protection parameters for the media resource.
     *
     * @remarks
     * <br/> - Available since v2.15.0.
     */
    contentProtection?: DRMConfiguration;
    /**
     * The content protection parameters for the media resource.
     *
     * @deprecated Superseded by {@link TypedSource.contentProtection}.
     */
    drm?: DRMConfiguration;
    /**
     * The Server-side Ad Insertion parameters for the media resource.
     *
     * @remarks
     * <br/> - Available since v2.12.0.
     */
    ssai?: ServerSideAdInsertionConfiguration;
    /**
     * Whether the source is for an ad or a content playback
     *
     * @internal
     */
    isAdvertisement?: boolean;
}
/**
 * The stream type, represented by a value from the following list:
 * <br/> - `'live'`: Live content.
 * <br/> - `'dvr'`: Live content with DVR.
 * <br/> - `'vod'`: On demand content.
 *
 * @category Source
 * @public
 */
type StreamType = 'live' | 'dvr' | 'vod';
/**
 * The integration identifier of a source specific to a pre-integration, represented by a value from the following list:
 * <br/> - `'verizon-media'`: The source is a {@link UplynkSource}. (Deprecated, superseded by `'uplynk'`)
 * <br/> - `'mediatailor'`: The source contains the MediaTailor initialization url.
 * <br/> - `'theolive'`: The source is a {@link TheoLiveSource}. (Deprecated, see {@link TheoLiveSource.integration})
 * <br/> - `'uplynk'`: The source is an {@link UplynkSource}.
 *
 * @category Source
 * @public
 */
type SourceIntegrationId = 'verizon-media' | 'mediatailor' | 'theolive' | 'uplynk';
/**
 * The integration identifier of an analytics description, represented by a value from the following list:
 * <br/> - `'agama'`: The description is an {@link AgamaConfiguration}
 * <br/> - `'youbora'`: The description is a {@link YouboraOptions}
 * <br/> - `'moat'`: The description is a {@link MoatConfiguration}
 * <br/> - `'streamone'`: The description is a {@link StreamOneConfiguration}
 * <br/> - `'smartsight'`: The description is a {@link SmartSightConfiguration}
 *
 * @category Source
 * @public
 */
type AnalyticsIntegrationID = 'agama' | 'youbora' | 'moat' | 'streamone' | 'smartsight';
/**
 * Describes the configuration of an analytics integration.
 *
 * @category Source
 * @public
 */
interface AnalyticsDescription {
    /**
     * The identifier of the analytics integration.
     */
    integration: AnalyticsIntegrationID;
}

/**
 * Fired when {@link RelatedContent.sources} changes.
 *
 * @category UI
 * @category Events
 * @public
 */
type RelatedChangeEvent = Event<'relatedchange'>;
/**
 * Fired when the related content panel is shown.
 *
 * @category UI
 * @category Events
 * @public
 */
type RelatedShowEvent = Event<'show'>;
/**
 * Fired when the related content panel is hidden.
 *
 * @category UI
 * @category Events
 * @public
 */
type RelatedHideEvent = Event<'hide'>;
/**
 * The events fired by the {@link RelatedContent | related content API}.
 *
 * @category UI
 * @public
 */
interface RelatedContentEventMap {
    /**
     * {@inheritDoc RelatedChangeEvent}
     */
    relatedchange: RelatedChangeEvent;
}
/**
 * The related content API.
 *
 * @remarks
 * <br/> - Available since v2.14.2.
 *
 * @category UI
 * @public
 */
interface RelatedContent extends EventDispatcher<RelatedContentEventMap> {
    /**
     * List of related content sources.
     */
    sources: RelatedContentSource[];
}
/**
 * The events fired by the {@link UIRelatedContent | related content API (with ui)}.
 *
 * @category UI
 * @public
 */
interface UIRelatedContentEventMap extends RelatedContentEventMap {
    /**
     * {@inheritDoc RelatedShowEvent}
     */
    show: RelatedShowEvent;
    /**
     * {@inheritDoc RelatedHideEvent}
     */
    hide: RelatedHideEvent;
}
/**
 * The related content UI API which can be used to toggle UI components.
 *
 * @remarks
 * <br/> - Available since v2.14.2.
 *
 * @category UI
 * @public
 */
interface UIRelatedContent extends RelatedContent, EventDispatcher<UIRelatedContentEventMap> {
    /**
     * Whether the related content menu is showing.
     */
    showing: boolean;
    /**
     * Show the related content menu.
     */
    show(): void;
    /**
     * Hides the related content menu.
     */
    hide(): void;
    /**
     * {@inheritDoc EventDispatcher.addEventListener}
     */
    addEventListener<TType extends StringKeyOf<UIRelatedContentEventMap>>(type: TType | readonly TType[], listener: EventListener<UIRelatedContentEventMap[TType]>): void;
    /**
     * {@inheritDoc EventDispatcher.removeEventListener}
     */
    removeEventListener<TType extends StringKeyOf<UIRelatedContentEventMap>>(type: TType | readonly TType[], listener: EventListener<UIRelatedContentEventMap[TType]>): void;
}
/**
 * Represents a related content source.
 *
 * @remarks
 * <br/> - Available since v2.14.2.
 *
 * @category UI
 * @public
 */
interface RelatedContentSource {
    /**
     * The duration of the related content source.
     */
    duration?: string;
    /**
     * The image of the related content source.
     */
    image: string;
    /**
     * The target URL for the related content source.
     *
     * @remarks
     * <br/> - Mutually exclusive with {@link RelatedContentSource.source}.
     * <br/> - Required if {@link RelatedContentSource.source} is not present.
     */
    link?: string;
    /**
     * The source description of the related content source.
     *
     * @remarks
     * <br/> - Mutually exclusive with {@link RelatedContentSource.link}.
     * <br/> - Required if {@link RelatedContentSource.link} is not present.
     */
    source?: SourceDescription;
    /**
     * The title of the related content source.
     */
    title?: string;
}

/**
 * The bundled Video.js library, based on version 5.x.
 *
 * @remarks
 * <br/> - See {@link https://docs.videojs.com/ | documentation}.
 *
 * @category API
 * @category UI
 * @public
 */
declare namespace videojs {
    /**
     * An instance of a player UI.
     *
     * @remarks
     * <br/> - See {@link https://docs.videojs.com/player | documentation}.
     *
     * @public
     */
    interface Player {
    }
}

/**
 * List of tracks.
 *
 * @category Media and Text Tracks
 * @public
 */
interface TrackList<TTrack extends Track> extends ReadonlyArray<TTrack>, EventDispatcher<TrackListEventMap> {
    /**
     * The number of tracks in the list.
     */
    readonly length: number;
    /**
     * Return the track at the requested index in the list.
     *
     * @param index - A `number` representing the index of a track in the list.
     * @returns The track with index `index` in the list.
     */
    item(index: number): TTrack;
    /**
     * Index signature to get the track at the requested index in the list.
     */
    readonly [index: number]: TTrack;
}

/**
 * List of text tracks.
 *
 * @category Media and Text Tracks
 * @public
 */
interface TextTracksList extends TrackList<TextTrack> {
    /**
     * The number of text tracks in the list.
     */
    readonly length: number;
    /**
     * Return the text track at the requested index in the list.
     *
     * @param index - A `number` representing the index of a text track in the list.
     * @returns The text track with index `index` in the list.
     */
    item(index: number): TextTrack;
    /**
     * Index signature to get the text track at the requested index in the list.
     */
    readonly [index: number]: TextTrack;
}

/**
 * The media error code, represented by a value from the following list:
 * <br/> - `1` - ABORTED: The fetching of the associated resource was aborted by the user's request.
 * <br/> - `2` - NETWORK: Some kind of network error occurred which prevented the media from being successfully fetched, despite having previously been available.
 * <br/> - `3` - DECODE: Despite having previously been determined to be usable, an error occurred while trying to decode the media resource, resulting in an error.
 * <br/> - `4` - SRC_NOT_SUPPORTED: The associated resource or media provider object (such as a MediaStream) has been found to be unsuitable.
 * <br/> - `5` - ENCRYPTED: Some kind of digital rights management error occurred.
 * <br/> - `6` - LICENSE_INVALID: The player's license was determined to be invalid.
 * <br/> - `7` - ADVERTISEMENT_ERROR: Some kind of advertisement related error occurred.
 *
 * @category Errors
 * @public
 */
type MediaErrorCode = 1 | 2 | 3 | 4 | 5 | 6 | 7;
/**
 * Thrown when a media error occurs.
 *
 * @category Errors
 * @public
 */
interface MediaError extends Error {
    /**
     * The code of the error.
     */
    readonly code: MediaErrorCode;
    /**
     * The cause of the error, if any.
     */
    readonly cause?: string;
    /**
     * The key system specific error code, if any.
     */
    readonly systemCode?: number;
}

/**
 * The events fired by a {@link Quality}.
 *
 * @category Media and Text Tracks
 * @public
 */
interface QualityEventMap {
    /**
     * {@inheritDoc UpdateQualityEvent}
     */
    update: UpdateQualityEvent;
}
/**
 * Fired when the quality updates.
 *
 * @category Media and Text Tracks
 * @category Events
 * @public
 */
interface UpdateQualityEvent extends Event<'update'> {
    /**
     * The quality which has been updated.
     */
    readonly quality: Quality;
}
/**
 * Represents a quality of a media track.
 *
 * @category Media and Text Tracks
 * @public
 */
interface Quality extends EventDispatcher<QualityEventMap> {
    /**
     * The average bandwidth of the quality, in bits per second.
     */
    readonly averageBandwidth?: number;
    /**
     * The required bandwidth for the quality, in bits per second.
     */
    readonly bandwidth: number;
    /**
     * The codecs of the quality.
     *
     * @remarks
     * <br/> - These are represented as a string containing the codecs as defined by the manifest.
     */
    readonly codecs: string;
    /**
     * The identifier for this quality. This identifier is tied to the stream's internal representation. It may be empty. For a unique id, use {@link Quality.uid}.
     */
    readonly id: string;
    /**
     * The unique identifier for this quality.
     */
    readonly uid: number;
    /**
     * The name of the quality.
     */
    readonly name: string;
    /**
     * The label of the quality.
     */
    label: string;
    /**
     * Whether the quality is available.
     *
     * @remarks
     * <br/> - A quality can be unavailable due to a DRM restriction (e.g. HDCP).
     */
    readonly available: boolean;
    /**
     * The HLS SCORE attribute.
     *
     * @remarks
     * <br/> - Available since v6.8.0.
     * <br/> - Only for HLS streams.
     */
    readonly score: number | undefined;
}
/**
 * Represents a quality of a video track.
 *
 * @category Media and Text Tracks
 * @public
 */
interface VideoQuality extends Quality {
    /**
     * The video height of the video quality, in pixels.
     */
    readonly height: number;
    /**
     * The video width of the video quality, in pixels.
     */
    readonly width: number;
    /**
     * The framerate of the video quality.
     */
    readonly frameRate: number;
    /**
     * The timestamp of the first frame of the video quality, in seconds.
     */
    readonly firstFrame: number;
}
/**
 * Represents a quality of an audio track.
 *
 * @category Media and Text Tracks
 * @public
 */
interface AudioQuality extends Quality {
    /**
     * The sampling rate of the audio quality.
     */
    readonly audioSamplingRate: number | [number, number];
}

/**
 * List of qualities.
 *
 * @category Media and Text Tracks
 * @public
 */
interface QualityList extends Array<Quality> {
    /**
     * Index signature to get the quality at the requested index in the list.
     */
    [index: number]: Quality;
    /**
     * Return the quality at the requested index in the list.
     *
     * @param index - A `number` representing the index of a quality in the list.
     * @returns The quality with index `index` in the list.
     */
    item(index: number): Quality;
}

/**
 * A quality-related event fired by a {@link MediaTrack}.
 *
 * @category Media and Text Tracks
 * @category Events
 * @public
 */
interface QualityEvent<TType extends string> extends Event<TType> {
    /**
     * The quality.
     */
    readonly quality: Quality;
}
/**
 * Fired when the media track's {@link MediaTrack.targetQuality | target quality} changes.
 *
 * @category Media and Text Tracks
 * @category Events
 * @public
 */
interface TargetQualityChangedEvent extends Event<'targetqualitychanged'> {
    /**
     * The new target quality.
     */
    readonly quality: Quality | undefined;
    /**
     * The new target qualities.
     */
    readonly qualities: Quality[];
}
/**
 * The events fired by a {@link MediaTrack}.
 *
 * @category Media and Text Tracks
 * @public
 */
interface MediaTrackEventMap extends TrackEventMap {
    /**
     * Fired when the media track's {@link MediaTrack.activeQuality | active quality} changes.
     */
    activequalitychanged: QualityEvent<'activequalitychanged'>;
    /**
     * Fired when the media track's {@link MediaTrack.targetQuality | target quality} changes.
     */
    targetqualitychanged: TargetQualityChangedEvent;
    /**
     * Fired when a quality of the track becomes unavailable.
     *
     * @remarks
     * <br/> - A Quality can become unavailable due to a DRM restriction (e.g. HDCP).
     */
    qualityunavailable: QualityEvent<'qualityunavailable'>;
}
/**
 * Represents a media track (audio or video) of a media resource.
 *
 * @category Media and Text Tracks
 * @public
 */
interface MediaTrack extends Track, EventDispatcher<MediaTrackEventMap> {
    /**
     * Whether the track is enabled.
     *
     * @remarks
     * <br/> - Only one track of the same type (e.g. video) can be enabled at the same time.
     * <br/> - Enabling a track will disable all other tracks of the same type.
     * <br/> - Disabling a track will not enable a different track of the same type.
     */
    enabled: boolean;
    /**
     * The identifier of the media track.
     *
     * @remarks
     * <br/> - This identifier can be used to distinguish between related tracks, e.g. tracks in the same list.
     */
    readonly id: string;
    /**
     * A unique identifier of the media track.
     *
     * @remarks
     * <br/> - This identifier is unique across tracks of a THEOplayer instance and can be used to distinguish between tracks.
     * <br/> - This identifier is a randomly generated number.
     */
    readonly uid: number;
    /**
     * The kind of the media track, represented by a value from the following list:
     * <br/> - `'main'`: The track is the default track for playback
     * <br/> - `'alternative'`: The track is not the default track for playback
     */
    readonly kind: string;
    /**
     * The label of the media track.
     */
    label: string;
    /**
     * The language of the media track.
     */
    readonly language: string;
    /**
     * The active quality of the media track, i.e. the quality that is currently being played.
     */
    readonly activeQuality: Quality | undefined;
    /**
     * The qualities of the media track.
     */
    readonly qualities: QualityList;
    /**
     * One or more desired qualities of the media track.
     *
     * @remarks
     * <br/> - If desired qualities are present, the Adaptive Bitrate mechanism of the player will limit itself to these qualities.
     * <br/> - If one desired quality is present, the Adaptive Bitrate mechanism of the player will be disabled and the desired quality will be played back.
     */
    targetQuality: Quality | Quality[] | undefined;
    /**
     * {@inheritDoc EventDispatcher.addEventListener}
     */
    addEventListener<TType extends StringKeyOf<MediaTrackEventMap>>(type: TType | readonly TType[], listener: EventListener<MediaTrackEventMap[TType]>): void;
    /**
     * {@inheritDoc EventDispatcher.removeEventListener}
     */
    removeEventListener<TType extends StringKeyOf<MediaTrackEventMap>>(type: TType | readonly TType[], listener: EventListener<MediaTrackEventMap[TType]>): void;
}

/**
 * List of media tracks.
 *
 * @category Media and Text Tracks
 * @public
 */
interface MediaTrackList extends TrackList<MediaTrack> {
    /**
     * The number of media tracks in the list.
     */
    readonly length: number;
    /**
     * Return the media track at the requested index in the list.
     *
     * @param index - A `number` representing the index of a media track in the list.
     * @returns The media track with index `index` in the list.
     */
    item(index: number): MediaTrack;
    /**
     * Index signature to get the media track at the requested index in the list.
     */
    readonly [index: number]: MediaTrack;
}

/**
 * Fires when the cast state changes.
 *
 * @category Casting
 * @category Events
 * @public
 */
interface CastStateChangeEvent extends Event<'statechange'> {
    /**
     * The new cast state.
     */
    readonly state: CastState;
}

/**
 * The state of a casting process, represented by a value from the following list:
 * <br/> - `'unavailable'`: No available cast devices.
 * <br/> - `'available'`: Cast device available, but the player is not connected.
 * <br/> - `'connecting'`: Cast device available and the player is connecting.
 * <br/> - `'connected'`: Cast device available and the player is connected.
 *
 * @category Casting
 * @public
 */
type CastState = 'unavailable' | 'available' | 'connecting' | 'connected';
/**
 * The events fired by the common vendor APIs.
 *
 * @category Casting
 * @public
 */
interface VendorCastEventMap {
    /**
     * Fired when the {@link VendorCast.state | state} changes.
     */
    statechange: CastStateChangeEvent;
}
/**
 * Common API for all cast integrations.
 *
 * @category Casting
 * @public
 */
interface VendorCast extends EventDispatcher<VendorCastEventMap> {
    /**
     * Whether the player is casting.
     */
    casting: boolean;
    /**
     * The state of the casting process.
     */
    state: CastState;
    /**
     * Start a casting session with the player's source.
     *
     * @remarks
     * <br/> - A native browser pop-up will prompt to choose a casting target device.
     */
    start(): void;
    /**
     * Stop the active casting session.
     */
    stop(): void;
}

/**
 * The events fired by the Chromecast API.
 *
 * @category Casting
 * @public
 */
interface ChromecastEventMap extends VendorCastEventMap {
    /**
     * Fired when an error occurs while casting or trying to cast.
     */
    error: ChromecastErrorEvent;
}
/**
 * The Chromecast API.
 *
 * @category Casting
 * @public
 */
interface Chromecast extends VendorCast, EventDispatcher<ChromecastEventMap> {
    /**
     * The last error that occurred during casting, if any.
     */
    error: ChromecastError | undefined;
    /**
     * The name of the Chromecast device that the player is casting to, if any.
     */
    receiverName: string | undefined;
    /**
     * The source of the active casting session, if any.
     *
     * @deprecated Superseded by {@link Chromecast.connectionCallback}.
     */
    source: SourceDescription | undefined;
    /**
     * The callback for the Chromecast connection changes.
     */
    connectionCallback: ChromecastConnectionCallback | undefined;
    /**
     * Join an active casting session.
     */
    join(): void;
    /**
     * Leave the active casting session.
     *
     * @remarks
     * <br/> - Does not stop the session when other devices are connected.
     * <br/> - Use {@link VendorCast.stop} to fully stop the session.
     */
    leave(): void;
    /**
     * {@inheritDoc EventDispatcher.addEventListener}
     */
    addEventListener<TType extends StringKeyOf<ChromecastEventMap>>(type: TType | readonly TType[], listener: EventListener<ChromecastEventMap[TType]>): void;
    /**
     * {@inheritDoc EventDispatcher.removeEventListener}
     */
    removeEventListener<TType extends StringKeyOf<ChromecastEventMap>>(type: TType | readonly TType[], listener: EventListener<ChromecastEventMap[TType]>): void;
}
/**
 * The ChromecastConnectionCallback.
 *
 * @category Casting
 * @public
 */
interface ChromecastConnectionCallback {
    /**
     * Called after the player has started the connection to the receiver.
     *
     * @remarks
     * <br/> - At this point we are trying to load the media from the sender to the receiver.
     * <br/> - Returning null will behave same as returning the provided SourceDescription.
     *
     * @param sourceDescription - The current SourceDescription on the sender device.
     * @returns The SourceDescription to be loaded on the receiver device.
     */
    onStart(sourceDescription: SourceDescription | undefined): SourceDescription | undefined;
    /**
     * Called after the player has stopped the connection to the receiver.
     *
     * @remarks
     * <br/> - At this point we are trying to load the media from the receiver to the sender.
     * <br/> - Returning null will behave same as returning the provided SourceDescription.
     *
     * @param sourceDescription - The current SourceDescription on the receiver device.
     * @returns The SourceDescription to be loaded on the sender device.
     */
    onStop(sourceDescription: SourceDescription | undefined): SourceDescription | undefined;
    /**
     * Called after the player has joined an already existing connection to the receiver.
     *
     * @remarks
     * <br/> - At this point it's possible to load a new media from the sender to the receiver.
     * <br/> - Returning null will not change the source on the receiver.
     *
     * @param sourceDescription - The current SourceDescription on the current sender device.
     * @returns The SourceDescription to be loaded on the receiver device.
     */
    onJoin(sourceDescription: SourceDescription | undefined): SourceDescription | undefined;
    /**
     * Called after the player has left the connection to the receiver.
     *
     * @remarks
     * <br/> - At this point we are trying to load the media from the receiver to the sender.
     * <br/> - Returning null will behave same as returning the provided SourceDescription.
     *
     * @param sourceDescription - The current SourceDescription on the receiver device.
     * @returns The SourceDescription to be loaded on the sender device.
     */
    onLeave(sourceDescription: SourceDescription | undefined): SourceDescription | undefined;
}
/**
 * The global Chromecast API.
 *
 * @category Casting
 * @public
 */
interface GlobalChromecast {
    /**
     * Initialize the Chromecast framework.
     *
     * @remarks
     * <br/> - If this method is not called, then the first created THEOplayer instance will automatically initialize the Chromecast framework.
     *
     * @param configuration - Describes Chromecast specific options.
     */
    initialize(configuration?: ChromecastConfiguration): PromiseLike<void>;
    /**
     * Start a casting session without a source.
     *
     * @remarks
     * <br/> - The Chromecast framework must be {@link GlobalChromecast.initialize | initialized} before starting a session.
     */
    startSession(): PromiseLike<void>;
    /**
     * Stop the active casting session.
     */
    endSession(): void;
}
/**
 * An error that occurred while casting or attempting to cast to Chromecast.
 *
 * @category Casting
 * @category Errors
 * @public
 */
interface ChromecastError {
    /**
     * The error code of the error.
     */
    errorCode: ChromecastErrorCode;
    /**
     * The human-readable description of the error.
     */
    description: string;
}
/**
 * The chromecast error code, represented by a value from the following list:
 * <br/> - `'CANCEL'`: The operation was canceled by the user.
 * <br/> - `'TIMEOUT'`: The operation timed out.
 * <br/> - `'API_NOT_INITIALIZED'`: The API is not initialized.
 * <br/> - `'INVALID_PARAMETER'`: The parameters to the operation were not valid.
 * <br/> - `'EXTENSION_NOT_COMPATIBLE'`: The API script is not compatible with the installed Cast extension.
 * <br/> - `'EXTENSION_MISSING'`: The Cast extension is not available.
 * <br/> - `'RECEIVER_UNAVAILABLE'`: No receiver was compatible with the session request.
 * <br/> - `'SESSION_ERROR'`: A session could not be created, or a session was invalid.
 * <br/> - `'CHANNEL_ERROR'`: A channel to the receiver is not available.
 * <br/> - `'LOAD_MEDIA_FAILED'`: Load media failed.
 *
 * @remarks
 * <br/> - The error codes correspond to the error codes documented in the {@link https://developers.google.com/cast/docs/reference/chrome/chrome.cast.html#.ErrorCode | Chromecast API reference}.
 *
 * @category Casting
 * @public
 */
type ChromecastErrorCode = 'CANCEL' | 'TIMEOUT' | 'API_NOT_INITIALIZED' | 'INVALID_PARAMETER' | 'EXTENSION_NOT_COMPATIBLE' | 'EXTENSION_MISSING' | 'RECEIVER_UNAVAILABLE' | 'SESSION_ERROR' | 'CHANNEL_ERROR' | 'LOAD_MEDIA_FAILED';
/**
 * Fired when an error occurs while casting or trying to cast.
 *
 * @category Casting
 * @public
 */
interface ChromecastErrorEvent extends Event<'error'> {
    /**
     * The error that occurred.
     */
    readonly error: ChromecastError;
}

/**
 * The AirPlay API.
 *
 * @category Casting
 * @public
 */
interface AirPlay extends VendorCast {
}

/**
 * The events fired by the {@link Cast | cast API}.
 *
 * @category Casting
 * @public
 */
interface CastEventMap {
    /**
     * Fired when {@link Cast.casting} changes.
     */
    castingchange: Event<'castingchange'>;
}
/**
 * The cast API.
 *
 * @category Casting
 * @public
 */
interface Cast extends EventDispatcher<CastEventMap> {
    /**
     * Whether the player is connected with a casting device.
     */
    casting: boolean;
    /**
     * The Airplay integration API.
     *
     * @remarks
     * <br/> - Only available with the feature `'airplay'`.
     */
    airplay?: AirPlay;
    /**
     * The Chromecast integration API.
     *
     * @remarks
     * <br/> - Only available with the feature `'chromecast'`.
     */
    chromecast?: Chromecast;
}
/**
 * The global cast API.
 *
 * @category Casting
 * @public
 */
interface GlobalCast {
    /**
     * The global Chromecast integration API.
     *
     * @remarks
     * <br/> - Only available with the feature `'chromecast'`.
     */
    chromecast?: GlobalChromecast;
}

/**
 * Represents a direction in the VR feature.
 *
 * @category VR
 * @public
 */
interface VRDirection {
    /**
     * The rotational position around the Z-axis.
     *
     * @remarks
     * <br/> - This number is in the range of [-180, 180].
     */
    yaw: number;
    /**
     * The rotational position around the X-axis.
     *
     * @remarks
     * <br/> - This number is in the range of [-180, 180].
     */
    roll: number;
    /**
     * The rotational position around the Y-axis.
     *
     * @remarks
     * <br/> - This number is in the range of [-180, 180].
     */
    pitch: number;
}
/**
 * The state of the VR feature, represented by a value from the following list:
 * <br/> - `'unavailable'`
 * <br/> - `'available'`
 * <br/> - `'presenting'`
 *
 * @category VR
 * @public
 */
type VRState = 'unavailable' | 'available' | 'presenting';
/**
 * Fired when the {@link VR.direction} changes.
 *
 * @category VR
 * @category Events
 * @public
 */
type DirectionChangeEvent = Event<'directionchange'>;
/**
 * Fired when the {@link VR.state} changes.
 *
 * @category VR
 * @category Events
 * @public
 */
type StateChangeEvent = Event<'statechange'>;
/**
 * Fired when the {@link VR.stereo} changes.
 *
 * @category VR
 * @category Events
 * @public
 */
type StereoChangeEvent = Event<'stereochange'>;
/**
 * The events fired by the {@link VR | VR API}.
 *
 * @category VR
 * @public
 */
interface VREventMap {
    /**
     * {@inheritDoc DirectionChangeEvent}
     */
    directionchange: DirectionChangeEvent;
    /**
     * {@inheritDoc StateChangeEvent}
     */
    statechange: StateChangeEvent;
    /**
     * {@inheritDoc StereoChangeEvent}
     */
    stereochange: StereoChangeEvent;
    /**
     * {@inheritDoc ErrorEvent}
     */
    error: ErrorEvent;
}
/**
 * The virtual reality API which allows you to control the display of 360° VR videos.
 *
 * @remarks
 * <br/> - See {@link VRConfiguration} to configure a source.
 * <br/> - The player utilises the {@link Canvas | Canvas API} internally to render 360° content and is restricted to the same limitations.
 * <br/> - To access `devicemotion` events on mobile devices, a page needs to be served over https on modern browsers.
 * <br/> - To access `devicemotion` events on Safari for iOS 13+ you need to request user permission using the {@link https://www.w3.org/TR/orientation-event/#dom-devicemotionevent-requestpermission | DeviceMotionEvent.requestPermission API}
 * <br/> - iPhone support requires iOS 10: On iOS 9 and lower, iPhone forces HTML5 video to play in fullscreen. As a result, the canvas used by THEOplayer VR will not be visible during playback, since it will be behind the fullscreen video. iPhone users must upgrade to iOS 10 or higher for the full VR experience. Note that iPad is unaffected: VR is supported even on iOS 9 and lower.
 * <br/> - Cross-origin iframes on iOS: iOS blocks cross-origin iframes from accessing `devicemotion` events {@link https://bugs.webkit.org/show_bug.cgi?id=152299 | WebKit bug #152299}. As a result, when using THEOplayer inside a cross-origin iframe, the player cannot rotate the VR display to align with the device's physical orientation. Fortunately, this can be worked around by listening for `devicemotion` events on the top frame and forwarding them as messages to the iframe. THEOplayer will automatically handle these messages as if they were native `devicemotion` events:
 *
 * @example
 * ```
 * const playerIframe = document.querySelector('iframe');
 * window.addEventListener('devicemotion', function (event) {
 *    playerIframe.contentWindow.postMessage({
 *        type : 'devicemotion',
 *        deviceMotionEvent : {
 *            acceleration : event.acceleration,
 *            accelerationIncludingGravity : event.accelerationIncludingGravity,
 *            interval : event.interval,
 *            rotationRate : event.rotationRate,
 *            timeStamp : event.timeStamp
 *        }
 *    }, '*');
 * });
 * ```
 *
 * @category VR
 * @public
 */
interface VR extends EventDispatcher<VREventMap> {
    /**
     * Whether stereo mode is enabled.
     *
     * @remarks
     * <br/> - Setting it to `true` renders the video in VR.
     *
     * @defaultValue `false`
     */
    stereo: boolean;
    /**
     * Whether controls using device motion on mobile devices is enabled when not viewing in stereo mode.
     *
     * @remarks
     * <br/> - This performs actions that require user consent, so setting this to true has to be behind a button press.
     * <br/> - Changes only take effect when `stereo` is `false`.
     *
     * @defaultValue `false`
     */
    useDeviceMotionControls: boolean;
    /**
     * The viewing direction.
     */
    direction: VRDirection;
    /**
     * The vertical field of view in VR, in degress.
     *
     * @remarks
     * <br/> - It should be a number in the range of [0, 180].
     *
     * @defaultValue `72`
     */
    verticalFOV: number;
    /**
     * Whether the player can present in VR mode.
     */
    readonly canPresentVR: boolean;
    /**
     * The state of the VR feature.
     */
    readonly state: VRState;
}

/**
 * The canvas API which allows drawing the player's current frame to a 2D or WebGL context.
 *
 * @remarks
 * This allows for advanced usages of the images, like transformations, drawing and cropping.
 *
 * Cross-origin restrictions:
 * Browsers place additional security restrictions for cross-origin video content drawn to a canvas.
 * When you draw video content retrieved without proper cross-origin settings to a canvas, the canvas becomes "tainted".
 * A {@link https://developer.mozilla.org/en-US/docs/Web/HTML/CORS_enabled_image#What_is_a_tainted_canvas | tainted canvas}
 * can still be used, but will throw errors when attempting to read pixel data from it (for example when calling
 * {@link https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/getImageData | `getImageData`} or
 * {@link https://developer.mozilla.org/en-US/docs/Web/API/HTMLCanvasElement/toBlob | `toBlob`}).
 *
 * In order to avoid tainting the canvas, the video content must be retrieved with the proper CORS settings.
 * Set `crossOrigin` to `"anonymous"` or `"use-credentials"` in the {@link TypedSource} of your {@link SourceDescription}
 * when loading the video source into THEOplayer.
 * This ensures that the content is always retrieved with CORS-enabled HTTP requests, and will not taint the canvas when drawn.
 *
 * Drawing cross-origin content to WebGL context on iOS 10 and lower:
 * iOS version 10 and lower has a bug that prevents drawing cross-origin video content to a
 * {@link https://developer.mozilla.org/en-US/docs/Web/API/WebGLRenderingContext | `WebGLRenderingContext`},
 * even when the proper CORS settings are provided ({@link https://bugs.webkit.org/show_bug.cgi?id=135379 | WebKit bug #135379}).
 * In particular, cross-origin 360° videos (using the {@link VR | VR API}) only render correctly in iOS 11 and higher.
 *
 * If you need to support iOS 10 and below, we recommend loading the stream from the same origin as the web page.
 *
 * DRM protected content:
 * It is not possible to render DRM protected content to a canvas.
 *
 * Available since v2.12.0.
 *
 * @category Canvas
 * @public
 */
interface Canvas {
    /**
     * Draw the current frame to a 2D Canvas context.
     *
     * @remarks
     * <br/> - If the video hasn't loaded yet, nothing will be drawn.
     * <br/> - The first argument is the destination 2D context for the draw operation. The other arguments are passed to the native CanvasRenderingContext2D.drawImage method.
     * <br/> - see {@link https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/drawImage | CanvasRenderingContext2D.drawImage()}.
     *
     * @param context2D - The 2D destination context.
     * @param dx - The x-axis coordinate in the destination canvas at which to place the top-left corner of the source image.
     * @param dy - The y-axis coordinate in the destination canvas at which to place the top-left corner of the source image.
     */
    drawImage(context2D: CanvasRenderingContext2D, dx: number, dy: number): boolean;
    /**
     * Draw the current frame to a 2D Canvas context.
     *
     * @remarks
     * <br/> - If the video hasn't loaded yet, nothing will be drawn.
     * <br/> - The first argument is the destination 2D context for the draw operation. The other arguments are passed to the native CanvasRenderingContext2D.drawImage method.
     * <br/> - see {@link https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/drawImage | CanvasRenderingContext2D.drawImage()}.
     *
     * @param context2D - The 2D destination context.
     * @param dx - The x-axis coordinate in the destination canvas at which to place the top-left corner of the source image.
     * @param dy - The y-axis coordinate in the destination canvas at which to place the top-left corner of the source image.
     * @param dWidth - The width to draw the image in the destination canvas. This allows scaling of the drawn image. If not specified, the image is not scaled in width when drawn.
     * @param dHeight - The height to draw the image in the destination canvas. This allows scaling of the drawn image. If not specified, the image is not scaled in height when drawn.
     */
    drawImage(context2D: CanvasRenderingContext2D, dx: number, dy: number, dWidth: number, dHeight: number): boolean;
    /**
     * Draw the current frame to a 2D Canvas context.
     *
     * @remarks
     * <br/> - If the video hasn't loaded yet, nothing will be drawn.
     * <br/> - The first argument is the destination 2D context for the draw operation. The other arguments are passed to the native CanvasRenderingContext2D.drawImage method.
     * <br/> - see {@link https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/drawImage | CanvasRenderingContext2D.drawImage()}.
     *
     * @param context2D - The 2D destination context.
     * @param sx - The x-axis coordinate of the top left corner of the sub-rectangle of the source image to draw into the destination context.
     * @param sy - The y-axis coordinate of the top left corner of the sub-rectangle of the source image to draw into the destination context.
     * @param sWidth - The width of the sub-rectangle of the source image to draw into the destination context. If not specified, the entire rectangle from the coordinates specified by sx and sy to the bottom-right corner of the image is used.
     * @param sHeight - The height of the sub-rectangle of the source image to draw into the destination context.
     * @param dx - The x-axis coordinate in the destination canvas at which to place the top-left corner of the source image.
     * @param dy - The y-axis coordinate in the destination canvas at which to place the top-left corner of the source image.
     * @param dWidth - The width to draw the image in the destination canvas. This allows scaling of the drawn image. If not specified, the image is not scaled in width when drawn.
     * @param dHeight - The height to draw the image in the destination canvas. This allows scaling of the drawn image. If not specified, the image is not scaled in height when drawn.
     */
    drawImage(context2D: CanvasRenderingContext2D, sx: number, sy: number, sWidth: number, sHeight: number, dx: number, dy: number, dWidth: number, dHeight: number): boolean;
    /**
     * Draw the current frame as a 2D texture to a 3D WebGL context.
     *
     * @remarks
     * <br/> - If the video hasn't loaded yet, nothing will be drawn.
     * <br/> - The first argument is the destination WebGL context for the draw operation. The other arguments are passed to the native WebGLRenderingContext.texImage2D method.
     * <br/> - See {@link https://developer.mozilla.org/en-US/docs/Web/API/WebGLRenderingContext/texImage2D | WebGLRenderingContext.texImage2D()}.
     *
     * @param contextWebGL - The WebGL context.
     * @param target - A GLenum specifying the binding point (target) of the active texture.
     * @param level - A GLint specifying the level of detail. Level 0 is the base image level and level n is the nth mipmap reduction level.
     * @param internalformat - A GLenum specifying the color components in the texture.
     * @param format - A GLenum specifying the format of the texel data.
     * @param type - A GLenum specifying the data type of the texel data.
     */
    texImage2D(contextWebGL: WebGLRenderingContext, target: GLenum, level: GLint, internalformat: GLint, format: GLenum, type: GLenum): boolean;
    /**
     * Registers a callback to be fired the next time a frame is presented to the compositor.
     *
     * @remarks
     * <br/> - Will fall back to `requestAnimationFrame` if `requestVideoFrameCallback` is not natively supported.
     * <br/> - See {@link https://wicg.github.io/video-rvfc/ | HTMLVideoElement.requestVideoFrameCallback()}.
     *
     * @param callback - The callback function.
     * @returns A handle that can (optionally) be cancelled with {@link Canvas.cancelVideoFrameCallback}.
     */
    requestVideoFrameCallback(callback: VideoFrameRequestCallback): number;
    /**
     * Cancels an existing video frame request callback given its handle.
     *
     * @param handle - The handle of the callback to cancel.
     */
    cancelVideoFrameCallback(handle: number): void;
}
/**
 * A callback to be fired the next time a frame is presented to the compositor,
 * used by {@link Canvas.requestVideoFrameCallback}.
 *
 * @param now - The current time in milliseconds, see {@link https://developer.mozilla.org/en-US/docs/Web/API/Performance/now | performance.now()}.
 * @param metadata - The video frame metadata. If `requestVideoFrameCallback()` is not natively supported, this is `undefined`.
 *
 * @category Canvas
 * @public
 */
type VideoFrameRequestCallback = (now: DOMHighResTimeStamp, metadata?: VideoFrameCallbackMetadata) => void;
/**
 * The metadata of a {@link VideoFrameRequestCallback}.
 *
 * @remarks
 * <br/> - See {@link https://developer.mozilla.org/en-US/docs/Web/API/HTMLVideoElement/requestVideoFrameCallback#parameters | requestVideoFrameCallback} for more information.
 *
 * @category Canvas
 * @public
 */
interface VideoFrameCallbackMetadata {
    captureTime?: DOMHighResTimeStamp;
    expectedDisplayTime: DOMHighResTimeStamp;
    height: number;
    mediaTime: number;
    presentationTime: DOMHighResTimeStamp;
    presentedFrames: number;
    processingDuration?: number;
    receiveTime?: DOMHighResTimeStamp;
    rtpTimestamp?: number;
    width: number;
}

/**
 * A callback for a visibility observer.
 *
 * @param ratio - Describes the ratio of visible pixels of the player.
 *
 * @category Player
 * @public
 */
type VisibilityObserverCallback = (ratio: number) => void;
/**
 * The visibility API.
 *
 * @category Player
 * @public
 */
interface Visibility {
    /**
     * Whether the {@link Visibility.ratio} of visible pixels is exceeded.
     */
    readonly visible: boolean;
    /**
     * The ratio of pixels of the player that are within the viewport.
     */
    readonly ratio: number;
    /**
     * The threshold that the ratio must exceed for the player to be visible.
     *
     * @remarks
     * <br/> - This number is in the range of [0, 1].
     */
    visibleThreshold: number;
    /**
     * Add a visibility observer to monitor the player.
     *
     * @remarks
     * <br/> - The callback is triggered every time the ratio of visible pixels crosses a threshold, and receives the ratio of visible pixels as first argument.
     * <br/> - The list of thresholds is evenly distributed between 0 and 1, with the distance between every two consecutive thresholds determined by the given step.
     *
     * @param step - The step between every threshold. This number is in the range of ]0, 1].
     * @param callback - The callback to be triggered every time a threshold is crossed.
     * @returns A new visibility observer.
     */
    addObserver(step: number, callback: VisibilityObserverCallback): VisibilityObserver;
    /**
     * Remove a visibility observer.
     *
     * The observer will stop monitoring player visibility,
     * and will no longer trigger its callback.
     *
     * @param observer - The observer to remove.
     */
    removeObserver(observer: VisibilityObserver): void;
}
/**
 * Represents a visibility observer.
 *
 * @category Player
 * @public
 */
interface VisibilityObserver {
    /**
     * The ratio of pixels of the player that are within the viewport.
     *
     * @remarks
     * <br/> - This value is updated every time an observed threshold is crossed. It is accurate up to the size of this observer's step.
     */
    readonly ratio: number;
    /**
     * List of thresholds which are monitored by the observer.
     */
    readonly thresholds: ReadonlyArray<number>;
}

/**
 * The Web Audio API.
 *
 * @remarks
 * The Web Audio API allows you to reroute the audio output of THEOplayer to a Web Audio context.
 * This is done by providing a Web Audio source node which outputs the player's audio.
 * Using Web Audio allows developers to apply a variety of effects and transformations to the player's audio output,
 * e.g. equalization, volume normalization, ...
 *
 * The way the Web Audio standard was designed has a few consequences.
 *
 * Once the player has created an AudioNode within a given AudioContext,
 * you must connect it to an output node in the graph, directly or indirectly,
 * or the output will be silent. The flow of audio from the created node has to
 * reach an output node, one way or another. Of course, the player's output can
 * pass through an arbitrary number of intermediary nodes before it reaches an output node.
 *
 * Once the player's is rerouted, there is no way back: the audio cannot be released
 * from its AudioContext, as Web Audio specifies no way to release audio resources which are piped through.
 * This means that you cannot change the AudioContext of the output node, nor can you stop piping
 * the player audio to Web Audio. In a well-designed Web Audio setup, this should not matter,
 * as there should be exactly one AudioContext per page, and there should be no need to stop piping to Web Audio.
 *
 * For advertisements, due to technical limitations, not all the audio can be rerouted using Web Audio.
 * Notably, Google IMA ads do not allow their audio to be rerouted, and therefore will not pass through the Web
 * Audio graph as specified by the developer.
 *
 * Available since v2.19.4.
 *
 * @category Player
 * @public
 */
interface WebAudio {
    /**
     * Create an AudioNode in the given AudioContext.
     *
     * @remarks
     * <br/> - Audio playback from the player will be re-routed into the processing graph of the AudioContext.
     */
    createAudioSourceNode(audioCtx: AudioContext): AudioNode;
}

/**
 * The presentation mode of the player, represented by a value from the following list:
 * <br/> - `'inline'`: The player is shown in its original location on the page.
 * <br/> - `'fullscreen'`: The player fills the entire screen.
 * <br/> - `'picture-in-picture'`: The player is shown on top of the page (see {@link PiPConfiguration} for more options).
 * <br/> - `'native-picture-in-picture'`: [Experimental] The player requests out-of-app picture-in-picture mode. Not supported on Firefox.
 *
 * @category Player
 * @public
 */
type PresentationMode = 'inline' | 'fullscreen' | 'picture-in-picture' | 'native-picture-in-picture';
/**
 * Fired when the presentation mode changes.
 *
 * @category Player
 * @category Events
 * @public
 */
interface PresentationModeChangeEvent extends Event<'presentationmodechange'> {
    /**
     * The new presentation mode.
     */
    readonly presentationMode: PresentationMode;
}
/**
 * The events fired by the {@link Presentation | presentation API}.
 *
 * @category Player
 * @public
 */
interface PresentationEventMap {
    /**
     * {@inheritDoc PresentationModeChangeEvent}
     */
    presentationmodechange: PresentationModeChangeEvent;
    /**
     * {@inheritDoc ErrorEvent}
     */
    error: ErrorEvent;
}
/**
 * The presentation API.
 *
 * @category Player
 * @public
 */
interface Presentation extends EventDispatcher<PresentationEventMap> {
    /**
     * The active presentation mode of the player.
     *
     * @defaultValue `'inline'`
     */
    readonly currentMode: PresentationMode;
    /**
     * Change the presentation mode of the player.
     *
     * @param mode - The requested presentation mode.
     */
    requestMode(mode: PresentationMode): void;
    /**
     * Whether the player supports the provided presentation mode.
     *
     * @param mode - The presentation mode to verify.
     * @returns Whether the player supports `mode`.
     */
    supportsMode(mode: PresentationMode): boolean;
}

/**
 * Provides estimates on the current network state.
 *
 * @category Network
 * @public
 */
interface NetworkEstimator {
    /**
     * The estimated network bandwidth in bit/s.
     */
    readonly bandwidth: number;
    /**
     * The estimated HTTP request round trip time.
     */
    readonly roundTripTime: number;
}

/**
 * Measures network metrics of an HTTP request and the associated HTTP response.
 *
 * @category Network
 * @public
 */
interface RequestMeasurer {
    /**
     * Marks the start time in milliseconds of a new HTTP request.
     * This method should only be called once.
     *
     * @param timestamp - The start time in milliseconds.
     */
    markRequestStart(timestamp: number): void;
    /**
     * Marks the start time in milliseconds of the HTTP response of the HTTP request.
     * This is the time at which the first byte of the HTTP response is received.
     * This method should only be called once and after `markRequestStart` has been called.
     *
     * @param timestamp - The start time in milliseconds.
     */
    markResponseStart(timestamp: number): void;
    /**
     * Marks the time in milliseconds at which new data is received as part of the current HTTP response.
     * This method should only be called after `markResponseStart` has been called.
     *
     * @param timestamp - The data reception time in milliseconds.
     * @param data - the Uint8Array of the received bytes.
     */
    markResponseData(timestamp: number, data: Uint8Array): void;
    /**
     * Marks the end time in milliseconds of the HTTP response.
     * This methods should only be called once after `markResponseStart` or `markResponseData`.
     *
     * @param timestamp - The end time in milliseconds.
     */
    markResponseEnd(timestamp: number): void;
}

/**
 * A {@link NetworkEstimator} that allows measuring the current network state.
 *
 * @category Network
 * @public
 */
interface MeasurableNetworkEstimator extends NetworkEstimator {
    /**
     * Creates a new {@link RequestMeasurer} instance for a given HTTP request URI.
     * @param request - The URI of the measured HTTP request.
     */
    createMeasurer(request: Request): RequestMeasurer | undefined;
}

/**
 * The RequestInterceptor is a function that accepts a Request object as its argument and can return a promise. If it returns a promise then the request waits until the promise is resolved.
 *
 * @category Network
 * @public
 */
type RequestInterceptor = (request: InterceptableRequest) => void | PromiseLike<void>;
/**
 * The ResponseInterceptor is a function that accepts a Response object as its argument and can return a promise. If it returns a promise then the response waits until the promise is resolved.
 *
 * @category Network
 * @public
 */
type ResponseInterceptor = (response: InterceptableResponse) => void | PromiseLike<void>;
/**
 * Record of HTTP headers.
 * Each entry contains the header name and its associated value.
 *
 * @category Network
 * @public
 */
interface HTTPHeaders {
    [headerName: string]: string;
}
/**
 * The possible types of an HTTP request body.
 *
 * @category Network
 * @public
 */
type RequestBody = ArrayBuffer | ArrayBufferView | string | null;
/**
 * The possible types of an HTTP response body.
 *
 * @category Network
 * @public
 */
type ResponseBody = ArrayBuffer | object | string | null;
/**
 * The request's type, represented by a value from the following list:
 * <br/> - `'manifest'`
 * <br/> - `'segment'`
 * <br/> - `'preload-hint'`
 * <br/> - `'content-protection'`
 *
 * @category Network
 * @public
 */
type RequestType = '' | 'manifest' | 'segment' | 'preload-hint' | 'content-protection';
/**
 * The content protection's subtype, represented by a value from the following list:
 * <br/> - `'fairplay-license'`
 * <br/> - `'fairplay-certificate'`
 * <br/> - `'widevine-license'`
 * <br/> - `'widevine-certificate'`
 * <br/> - `'playready-license'`
 * <br/> - `'clearkey-license'`
 * <br/> - `'aes128-key'`
 *
 * @category Network
 * @public
 */
type ContentProtectionRequestSubType = 'fairplay-license' | 'fairplay-certificate' | 'widevine-license' | 'widevine-certificate' | 'playready-license' | 'clearkey-license' | 'aes128-key';
/**
 * The request's subtype, represented by a value from the following list:
 * <br/> - `'initialization-segment'`
 * <br/> - Any value of {@link ContentProtectionRequestSubType}
 * <br/> - Empty string (`''`) when the subtype is unknown
 *
 * @category Network
 * @public
 */
type RequestSubType = '' | 'initialization-segment' | ContentProtectionRequestSubType;
/**
 * The media's type, represented by a value from the following list:
 * <br/> - `'audio'`
 * <br/> - `'video'`
 * <br/> - `'text'`
 * <br/> - `'image'`
 * <br/> - Empty string (`''`) when the media type is unknown
 *
 * @category Network
 * @public
 */
type MediaType = '' | 'audio' | 'video' | 'text' | 'image';
/**
 * The response's type, represented by a value from the following list:
 * <br/> - `'arraybuffer'`
 * <br/> - `'json'`
 * <br/> - `'stream'`
 * <br/> - `'text'`
 *
 * @category Network
 * @public
 */
type ResponseType = 'arraybuffer' | 'json' | 'stream' | 'text';
/**
 * The request's type, represented by a value from the following list:
 * <br/> - `'GET'`
 * <br/> - `'HEAD'`
 * <br/> - `'POST'`
 * <br/> - `'PUT'`
 * <br/> - `'DELETE'`
 * <br/> - `'OPTIONS'`
 *
 * @category Network
 * @public
 */
type RequestMethod = 'DELETE' | 'GET' | 'HEAD' | 'OPTIONS' | 'POST' | 'PUT';
/**
 * The possible types representing an HTTP request.
 *
 * @category Network
 * @public
 */
type RequestLike = string | RequestInit;
/**
 * The possible types representing an HTTP response.
 *
 * @category Network
 * @public
 */
type ResponseLike = ResponseInit;
/**
 * A Node-style asynchronous callback.
 *
 * After all asynchronous work is done, the callback *must* call `done`, optionally passing an error argument.
 *
 * @category Network
 * @public
 */
type NodeStyleVoidCallback = (done: (error?: any) => void) => void;
/**
 * An promise-returning asynchronous callback.
 *
 * The callback *must* return a promise that resolves (or rejects) after all asynchronous work is done.
 *
 * @category Network
 * @public
 */
type VoidPromiseCallback = () => PromiseLike<void>;
/**
 * An asynchronous callback to delay a request or response.
 *
 * @category Network
 * @public
 */
type WaitUntilCallback = NodeStyleVoidCallback | VoidPromiseCallback;
/**
 * Network interceptor API which can be used to intercept network requests and responses.
 *
 * @remarks
 * <br/> - Request interceptors will be executed in the order they were added.
 * <br/> - {@link InterceptableRequest.respondWith} can be called at most once, otherwise an error will be thrown.
 *
 * @category Network
 * @public
 */
interface NetworkInterceptorController {
    /**
     * Add a request interceptor.
     *
     * @param interceptor - A {@link RequestInterceptor}
     */
    addRequestInterceptor(interceptor: RequestInterceptor): void;
    /**
     * Remove a request interceptor.
     *
     * @param interceptor - A {@link RequestInterceptor}
     */
    removeRequestInterceptor(interceptor: RequestInterceptor): void;
    /**
     *
     * Add a response interceptor.
     *
     * @param interceptor - A {@link ResponseInterceptor}
     */
    addResponseInterceptor(interceptor: ResponseInterceptor): void;
    /**
     * Remove a response interceptor.
     *
     * @param interceptor - A {@link ResponseInterceptor}
     */
    removeResponseInterceptor(interceptor: ResponseInterceptor): void;
}
/**
 * Network estimator API which can be used to get or set the active `MeasurableNetworkEstimator`.
 *
 * @remarks
 * <br/> - EXPERIMENTAL: Setting an external `MeasurableNetworkEstimator` implementation will only affect playback of HLS streams.
 *
 * @category Network
 * @public
 */
interface NetworkEstimatorController {
    /**
     * Returns the active `MeasurableNetworkEstimator`. An internal implementation is provided by default.
     */
    readonly estimator: NetworkEstimator;
    /**
     * Set a `MeasurableNetworkEstimator` implementation for internal use by the player.
     */
    setEstimator(estimator: MeasurableNetworkEstimator | undefined): void;
}
/**
 * The events fired by the {@link Network | network API}.
 *
 * @category Network
 * @public
 */
interface NetworkEventMap {
    /**
     * Fired when the manifest is online.
     */
    online: Event<'online'>;
    /**
     * Fired when the manifest is offline.
     */
    offline: Event<'offline'>;
}
/**
 * The network API.
 *
 * @remarks
 * <br/> - Available since v2.21.0.
 *
 * @category Network
 * @public
 */
interface Network extends EventDispatcher<NetworkEventMap>, NetworkInterceptorController, NetworkEstimatorController {
    /**
     * Whether the stream is online.
     */
    readonly online: boolean;
}
/**
 * Contains network request properties used to modify an HTTP request.
 *
 * @category Network
 * @public
 */
interface RequestInit {
    /**
     * The request's URL.
     *
     * @defaultValue The original request's URL.
     */
    url?: string;
    /**
     * The request's HTTP method.
     *
     * @defaultValue The original request's HTTP method.
     */
    method?: RequestMethod;
    /**
     * The request's HTTP headers.
     *
     * @defaultValue The original request's HTTP headers.
     */
    headers?: HTTPHeaders;
    /**
     * The request's body.
     *
     * @defaultValue The original request's body.
     */
    body?: RequestBody;
    /**
     * Whether the player is allowed to use credentials for cross-origin requests.
     *
     * @remarks
     * <br/> - Credentials are cookies, authorization headers or TLS client certificates.
     *
     * @defaultValue The original request's `useCredentials` value.
     */
    useCredentials?: boolean;
    /**
     * The request's type.
     *
     * @defaultValue The original request's type.
     */
    type?: RequestType;
    /**
     * The request's subtype.
     *
     * @defaultValue The original request's subtype.
     */
    subType?: RequestSubType;
    /**
     * The request's media type.
     *
     * @defaultValue The original request's media type.
     */
    mediaType?: MediaType;
    /**
     * The request's response type.
     *
     * @defaultValue The original request's response type.
     */
    responseType?: ResponseType;
}
/**
 * Contains network response properties used to modify an HTTP response.
 *
 * @category Network
 * @public
 */
interface ResponseInit {
    /**
     * The response's URL.
     *
     * @defaultValue The original response's URL.
     */
    url?: string;
    /**
     * The response's status code.
     *
     * @defaultValue The original response's status code.
     */
    status?: number;
    /**
     * The response's status text.
     *
     * @defaultValue The original response's status text.
     */
    statusText?: string;
    /**
     * The response's HTTP headers.
     *
     * @defaultValue The original response's HTTP headers.
     */
    headers?: HTTPHeaders;
    /**
     * The response's body.
     *
     * @defaultValue The original response's body.
     */
    body?: ResponseBody;
}
/**
 * Represents an HTTP request.
 *
 * @category Network
 * @public
 */
interface Request {
    /**
     * The request's URL.
     */
    readonly url: string;
    /**
     * The request's HTTP method.
     */
    readonly method: RequestMethod;
    /**
     * The request's HTTP headers.
     */
    readonly headers: HTTPHeaders;
    /**
     * The request's body.
     */
    readonly body: RequestBody;
    /**
     * Whether the player is allowed to use credentials for cross-origin requests.
     */
    readonly useCredentials: boolean;
    /**
     * The request's type.
     */
    readonly type: RequestType;
    /**
     * The request's subtype.
     */
    readonly subType: RequestSubType;
    /**
     * The request's media type.
     */
    readonly mediaType: MediaType;
    /**
     * The request's response type.
     */
    readonly responseType: ResponseType;
}
/**
 * Represents an intercepted HTTP request which can be modified.
 *
 * @category Network
 * @public
 */
interface InterceptableRequest extends Request {
    /**
     * Whether the request is closed.
     *
     * @remarks
     * <br/> - Request is closed by {@link InterceptableRequest.redirect} and {@link InterceptableRequest.respondWith}.
     */
    readonly closed: boolean;
    /**
     * Replaces the original request with the provided request.
     *
     * @remarks
     * <br/> - Invocation closes the request.
     * <br/> - Invocation while the request is closed will throw an error.
     *
     * @param request - A {@link RequestInit} or a string which is shorthand for {@link RequestInit.url}.
     */
    redirect(request: RequestLike): void;
    /**
     * Immediately respond with the provided response.
     *
     * @remarks
     * <br/> - Invocation closes the request.
     * <br/> - Invocation while the request is closed will throw an error.
     * <br/> - The original request will not be performed.
     *
     * @param response - A {@link ResponseInit}.
     */
    respondWith(response: ResponseLike): void;
    /**
     * Wait until the given callback is done before closing and executing this request.
     *
     * @remarks
     * <br/> - The first argument of the callback is a `done` function, which must be called to resolve the callback.
     * <br/> - Alternatively, the callback can return a {@link https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise| `PromiseLike`}.
     * <br/> - Invocation of the `done` function closes the request.
     * <br/> - Invocation while the request is closed will throw an error.
     *
     * @param fn - A {@link WaitUntilCallback}
     */
    waitUntil(fn: WaitUntilCallback): void;
    /**
     * Wait until the given promise is resolved before closing and executing this request.
     *
     * @remarks
     * <br/> - Resolution of the promise closes the request.
     * <br/> - Invocation while the request is closed will throw an error.
     * <br/> - This is equivalent to:
     * ```
     * request.waitUntil(function (done) {
     *   promise.then(function () {
     *     done();
     *   }).catch(function (error) {
     *     done(error);
     *   });
     * })
     * ```
     *
     * @param promise - A {@link https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise| `PromiseLike`}.
     */
    waitUntil(promise: PromiseLike<any>): void;
}
/**
 * Represents an intercepted HTTP response which can be modified.
 *
 * @category Network
 * @public
 */
interface InterceptableResponse {
    /**
     * The response's request.
     */
    readonly request: Request;
    /**
     * The response's url.
     *
     * @remarks
     * <br/> - This can differ from the {@link InterceptableResponse.request | `request.url`} when redirected.
     */
    readonly url: string;
    /**
     * The response's status code.
     */
    readonly status: number;
    /**
     * The response's status text.
     */
    readonly statusText: string;
    /**
     * The response's HTTP headers.
     */
    readonly headers: HTTPHeaders;
    /**
     * The response's body.
     */
    readonly body: ResponseBody;
    /**
     * Whether the response is closed.
     *
     * @remarks
     * <br/> - Response is closed by {@link InterceptableResponse.respondWith}.
     */
    readonly closed: boolean;
    /**
     * Replaces the original response with the provided response.
     *
     * @remarks
     * <br/> - Invocation closes the response.
     * <br/> - Invocation while the response is closed will throw an error.
     *
     * @param response - A {@link ResponseLike}.
     */
    respondWith(response: ResponseLike): void;
    /**
     * Wait until the given callback is done before closing this response.
     *
     * @remarks
     * <br/> - The first argument of the callback is a `done` function, which must be called to resolve the callback.
     * <br/> - Invocation of the `done` function closes the response.
     * <br/> - Invocation while the response is closed will throw an error.
     *
     * @param fn - A {@link WaitUntilCallback}
     */
    waitUntil(fn: WaitUntilCallback): void;
    /**
     * Wait until the given promise is resolved before closing this response.
     *
     * @remarks
     * <br/> - Resolution of the promise closes the response.
     * <br/> - Invocation while the response is closed will throw an error.
     * <br/> - This is equivalent to:
     * ```
     * response.waitUntil(function (done) {
     *   promise.then(function () {
     *     done();
     *   }).catch(function (error) {
     *     done(error);
     *   });
     * })
     * ```
     *
     * @param promise - {@link https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise| `PromiseLike`}.
     */
    waitUntil(promise: PromiseLike<any>): void;
}

/**
 * Events fired by the {@link TextTrackStyle | TextTrackStyle API}.
 *
 * @category Media and Text Tracks
 * @public
 */
interface TextTrackStyleEventMap {
    /**
     * Fired when any of the {@link TextTrackStyle | TextTrackStyle's properties} changes.
     */
    change: Event<'change'>;
}
/**
 * The text track style API.
 *
 * @remarks
 * <br/> - Available since v2.27.4.
 *
 * @category Media and Text Tracks
 * @public
 */
interface TextTrackStyle extends EventDispatcher<TextTrackStyleEventMap> {
    /**
     * The font family for the text track.
     */
    fontFamily: string | undefined;
    /**
     * The font color for the text track.
     *
     * @example
     * <br/> - `red` will set the color of the text to red.
     * <br/> - `#ff0000` will set the color of the text to red.
     * <br/> - `rgba(255,0,0,0.5)` will set the color of the text to red, with 50% opacity.
     */
    fontColor: string | undefined;
    /**
     * The font size for the text track.
     *
     * @remarks
     * Can be a percentage value such as '50%', '75%', '100%', '150%' or '200%'.
     */
    fontSize: string | undefined;
    /**
     * The background color for the text track.
     *
     * @remarks
     * This targets the area directly behind the text.
     *
     * @example
     * <br/> - `red` will set the background color of the text track to red.
     * <br/> - `#ff0000` will set the background color of the text track to red.
     * <br/> - `rgba(255,0,0,0.5)` will set the background color of the text track to red, with 50% opacity.
     */
    backgroundColor: string | undefined;
    /**
     * The window color for the text track.
     *
     * @remarks
     * This targets the area covering the full width of the text track.
     *
     * @example
     * <br/> - `red` will set the background color of the window of the text track to red.
     * <br/> - `#ff0000` will set the background color of the window of the text track to red.
     * <br/> - `rgba(255,0,0,0.5)` will set the background color of the window of the text track to red, with 50% opacity.
     */
    windowColor: string | undefined;
    /**
     * The edge style of the text, represented by a value from the following list:
     * <br/> - `'none'`
     * <br/> - `'dropshadow'`
     * <br/> - `'raised'`
     * <br/> - `'depressed'`
     * <br/> - `'uniform`
     */
    edgeStyle: EdgeStyle | undefined;
    /**
     * The top margin of the area where subtitles are being rendered.
     *
     * @remarks
     * <br/> - Available since v4.2.0
     * <br/> - The margin is in number of pixels.
     * <br/> - Useful for pushing the subtitles down, so they don't overlap with the UI.
     */
    marginTop: number | undefined;
    /**
     * The bottom margin of the area where subtitles are being rendered.
     *
     * @remarks
     * <br/> - Available since v4.2.0
     * <br/> - The margin is in number of pixels.
     * <br/> - Useful for pushing the subtitles up, so they don't overlap with the UI.
     */
    marginBottom: number | undefined;
    /**
     * The left margin of the area where subtitles are being rendered.
     *
     * @remarks
     * <br/> - Available since v4.2.0
     * <br/> - The margin is in number of pixels.
     * <br/> - Useful for pushing the subtitles right, so they don't overlap with the UI.
     */
    marginLeft: number | undefined;
    /**
     * The right margin  of the area where subtitles are being rendered.
     *
     * @remarks
     * <br/> - Available since v4.2.0
     * <br/> - The margin is in number of pixels.
     * <br/> - Useful for pushing the subtitles left, so they don't overlap with the UI.
     */
    marginRight: number | undefined;
}
/**
 * The style of the edge, represented by a value from the following list:
 * <br/> - `'none'`
 * <br/> - `'dropshadow'`
 * <br/> - `'raised'`
 * <br/> - `'depressed'`
 * <br/> - `'uniform'`
 *
 * @category Media and Text Tracks
 * @public
 */
type EdgeStyle = 'none' | 'dropshadow' | 'raised' | 'depressed' | 'uniform';

/**
 * The adaptive bitrate strategy of the first segment, represented by a value from the following list:
 * <br/> - `'performance'`: The player will optimize ABR behavior to focus on the performance of the player. This strategy initiates playback with the lowest quality suitable for the device which means faster start-up time.
 * <br/> - `'quality'`: The player will optimize ABR behavior to focus displaying the best visual quality to the end-user. This strategy initiates playback with the highest bit rate suitable for the device.
 * <br/> - `'bandwidth'`: The player will optimize the ABR behavior to focus on displaying the most optimal quality based on historic data of available bandwidth and knowledge of the network conditions. When no historic data is available, the player will start playback at a medium bitrate quality (up to 2.5 Mbps).
 *
 * @category ABR
 * @public
 */
type ABRStrategyType = 'performance' | 'quality' | 'bandwidth';
/**
 * Describes the metadata of the adaptive bitrate strategy.
 *
 * @category ABR
 * @public
 */
interface ABRMetadata {
    /**
     * The initial bitrate, in bits per second.
     *
     * @defaultValue Bitrate available to the browser.
     */
    bitrate?: number;
}
/**
 * Describes the configuration of the adaptive bitrate strategy.
 *
 * @category ABR
 * @public
 */
interface ABRStrategyConfiguration {
    /**
     * The strategy for initial playback.
     */
    type: ABRStrategyType;
    /**
     * The metadata for the initial playback strategy.
     *
     * @defaultValue A {@link ABRMetadata} object with default values.
     */
    metadata?: ABRMetadata;
}
/**
 * The adaptive bitrate strategy.
 *
 * @category ABR
 * @public
 */
type ABRStrategy = ABRStrategyConfiguration | ABRStrategyType;
/**
 * Describes the adaptive bitrate configuration.
 *
 * @remarks
 * <br/> - Available since v2.30.0.
 *
 * @category ABR
 * @public
 */
interface ABRConfiguration {
    /**
     * The adaptive bitrate strategy.
     *
     * @defaultValue `'bandwidth'`
     */
    strategy?: ABRStrategy;
    /**
     * The amount which the player should buffer ahead of the current playback position, in seconds.
     *
     * @remarks
     * <br/> - Before v4.3.0: This duration has a maximum of 60 seconds.
     * <br/> - After v4.3.0: This duration has no maximum.
     * <br/> - The player might reduce or ignore the configured amount because of device or performance constraints.
     *
     * @defaultValue `20`
     */
    targetBuffer?: number;
    /**
     * The amount of data which the player should keep in its buffer before the current playback position, in seconds.
     * This configuration option can be used to reduce the memory footprint on memory restricted devices or on devices
     * which don't automatically prune decoder buffers.
     *
     * Note that the player can decide to keep less data in the decoder buffer in case memory is running low.
     * A value of 0 or lower is not accepted and will be treated as default.
     *
     * @defaultValue `30`
     */
    bufferLookbackWindow?: number;
    /**
     * The maximum length of the player's buffer, in seconds.
     *
     * The player will initially buffer up to {@link ABRConfiguration.targetBuffer} seconds of media data.
     * If the player detects that the decoder is unable to hold so much data,
     * it will reduce `maxBufferLength` and restrict `targetBuffer` to be less than
     * this maximum.
     *
     * @defaultValue `Infinity`
     */
    readonly maxBufferLength: number;
    /**
     * Clears the buffer when setting a single target quality on a MediaTrack.
     *
     * @remarks
     * <br/> - Available since v6.8.0 for HLS streams only.
     *
     * @defaultValue `false`
     */
    clearBufferWhenSettingTargetQuality: boolean;
}

/**
 * The events fired by the {@link Clip | clip API}.
 *
 * @category Clipping
 * @public
 */
interface ClipEventMap {
    /**
     * Fired when the {@link Clip.startTime} or {@link Clip.endTime} changed.
     */
    change: Event<'change'>;
}
/**
 * The clip API which can be used to clip the playback window of a source.
 *
 * @category Clipping
 * @public
 */
interface Clip extends EventDispatcher<ClipEventMap> {
    /**
     * The start time of the clip's window, in seconds.
     */
    startTime: number;
    /**
     * The end time of the clip's window, in seconds.
     */
    endTime: number;
}

/**
 * The number of audio and video segments in the buffer.
 *
 * @category Analytics
 * @public
 */
interface BufferedSegments {
    amountOfBufferedAudioSegments: number;
    amountOfBufferedVideoSegments: number;
}
/**
 * The metrics API which can be used to gather information related to the quality-of-service and video playback experience.
 *
 * @remarks
 * <br/> - Available since v2.46.0.
 *
 * @category Analytics
 * @public
 */
interface Metrics {
    /**
     * The total number of video frames that could not be decoded.
     *
     * @remarks
     * <br/> - This value resets on a source change.
     */
    corruptedVideoFrames: number;
    /**
     * The total number of dropped video frames.
     *
     * @remarks
     * <br/> - This value resets on a source change.
     */
    droppedVideoFrames: number;
    /**
     * The total number of video frames.
     *
     * @remarks
     * <br/> - This value resets on a source change.
     */
    totalVideoFrames: number;
    /**
     * The bandwidth in bits per second estimated to be currently available as used for ABR decisions.
     */
    currentBandwidthEstimate: number;
    /**
     * The total bytes received in response to all media segments since loading the current source.
     */
    totalBytesLoaded: number;
    /**
     * The total number of audio and video segments in the buffer.
     *
     * @remarks
     * <br/> - This value is currently available only for DASH.
     */
    bufferedSegments: BufferedSegments;
}

/**
 * The preload type of the player, represented by a value from the following list:
 * <br/> - `'none'`: The player will not load anything on source change.
 * <br/> - `'metadata'`: The player will immediately load metadata on source change.
 * <br/> - `'auto'`: The player will immediately load metadata and media on source change.
 *
 * @remarks
 * <br/> - `'metadata'` loads enough resources to be able to determine the {@link ChromelessPlayer.duration}.
 * <br/> - `'auto'` loads media up to {@link ABRConfiguration.targetBuffer}.
 *
 * @category Player
 * @public
 */
type PreloadType = 'none' | 'metadata' | 'auto' | '';

/**
 * Fired when the ad break begins.
 *
 * @category Uplynk
 * @category Events
 * @public
 */
interface UplynkAdBreakBeginEvent extends Event<'adbreakbegin'> {
    /**
     * The ad break which began.
     */
    readonly adBreak: UplynkAdBreak;
}

/**
 * Fired when the ad break ends.
 *
 * @category Uplynk
 * @category Events
 * @public
 */
interface UplynkAdBreakEndEvent extends Event<'adbreakend'> {
    /**
     * The ad break which ended.
     */
    readonly adBreak: UplynkAdBreak;
}

/**
 * Fired when the ad break is skipped.
 *
 * @category Uplynk
 * @category Events
 * @public
 */
interface UplynkAdBreakSkipEvent extends Event<'adbreakskip'> {
    /**
     * The ad break which has been skipped.
     */
    readonly adBreak: UplynkAdBreak;
}

/**
 * Fired when the ad break is updated.
 *
 * @category Uplynk
 * @category Events
 * @public
 */
interface UplynkUpdateAdBreakEvent extends Event<'updateadbreak'> {
    /**
     * The ad break which has been updated.
     */
    readonly adBreak: UplynkAdBreak;
}

/**
 * List of generic items.
 *
 * @public
 */
interface List<T> extends Array<T> {
    /**
     * The number of items in the list.
     */
    length: number;
    /**
     * Returns the object representing the nth item in the list.
     * @param index - The index of the item to retrieve.
     */
    item(index: number): T | undefined;
    /**
     * The object representing the nth in the list.
     */
    [index: number]: T;
}
/**
 * List of generic items which can dispatch events.
 *
 * @public
 */
interface EventedList<T, M extends EventMap<StringKeyOf<M>>> extends List<T>, EventDispatcher<M> {
}

/**
 * Fired when an ad begins.
 *
 * @category Uplynk
 * @category Events
 * @public
 */
interface UplynkAdBeginEvent extends Event<'adbegin'> {
    /**
     * The ad which began.
     */
    readonly ad: UplynkAd;
}

/**
 * Fired when the ad ends.
 *
 * @category Uplynk
 * @category Events
 * @public
 */
interface UplynkAdEndEvent extends Event<'adend'> {
    /**
     * The ad which has ended.
     */
    readonly ad: UplynkAd;
}

/**
 * Fired when the ad reaches the first quartile.
 *
 * @category Uplynk
 * @category Events
 * @public
 */
interface UplynkAdFirstQuartileEvent extends Event<'adfirstquartile'> {
    /**
     * The ad which has progressed.
     */
    readonly ad: UplynkAd;
}
/**
 * Fired when the ad reaches the mid point.
 *
 * @category Uplynk
 * @category Events
 * @public
 */
interface UplynkAdMidpointEvent extends Event<'admidpoint'> {
    /**
     * The ad which has progressed.
     */
    readonly ad: UplynkAd;
}
/**
 * Fired when the ad reaches the third quartile.
 *
 * @category Uplynk
 * @category Events
 * @public
 */
interface UplynkAdThirdQuartileEvent extends Event<'adthirdquartile'> {
    /**
     * The ad which has progressed.
     */
    readonly ad: UplynkAd;
}
/**
 * Fired when the ad is completed.
 *
 * @category Uplynk
 * @category Events
 * @public
 */
interface UplynkAdCompleteEvent extends Event<'adcomplete'> {
    /**
     * The ad which has progressed.
     */
    readonly ad: UplynkAd;
}

/**
 * The events fired by the {@link UplynkAd}.
 *
 * @category Uplynk
 * @public
 */
interface UplynkAdEventMap {
    /**
     * {@inheritDoc UplynkAdBeginEvent}
     */
    adbegin: UplynkAdBeginEvent;
    /**
     * {@inheritDoc UplynkAdEndEvent}
     */
    adend: UplynkAdEndEvent;
    /**
     * {@inheritDoc UplynkAdFirstQuartileEvent}
     */
    adfirstquartile: UplynkAdFirstQuartileEvent;
    /**
     * {@inheritDoc UplynkAdMidpointEvent}
     */
    admidpoint: UplynkAdMidpointEvent;
    /**
     * {@inheritDoc UplynkAdThirdQuartileEvent}
     */
    adthirdquartile: UplynkAdThirdQuartileEvent;
    /**
     * {@inheritDoc UplynkAdCompleteEvent}
     */
    adcomplete: UplynkAdCompleteEvent;
}
/**
 * Represents an Uplynk ad.
 *
 * @category Uplynk
 * @public
 */
interface UplynkAd extends EventDispatcher<UplynkAdEventMap> {
    /**
     * The start time of the ad, in seconds.
     */
    readonly startTime: number;
    /**
     * The end time of the ad, in seconds.
     */
    readonly endTime: number;
    /**
     * The duration of the ad, in seconds.
     */
    readonly duration: number;
    /**
     * The API framework, if any.
     *
     * @remarks
     * <br/> - If the value is 'VPAID', then the ad is a VPAID ad.
     * <br/> - Otherwise the ad is an Uplynk CMS asset.
     */
    readonly apiFramework: string | undefined;
    /**
     * The identifier of the creative.
     *
     * @remarks
     * <br/> - Either a VPAID URL if the API framework is `'VPAID'`.
     * <br/> - Otherwise an asset ID from the Uplynk CMS.
     */
    readonly creative: string;
    /**
     * The creative's mime type.
     *
     * @remarks
     * <br/> - Either 'application/javascript' if the API framework is `'VPAID'`.
     * <br/> - Otherwise 'uplynk/m3u8'.
     */
    readonly mimeType: string;
    /**
     * The width of the ad, in pixels.
     *
     * @remarks
     * <br/> - Returns `0` when this is not a companion.
     */
    readonly width: number;
    /**
     * The height of the ad, in pixels.
     *
     * @remarks
     * <br/> - Returns `0` when this is not a companion.
     */
    readonly height: number;
    /**
     * A record of all VAST 3.0 tracking events for this ad.
     * Each entry contains all related tracking URLs.
     */
    readonly events: Record<string, string[]>;
    /**
     * List of companion ads of the ad.
     */
    readonly companions: ReadonlyArray<UplynkAd>;
    /**
     * List of VAST extensions returned by the ad server.
     */
    readonly extensions: ReadonlyArray<object>;
    /**
     * Record of FreeWheel-defined creative parameters.
     * Each entry contains the parameter name together with the associated value.
     */
    readonly freeWheelParameters: Record<string, string>;
}

/**
 * Fired when the ad is removed.
 *
 * @category Uplynk
 * @category Events
 * @public
 */
interface UplynkRemoveAdEvent extends Event<'removead'> {
    readonly ad: UplynkAd;
}

/**
 * Events fired by the {@link UplynkAdList}.
 *
 * @category Uplynk
 * @public
 */
interface UplynkAdListEventMap {
    /**
     *{@inheritDoc UplynkRemoveAdEvent}
     */
    removead: UplynkRemoveAdEvent;
}
/**
 * List of Uplynk ads.
 *
 * @category Uplynk
 * @public
 */
interface UplynkAdList extends EventedList<UplynkAd, UplynkAdListEventMap> {
}

/**
 * The events fired by the {@link UplynkAdBreak}.
 *
 * @category Uplynk
 * @public
 */
interface UplynkAdBreakEventMap {
    /**
     * {@inheritDoc UplynkAdBreakBeginEvent}
     */
    adbreakbegin: UplynkAdBreakBeginEvent;
    /**
     * {@inheritDoc UplynkAdBreakEndEvent}
     */
    adbreakend: UplynkAdBreakEndEvent;
    /**
     * {@inheritDoc UplynkAdBreakSkipEvent}
     */
    adbreakskip: UplynkAdBreakSkipEvent;
    /**
     * {@inheritDoc UplynkUpdateAdBreakEvent}
     */
    updateadbreak: UplynkUpdateAdBreakEvent;
}
/**
 * Represents an Uplynk ad break.
 *
 * @category Uplynk
 * @public
 */
interface UplynkAdBreak extends EventDispatcher<UplynkAdBreakEventMap> {
    /**
     * The start time of the ad break, in seconds.
     */
    readonly startTime: number;
    /**
     * The end time of the ad break, in seconds.
     *
     * @remarks
     * <br/> - For channels it can return `undefined` when the end time has not yet been signaled.
     */
    readonly endTime: number | undefined;
    /**
     * The duration of the ad break, in seconds.
     *
     * @remarks
     * <br/> - For channels it can return `undefined` when the duration has not yet been signaled.
     */
    readonly duration: number | undefined;
    /**
     * List of ads in the ad break.
     */
    readonly ads: UplynkAdList;
    /**
     * Offset after which the ad break may be skipped, in seconds.
     *
     * @remarks
     * If the offset is -1, the ad is unskippable.
     * If the offset is 0, the ad is immediately skippable.
     * Otherwise, it must be a positive number indicating the offset.
     * Skipping the ad in live streams is unsupported.
     *
     * @example
     * To be able to skip the first ad after 10 seconds use: `10`.
     *
     * @defaultValue The {@link UplynkConfiguration.defaultSkipOffset}.
     */
    skipOffset: number;
}

/**
 * Fired when the ad break is added.
 *
 * @category Uplynk
 * @category Events
 * @public
 */
interface UplynkAddAdBreakEvent extends Event<'addadbreak'> {
    /**
     * The ad break which has been added.
     */
    readonly adBreak: UplynkAdBreak;
}

/**
 * Fired when the ad break is removed.
 *
 * @category Uplynk
 * @category Events
 * @public
 */
interface UplynkRemoveAdBreakEvent extends Event<'removeadbreak'> {
    /**
     * The ad break which has been removed.
     */
    readonly adBreak: UplynkAdBreak;
}

/**
 * The events fired by the {@link UplynkAdBreakList}.
 *
 * @category Uplynk
 * @public
 */
interface UplynkAdBreakListEventMap {
    /**
     * {@inheritDoc UplynkAddAdBreakEvent}
     */
    addadbreak: UplynkAddAdBreakEvent;
    /**
     * {@inheritDoc UplynkRemoveAdBreakEvent}
     */
    removeadbreak: UplynkRemoveAdBreakEvent;
}
/**
 * List with Uplynk ad breaks.
 *
 * @category Uplynk
 * @public
 */
interface UplynkAdBreakList extends EventedList<UplynkAdBreak, UplynkAdBreakListEventMap> {
}

/**
 * The Uplynk ads API.
 *
 * @category Uplynk
 * @public
 */
interface UplynkAds {
    /**
     * List of ad breaks.
     */
    readonly adBreaks: UplynkAdBreakList;
    /**
     * The currently playing ad break.
     */
    readonly currentAdBreak: UplynkAdBreak | undefined;
    /**
     * The currently playing ads.
     *
     * @remarks
     * <br/> - These will always be part of the {@link UplynkAds.currentAdBreak | current ad break}.
     */
    readonly currentAds: UplynkAdList;
    /**
     * Seek to the end of the ad if it is skippable.
     *
     * @remarks
     * <br/> - The ad is skippable when it is currently playing and the ad break's offset is reached.
     */
    skip(): void;
}

/**
 * Represents an Uplynk response with advertisement information for VOD assets.
 *
 * @category Uplynk
 * @public
 */
interface UplynkResponseVodAds {
    /**
     * List of ad break information.
     *
     * @remarks
     * <br/> - This includes both linear and non-linear ads.
     */
    breaks: UplynkResponseVodAdBreak[];
    /**
     * List of ad break offset information.
     */
    breakOffsets?: UplynkResponseVodAdBreakOffset[];
    /**
     * List of placeholder offset information.
     */
    placeholderOffsets?: UplynkResponseVodAdPlaceholder[];
}
/**
 * Represents an Uplynk response with ad break information for VOD assets.
 *
 * @category Uplynk
 * @public
 */
interface UplynkResponseVodAdBreak {
    /**
     * The type of the ad break.
     */
    type: 'linear' | 'nonlinear';
    /**
     * The position of the ad break, represented by a value from the following list:
     * <br/> - `'preroll'`: Ad break that plays before the content.
     * <br/> - `'midroll'`: Ad break that plays during the content.
     * <br/> - `'postroll'`: Ad break that plays after the content.
     * <br/> - `'pause'`: Ad break that should be shown when the player is paused.
     * <br/> - `'overlay'`: Non-linear ad break that is shown over the player.
     * <br/> - `''`: Unknown ad break position.
     */
    position: 'preroll' | 'midroll' | 'postroll' | 'pause' | 'overlay' | '';
    /**
     * The time offset of the ad break, in seconds.
     */
    timeOffset: number;
    /**
     * The duration of the ad break, in seconds.
     */
    duration: number;
    /**
     * List of ad information.
     */
    ads: UplynkResponseVodAd[];
    /**
     * A record of all VAST 3.0 tracking events for the ad break.
     * Each entry contains an event name with associated tracking URLs.
     */
    events: Record<string, string[]>;
}
/**
 * The Uplynk response with ad information for VOD assets.
 *
 * @category Uplynk
 * @public
 */
interface UplynkResponseVodAd {
    /**
     * The duration of the ad, in seconds.
     */
    duration: number;
    /**
     * The API framework, if any.
     *
     * @remarks
     * <br/> - If the value is 'VPAID', then the ad is a VPAID ad.
     * <br/> - Otherwise the ad is an Uplynk CMS asset.
     */
    apiFramework: string | null;
    /**
     * The creative identifier.
     *
     * @remarks
     * <br/> - Either a VPAID URL if the API framework is `'VPAID'`.
     * <br/> - Otherwise an asset ID from the Uplynk CMS.
     */
    creative: string;
    /**
     * The creative's mime type.
     *
     * @remarks
     * <br/> - Either 'application/javascript' if the API framework is `'VPAID'`.
     * <br/> - Otherwise 'uplynk/m3u8'.
     */
    mimeType: string;
    /**
     * The width of the ad, in pixels.
     *
     * @remarks
     * <br/> - Returns `0` when this is not a companion.
     */
    width: number;
    /**
     * The height of the ad, in pixels.
     *
     * @remarks
     * <br/> - Returns `0` when this is not a companion.
     */
    height: number;
    /**
     * List of companion ads of the ad.
     */
    companions: UplynkResponseVodAd[];
    /**
     * List of VAST extensions returned by the ad server.
     */
    extensions?: object[];
    /**
     * Record of FreeWheel-defined creative parameters.
     * Each entry contains the parameter name together with the associated value.
     */
    fw_parameters?: Record<string, string>;
    /**
     * A record of all VAST 3.0 tracking events for the ad.
     * Each entry contains an event name with associated tracking URLs.
     */
    events: Record<string, string[]>;
}
/**
 * Represents the offset of an Uplynk ad break.
 *
 * @category Uplynk
 * @public
 */
interface UplynkResponseVodAdBreakOffset {
    /**
     * The index of the ad break in the ads.breaks array.
     */
    index: number;
    /**
     * The time offset of the ad break, in seconds.
     */
    timeOffset: number;
}
/**
 * Represents an Uplynk response with a placeholder for an ad for VOD assets.
 *
 * @remarks
 * A placeholder is an ad which
 * <br/> - is a short blank video for non-video ads (e.g. VPAID ads).
 * <br/> - is a system asset which is potentially subject to change.
 *
 * @category Uplynk
 * @public
 */
interface UplynkResponseVodAdPlaceholder {
    /**
     * The index of the placeholder's ad break in the `ads.breaks` array.
     */
    breaksIndex: number;
    /**
     * The index of the placeholder in the `ads.breaks.ads` array.
     */
    adsIndex: number;
    /**
     * The start time of the placeholder, in seconds.
     */
    startTime: number;
    /**
     * The end time of the placeholder, in seconds.
     */
    endTime: number;
}

/**
 * The response type of the Uplynk Preplay request, represented by a value from the following list:
 * <br/> - `'vod'`
 * <br/> - `'live'`
 *
 * @category Uplynk
 * @public
 */
type UplynkPreplayResponseType = 'vod' | 'live';
/**
 * Type of an Uplynk Preplay response.
 *
 * @category Uplynk
 * @public
 */
type UplynkPreplayResponse = UplynkPreplayVodResponse | UplynkPreplayLiveResponse;
/**
 * Represents an Uplynk Preplay base response.
 *
 * @category Uplynk
 * @public
 */
interface UplynkPreplayBaseResponse {
    /**
     * The response type of the request.
     */
    type: UplynkPreplayResponseType;
    /**
     * The manifest's URL.
     */
    playURL: string;
    /**
     * The zone prefix for the viewer's session.
     *
     * @remarks
     * <br/> - Use this prefix when submitting playback or API requests for this session.
     *
     * @example
     * E.g. 'https://content-ause2.uplynk.com/'
     */
    prefix: string;
    /**
     * The identifier of the viewer's session.
     */
    sid: string;
    /**
     * The content protection information.
     *
     * @remarks
     * <br/> - Currently, this only contains the Fairplay certificate URL.
     * <br/> - Widevine will default to 'https://content.uplynk.com/wv'.
     * <br/> - Playready will default to 'https://content.uplynk.com/pr'.
     */
    drm?: UplynkResponseDrm;
}
/**
 * Represents an Uplynk DRM response.
 *
 * @category Uplynk
 * @public
 */
interface UplynkResponseDrm {
    /**
     * Indicates whether {@link https://api-docs.uplynk.com/#Develop/Studio-DRM-API.htm%3FTocPath%3D_____11 | Studio DRM} is required for playback.
     */
    required?: boolean;
    /**
     * The Fairplay certificate URL.
     */
    fairplayCertificateURL?: string;
    /**
     * The Widevine certificate URL.
     */
    widevineLicenseURL?: string;
    /**
     * The PlayReady certificate URL.
     */
    playreadyLicenseURL?: string;
}
/**
 * Represents an Uplynk Preplay response for VOD assets.
 *
 * @category Uplynk
 * @public
 */
interface UplynkPreplayVodResponse extends UplynkPreplayBaseResponse {
    /**
     * The response type of the request.
     */
    type: 'vod';
    /**
     * The advertisement information.
     */
    ads: UplynkResponseVodAds;
    /**
     * The URL to the interstitial information
     *
     * @remarks
     * <br/> - This is an XML file.
     * <br/> - This parameter reports `null` when ads are not found.
     * <br/> - It should only be used on Apple TV.
     */
    interstitialURL: string | null | undefined;
}
/**
 * Represents an Uplynk Preplay response for live assets.
 *
 * @category Uplynk
 * @public
 */
interface UplynkPreplayLiveResponse extends UplynkPreplayBaseResponse {
    /**
     * The response type of the request.
     */
    type: 'live';
}

/**
 * Fired when a Preplay response is received.
 *
 * @category Uplynk
 * @public
 */
interface UplynkPreplayResponseEvent extends Event<'preplayresponse'> {
    /**
     * The response which has been received.
     */
    readonly response: UplynkPreplayResponse;
}

/**
 * Represents an Uplynk Asset Info Response.
 *
 * @remarks
 * <br/> - See {@link https://api-docs.uplynk.com/#Develop/AssetInfo.htm | Asset Info}.
 *
 * @category Uplynk
 * @public
 */
interface UplynkAssetInfoResponse {
    /**
     * Returns 1 when the asset is audio only.
     *
     * @remarks
     * Valid values are: `0` | `1`.
     */
    audio_only: number;
    /**
     * List of objects which contain information for the boundaries for the asset.
     */
    boundary_details: Boundary[] | undefined;
    /**
     * Returns 1 when an error occurred with the asset.
     *
     * @remarks
     * Valid values are: `0` | `1`.
     */
    error: number;
    /**
     * The TV rating of the asset, represented by a value from the following list:
     * <br/> - `-1`: Not Available.
     * <br/> - `0`: Not Rated.
     * <br/> - `1`: TV-Y.
     * <br/> - `2`: TV-Y7.
     * <br/> - `3`: TV-G.
     * <br/> - `4`: TV-PG.
     * <br/> - `5`: TV-14.
     * <br/> - `6`: TV-MA.
     * <br/> - `7`: Not Rated.
     */
    tv_rating: UplynkAssetTvRating;
    /**
     * The number of slices available for the asset.
     */
    max_slice: number;
    /**
     * The base URL to the {@link https://api-docs.uplynk.com/Content/Develop/AssetInfo.htm#Thumbnails | thumbnails}.
     */
    thumb_prefix: string;
    /**
     * The average slice duration, in seconds.
     */
    slice_dur: number;
    /**
     * The movie rating of the asset, represented by a value from the following list:
     * <br/> - `-1`: Not Available.
     * <br/> - `0`: Not Applicable.
     * <br/> - `1`: G.
     * <br/> - `2`: PG.
     * <br/> - `3`: PG-13.
     * <br/> - `4`: R.
     * <br/> - `5`: NC-17.
     * <br/> - `6`: X.
     * <br/> - `7`: Not Rated.
     */
    movie_rating: UplynkAssetMovieRating;
    /**
     * The identifier of the owner.
     */
    owner: string;
    /**
     * The metadata attached to the asset.
     *
     * @remarks
     * <br/> - Metadata may be added via the CMS.
     */
    meta: object;
    /**
     * The available bitrates of the asset.
     */
    rates: number[];
    /**
     * List of thumbnail resolutions of the asset.
     */
    thumbs: ThumbnailResolution[];
    /**
     * The poster URL of the asset.
     */
    poster_url: string;
    /**
     * The duration of the asset, in seconds.
     */
    duration: number;
    /**
     * The default poster URL created for the asset.
     */
    readonly default_poster_url: string;
    /**
     * The description of the asset.
     */
    desc: string;
    /**
     * The ratings for the asset, as bitwise flags.
     *
     * @remarks
     * These available flags are the following:
     * - D: Drug-related themes are present
     * - V: Violence is present
     * - S: Sexual situations are present
     * - L: Adult Language is present
     *
     * This number is a bitwise number to indicate if one or more of these values are present.
     * - [&nbsp;&nbsp;][&nbsp;&nbsp;][&nbsp;&nbsp;][&nbsp;&nbsp;] - 0: No rating flag.
     * - [&nbsp;&nbsp;][&nbsp;&nbsp;][&nbsp;&nbsp;][L] - 1: Language flag.
     * - [&nbsp;&nbsp;][&nbsp;&nbsp;][S][&nbsp;&nbsp;] - 2: Sex flag.
     * - [&nbsp;&nbsp;][V][&nbsp;&nbsp;][&nbsp;&nbsp;] - 4: Violence flag.
     * - [D][&nbsp;&nbsp;][&nbsp;&nbsp;][&nbsp;&nbsp;] - 8: Drugs flag.
     * - [D][V][S][L] - 15: All flags are on.
     */
    rating_flags: number;
    /**
     * The identifier of the external source.
     */
    external_id: string;
    /**
     * Returns 1 when asset is an ad.
     *
     * @remarks
     * Valid values are: `0` | `1`.
     */
    is_ad: number;
    /**
     * The identifier of the asset.
     */
    asset: string;
}
/**
 * A boundary can be one of 3 possible types:
 * - `c3`: An ad that is relevant for up to 3 days after the original airing.
 * - `c7`: An ad that is relevant for up to 7 days after the original airing.
 * - `halftime`: Identifies special content.
 *
 * @remarks
 * <br/> - See {@link https://api-docs.uplynk.com/index.html#Setup/Boundaries-Setup-Playback.htm | Boundaries }
 *
 * @category Uplynk
 * @public
 */
type Boundary = BoundaryC3 | BoundaryC7 | BoundaryHalftime;
/**
 * Represents the information of an ad boundary.
 *
 * @category Uplynk
 * @public
 */
interface BoundaryInfo {
    /**
     * The duration of this boundary, in seconds.
     */
    duration: number;
    /**
     * The offset for this boundary, in seconds.
     */
    offset: number;
}
/**
 * Represents the boundary of an ad that is relevant for up to three days after the original airing.
 *
 * @category Uplynk
 * @public
 */
interface BoundaryC3 {
    c3: BoundaryInfo;
}
/**
 * Represents the boundary of an ad that is relevant for up to seven days after the original airing.
 *
 * @category Uplynk
 * @public
 */
interface BoundaryC7 {
    c7: BoundaryInfo;
}
/**
 * Represents the boundary that identifies special content.
 *
 * @category Uplynk
 * @public
 */
interface BoundaryHalftime {
    halftime: BoundaryInfo;
}
/**
 * Represents the resolution of an Uplynk thumbnail.
 *
 * @category Uplynk
 * @public
 */
interface ThumbnailResolution {
    /**
     * The width of the thumbnail, in pixels.
     */
    width?: number;
    /**
     * The prefix of the thumbnail.
     */
    prefix: string;
    /**
     * The requested width, in pixels.
     *
     * @remarks
     * <br/> - This can differ from the actual width because images are not stretched.
     */
    bw: number;
    /**
     * The requested height, in pixels.
     *
     * @remarks
     * <br/> - This can differ from the actual width because images are not stretched.
     */
    bh: number;
    /**
     * The height of the thumbnail, in pixels.
     */
    height?: number;
}
/**
 * The TV rating of an asset, represented by a value from the following list:
 * <br/> - `-1` (NOT_AVAILABLE)
 * <br/> - `0` (NOT_APPLICABLE)
 * <br/> - `1` (TV_Y)
 * <br/> - `2` (TV_Y7)
 * <br/> - `3` (TV_G)
 * <br/> - `4` (TV_PG)
 * <br/> - `5` (TV_14)
 * <br/> - `6` (TV_MA)
 * <br/> - `7` (NOT_RATED)
 *
 * @remarks
 * In the online documentation the value for 0 is also "NOT RATED". Since this is counter-intuitive, we have assumed
 * this to be erronous and have modeled this according to the Movie Ratings, with 0 being "NOT APPLICABLE".
 *
 * @category Uplynk
 * @public
 */
type UplynkAssetTvRating = -1 | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7;
/**
 * The movie rating of an asset, represented by a value from the following list:
 * <br/> - `-1` (NOT_AVAILABLE)
 * <br/> - `0` (NOT_APPLICABLE)
 * <br/> - `1` (G)
 * <br/> - `2` (PG)
 * <br/> - `3` (PG_13)
 * <br/> - `4` (R)
 * <br/> - `5` (NC_17)
 * <br/> - `6` (X)
 * <br/> - `7` (NOT_RATED)
 *
 * @category Uplynk
 * @public
 */
type UplynkAssetMovieRating = -1 | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7;

/**
 * Fired when an asset info response is received.
 *
 * @category Uplynk
 * @category Events
 * @public
 */
interface UplynkAssetInfoResponseEvent extends Event<'assetinforesponse'> {
    /**
     * The response which has been received.
     */
    readonly response: UplynkAssetInfoResponse;
}

/**
 * Represents an Uplynk response with advertisement information for live assets.
 *
 * @category Uplynk
 * @public
 */
interface UplynkResponseLiveAds {
    /**
     * List of ad break information.
     *
     * @remarks
     * <br/> - This includes both linear and non-linear ads.
     */
    breaks: UplynkResponseLiveAdBreak[];
}
/**
 * Represents an Uplynk response for live ad breaks.
 *
 * @category Uplynk
 * @public
 */
interface UplynkResponseLiveAdBreak {
    /**
     * The identifier of the ad break.
     */
    breakId: string;
    /**
     * List of ad information.
     */
    ads: UplynkResponseLiveAd[];
    /**
     * The type of the ad break.
     */
    type: 'linear' | 'nonlinear';
    /**
     * The position of the ad break, represented by a value from the following list:
     * <br/> - `'preroll'`: Ad break that plays before the content.
     * <br/> - `'midroll'`: Ad break that plays during the content.
     * <br/> - `'postroll'`: Ad break that plays after the content.
     * <br/> - `'pause'`: Ad break that should be shown when the player is paused.
     * <br/> - `'overlay'`: Non-linear ad break that is shown over the player.
     * <br/> - `''`: Unknown ad break position.
     */
    position: 'preroll' | 'midroll' | 'postroll' | 'pause' | 'overlay' | '';
    /**
     * The time offset of the ad break, in seconds.
     */
    timeOffset: number;
    /**
     * The duration of the ad break, in seconds.
     */
    duration: number;
    /**
     * The height of the ads in the ad break, in pixels.
     *
     * @remarks
     * <br/> - Each ad can override this value.
     */
    height?: number;
    /**
     * The width of the ads in the ad break, in pixels.
     *
     * @remarks
     * <br/> - Each ad can override this value.
     */
    width?: number;
    /**
     * A record of all VAST 3.0 tracking events for this ad.
     * Each entry contains an event name with associated tracking URLs.
     */
    events: Record<string, string[]>;
}
/**
 * Represents an Uplynk response with live ads.
 *
 * @category Uplynk
 * @public
 */
interface UplynkResponseLiveAd {
    /**
     * Identifier for the ad.
     */
    ad_id: string;
    /**
     * The API framework, if any.
     *
     * @remarks
     * <br/> - If the value is 'VPAID', then the ad is a VPAID ad.
     * <br/> - Otherwise the ad is an Uplynk CMS asset.
     */
    apiFramework: string | null;
    /**
     * List of companion ads of the ad.
     */
    companions: UplynkResponseLiveAd[];
    /**
     * The creative identifier.
     *
     * @remarks
     * <br/> - Either a VPAID URL if the API framework is `'VPAID'`.
     * <br/> - Otherwise an asset ID from the Uplynk CMS.
     */
    creative: string;
    /**
     * The duration of the ad, in seconds.
     */
    duration: number;
    /**
     * The creative's mime type.
     *
     * @remarks
     * <br/> - Either 'application/javascript' if the API framework is `'VPAID'`.
     * <br/> - Otherwise 'uplynk/m3u8'.
     */
    mimeType: string;
    /**
     * The height of the ad, in pixels.
     *
     * @remarks
     * <br/> - Returns `0` when this is not a companion.
     */
    height: number;
    /**
     * The width of the ad, in pixels.
     *
     * @remarks
     * <br/> - Returns `0` when this is not a companion.
     */
    width: number;
    /**
     * List of VAST extensions returned by the ad server.
     */
    extensions?: object[];
    /**
     * Record of FreeWheel-defined creative parameters.
     * Each entry contains the parameter name together with the associated value.
     */
    fw_parameters?: Record<string, string>;
}

/**
 * Represents an Uplynk Ping response.
 *
 * @remarks
 * <br/> - See {@link https://api-docs.uplynk.com/#Develop/Pingv2.htm%3FTocPath%3DClient%2520(Media%2520Player)%7C_____3 | Ping API (Version 2)}.
 *
 * @category Uplynk
 * @public
 */
interface UplynkPingResponse {
    /**
     * The playback position at which the next ping request must be made, in seconds.
     *
     * @remarks
     * <br/> - Ping requests should stop after receiving `-1`.
     */
    next_time: number;
    /**
     * The live ad information.
     */
    ads?: UplynkResponseLiveAds;
    /**
     * Whether {@link UplynkAds.currentAdBreak} is ending.
     *
     * @remarks
     * <br/> - False if `0`, true otherwise.
     */
    currentBreakEnd?: number;
    /**
     * List of VAST extensions returned by the ad server.
     */
    extensions?: object[];
    /**
     * The last error that occurred, if any.
     */
    error?: string;
}

/**
 * Fired when a Ping response is received.
 *
 * @category Uplynk
 * @category Events
 * @public
 */
interface UplynkPingResponseEvent extends Event<'pingresponse'> {
    /**
     * The response which has been received.
     */
    readonly response: UplynkPingResponse;
}

/**
 * Fired when an error or invalid response is received from the Ping API.
 *
 * @category Uplynk
 * @category Events
 * @public
 */
interface UplynkPingErrorEvent extends Event<'pingerror'> {
    /**
     * The error message.
     */
    readonly error: string;
}

/**
 * Represents an Uplynk asset.
 *
 * @category Uplynk
 * @public
 */
interface UplynkAsset {
    /**
     * The start time of the asset, in seconds.
     */
    startTime: number;
    /**
     * The end time of the asset, in seconds.
     *
     * @remarks
     * <br> - The end time is the sum of {@link UplynkAsset.startTime}, {@link UplynkAsset.duration} and the {@link UplynkAdBreak.duration} of the ad breaks scheduled during the asset.
     */
    endTime: number;
    /**
     * The duration of the asset, in seconds.
     */
    duration: number;
    /**
     * Whether the asset is audio only.
     */
    audioOnly: boolean;
    /**
     * List of boundaries of the asset.
     *
     * @remarks
     * <br/> - See {@link https://api-docs.uplynk.com/index.html#Setup/Boundaries-Setup-Playback.htm | Boundaries}
     */
    boundaryDetails: Boundary[] | undefined;
    /**
     * Whether an error occurred with the asset.
     */
    error: boolean;
    /**
     * The tv-rating of the asset, represented by a value from the following list:
     * <br/> - `-1`: Not Available.
     * <br/> - `0`: Not Rated.
     * <br/> - `1`: TV-Y.
     * <br/> - `2`: TV-Y7.
     * <br/> - `3`: TV-G.
     * <br/> - `4`: TV-PG.
     * <br/> - `5`: TV-14.
     * <br/> - `6`: TV-MA.
     * <br/> - `7`: Not Rated.
     */
    tvRating: number;
    /**
     * The number of slices available for the asset.
     */
    maxSlice: number;
    /**
     * The prefix URL to the thumbnails.
     */
    thumbPrefix: string;
    /**
     * The average slice duration, in seconds.
     */
    sliceDuration: number;
    /**
     * The movie rating of the asset, represented by a value from the following list:
     * <br/> - `-1`: Not Available.
     * <br/> - `0`: Not Applicable.
     * <br/> - `1`: G.
     * <br/> - `2`: PG.
     * <br/> - `3`: PG-13.
     * <br/> - `4`: R.
     * <br/> - `5`: NC-17.
     * <br/> - `6`: X.
     * <br/> - `7`: Not Rated.
     */
    movieRating: number;
    /**
     * The identifier of the owner.
     */
    ownerId: string;
    /**
     * The metadata attached to the asset.
     *
     * @remarks
     * <br/> - Metadata may be added via the CMS.
     */
    metadata: object;
    /**
     * The available bitrates of the asset.
     */
    rates: number[];
    /**
     * List of thumbnail resolutions of the asset.
     */
    thumbnailResolutions: ThumbnailResolution[];
    /**
     * The poster URL.
     */
    posterUrl: string;
    /**
     * The default poster URL created for the asset.
     */
    defaultPosterUrl: string;
    /**
     * The description of the asset.
     */
    description: string;
    /**
     * Whether the asset contains adult language.
     */
    hasAdultLanguage: boolean;
    /**
     * Whether the asset contains sexual situations.
     */
    hasSexualSituations: boolean;
    /**
     * Whether the asset contains violence.
     */
    hasViolence: boolean;
    /**
     * Whether the asset contains drug situations.
     */
    hasDrugSituations: boolean;
    /**
     * The identifier of the external source.
     */
    externalId: string;
    /**
     * Whether the asset is an ad.
     */
    isAd: boolean;
    /**
     * The identifier of the asset.
     */
    assetId: string;
}

/**
 * Fired when an asset is added.
 *
 * @category Uplynk
 * @category Events
 * @public
 */
interface UplynkAddAssetEvent extends Event<'addasset'> {
    /**
     * The asset which has been added.
     */
    readonly asset: UplynkAsset;
}

/**
 * Fired when an asset is removed.
 *
 * @category Uplynk
 * @category Events
 * @public
 */
interface UplynkRemoveAssetEvent extends Event<'removeasset'> {
    /**
     * The asset which has been removed.
     */
    readonly asset: UplynkAsset;
}

/**
 * The events fired by the {@link UplynkAssetList}.
 *
 * @category Uplynk
 * @public
 */
interface UplynkAssetEventMap {
    /**
     * {@inheritDoc UplynkAddAssetEvent}
     */
    addasset: UplynkAddAssetEvent;
    /**
     * {@inheritDoc UplynkRemoveAssetEvent}
     */
    removeasset: UplynkRemoveAssetEvent;
}
/**
 * List of Uplynk assets.
 *
 * @category Uplynk
 * @public
 */
interface UplynkAssetList extends EventedList<UplynkAsset, UplynkAssetEventMap> {
}

/**
 * The events fired by the {@link Uplynk | Uplynk API}.
 *
 * @category Uplynk
 * @public
 */
interface UplynkEventMap {
    /**
     * {@inheritDoc UplynkPreplayResponseEvent}
     */
    preplayresponse: UplynkPreplayResponseEvent;
    /**
     * {@inheritDoc UplynkAssetInfoResponseEvent}
     */
    assetinforesponse: UplynkAssetInfoResponseEvent;
    /**
     * {@inheritDoc UplynkPingResponseEvent}
     */
    pingresponse: UplynkPingResponseEvent;
    /**
     * {@inheritDoc UplynkPingErrorEvent}
     */
    pingerror: UplynkPingErrorEvent;
}
/**
 * The Uplynk API.
 *
 * @remarks
 * <br/> - Only available with the feature 'uplynk'.
 *
 * @category Uplynk
 * @public
 */
interface Uplynk extends EventDispatcher<UplynkEventMap> {
    /**
     * The Uplynk SSAI API.
     */
    readonly ads: UplynkAds;
    /**
     * List of Uplynk assets.
     */
    readonly assets: UplynkAssetList;
}

/**
 * An error code whose category is `ErrorCategory.CONTENT_PROTECTION`.
 *
 * @category Content Protection
 * @category Errors
 * @public
 */
type ContentProtectionErrorCode = ErrorCode.CONTENT_PROTECTION_ERROR | ErrorCode.CONTENT_PROTECTION_NOT_SUPPORTED | ErrorCode.CONTENT_PROTECTION_CONFIGURATION_MISSING | ErrorCode.CONTENT_PROTECTION_CONFIGURATION_INVALID | ErrorCode.CONTENT_PROTECTION_INITIALIZATION_INVALID | ErrorCode.CONTENT_PROTECTION_CERTIFICATE_ERROR | ErrorCode.CONTENT_PROTECTION_CERTIFICATE_INVALID | ErrorCode.CONTENT_PROTECTION_LICENSE_ERROR | ErrorCode.CONTENT_PROTECTION_LICENSE_INVALID | ErrorCode.CONTENT_PROTECTION_KEY_EXPIRED | ErrorCode.CONTENT_PROTECTION_KEY_MISSING | ErrorCode.CONTENT_PROTECTION_OUTPUT_RESTRICTED | ErrorCode.CONTENT_PROTECTION_INTERNAL_ERROR;
/**
 * An error related to content protection.
 *
 * @category Content Protection
 * @category Errors
 * @public
 */
interface ContentProtectionError extends THEOplayerError {
    /**
     * {@inheritDoc THEOplayerError.code}
     */
    readonly code: ContentProtectionErrorCode;
    /**
     * The URL that was used in the request.
     *
     * @remarks
     * <br/> - Only available when {@link ContentProtectionError.code} is {@link ErrorCode.CONTENT_PROTECTION_CERTIFICATE_ERROR} or {@link ErrorCode.CONTENT_PROTECTION_LICENSE_ERROR}.
     */
    readonly url?: string;
    /**
     * The status code from the HTTP response.
     *
     * @remarks
     * <br/> - Only available when {@link ContentProtectionError.code} is {@link ErrorCode.CONTENT_PROTECTION_CERTIFICATE_ERROR} or {@link ErrorCode.CONTENT_PROTECTION_LICENSE_ERROR}.
     */
    readonly status?: number;
    /**
     * The status text from the HTTP response.
     *
     * @remarks
     * <br/> - Only available when {@link ContentProtectionError.code} is {@link ErrorCode.CONTENT_PROTECTION_CERTIFICATE_ERROR} or {@link ErrorCode.CONTENT_PROTECTION_LICENSE_ERROR}.
     */
    readonly statusText?: string;
    /**
     * The body contained in the HTTP response.
     *
     * @remarks
     * <br/> - Only available when {@link ContentProtectionError.code} is {@link ErrorCode.CONTENT_PROTECTION_CERTIFICATE_ERROR} or {@link ErrorCode.CONTENT_PROTECTION_LICENSE_ERROR}.
     */
    readonly response?: string;
    /**
     * The internal error code from the CDM.
     *
     * @remarks
     * <br/> - Only available when {@link ContentProtectionError.code} is {@link ErrorCode.CONTENT_PROTECTION_INTERNAL_ERROR}.
     */
    readonly systemCode?: number;
}

/**
 * Fired when an error related to content protection occurs.
 *
 * @category Content Protection
 * @category Errors
 * @category Events
 * @public
 */
interface ContentProtectionErrorEvent extends Event<'contentprotectionerror'> {
    /**
     * The error that occurred.
     *
     * @deprecated use {@link ContentProtectionErrorEvent.errorObject | errorObject.message} instead
     */
    error: string;
    /**
     * An error object containing additional information about the error.
     */
    errorObject: ContentProtectionError;
    /**
     * @deprecated use {@link ContentProtectionError.url | errorObject.url} instead
     */
    readonly licenseAcquisitionURL?: string;
    /**
     * @deprecated use {@link ContentProtectionError.status | errorObject.status} instead
     */
    readonly status?: number;
    /**
     * @deprecated use {@link ContentProtectionError.statusText | errorObject.statusText} instead
     */
    readonly statusText?: string;
    /**
     * @deprecated use {@link ContentProtectionError.response | errorObject.response} instead
     */
    readonly licenseAcquisitionMessage?: string;
    /**
     * @deprecated use {@link ContentProtectionError.systemCode | errorObject.systemCode} instead
     */
    readonly systemCode?: number;
}

/**
 * The events fired by the {@link HespApi}.
 * @remarks
 * <br/> - Note: This API is in an experimental stage and may be subject to breaking changes.
 * <br/> - Only available with the feature `'hesp'`.
 * <br/> - Only available when an HESP source is playing.
 *
 * @category HESP
 * @public
 */
interface HespApiEventMap {
    /**
     * Fired when the player enters the HESP live playback mode.
     */
    golive: Event<'golive'>;
    /**
     * Fired when the player seeks back to live to recover from the latency being too high.
     */
    latencyrecoveryseek: Event<'latencyrecoveryseek'>;
}
/**
 * The HESP API.
 * @remarks
 * <br/> - Note: This API is in an experimental stage and may be subject to breaking changes.
 * <br/> - Only available with the feature `'hesp'`.
 *
 * @category HESP
 * @public
 */
interface HespApi extends EventDispatcher<HespApiEventMap> {
    /**
     * Seeks the player to the live point.
     * @remarks
     * <br/> - Only works during HESP playback.
     */
    goLive(): void;
    /**
     * True if the HESP playback is in live mode.
     */
    readonly isLive: boolean;
    /**
     * Returns the manifest for the current HESP source.
     * @remarks
     * <br/> - Undefined if no HESP source is configured.
     */
    readonly manifest: Object | undefined;
    /**
     * Returns an overview of the latencies of different parts of the pipeline.
     *
     * @internal
     */
    readonly latencies: Latencies | undefined;
}
/**
 * Specific source configuration for an HESP media resource.
 * @remarks
 * <br/> - Note: This API is in an experimental stage and may be subject to breaking changes.
 * <br/> - Only available with the feature `'hesp'`.
 * <br/> - Only applicable when configuring an HESP source.
 *
 * @category HESP
 * @category Source
 * @public
 */
interface HespSourceConfiguration {
}
/**
 * Specific {@link TypedSource} variant for an HESP media resource.
 * @remarks
 * <br/> - Note: This API is in an experimental stage and may be subject to breaking changes.
 * <br/> - Only available with the feature `'hesp'`.
 * <br/> - Only applicable when configuring an HESP source.
 *
 * @category HESP
 * @category Source
 * @public
 */
interface HespTypedSource extends TypedSource {
    type: 'application/vnd.theo.hesp+json';
    /**
     * Specific source configuration for an HESP media resource.
     * @remarks
     * <br/> - Note: This API is in an experimental stage and may be subject to breaking changes.
     * <br/> - Only available with the feature `'hesp'`.
     * <br/> - Only applicable when configuring an HESP source.
     */
    hesp?: HespSourceConfiguration;
}
/**
 * An overview of different latencies in the pipeline.
 *
 * @internal
 */
interface Latencies {
    /**
     * The total latency between a frame entering the transcoder and being displayed on the screen.
     */
    readonly theolive: number;
    /**
     * The latency a frame spends in the transcoding and packaging step.
     */
    readonly engine: number;
    /**
     * The latency between a frame exiting the packager and being received by the player.
     */
    readonly distribution: number;
    /**
     * The latency added by the player in the form of buffer.
     */
    readonly player: number;
}

/**
 * Represents a DASH representation.
 *
 * @category Media and Text Tracks
 * @public
 */
interface Representation {
    /**
     * The identifier for the representation.
     */
    id: string;
    /**
     * The type of the representation, represented by a value from the following list:
     * <br/> - `'audio'`
     * <br/> - `'video'`
     * <br/> - `'text'`
     * <br/> - `'image'`
     * <br/> - `'unknown'`
     */
    type: string;
    /**
     * The required bandwidth for the representation, in bits per second.
     */
    bandwidth: number;
    /**
     * The video height of the representation, in pixels.
     */
    height: number;
    /**
     * The video width of the representation, in pixels.
     */
    width: number;
    /**
     * The framerate of the representation, in frames per seconds.
     */
    frameRate: number;
    /**
     * The audio sampling rate of the representation, in Hertz.
     *
     * @remarks
     * <br/> - Either a single value or a list of two values corresponding to the minimum and maximum sampling rate.
     */
    audioSamplingRate: number | [number, number];
}

/**
 * Fired when `ChromelessPlayer.source` changes.
 *
 * @category Events
 * @public
 */
interface SourceChangeEvent extends Event<'sourcechange'> {
    /**
     * The player's new source.
     */
    readonly source: SourceDescription | undefined;
}
/**
 * Fired when the current source, which is chosen from {@link SourceDescription.sources | ChromelessPlayer.source.sources}, changes.
 *
 * @category Events
 * @public
 */
interface CurrentSourceChangeEvent extends Event<'currentsourcechange'> {
    /**
     * The player's new current source.
     */
    readonly currentSource: TypedSource | undefined;
}
/**
 * Fired when `ChromelessPlayer.paused` changes to `false`.
 *
 * @category Events
 * @public
 */
interface PlayEvent extends Event<'play'> {
    /**
     * The player's current time.
     */
    readonly currentTime: number;
}
/**
 * Fired when `ChromelessPlayer.paused` changes to `true`.
 *
 * @category Events
 * @public
 */
interface PauseEvent extends Event<'pause'> {
    /**
     * The player's current time.
     */
    readonly currentTime: number;
}
/**
 * Fired when `ChromelessPlayer.seeking` changes to `true`, and the player has started seeking to a new position.
 *
 * @category Events
 * @public
 */
interface SeekingEvent extends Event<'seeking'> {
    /**
     * The player's current time.
     */
    readonly currentTime: number;
}
/**
 * Fired when `ChromelessPlayer.seeking` changes to `false` after the current playback position was changed.
 *
 * @category Events
 * @public
 */
interface SeekedEvent extends Event<'seeked'> {
    /**
     * The player's current time.
     */
    readonly currentTime: number;
}
/**
 * Fired when the current playback position changed as part of normal playback or in an especially interesting way, for example discontinuously.
 *
 * @category Events
 * @public
 */
interface TimeUpdateEvent extends Event<'timeupdate'> {
    /**
     * The player's current time.
     */
    readonly currentTime: number;
    /**
     * The player's current program date time.
     */
    readonly currentProgramDateTime: Date | undefined;
}
/**
 * Fired when playback has stopped because the end of the media resource was reached.
 *
 * @category Events
 * @public
 */
interface EndedEvent extends Event<'ended'> {
    /**
     * The player's current time.
     */
    readonly currentTime: number;
}
/**
 * Fired when playback is ready to start after having been paused or delayed due to lack of media data.
 *
 * @category Events
 * @public
 */
interface PlayingEvent extends Event<'playing'> {
    /**
     * The player's current time.
     */
    readonly currentTime: number;
}
/**
 * Fired when playback has stopped because the next frame is not available, but the player expects that frame to become available in due course.
 *
 * @category Events
 * @public
 */
interface WaitingEvent extends Event<'waiting'> {
    /**
     * The player's current time.
     */
    readonly currentTime: number;
}
/**
 * Fired when `ChromelessPlayer.readyState` changes.
 *
 * @category Events
 * @public
 */
interface ReadyStateChangeEvent extends Event<'readystatechange'> {
    /**
     * The player's current time.
     */
    readonly currentTime: number;
    /**
     * The player's new ready state, represented by a value from the following list:
     * <br/> - 0 (HAVE_NOTHING): The player has no information about the duration of its source.
     * <br/> - 1 (HAVE_METADATA): The player has information about the duration of its source.
     * <br/> - 2 (HAVE_CURRENT_DATA): The player has its current frame in its buffer.
     * <br/> - 3 (HAVE_FUTURE_DATA): The player has enough data for immediate playback.
     * <br/> - 4 (HAVE_ENOUGH_DATA): The player has enough data for continuous playback.
     *
     * @remarks
     * <br/> - See the {@link https://html.spec.whatwg.org/multipage/media.html#ready-states | HTML Media Specification}
     */
    readonly readyState: number;
}
/**
 * Fired when the player determines the duration and dimensions of the media resource.
 *
 * @category Events
 * @public
 */
interface LoadedMetadataEvent extends Event<'loadedmetadata'> {
    /**
     * The player's current time.
     */
    readonly currentTime: number;
    /**
     * The player's new ready state.
     */
    readonly readyState: number;
}
/**
 * Fired when the player can render the media data at the current playback position for the first time.
 *
 * @category Events
 * @public
 */
interface LoadedDataEvent extends Event<'loadeddata'> {
    /**
     * The player's current time.
     */
    readonly currentTime: number;
    /**
     * The player's new ready state.
     */
    readonly readyState: number;
}
/**
 * Fired when the player can resume playback of the media data.
 *
 * @category Events
 * @public
 */
interface CanPlayEvent extends Event<'canplay'> {
    /**
     * The player's current time.
     */
    readonly currentTime: number;
    /**
     * The player's new ready state.
     */
    readonly readyState: number;
}
/**
 * Fired when the player can resume playback of the media data and buffering is unlikely.
 *
 * @category Events
 * @public
 */
interface CanPlayThroughEvent extends Event<'canplaythrough'> {
    /**
     * The player's current time.
     */
    readonly currentTime: number;
    /**
     * The player's new ready state.
     */
    readonly readyState: number;
}
/**
 * Fired when the player's source is cleared.
 *
 * @category Events
 * @public
 */
interface EmptiedEvent extends Event<'emptied'> {
    /**
     * The player's current time.
     */
    readonly currentTime: number;
    /**
     * The player's new ready state.
     */
    readonly readyState: number;
}
/**
 * Fired when the player loaded media data.
 *
 * @category Events
 * @public
 */
interface ProgressEvent extends Event<'progress'> {
    /**
     * The player's current time.
     */
    readonly currentTime: number;
}
/**
 * Fired when `ChromelessPlayer.duration` changes.
 *
 * @category Events
 * @public
 */
interface DurationChangeEvent extends Event<'durationchange'> {
    /**
     * The player's new duration.
     */
    readonly duration: number;
}
/**
 * Fired when `ChromelessPlayer.volume` changes.
 *
 * @category Events
 * @public
 */
interface VolumeChangeEvent extends Event<'volumechange'> {
    /**
     * The player's new volume.
     */
    readonly volume: number;
}
/**
 * Fired when the current representation changes.
 *
 * @category Events
 * @public
 */
interface RepresentationChangeEvent extends Event<'representationchange'> {
    /**
     * The player's current representation.
     */
    readonly representation: Representation | undefined;
    /**
     * The player's previous representation.
     */
    readonly previousRepresentation: Representation | undefined;
}
/**
 * Fired when `ChromelessPlayer.playbackRate` changes.
 *
 * @category Events
 * @public
 */
interface RateChangeEvent extends Event<'ratechange'> {
    /**
     * The player's new playback rate.
     */
    readonly playbackRate: number;
}
/**
 * Fired when the dimensions of the HTML element changes.
 *
 * @category Events
 * @public
 */
interface DimensionChangeEvent extends Event<'dimensionchange'> {
    /**
     * The current width of the player's HTML element, in pixels.
     */
    readonly width: number;
    /**
     * The current height of the player's HTML element, in pixels.
     */
    readonly height: number;
}
/**
 * Fired when the player encounters key system initialization data in the media data.
 *
 * @category Events
 * @public
 */
interface EncryptedEvent extends Event<'encrypted'> {
    /**
     * The player's current time.
     */
    readonly currentTime: number;
    /**
     * The type of the initialization data.
     */
    readonly initDataType: string;
    /**
     * The initialization data.
     */
    readonly initData: ArrayBuffer;
}

/**
 * The latency manager, used to control low-latency live playback.
 *
 * @remarks This is only used for live playback.
 *
 * @category Player
 * @public
 */
interface LatencyManager {
    /**
     * Whether the latency manager is enabled.
     */
    enabled: boolean;
    /**
     * Whether the latency manager is monitoring to stay within the {@link LatencyManager.currentConfiguration | live playback configuration}.
     *
     * @remarks
     * <br/> - Can only be monitored for live playback.
     */
    readonly monitoringLivePlayback: boolean;
    /**
     * The current latency.
     *
     * @remarks
     * <br/> - Only available during live playback.
     */
    readonly currentLatency: number | undefined;
    /**
     * The current latency configuration for the current source, if available.
     *
     * @remarks
     * <br/> - The initial value will be based on {@link BaseSource.latencyConfiguration}
     * <br/> - If {@link BaseSource.latencyConfiguration} is not set, the player will determine the configuration for your live stream.
     * <br/> - The player might change the latency configuration based on playback events like stalls.
     */
    readonly currentConfiguration: LatencyConfiguration | undefined;
}
/**
 * The latency configuration for managing the live offset of the player.
 *
 * @category Player
 * @public
 */
interface LatencyConfiguration {
    /**
     * The start of the target live window.
     * If the live offset becomes smaller than this value, the player will slow down in order to increase the latency.
     */
    readonly minimumOffset: number;
    /**
     * The end of the target live window.
     * If the live offset becomes higher than this value, the player will speed up in order to decrease the latency.
     */
    readonly maximumOffset: number;
    /**
     * The live offset that the player will aim for. When correcting the offset by tuning the playbackRate,
     * the player will stop correcting when it reaches this value.
     */
    readonly targetOffset: number;
    /**
     * The live offset at which the player will automatically trigger a live seek.
     */
    readonly forceSeekOffset: number;
    /**
     * Indicates the minimum playbackRate used to slow down the player.
     */
    readonly minimumPlaybackRate: number;
    /**
     * Indicates the maximum playbackRate used to speed up the player.
     */
    readonly maximumPlaybackRate: number;
}

/**
 * Represents one or more ranges of time, each specified by a start time and an end time.
 *
 * @remarks
 * This is equivalent to the {@link https://developer.mozilla.org/en-US/docs/Web/API/TimeRanges | TimeRanges} interface used by an HTML video element.
 *
 * @public
 */
interface TimeRanges {
    /** Returns the number of ranges in the object. */
    readonly length: number;
    /**
     * Returns the time for the start of the range with the given index.
     *
     * @throws Throws an Error if the index is out of bounds.
     */
    start(index: number): number;
    /**
     * Returns the time for the end of the range with the given index.
     *
     * @throws Throws an Error if the index is out of bounds.
     */
    end(index: number): number;
}

/**
 * Fired when the loading of a THEOlive publication starts.
 *
 * @public
 */
interface PublicationLoadStartEvent extends Event<'publicationloadstart'> {
    readonly publicationId: string;
}
/**
 * Fired when the loading of a THEOlive publication is complete and playback can start. This event is dispatched on publication reloads as well, which
 * can happen when an error is encountered or the player fallbacks.
 *
 * @public
 */
interface PublicationLoadedEvent extends Event<'publicationloaded'> {
    readonly publicationId: string;
    readonly channelName: string;
}
/**
 * Fired when loading a THEOlive publication that cannot be played, for example because the publication is stopped.
 *
 * @public
 */
interface PublicationOfflineEvent extends Event<'publicationoffline'> {
    readonly publicationId: string;
}
/**
 * Fired when the player cannot play the current primary publication and would like to fallback. If a fallback has been configured it will fallback,
 * otherwise only the event is fired.
 *
 * @public
 */
interface IntentToFallbackEvent extends Event<'intenttofallback'> {
}
/**
 * Fired when the player enters bad network mode.
 *
 * @public
 */
interface EnterBadNetworkModeEvent extends Event<'enterbadnetworkmode'> {
}
/**
 * Fired when the player exits bad network mode.
 *
 * @public
 */
interface ExitBadNetworkModeEvent extends Event<'exitbadnetworkmode'> {
}
/**
 * A collection of events dispatched by the THEOlive api.
 *
 * @public
 */
interface TheoLiveApiEventMap {
    readonly publicationloadstart: PublicationLoadStartEvent;
    readonly publicationloaded: PublicationLoadedEvent;
    readonly publicationoffline: PublicationOfflineEvent;
    readonly intenttofallback: IntentToFallbackEvent;
    readonly enterbadnetworkmode: EnterBadNetworkModeEvent;
    readonly exitbadnetworkmode: ExitBadNetworkModeEvent;
}
/**
 * A THEOlive publication.
 *
 * @public
 */
interface TheoLivePublication {
    readonly name: string;
}
/**
 * The THEOlive api.
 *
 * @public
 */
interface TheoLiveApi extends EventDispatcher<TheoLiveApiEventMap> {
    badNetworkMode: boolean;
    preloadPublications(publicationIds: string[]): Promise<TheoLivePublication[]>;
}

/**
 * A WebVTT-defined region scroll setting, represented by a value from the following list:
 * <br/> - `''`: None. Cues in the region stay fixed at the location they were first painted in.
 * <br/> - `'up'`: Up. Cues in the region will be added at the bottom of the region and push any already displayed cues in the region up until all lines of the new cue are visible in the region.
 *
 * @category Media and Text Tracks
 * @public
 */
type VTTScrollSetting = '' | /* none */ 'up';
/**
 * Represents a WebVTT region.
 *
 * @category Media and Text Tracks
 * @public
 */
interface WebVTTRegion {
    /**
     * The identifier of the region.
     */
    readonly id: string;
    /**
     * The number of lines in the region.
     */
    readonly lines: number;
    /**
     * The horizontal coordinate of the anchor point of the region to the viewport, as a percentage of the video width.
     */
    readonly regionAnchorX: number;
    /**
     * The vertical coordinate of the anchor point of the region to the viewport, as a percentage of the video height.
     */
    readonly regionAnchorY: number;
    /**
     * The scroll setting of the region.
     */
    readonly scrollValue: VTTScrollSetting;
    /**
     * The horizontal coordinate of the point of the viewport the anchor point of the region is anchored to, as a percentage of the video width.
     */
    readonly viewportAnchorX: number;
    /**
     * The veritcal coordinate of the point of the viewport the anchor point of the region is anchored to, as a percentage of the video height.
     */
    readonly viewportAnchorY: number;
    /**
     * The width of the region, as a percentage of the video width.
     */
    readonly width: number;
    /**
     * The identifier of the region.
     *
     * @deprecated Superseded by {@link WebVTTRegion.id}.
     */
    readonly identifier: string;
}

/**
 * A WebVTT-defined writing direction, represented by a value from the following list:
 * <br/> - `''`: Horizontal. A line extends horizontally and is offset vertically from the video viewport’s top edge, with consecutive lines displayed below each other.
 * <br/> - `'rl'`: Vertical right-to-left. A line extends vertically and is offset horizontally from the video viewport’s right edge, with consecutive lines displayed to the left of each other.
 * <br/> - `'lr'`: vertical left-to-right. A line extends vertically and is offset horizontally from the video viewport’s left edge, with consecutive lines displayed to the right of each other.
 *
 * @category Media and Text Tracks
 * @public
 */
type VTTDirectionSetting = '' | 'rl' | 'lr';
/**
 * A WebVTT-defined line alignment, represented by a value from the following list:
 * <br/> - `'start'`: The cue box's start is aligned at a specified line.
 * <br/> - `'center'`: The cue box's center is aligned at a specified line.
 * <br/> - `'end'`: The cue box's end is aligned at a specified line.
 *
 * @category Media and Text Tracks
 * @public
 */
type VTTLineAlignSetting = 'start' | 'center' | 'end';
/**
 * A WebVTT-defined text alignment, represented by a value from the following list:
 * <br/> - `'start'`: The text of each line is aligned towards the start side of the box.
 * <br/> - `'center'`: The text of each line is aligned at the center of the box.
 * <br/> - `'end'`: The text of each line is aligned towards the end side of the box.
 * <br/> - `'left'`: The text of each line is aligned to the box’s left side for horizontal cues, or top side otherwise.
 * <br/> - `'right'`: The text of each line is aligned to the box’s right side for horizontal cues, or bottom side otherwise.
 *
 * @category Media and Text Tracks
 * @public
 */
type VTTAlignSetting = 'start' | 'center' | 'end' | 'left' | 'right';
/**
 * A WebVTT-defined position alignment, represented by a value from the following list:
 * <br/> - `'line-left'`: The cue box's start is aligned at a specified position.
 * <br/> - `'center'`: The cue box's center is aligned at a specified position.
 * <br/> - `'line-right'`: The cue box's end is aligned at a specified position.
 * <br/> - `'auto'`: The cue box's alignment is dependent on its text alignment setting.
 *
 * @category Media and Text Tracks
 * @public
 */
type VTTPositionAlignSetting = 'line-left' | 'center' | 'line-right' | 'auto';
/**
 * A WebVTT-defined line offset, represented by a value from the following list:
 * <br/> - a `number`: The line offset is expressed in a number of text lines or a percentage of the video viewport height or width.
 * <br/> - `'auto'`: The line offset depends on the other showing tracks.
 *
 * @remarks
 * <br/> - The semantics of the `number` variant are dependent on {@link WebVTTCue.snapToLines}.
 *
 * @category Media and Text Tracks
 * @public
 */
type VTTLine = number | 'auto';
/**
 * A WebVTT-defined position, represented by a value from the following list:
 * <br/> - a number: The position is expressed as a percentage value.
 * <br/> - `'auto'`: The position depends on the text alignment of the cue.
 *
 * @category Media and Text Tracks
 * @public
 */
type VTTPosition = number | 'auto';
/**
 * Represents a cue of a {@link https://www.w3.org/TR/webvtt1/ | WebVTT} text track.
 *
 * @category Media and Text Tracks
 * @public
 */
interface WebVTTCue extends TextTrackCue {
    /**
     * The text alignment of the cue.
     */
    align: VTTAlignSetting;
    /**
     * The content of the cue in raw unparsed form.
     */
    content: string;
    /**
     * The line offset of the cue.
     */
    line: VTTLine;
    /**
     * The line alignment of the cue.
     */
    lineAlign: VTTLineAlignSetting;
    /**
     * The position of the cue.
     */
    position: VTTPosition;
    /**
     * The position alignment of the cue.
     */
    positionAlign: VTTPositionAlignSetting;
    /**
     * The region of the cue.
     */
    region: WebVTTRegion | null;
    /**
     * Whether snap-to-lines is enabled for the cue.
     *
     * @remarks
     * <br/> - This property indicates whether {@link WebVTTCue.line} is an integer number of lines or a percentage of the dimension of the video.
     */
    snapToLines: boolean;
    /**
     * The size of the cue's box.
     *
     * @remarks
     * <br/> - This property is to be interpreted as a percentage of the video, relative to the cue direction stated by {@link WebVTTCue.vertical}.
     */
    size: number;
    /**
     * The text of the cue in raw unparsed form.
     */
    text: string;
    /**
     * The writing direction of the cue.
     */
    vertical: VTTDirectionSetting;
}

/**
 * Represents a text track of a media resource that can be filled with cues during playback.
 *
 * @category Media and Text Tracks
 * @public
 */
interface CustomWebVTTTextTrack extends TextTrack {
    /**
     * The kind of the text track.
     */
    readonly type: 'webvtt';
    /**
     * Adds a cue to the text track.
     * @param startTime The start time of the cue.
     * @param endTime The end time of the cue.
     * @param content The content of the cue.
     */
    addCue(startTime: number, endTime: number, content: string): WebVTTCue;
    /**
     * Removed a cue from the text track.
     * @param cue The cue to be removed.
     */
    removeCue(cue: WebVTTCue): void;
}

/**
 * Options for creating a custom text track.
 *
 * @category Media and Text Tracks
 * @public
 */
interface CustomTextTrackOptions {
    /**
     * The type of cues this track will support.
     */
    type: SupportedCustomTextTrackCueTypes;
    /**
     * The kind of the text track, represented by a value from the following list:
     * <br/> - `'subtitles'`: The track contains subtitles.
     * <br/> - `'captions'`: The track contains closed captions, a translation of dialogue and sound effects.
     * <br/> - `'descriptions'`: The track contains descriptions, a textual description of the video.
     * <br/> - `'chapters'`: The track contains chapter titles.
     * <br/> - `'metadata'`: The track contains metadata. This track will not serve display purposes.
     */
    kind: string;
    /**
     * The label of the text track.
     */
    label?: string;
    /**
     * The language of the text track.
     */
    language?: string;
}
/**
 * The supported cue types for custom text tracks.
 *
 * @category Media and Text Tracks
 * @public
 */
type SupportedCustomTextTrackCueTypes = 'webvtt';
/**
 * The mapping between the type in {@link CustomTextTrackOptions} and which kind of TextTrack the `player.addTextTrack()` API will return.
 *
 * @category Media and Text Tracks
 * @public
 */
interface CustomTextTrackMap {
    webvtt: CustomWebVTTTextTrack;
}

/**
 * The THEOads API.
 *
 * @remarks
 * <br/> - Available since v8.12.0.
 *
 * @category THEOads
 * @public
 */
interface TheoAds extends EventDispatcher<TheoAdsEventsMap> {
    /**
     * The currently playing interstitials.
     */
    currentInterstitials: readonly Interstitial[];
    /**
     * List of interstitials which still need to be played.
     */
    scheduledInterstitials: readonly Interstitial[];
    /**
     * Replaces all the ad tag parameters used for upcoming ad requests for a live stream.
     *
     * @param adTagParameters - The new ad tag parameters.
     *
     * @remarks
     * <br/> - If set, this value overrides any parameters set on the {@link TheoAdDescription.adTagParameters}.
     */
    replaceAdTagParameters(adTagParameters?: Record<string, string>): void;
}
/**
 * The events fired by the {@link TheoAds | THEOads API}.
 *
 * @category THEOads
 * @public
 */
interface TheoAdsEventsMap {
    /**
     * Fired when an interstitial is added.
     */
    addinterstitial: InterstitialEvent<'addinterstitial'>;
    /**
     * Fired when an interstitial begins.
     */
    interstitialbegin: InterstitialEvent<'interstitialbegin'>;
    /**
     * Fired when an interstitial ends.
     */
    interstitialend: InterstitialEvent<'interstitialend'>;
    /**
     * Fired when an interstitial is updated.
     */
    interstitialupdate: InterstitialEvent<'interstitialupdate'>;
    /**
     * Fired when an interstitial has errored.
     */
    interstitialerror: InterstitialEvent<'interstitialerror'>;
}
/**
 * Base type for events related to an interstitial.
 *
 * @category THEOads
 * @category Events
 * @public
 */
interface InterstitialEvent<TType extends string> extends Event<TType> {
    /**
     * The interstitial.
     */
    readonly interstitial: Interstitial;
}
/**
 * The type of the interstitial.
 *
 * @category THEOads
 * @public
 */
type InterstitialType = 'adbreak' | 'overlay';
/**
 * The THEOads interstitial.
 *
 * @category THEOads
 * @public
 */
interface Interstitial {
    /**
     * The type of the interstitial.
     */
    type: InterstitialType;
    /**
     * The identifier of the interstitial.
     */
    id: string;
    /**
     * The start time at which the interstitial will start.
     */
    startTime: number;
    /**
     * The duration of the interstitial, in seconds.
     *
     */
    duration: number | undefined;
}
/**
 *  The layout of the THEOad.
 */
type TheoAdsLayout = 'single' | 'l-shape' | 'double';
/**
 * The THEOads interstitial that corresponds with ad playback.
 *
 * @category THEOads
 * @public
 */
interface AdBreakInterstitial extends Interstitial {
    type: 'adbreak';
    /**
     * The layout which is used to play the ads of the interstitial.
     */
    layout: TheoAdsLayout;
    /**
     * The background when playing an ad.
     *
     * @remarks
     * - <br/> This is only available when playing in double or l-shape layout.
     */
    backdropUri: string | undefined;
    /**
     * The ads that are part of the interstitial.
     *
     * @remarks
     * - <br/> - Only available during ad playback.
     */
    ads: readonly Ad[];
}
/**
 * The THEOads interstitial that corresponds with overlay playback.
 *
 * @category THEOads
 * @public
 */
interface OverlayInterstitial extends Interstitial {
    type: 'overlay';
    /**
     * The url of the image of the overlay.
     */
    imageUrl: string | undefined;
    /**
     * The clickThrough url of the overlay.
     */
    clickThrough: string | undefined;
    /**
     * The position of the overlay.
     */
    position: OverlayPosition;
    /**
     * The size of the overlay.
     */
    size: OverlaySize;
}
/**
 * The position information of the overlay.
 *
 * @category THEOads
 * @public
 */
interface OverlayPosition {
    left?: number;
    right?: number;
    top?: number;
    bottom?: number;
}
/**
 * The size information of the overlay.
 *
 * @category THEOads
 * @public
 */
interface OverlaySize {
    width?: number;
    height?: number;
}

/**
 * The events fired by the {@link ChromelessPlayer}.
 *
 * @category Player
 * @public
 */
interface PlayerEventMap {
    /**
     * Fired when {@link ChromelessPlayer.source} changes.
     */
    sourcechange: SourceChangeEvent;
    /**
     * Fired when the current source, which is chosen from {@link SourceDescription.sources | ChromelessPlayer.source.sources}, changes.
     */
    currentsourcechange: CurrentSourceChangeEvent;
    /**
     * Fired when {@link ChromelessPlayer.paused} changes to `false`.
     *
     * @remarks
     * <br/> - Either fired after the play() method has returned, or when the {@link ChromelessPlayer.autoplay} attribute has caused playback to begin.
     */
    play: PlayEvent;
    /**
     * Fired when {@link ChromelessPlayer.paused} changes to `true`.
     *
     * @remarks
     * <br/> - Fired after the `pause()` method has returned.
     */
    pause: PauseEvent;
    /**
     * Fired when {@link ChromelessPlayer.seeking} changes to `true`, and the player has started seeking to a new position.
     */
    seeking: SeekingEvent;
    /**
     * Fired when {@link ChromelessPlayer.seeking} changes to `false` after the current playback position was changed.
     */
    seeked: SeekedEvent;
    /**
     * Fired when the current playback position changed as part of normal playback or in an especially interesting way, for example discontinuously.
     */
    timeupdate: TimeUpdateEvent;
    /**
     * Fired when playback has stopped because the end of the media resource was reached.
     */
    ended: EndedEvent;
    /**
     * Fired when playback is ready to start after having been paused or delayed due to lack of media data.
     */
    playing: PlayingEvent;
    /**
     * Fired when playback has stopped because the next frame is not available, but the player expects that frame to become available in due course.
     */
    waiting: WaitingEvent;
    /**
     * Fired when {@link ChromelessPlayer.readyState} changes.
     */
    readystatechange: ReadyStateChangeEvent;
    /**
     * Fired when the player determines the duration and dimensions of the media resource.
     *
     * @remarks
     * <br/> - See {@link https://html.spec.whatwg.org/multipage/media.html#mediaevents:dom-media-readystate | HTML media - network state events}.
     * <br/> - The {@link ChromelessPlayer.seekable | seekable range} should be available as soon as the {@link ChromelessPlayer.duration | duration} is known. However, certain browsers (e.g. Safari) do not make it available until the `loadeddata` event is fired.
     */
    loadedmetadata: LoadedMetadataEvent;
    /**
     * Fired when the player can render the media data at the current playback position for the first time.
     *
     * @remarks
     * <br/> - See {@link https://html.spec.whatwg.org/multipage/media.html#mediaevents:dom-media-readystate | HTML media - network state events}.
     */
    loadeddata: LoadedDataEvent;
    /**
     * Fired when the player can resume playback of the media data.
     *
     * @remarks
     * <br/> - In comparison to `canplaythrough`, the player estimates that if playback were to be started now, the media resource could not be rendered at the current playback rate up to its end without having to stop for further buffering of content.
     * <br/> - See {@link https://html.spec.whatwg.org/multipage/media.html#mediaevents:dom-media-readystate | HTML media - network state events}.
     */
    canplay: CanPlayEvent;
    /**
     * Fired when the player can resume playback of the media data and buffering is unlikely.
     *
     * @remarks
     * <br/> - In comparison to `canplay`, the player estimates that if playback were to be started now, the media resource could be rendered at the current playback rate all the way to its end without having to stop for further buffering.
     * <br/> - See {@link https://html.spec.whatwg.org/multipage/media.html#mediaevents:dom-media-readystate | HTML media - network state events}.
     */
    canplaythrough: CanPlayThroughEvent;
    /**
     * Fired when the player starts loading the manifest.
     *
     * @remarks
     * <br/> - See {@link https://html.spec.whatwg.org/multipage/media.html#mediaevents:dom-media-networkstate | HTML media - network state events}.
     */
    loadstart: Event<'loadstart'>;
    /**
     * Fired when the player loaded media data.
     *
     * @remarks
     * <br/> - For DASH streams, the event is fired every 350ms or for every byte received whichever is least frequent.
     * <br/> - See {@link https://html.spec.whatwg.org/multipage/media.html#mediaevents:dom-media-networkstate | HTML media - network state events}.
     */
    progress: ProgressEvent;
    /**
     * Fired when the player's source is cleared.
     *
     * @remarks
     * <br/> - See {@link https://html.spec.whatwg.org/multipage/media.html#mediaevents:dom-media-networkstate | HTML media - network state events}.
     */
    emptied: EmptiedEvent;
    /**
     * Fired when {@link ChromelessPlayer.duration} changes.
     *
     * @remarks
     * <br/> - Fired after {@link ChromelessPlayer.readyState} has loaded metadata, or when the last segment is appended and there is a mismatch with the original duration.
     */
    durationchange: DurationChangeEvent;
    /**
     * Fired when {@link ChromelessPlayer.volume} changes.
     */
    volumechange: VolumeChangeEvent;
    /**
     * Fired when the current representation changes.
     */
    representationchange: RepresentationChangeEvent;
    /**
     * Fired when {@link ChromelessPlayer.playbackRate} changes.
     */
    ratechange: RateChangeEvent;
    /**
     * Fired when the dimensions of the HTML element changes.
     *
     * @remarks
     * <br/> - See {@link https://developer.mozilla.org/en-US/docs/Web/API/Element/getBoundingClientRect | Element.getBoundingClientRect()}.
     */
    dimensionchange: DimensionChangeEvent;
    /**
     * Fired when either {@link ChromelessPlayer.videoWidth} or {@link ChromelessPlayer.videoHeight} changes.
     */
    resize: Event<'resize'>;
    /**
     * Fired when the manifest is updated.
     */
    manifestupdate: Event<'manifestupdate'>;
    /**
     * Fired when a segment can not be found.
     *
     * @remarks
     * <br/> - Only fired on DASH streams.
     */
    segmentnotfound: Event<'segmentnotfound'>;
    /**
     * Fired when the player encounters key system initialization data in the media data.
     *
     * @remarks
     * <br/> - See {@link https://www.w3.org/TR/encrypted-media/#dom-evt-encrypted | Encrypted Media Extensions}.
     */
    encrypted: EncryptedEvent;
    /**
     * Fired when the key is usable for decryption.
     *
     * @remarks
     * <br/> - A key is `usable` if the CDM is certain the key can decrypt one or more blocks of media data.
     * <br/> - See {@link https://www.w3.org/TR/encrypted-media/#usable-for-decryption | Encrypted Media Extension - usable for decryption}.
     */
    contentprotectionsuccess: Event<'contentprotectionsuccess'>;
    /**
     * Fired when an error related to content protection occurs.
     */
    contentprotectionerror: ContentProtectionErrorEvent;
    /**
     * Fired when an {@link ChromelessPlayer.error | error} occurs.
     */
    error: ErrorEvent;
    /**
     * Fired when the player is destroyed.
     *
     * @remarks
     * <br/> - Available since v2.33.3.
     */
    destroy: Event<'destroy'>;
    /** @internal */
    airplaychanged_: Event<'airplaychanged_'>;
    /** @internal */
    fullscreenVideoElementChange_: Event<'fullscreenVideoElementChange_'>;
    /** @internal */
    imagesourcechange_: Event<'imagesourcechange_'>;
    /** @internal */
    nosupportedrepresentationfound: Event<'nosupportedrepresentationfound'>;
    /** @internal */
    metricschange: Event<'metricschange'>;
    /** @internal */
    offline: Event<'offline'>;
    /** @internal */
    online: Event<'online'>;
    /** @internal */
    presentationmodechange: Event<'presentationmodechange'>;
    /** @internal */
    segmentrequest_: Event<'segmentrequest_'>;
    /** @internal */
    segmentresponse_: Event<'segmentresponse_'>;
}
/**
 * The player API.
 *
 * @category API
 * @category Player
 * @public
 */
declare class ChromelessPlayer implements EventDispatcher<PlayerEventMap> {
    constructor(element: HTMLElement, configuration?: PlayerConfiguration);
    /**
     * The adaptive bitrate configuration.
     */
    readonly abr: ABRConfiguration;
    /**
     * List of audio tracks of the current source.
     */
    audioTracks: MediaTrackList;
    /**
     * Whether the player should immediately start playback after source change.
     *
     * @remarks
     * <br/> - To autoplay with sound on certain platforms, {@link ChromelessPlayer.prepareWithUserAction} must be called at least once.
     * <br/> - To autoplay without sound, {@link PlayerConfiguration.mutedAutoplay} must be configured.
     */
    autoplay: boolean;
    /**
     * Returns a TimeRanges object that represents the ranges of the media resource that the player has buffered.
     */
    readonly buffered: TimeRanges;
    /**
     * The clip API.
     */
    readonly clip: Clip;
    /**
     * The current playback position of the media, as a timestamp.
     *
     * @remarks
     * <br/> - The relation between {@link ChromelessPlayer.currentProgramDateTime} and {@link ChromelessPlayer.currentTime} is determined by the manifest.
     */
    currentProgramDateTime: Date | null;
    /**
     * The current playback position of the media, in seconds.
     */
    currentTime: number;
    /**
     * The duration of the media, in seconds.
     *
     * @remarks
     * <br/> - On source change, duration becomes available after {@link ChromelessPlayer.readyState} is at least `1` (HAVE_METADATA).
     */
    duration: number;
    /**
     * The HTML element containing the player.
     */
    element: HTMLElement;
    /**
     * Whether playback of the media is ended.
     *
     * @remarks
     * <br/> - Playback is ended when the current playback position is at the end of the media, and the player does not {@link ChromelessPlayer.loop}.
     */
    ended: boolean;
    /**
     * The last error that occurred for the current source, if any.
     *
     * @deprecated use {@link ChromelessPlayer.errorObject} instead
     */
    error: MediaError | undefined;
    /**
     * The last error that occurred for the current source, if any.
     *
     * @remarks
     * <br/> - This will equal the {@link ErrorEvent.errorObject} property from the last {@link ErrorEvent}.
     */
    errorObject: THEOplayerError | undefined;
    /**
     * Whether playback of the media is looped.
     *
     * @remarks
     * <br/> - When playback is looped, upon reaching the end of the media, playback immediately continues at the start of the media.
     * <br/> - Looped media is never {@link ChromelessPlayer.ended}.
     */
    loop: boolean;
    /**
     * The current source which describes desired playback of a media resource.
     *
     * @remarks
     * <br/> - Changing source might {@link ChromelessPlayer.preload} and {@link ChromelessPlayer.autoplay}.
     * <br/> - Changing source will {@link ChromelessPlayer.stop} the previous source.
     */
    source: SourceDescription | undefined;
    /**
     * The current URL of the media resource.
     *
     * @remarks
     * <br/> - Prefer {@link ChromelessPlayer.source} instead.
     */
    src: string | undefined;
    /**
     * Whether audio is muted.
     *
     * @remarks
     * <br/> - This affects capabilities of {@link ChromelessPlayer.autoplay}.
     */
    muted: boolean;
    /**
     * The metrics API.
     */
    readonly metrics: Metrics;
    /**
     * Whether the player is paused.
     */
    paused: boolean;
    /**
     * The playback rate of the media.
     *
     * @example
     * <br/> - `playbackRate = 0.70` will slow down the playback rate of the media by 30%.
     * <br/> - `playbackRate = 1.25` will speed up the playback rate of the media by 25%.
     *
     * @remarks
     * <br/> - Playback rate is represented by a number where `1` is default playback speed.
     * <br/> - Playback rate must be a positive number.
     * <br/> - It is recommended that you limit the range to between 0.5 and 4.
     */
    playbackRate: number;
    /**
     * Returns a TimeRanges object that represents the ranges of the media resource that the player has played.
     */
    played: TimeRanges;
    /**
     * The poster of the current source.
     *
     * @remarks
     * <br/> - An empty string (`''`) clears the current poster.
     * <br/> - The {@link SourceConfiguration.poster} has priority over this poster.
     */
    poster: string;
    /**
     * The preload setting of the player.
     */
    preload: PreloadType;
    /**
     * The ready state of the player, represented by a value from the following list:
     * <br/> - `0` (HAVE_NOTHING): The player has no information about the duration of its source.
     * <br/> - `1` (HAVE_METADATA): The player has information about the duration of its source.
     * <br/> - `2` (HAVE_CURRENT_DATA): The player has its current frame in its buffer.
     * <br/> - `3` (HAVE_FUTURE_DATA): The player has enough data for immediate playback.
     * <br/> - `4` (HAVE_ENOUGH_DATA): The player has enough data for continuous playback.
     *
     * @remarks
     * <br/> - See the {@link https://html.spec.whatwg.org/multipage/media.html#ready-states | HTML Media Specification}
     */
    readyState: number;
    /**
     * Returns a TimeRanges object that represents the ranges of the media resource that are seekable by the player.
     *
     * @remarks
     * <br/> - On source change, seekable becomes available after {@link ChromelessPlayer.readyState} is at least `1`.
     */
    seekable: TimeRanges;
    /**
     * Whether the player is seeking.
     */
    seeking: boolean;
    /**
     * List of text tracks of the current source.
     */
    textTracks: TextTracksList;
    /**
     * The text track style API.
     *
     */
    readonly textTrackStyle: TextTrackStyle;
    readonly theoLive?: TheoLiveApi;
    /**
     * Unique ID of the player.
     */
    uid: number;
    /**
     * The height of the active video rendition, in pixels.
     */
    videoHeight: number;
    /**
     * List of video tracks of the current source.
     */
    videoTracks: MediaTrackList;
    /**
     * The width of the active video rendition, in pixels.
     */
    videoWidth: number;
    /**
     * The volume of the audio.
     *
     * @example
     * <br/> - `volume = 0.7` will reduce the audio volume of the media by 30%.
     *
     * @remarks
     * <br/> - Volume is represented by a floating point number between `0.0` and `1.0`.
     */
    volume: number;
    /**
     * The latency manager for low latency live playback.
     */
    latency: LatencyManager;
    /**
     * The canvas of the player.
     */
    readonly canvas: Canvas;
    /**
     * The network API.
     */
    readonly network: Network;
    /**
     * The presentation API.
     */
    readonly presentation: Presentation;
    /**
     * Destroy the player.
     *
     * @remarks
     * <br/> - Available since v2.26.
     * <br/> - All resources associated with the current source are released.
     * <br/> - All resources associated with the player are released.
     * <br/> - The player can no longer be used.
     */
    destroy(): void;
    /**
     * Start or resume playback.
     */
    play(): void;
    /**
     * Pause playback.
     */
    pause(): void;
    /**
     * Stop playback.
     *
     * @remarks
     * <br/> - All resources associated with the current source are released.
     * <br/> - The player can be reused by setting a new {@link ChromelessPlayer.source}.
     */
    stop(): void;
    /**
     * Prepare the player to {@link ChromelessPlayer.autoplay} on platforms where autoplay is restricted without user action.
     *
     * @remarks
     * <br/> - Any invocation must happen on user action.
     * <br/> - Affected platforms include all mobile platforms and Safari 11+.
     */
    prepareWithUserAction(): void;
    /**
     * Set current source which describes desired playback of a media resource.
     *
     * @deprecated Superseded by {@link ChromelessPlayer.source}.
     */
    setSource(sourceDescription: SourceDescription | undefined): void;
    /**
     * {@inheritDoc EventDispatcher.addEventListener}
     */
    addEventListener<TType extends StringKeyOf<PlayerEventMap>>(type: TType | readonly TType[], listener: EventListener<PlayerEventMap[TType]>): void;
    /**
     * {@inheritDoc EventDispatcher.removeEventListener}
     */
    removeEventListener<TType extends StringKeyOf<PlayerEventMap>>(type: TType | readonly TType[], listener: EventListener<PlayerEventMap[TType]>): void;
    /**
     * Adds a new custom text track to the player where cues can be added externally.
     *
     * @param options The options for creating the track.
     *
     * @remarks
     * <br/> - This needs to be called after the player dispatches a `loadedmetadata` event.
     * <br/> - All text tracks added using this method will be cleared when the source of the player changes.
     */
    addTextTrack<TOptions extends CustomTextTrackOptions>(options: TOptions): CustomTextTrackMap[TOptions['type']];
    /**
     * The web audio API.
     *
     * @remarks
     * <br/> - Only available with the feature `'webaudio'`.
     */
    readonly audio?: WebAudio;
    /**
     * The ads API.
     *
     * @remarks
     * <br/> - Only available with the feature `'ads'`.
     */
    readonly ads?: Ads;
    /**
     * The cast API.
     *
     * @remarks
     * <br/> - Only available with the feature `'airplay'` or `'chromecast'`.
     */
    readonly cast?: Cast;
    /**
     * The related content API.
     *
     * @remarks
     * <br/> - Only available with the feature `'relatedcontent'`.
     */
    readonly related?: RelatedContent;
    /**
     * The VR API.
     *
     * @remarks
     * <br/> - Only available with the feature `'vr'`.
     */
    readonly vr?: VR;
    /**
     * The visibility API.
     */
    readonly visibility: Visibility;
    /**
     * The Uplynk API.
     *
     * @remarks
     * <br/> - Only available with the feature `'uplynk'`.
     */
    readonly uplynk?: Uplynk;
    /**
     * The HESP API.
     * @remarks
     * <br/> - Note: This API is in an experimental stage and may be subject to breaking changes.
     * <br/> - Only available with the feature `'hesp'`.
     */
    readonly hesp?: HespApi;
    /**
     * The THEOads API.
     *
     * @remarks
     * <br/> - Only available with the feature `'theoads''`.
     */
    readonly theoads?: TheoAds;
}

/**
 * The picture-in-picture position, represented by a value from the following list:
 * <br/> - `'top-left'`
 * <br/> - `'top-right'`
 * <br/> - `'bottom-left'`
 * <br/> - `'bottom-right'`
 *
 * @category UI
 * @public
 */
type PiPPosition = 'top-left' | 'top-right' | 'bottom-left' | 'bottom-right';
/**
 * Describes the configuration of the picture-in-picture feature.
 *
 * @category UI
 * @public
 */
interface PiPConfiguration {
    /**
     * The corner in which the player should be shown while in picture-in-picture.
     *
     * @defaultValue `'bottom-right'`
     */
    position?: PiPPosition;
    /**
     * The maximum percentage of the original player position that should be visible to enable picture-in-picture automatically.
     *
     * @remarks
     * <br/> - If not configured, picture-in-picture can only be activated by calling {@link Presentation.requestMode} with the `'picture-in-picture'` argument.
     *
     * @defaultValue `undefined`
     */
    visibility?: number | undefined;
    /**
     * Whether the presentation mode should be retained on source changes.
     *
     * @defaultValue `false`
     */
    retainPresentationModeOnSourceChange?: boolean;
}

/**
 * Describes the UI related configuration of the player.
 *
 * @category UI
 * @public
 */
interface UIPlayerConfiguration extends PlayerConfiguration {
    /**
     * The user interface configuration.
     */
    ui?: UIConfiguration;
    /**
     * The picture-in-picture configuration.
     */
    pip?: PiPConfiguration;
    /**
     * @deprecated use ui.width
     */
    width?: number | string;
    /**
     * @deprecated use ui.height
     */
    height?: number | string;
    /**
     * @deprecated use ui.fluid
     */
    fluid?: boolean;
}
/**
 * Describes the UI configuration of the player.
 *
 * @category UI
 * @public
 */
interface UIConfiguration {
    /**
     * The width of the player.
     *
     * @remarks
     * Possible formats
     * <br/> - A number as the amount of pixels.
     * <br/> - A percentage string (XX%).
     */
    width?: number | string;
    /**
     * The height of the player.
     *
     * @remarks
     * Possible formats
     * <br/> - A number as the amount of pixels.
     * <br/> - A percentage string (XX%).
     */
    height?: number | string;
    /**
     * Whether the UI of the player is responsive.
     *
     * @defaultValue `false`
     */
    fluid?: boolean;
    /**
     * The language which is used for localization.
     *
     * @remarks
     * <br/> - This can be a {@link UILanguage | language map}.
     * <br/> - Otherwise it can be a language code which is the key to a {@link UILanguage | language map} in {@link UIConfiguration.languages}.
     *
     * @example
     * Localize statically to one language.
     * ```
     * ui: {
     *   language: {
     *     "Play": "Reproducir",
     *     "Pause": "Pausa",
     *     "Current Time": "Tiempo actual",
     *     // [...]
     *   }
     * }
     * ```
     *
     * @example
     * Localize dynamically to one of multiple languages.
     * ```
     * ui: {
     *   language: 'es',
     *   languages: {
     *     "es": {
     *       "Play": "Reproducir",
     *       "Pause": "Pausa",
     *       "Current Time": "Tiempo actual",
     *       // [...]
     *     },
     *     "fr": {
     *       // [...]
     *     }
     *   }
     * }
     * ```
     */
    language?: string | UILanguage;
    /**
     * A record used to localize to multiple languages.
     * Each entry contains a language code with associated {@link UILanguage | language map}.
     */
    languages?: Record<string, UILanguage>;
    /**
     * Options to control transitions to fullscreen mode.
     *
     * @remarks
     * <br/> - Available since v2.90.0.
     */
    fullscreenOptions?: FullscreenOptions$1;
    /**
     * Actions that define the behavior of the player.
     *
     * @remarks
     * <br/> - Available since v4.3.0
     */
    userActions?: UserActions;
}
/**
 * A record used to map localization.
 * Each entry contains a translation of an English string.
 *
 * @category UI
 * @public
 */
type UILanguage = Record<string, string>;
/**
 * Options to control transitions to fullscreen mode.
 *
 * @remarks
 * <br/> - Available since v2.90.0.
 *
 * @category UI
 * @public
 */
interface FullscreenOptions$1 {
    /**
     * Whether to show navigation UI while in fullscreen.
     *
     * @remarks
     * <p>On mobile devices, the platform may want to show a native on-screen navigation UI (such as a back button or home button)
     * while the player is in fullscreen mode. This setting controls whether or not this should be shown:
     * <br/> - If set to "show", then the native navigation UI is preferred.
     * <br/> - If set to "hide", then more screen space for the player is preferred.
     * <br/> - If set to "auto", then the choice is left to the platform.
     * <p>By default, the player prefers to hide the on-screen navigation UI, since it already provides its own "exit fullscreen" button
     * on its control bar.
     *
     * @defaultValue `"hide"`
     * @public
     */
    navigationUI?: 'auto' | 'show' | 'hide';
}
/**
 * Actions that define the behavior of the player.
 *
 * @remarks
 * <br/> - Available since v4.3.0
 *
 * @category UI
 * @public
 */
interface UserActions {
    /**
     * Whether clicking the player element will play/pause the player.
     *
     * @defaultValue `true`
     * @public
     */
    click?: boolean | ((event: any) => void);
}

/**
 * List of players.
 *
 * @category Player
 * @public
 */
interface PlayerList extends Array<ChromelessPlayer> {
    /**
     * Length of the list.
     */
    length: number;
    [index: number]: ChromelessPlayer;
    /**
     * Return the player with corresponding UID, if any.
     *
     * @param UID - The UID of the requested player.
     * @returns The player with the given `UID`, if any.
     */
    getPlayerByUID(UID: number): ChromelessPlayer | undefined;
}

/**
 * The {@link CachingTask}'s license API.
 *
 * @category Caching
 * @public
 */
interface CachingTaskLicense {
    /**
     * Renew all the licenses associated with this task.
     *
     * @param drmConfiguration - The DRM configuration used for license renewals. Defaults to the DRM configuration of the original sourceDescription when omitted.
     */
    renew(drmConfiguration?: DRMConfiguration): void;
}

/**
 * Describes the configuration of a caching task.
 *
 * @category Caching
 * @public
 */
interface CachingTaskParameters {
    /**
     * The amount of data to cache for the given stream.
     *
     * @remarks
     * Possible formats:
     * <br/> - A number in seconds.
     * <br/> - A percentage string (XX%) for a proportion of the content duration.
     */
    amount: number | string;
    /**
     * The expiration date of the cached data.
     *
     * @remarks
     * <br/> - Must be a date in the future.
     * <br/> - Data might be removed by the browser if it runs out of disk space.
     *
     * @defaultValue 30 minutes after starting the caching task.
     */
    expirationDate?: Date;
    /**
     * Upper bandwidth limit of the quality to cache.
     *
     * @remarks
     * <br/> - This will take the quality with the highest bandwidth that is lower than the specified bandwidth.
     * <br/> - It should be a value between zero and infinity.
     *
     * @defaultValue Infinity
     */
    bandwidth?: number;
}

/**
 * The cache task status, represented by a value from the following list:
 * <br/> - `'idle'`: The task has been created, but has not started downloading content.
 * <br/> - `'loading'`: The task is currently downloading the content.
 * <br/> - `'done'`: The task has finished downloading all content.
 * <br/> - `'error'`: The task has encountered an error while downloading or evicting content.
 * <br/> - `'evicted'`: All data associated with the task has been removed because the task expired or the user invoked the {@link CachingTask.remove|remove} method.
 *
 * @category Caching
 * @public
 */
type CacheTaskStatus = 'idle' | 'loading' | 'done' | 'error' | 'evicted';
/**
 * The events fired by the {@link CachingTask}.
 *
 * @category Caching
 * @public
 */
interface CachingTaskEventMap {
    /**
     * Fired when a segment is added to the cache.
     */
    progress: Event<'progress'>;
    /**
     * Fired when {@link CachingTask.status} changes.
     */
    statechange: Event<'statechange'>;
}
/**
 * Represents a caching task.
 *
 * @category Caching
 * @public
 */
interface CachingTask extends EventDispatcher<CachingTaskEventMap> {
    /**
     * The generated identifier for the task.
     */
    readonly id: string;
    /**
     * The current status of the task.
     */
    readonly status: CacheTaskStatus;
    /**
     * The media source associated with the task.
     */
    readonly source: SourceDescription;
    /**
     * The configuration of the task.
     */
    readonly parameters: CachingTaskParameters;
    /**
     * The requested cached duration of the media, in seconds.
     */
    readonly duration: number;
    /**
     * The time ranges cached.
     */
    readonly cached: TimeRanges;
    /**
     * The duration cached, in seconds.
     */
    readonly secondsCached: number;
    /**
     * The percentage cached.
     */
    readonly percentageCached: number;
    /**
     * The estimation of the amount this task will download and store, in bytes.
     *
     * @remarks
     * <br/> - Returns -1 if the estimate is not available yet.
     */
    readonly bytes: number;
    /**
     * The amount downloaded and stored, in bytes.
     */
    readonly bytesCached: number;
    /**
     * The API for license related queries and operations
     */
    readonly license: CachingTaskLicense;
    /**
     * Start caching the media.
     */
    start(): void;
    /**
     * Remove the cached media.
     */
    remove(): void;
    /**
     * Pause caching the media.
     *
     * @remarks
     * <br/> - A paused task can be resumed with {@link CachingTask.start}.
     */
    pause(): void;
}

/**
 * Fired when a caching task is added.
 *
 * @category Caching
 * @category Events
 * @public
 */
interface AddCachingTaskEvent extends Event<'addtask'> {
    /**
     * The task which has been added.
     */
    readonly task: CachingTask;
}

/**
 * Fired when a caching task is removed.
 *
 * @category Caching
 * @category Events
 * @public
 */
interface RemoveCachingTaskEvent extends Event<'removetask'> {
    /**
     * The task which has been removed.
     */
    readonly task: CachingTask;
}

/**
 * The events fired by the {@link CachingTaskList}.
 *
 * @category Caching
 * @public
 */
interface CachingTaskListEventMap {
    /**
     * {@inheritDoc AddCachingTaskEvent}
     */
    addtask: AddCachingTaskEvent;
    /**
     * {@inheritDoc AddCachingTaskEvent}
     */
    removetask: RemoveCachingTaskEvent;
}
/**
 * List of caching tasks.
 *
 * @category Caching
 * @public
 */
interface CachingTaskList extends EventedList<CachingTask, CachingTaskListEventMap> {
}

/**
 * The cache status, represented by a value from the following list:
 * <br/> - `'uninitialised'`: Previously stored caching tasks are unavailable.
 * <br/> - `'initialised'`: Previously stored caching tasks are now available.
 *
 * @category Caching
 * @public
 */
type CacheStatus = 'uninitialised' | 'initialised';
/**
 * The events fired by the {@link Cache | cache API}.
 *
 * @category Caching
 * @public
 */
interface CacheEventMap {
    /**
     * Fired when {@link Cache.status} changes.
     */
    statechange: Event<'statechange'>;
}
/**
 * The media caching API.
 *
 * @remarks
 * <br/> - Available since v2.26.
 *
 * @category Caching
 * @public
 */
interface Cache extends EventDispatcher<CacheEventMap> {
    /**
     * List of caching tasks which control the caching of media.
     */
    readonly tasks: CachingTaskList;
    /**
     * The current status of the cache.
     */
    readonly status: CacheStatus;
    /**
     * The cache's network API which allows intercepting requests and responses made by the cache.
     */
    readonly network: NetworkInterceptorController;
    /**
     * Create a caching task which controls the caching of media.
     *
     * @param source - Describes the media source to be cached.
     * @param parameters - Contains caching task related options.
     */
    createTask(source: SourceDescription, parameters: CachingTaskParameters): CachingTask;
}

/**
 * Util for encoding binary data as base64 string and vice versa.
 *
 * @public
 */
interface Base64Util {
    encode(value: Uint8Array): string;
    decode(value: string): Uint8Array;
}
/**
 * Utils that serve common use cases. For example encoding and decoding a base64 string to Uint8Array and vice versa.
 *
 * @public
 */
interface CommonUtils {
    readonly base64: Base64Util;
}

/**
 * A request, either for a certificate or a license.
 * @category Content Protection
 * @public
 */
interface ContentProtectionRequest {
    /**
     * The URL for the certificate server. By default, this will equal the certificate URL configured in the
     * `{@link KeySystemConfiguration}`.
     */
    url: string;
    /**
     * The method of the HTTP request, for example: GET, POST or PUT.
     *
     * @remarks
     * <br/> - Will be equal to GET for Fairplay certificate requests and POST for Widevine certificate requests.
     * <br/> - Will be equal to POST for all license requests.
     */
    method: string;
    /**
     * The HTTP request headers to be sent to the server.
     */
    headers: {
        [headerName: string]: string;
    };
    /**
     * The body of the certificate request.
     *
     * @remarks
     * <br/> - For GET requests (such as with Fairplay), the body will be empty (null).
     * <br/> - For POST requests (such as with Widevine): the body will contain the two bytes in an array as specified in the certificate request protocol.
     */
    body: Uint8Array | null;
    /**
     * Whether the player is allowed to use credentials for cross-origin requests.
     */
    useCredentials: boolean;
}
/**
 * A request for a certificate.
 *
 * @category Content Protection
 * @public
 */
type CertificateRequest = ContentProtectionRequest;
/**
 * A request for a license.
 * @category Content Protection
 * @public
 */
interface LicenseRequest extends ContentProtectionRequest {
    /**
     * The SKD URL (for example skd://fb64ba7c5bd34bf188cf9ba76ab8370e) as extracted from the #EXT-X-KEY tag in the HLS playlist.
     *
     * @remarks
     * <br/> - Only available for Fairplay license requests. The value will be `undefined` otherwise.
     */
    fairplaySkdUrl: string | undefined;
}

/**
 * The response, either of a license or for a certificate request.
 * @category Content Protection
 * @public
 */
interface ContentProtectionResponse {
    /**
     * The request for which the response is being returned.
     */
    request: ContentProtectionRequest;
    /**
     * The URL from which the response was returned. This might have been redirected transparently.
     */
    url: string;
    /**
     * The status code as returned in the HTTP response.
     */
    status: number;
    /**
     * The status text as returned in the HTTP response.
     */
    statusText: string;
    /**
     * The HTTP headers as returned by the server.
     *
     * @remarks
     * <br/> - On web not all headers might be shown due to Cross Origin Resource Sharing restrictions.
     */
    headers: {
        [headerName: string]: string;
    };
    /**
     * The body of the response.
     */
    body: Uint8Array;
}
/**
 * The response of a certificate request.
 * @category Content Protection
 * @public
 */
interface CertificateResponse extends ContentProtectionResponse {
    /**
     * The request for which the response is being returned.
     */
    request: CertificateRequest;
}
/**
 * The response of a license request.
 * @category Content Protection
 * @public
 */
interface LicenseResponse extends ContentProtectionResponse {
    /**
     * The request for which the response is being returned.
     */
    request: LicenseRequest;
}

/**
 * This ContentProtectionIntegration defines some methods to alter license and certificate requests and responses.
 *
 * @category Content Protection
 * @public
 */
interface ContentProtectionIntegration {
    /**
     * Handler which will be called when a HTTP request for a new certificate is about to be sent.
     *
     * @remarks
     * If a valid certificate was provided as part of the {@link KeySystemConfiguration.certificate}, this handler will not be called.
     * The handler must return either a request or a raw certificate. When a (possibly modified) request is returned,
     * the player will send that request instead of the original request. When a raw certificate is returned,
     * the request is skipped entirely and the certificate is used directly. If no handler is provided, the player sends the original request.
     *
     * For example, an integration may want to “wrap” the request body in a different format (e.g. JSON or XML) for
     * certain DRM vendors, or add additional authentication tokens to the request.
     * Alternatively, an integration may want to send the HTTP request using its own network stack,
     * and return the final certificate response to the player.
     *
     * @param request - The {@link CertificateRequest} that is about to be sent.
     */
    onCertificateRequest?(request: CertificateRequest): MaybeAsync<Partial<CertificateRequest> | BufferSource>;
    /**
     * Handler which will be called when a HTTP request for a certificate returns a response.
     *
     * @remarks
     * The handler will be called regardless of the HTTP status code on the response (i.e. also for unsuccessful statuses outside of the 200-299 range).
     * The handler must return the raw certificate, in a manner suitable for further processing by the CDM.
     * If no handler is provided, the player uses the response body as raw certificate, but only if the response’s status indicates success.
     *
     * For example, an integration may want to “unwrap” a wrapped JSON or XML response body, turning it into a raw certificate.
     *
     * @param response - The {@link CertificateResponse} that was returned from the certificate request.
     */
    onCertificateResponse?(response: CertificateResponse): MaybeAsync<BufferSource>;
    /**
     * Handler which will be called when a HTTP request for a new license is about to be sent.
     *
     * @remarks
     * The handler must return either a request or a raw license. When a (possibly modified) request is returned,
     * the player will send that request instead of the original request. When a raw license is returned,
     * the request is skipped entirely and the license is used directly. If no handler is provided, the player sends the original request.
     *
     * For example, an integration may want to “wrap” the request body in a different format (e.g. JSON or XML) for certain DRM vendors,
     * or add additional authentication tokens to the request. Alternatively, an integration may want to send the HTTP request using its own network stack,
     * and return the final license response to the player.
     *
     * @param request - The {@link LicenseRequest} that is about to be sent.
     */
    onLicenseRequest?(request: LicenseRequest): MaybeAsync<Partial<LicenseRequest> | BufferSource>;
    /**
     * Handler which will be called when a HTTP request for a license returns an response.
     *
     * @remarks
     * The handler will be called regardless of the HTTP status code on the response (i.e. also for unsuccessful statuses outside of the 200-299 range).
     * The handler must return the raw license, in a manner suitable for further processing by the CDM.
     * If no handler is provided, the player uses the response body as raw license, but only if the response’s status indicates success.
     *
     * For example, an integration may want to “unwrap” a wrapped JSON or XML response body, turning it into a raw license.
     *
     * @param response - The {@link LicenseResponse} that was returned from the license request.
     */
    onLicenseResponse?(response: LicenseResponse): MaybeAsync<BufferSource>;
    /**
     * A function to extract the Fairplay content ID from the key URI, as given by the URI attribute of the `#EXT-X-KEY` tag in the HLS playlist (m3u8).
     *
     * @remarks
     * In order to start a Fairplay license request, the player must provide the initialization data, the content ID and the certificate to the CDM.
     * The content ID is usually contained in the key URI in some vendor-specific way, for example in the host name (e.g. `skd://123456789`)
     * or in the URL query (e.g. `skd://vendor?123456789`). This function should extract this content ID from the key URI.
     * This method is required only for Fairplay integrations. It is ignored for other key systems.
     *
     * @param skdUrl - The key URI.
     */
    extractFairplayContentId?(skdUrl: string): MaybeAsync<string>;
}

/**
 * Factory pattern to create {@link ContentProtectionIntegration}s.
 *
 * @category Content Protection
 * @public
 */
interface ContentProtectionIntegrationFactory {
    /**
     * Build a new {@link ContentProtectionIntegration} based on the given {@link DRMConfiguration}.
     *
     * @param configuration - The {@link DRMConfiguration} of the currently loading source.
     */
    build(configuration: DRMConfiguration): ContentProtectionIntegration;
}

/**
 * The identifier of the Axinom integration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
type AxinomIntegrationID = 'axinom';
/**
 * Describes the configuration of the Axinom DRM integration.
 *
 * @example
 * ```
 * const drmConfiguration = {
 *     integration : 'axinom',
 *     token: 'yourToken',
 *     fairplay: {
 *          licenseAcquisitionURL: 'yourLicenseAcquisitionURL'
 *          certificateURL: 'yourCertificateAcquisitionURL'
 *     },
 * }
 * ```
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface AxinomDRMConfiguration extends DRMConfiguration {
    /**
     * {@inheritDoc DRMConfiguration.integration}
     */
    integration: AxinomIntegrationID;
    /**
     * The Axinom Authorization Token.
     *
     * @remarks
     * <br/> - This token which will be attached to the license request (custom data) is retrieved.
     */
    token: string;
}

/**
 * The identifier of the Azure Media Services integration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
type AzureIntegrationID = 'azure';
/**
 * Describes the configuration of the Azure Media Services DRM integration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface AzureDRMConfiguration extends DRMConfiguration {
    /**
     * {@inheritDoc DRMConfiguration.integration}
     */
    integration: AzureIntegrationID;
    /**
     * The Azure Media Services Authorization Token.
     *
     * @remarks
     * <br/> -  This token which will be used for the license request.
     */
    token: string;
}

/**
 * The identifier of the Comcast integration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
type ComcastIntegrationID = 'comcast';
/**
 * Describes the configuration of the Comcast DRM integration.
 *
 * @example
 * ```
 * const drmConfiguration = {
 *     integration : 'comcast',
 *     fairplay: {
 *         certificateURL: 'yourComcastCertificateUrl',
 *         licenseAcquisitionURL: 'yourComcastLicenseAcquisitionURL'
 *     }
 * }
 * ```
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface ComcastDRMConfiguration extends DRMConfiguration {
    /**
     * {@inheritDoc DRMConfiguration.integration}
     */
    integration: ComcastIntegrationID;
    /**
     * The Comcast Authorization Token.
     *
     * @remarks
     * <br/> - This token is required and will be attached to the license request's header.
     * <br/> - The token is valid for a limited amount of time.
     */
    token: string;
    /**
     * The identifier of the Comcast account.
     */
    accountId: string;
    /**
     * The PID of the media for which the license is being requested.
     */
    releasePid: string;
}

/**
 * The identifier of the Conax integration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
type ConaxIntegrationID = 'conax';
/**
 * Describes the configuration of the Conax DRM integration.
 *
 * @example
 * example for DASH with Widevine and PlayReady
 * ```
 * const dashDrmConfiguration = {
 *     integration : 'conax',
 *     token : 'yourConaxToken',
 *     deviceId : 'YourConaxDeviceId'
 * }
 * ```
 *
 * @example
 * Example for HLS
 * ```
 * const hlsDrmConfiguration = {
 *     integration : 'conax',
 *     fairplay: {
 *        certificateURL: 'yourConaxCertificateURL',
 *     },
 *     token : 'yourConaxToken',
 *     deviceId : 'YourConaxDeviceId'
 * }
 * ```
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface ConaxDRMConfiguration extends DRMConfiguration {
    /**
     * {@inheritDoc DRMConfiguration.integration}
     */
    integration: ConaxIntegrationID;
    /**
     * An Optional Authorization Token used to configure the Conax Classic model.
     *
     * @remarks
     * <br/> - This token which will be attached to the license request (custom data) is retrieved.
     * <br/> - The token is valid for a limited time and can only be used once.
     * <br/> - Usually this will be a call to the portal that is integrated with Contego.
     */
    token?: string;
    /**
     * An optional identifier of the Conax Device used to configure the Conax Classic model.
     *
     * @remarks
     * <br/> - This id will be added to the OTT Account. This is done every time the video is started to simplify the example, adding the same device twice will not result in any changes.
     * <br/> - The portal will usually handle adding a device to an account.
     */
    deviceId?: string;
}

/**
 * The identifier of the DRM Today integration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
type DRMTodayIntegrationID = 'drmtoday';
/**
 * Describes the configuration of the DRM Today DRM integration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface DRMTodayDRMConfiguration extends DRMConfiguration {
    /**
     * {@inheritDoc DRMConfiguration.integration}
     */
    integration: DRMTodayIntegrationID;
    /**
     * The DRM Today Authorization Token.
     *
     * @remarks
     * <br/> - This attribute is required when you use the User Authentication Callback flow to make the license request.
     */
    token?: string;
    /**
     * The identifier of the user.
     *
     * @remarks
     * <br/> - This attribute is required when you use the User Authentication Callback flow to make the license request.
     */
    userId?: string;
    /**
     * The identifier of the session.
     *
     * @remarks
     * <br/> - This attribute is required when you use the User Authentication Callback flow to make the license request.
     */
    sessionId?: string;
    /**
     * The identifier of the merchant
     *
     * @remarks
     * <br/> - This attribute is required when you use the User Authentication Callback flow to make the license request.
     */
    merchant?: string;
}

/**
 * The identifier of the ExpressPlay integration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
type ExpressPlayIntegrationID = 'expressplay';
/**
 * Describes the configuration of the ExpressPlay DRM integration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface ExpressPlayDRMConfiguration extends DRMConfiguration {
    /**
     * {@inheritDoc DRMConfiguration.integration}
     */
    integration: ExpressPlayIntegrationID;
}

/**
 * The identifier of the Ezdrm integration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
type EzdrmIntegrationID = 'ezdrm';
/**
 * Describes the configuration of the Ezdrm DRM integration.
 *
 * @example
 * ```
 * const drmConfiguration = {
 *      integration : 'ezdrm',
 *      fairplay: {
 *          certificateURL: 'yourEzdrmCertificateUrl',
 *          licenseAcquisitionURL: 'yourEzdrmLicenseAcquisitionURL'
 *      }
 * }
 * ```
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface EzdrmDRMConfiguration extends DRMConfiguration {
    /**
     * {@inheritDoc DRMConfiguration.integration}
     */
    integration: EzdrmIntegrationID;
}

/**
 * The identifier of the Irdeto integration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
type IrdetoIntegrationID = 'irdeto';
/**
 * Describes the configuration of the Irdeto DRM integration.
 *
 * @example
 * ```
 * const drmConfiguration = {
 *     integration : 'irdeto',
 *     fairplay: {
 *         certificateURL: 'yourIrdetoCertificateUrl',
 *         licenseAcquisitionURL: 'yourIrdetoLicenseAcquisitionURL'
 *     }
 *     crmId: 'yourIrdetoCrmId',
 *     accountId: 'yourIrdetoCrmId',
 *     contentId: 'yourIrdetokeyId',
 *     accountId: 'yourIrdetoCrmId',
 *     applicationId: 'yourIrdeotApplicationId',
 * }
 * ```
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface IrdetoDRMConfiguration extends DRMConfiguration {
    /**
     * {@inheritDoc DRMConfiguration.integration}
     */
    integration: IrdetoIntegrationID;
    /**
     * The identifier of the CRM.
     *
     * @remarks
     * <br/> - This ID will be added for license URL requests.
     */
    crmId: string;
    /**
     * The identifier of the Irdeto account.
     */
    accountId: string;
    /**
     * The identifier of the content.
     */
    contentId: string;
    /**
     * The identifier of the key.
     *
     * @remarks
     * <br/> - It must be present for FairPlay.
     */
    keyId?: string;
    /**
     * The identifier of the application.
     *
     * @remarks
     * <br/> - It must be present for FairPlay.
     */
    applicationId?: string;
    /**
     * The identifier of the session.
     *
     * @remarks
     * <br/> - It must be present for registered user flow parameters.
     * <br/> - This is not mandatory in case of free open streams.
     */
    sessionId?: string;
    /**
     * The ticket for registered user flows.
     *
     * @remarks
     * <br/> - It must be present for registered user flow parameters.
     * <br/> - This is not mandatory in case of free open streams.
     */
    ticket?: string;
}

/**
 * The identifier of the KeyOS integration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
type KeyOSIntegrationID = 'keyos';
/**
 * Describes the configuration of the KeyOS DRM integration
 *
 * @example
 * Basic example
 * ```
 * const drmConfiguration = {
 *     integration : 'keyos',
 *     customdata : 'PEtleU9T...blhNTD4='
 * }
 * ```
 *
 * @example
 * Advanced example
 * ```
 * const drmConfiguration = {
 *     integration : 'keyos',
 *     customdata : 'PEtleU9T...blhNTD4=',
 *     playready : {
 *         licenseAcquisitionURL : 'customplayready.url',
 *         customdata : 'CUSTOM...='
 *     }
 * }
 * ```
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface KeyOSDRMConfiguration extends DRMConfiguration {
    /**
     * {@inheritDoc DRMConfiguration.integration}
     */
    integration: KeyOSIntegrationID;
    /**
     * The custom data for the licence acquisition request.
     *
     * @remarks
     * <br/> - This attribute is required if it is not specified in the separate {@link KeyOSKeySystemConfiguration} for Widevine and PlayReady.
     * <br/> - The value of this attribute should be the value of the customData header that you want to send with license requests to the KeyOS license server.
     * <br/> - In most cases this will be the base64 encoded KeyOS authentication XML.
     */
    customdata?: string;
    /**
     * The configuration of the PlayReady key system.
     */
    playready?: KeyOSKeySystemConfiguration;
    /**
     * The configuration of the Widevine key system.
     */
    widevine?: KeyOSKeySystemConfiguration;
    /**
     * The configuration of the FairPlay key system.
     */
    fairplay?: KeyOSFairplayKeySystemConfiguration;
}
/**
 * Describes the KeyOS key system configuration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface KeyOSKeySystemConfiguration extends KeySystemConfiguration {
    /**
     * The custom data for the licence acquisition request.
     */
    customdata?: string;
}
/**
 * Describes the KeyOS FairPlay key system configuration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface KeyOSFairplayKeySystemConfiguration extends FairPlayKeySystemConfiguration {
    /**
     * The custom data for the licence acquisition request.
     */
    customdata?: string;
}

/**
 * The identifier of the Titanium integration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
type TitaniumIntegrationID = 'titanium';
/**
 * Describes the configuration of the Titanium DRM integration.
 *
 * @example
 * ```
 * const drmConfiguration = {
 *     integration : 'keyos',
 *     playready: {
 *     licenseAcquisitionURL: 'yourTitaniumPlayReadyLicenseAcquisitionURL'
 *     },
 *     widevine: {
 *     licenseAcquisitionURL: 'yourTitaniumWidevineLicenseAcquisitionURL'
 *     },
 *     accountName: 'yourTitaniumAccountName',
 *     customerName: 'yourTitaniumCustomerName',
 *     friendlyName: 'yourTitaniumFriendlyName',
 *     portalId: 'yourTitaniumPortalId'
 * }
 * ```
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface TitaniumDRMConfiguration extends DRMConfiguration {
    /**
     * {@inheritDoc DRMConfiguration.integration}
     */
    integration: TitaniumIntegrationID;
    /**
     * The version of Titanium, represented by a value from the following list:
     * <br/> - `'2'`
     * <br/> - `'3'`
     *
     * @remarks
     * Only version 2 and 3 are supported.
     *
     * @defaultValue `'2'`.
     */
    version?: '2' | '3';
    /**
     * The account name.
     *
     * @remarks
     * <br/> - Required when doing device-based authentication.
     */
    accountName?: string;
    /**
     * The customer name.
     *
     * @remarks
     * <br/> - Required when doing device-based authentication.
     */
    customerName?: string;
    /**
     * The friendly name of the customer.
     *
     * @remarks
     * <br/> - Required when doing device-based authentication.
     */
    friendlyName?: string;
    /**
     * The identifier of the portal.
     *
     * @remarks
     * <br/> - Required when doing device-based authentication.
     */
    portalId?: string;
    /**
     * The authentication token.
     *
     * @remarks
     * <br/> - This is a JSON web token provided by the Titanium Secure Token Server.
     * <br/> - Required when doing token-based authentication.
     */
    authToken?: string;
}
/**
 * Describes the configuration of the Titanium DRM integration with device-based authentication.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface DeviceBasedTitaniumDRMConfiguration extends TitaniumDRMConfiguration {
    /**
     * The account name.
     */
    accountName: string;
    /**
     * The customer name.
     */
    customerName: string;
    /**
     * The friendly name of this customer.
     */
    friendlyName: string;
    /**
     * The identifier of the portal.
     */
    portalId: string;
    /**
     * The authentication token.
     *
     * @remarks
     * <br/> - This is a JSON web token provided by the Titanium Secure Token Server.
     */
    authToken?: undefined;
}
/**
 * Describes the configuration of the Titanium DRM integration with token-based authentication.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface TokenBasedTitaniumDRMConfiguration extends TitaniumDRMConfiguration {
    /**
     * The account name.
     */
    accountName?: undefined;
    /**
     * The customer name.
     */
    customerName?: undefined;
    /**
     * The friendly name of this customer.
     */
    friendlyName?: undefined;
    /**
     * The identifier of the portal.
     */
    portalId?: undefined;
    /**
     * The authentication token.
     *
     * @remarks
     * <br/> - This is a JSON web token provided by the Titanium Secure Token Server.
     */
    authToken: string;
}

/**
 * The identifier of the Uplynk integration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
type UplynkIntegrationID = 'uplynk';
/**
 * Describes the configuration of the Uplynk DRM integration.
 *
 * @example
 * ```
 * const drmConfiguration = {
 *     integration : 'uplynk',
 *     fairplay: {
 *          certificateURL: 'yourCertificateAcquisitionURL'
 *     },
 * }
 * ```
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface UplynkDRMConfiguration extends DRMConfiguration {
    /**
     * {@inheritDoc DRMConfiguration.integration}
     */
    integration: UplynkIntegrationID;
}

/**
 * The identifier of the Verimatrix integration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
type VerimatrixIntegrationID = 'verimatrix';
/**
 * Describes the configuration of the Veramatrix DRM integration.
 *
 * @example
 * ```
 * const drmConfiguration = {
 *     integration : 'verimatrix',
 *     fairplay: {
 *          licenseAcquisitionURL: 'yourLicenseAcquisitionURL',
 *          certificateURL: 'yourCertificateURL'
 *     }
 * }
 * ```
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface VerimatrixDRMConfiguration extends DRMConfiguration {
    /**
     * {@inheritDoc DRMConfiguration.integration}
     */
    integration: VerimatrixIntegrationID;
}

/**
 * The identifier of the Vimond integration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
type VimondIntegrationID = 'vimond';
/**
 * Describes the configuration of the Vimond DRM integration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface VimondDRMConfiguration extends DRMConfiguration {
    /**
     * {@inheritDoc DRMConfiguration.integration}
     */
    integration: VimondIntegrationID;
}

/**
 * The identifier of the Vudrm integration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
type VudrmIntegrationID = 'vudrm';
/**
 * Describes the configuration of the Vudrm DRM integration.
 *
 * @example
 * ```
 * var drmConfiguration = {
 *     integration : 'vudrm',
 *     playready: {
 *          licenseAcquisitionURL: 'yourVudrmPlayReadyLicenseAcquisitionURL'
 *     },
 *     widevine: {
 *         licenseAcquisitionURL: 'yourVudrmWidevineLicenseAcquisitionURL'
 *     },
 *     token: 'PEtleU9T...blhNTD4='
 * }
 * ```
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface VudrmDRMConfiguration extends DRMConfiguration {
    /**
     * {@inheritDoc DRMConfiguration.integration}
     */
    integration: VudrmIntegrationID;
    /**
     * The authentication token.
     */
    token: string;
    /**
     * The key id.
     *
     * @remarks
     * <br/> - Only mandatory when chromecasting.
     */
    keyId?: string;
}

/**
 * The identifier of the Xstream integration.
 *
 * @category Source
 * @category Content Protection
 * @public
 */
type XstreamIntegrationID = 'xstream';
/**
 * Describes the configuration of the Xstream DRM integration.
 *
 * @example
 * ```
 * const drmConfiguration = {
 *     integration : 'xstream',
 *     sessionId: 'yourSessionId',
 *     streamId: 'yourStreamId'
 *     fairplay: {
 *          licenseAcquisitionURL: 'yourLicenseAcquisitionURL'
 *          certificateURL: 'yourCertificateAcquisitionURL'
 *     },
 * }
 * ```
 *
 * @category Source
 * @category Content Protection
 * @public
 */
interface XstreamDRMConfiguration extends DRMConfiguration {
    /**
     * {@inheritDoc DRMConfiguration.integration}
     */
    integration: XstreamIntegrationID;
    /**
     * The identifier of the session.
     */
    sessionId: string;
    /**
     * The identifier of the stream.
     */
    streamId: string;
    /**
     * The ticket acquisition URL.
     */
    ticketAcquisitionURL: string;
}

/**
 * Represents a source for the MediaTailor integration.
 *
 * @category Source
 * @category Analytics
 * @public
 */
interface MediaTailorSource extends TypedSource {
    /**
     * The integration ID of the source.
     */
    integration: 'mediatailor';
    /**
     * Optional ad parameters to perform client-side ad reporting.
     * For more information visit https://docs.aws.amazon.com/mediatailor/latest/ug/ad-reporting-client-side.html .
     */
    adParams?: Record<string, string>;
}

/**
 * Represents a cue of a HLS date range metadata text track.
 *
 * @category Media and Text Tracks
 * @public
 */
interface DateRangeCue extends TextTrackCue {
    /**
     * The class of the date range cue.
     *
     * @remarks
     * <br/> - The class is a client-defined string specifying a set of attributes with associated value semantics.
     */
    class: string | undefined;
    /**
     * The playback position at which the date range cue becomes active, as a Date.
     */
    startDate: Date;
    /**
     * The playback position at which the date range cue becomes inactive, as a Date.
     */
    endDate: Date | undefined;
    /**
     * The duration of the date range cue, in seconds.
     */
    duration: number | undefined;
    /**
     * The planned duration of the date range cue, in seconds.
     *
     * @remarks
     * <br/> - This is used when the exact duration is not known yet.
     */
    plannedDuration: number | undefined;
    /**
     * Whether end-on-next is enabled for the date range cue.
     *
     * @remarks
     * <br/> - End-on-next results in the {@link DateRangeCue.endDate} of the date range cue becoming equal to the {@link DateRangeCue.startDate} of the next date range cue with the same {@link DateRangeCue."class"}, once it is known.
     */
    endOnNext: boolean;
    /**
     * The SCTE 'cmd' splice_info_section of the date range cue.
     */
    scte35Cmd: ArrayBuffer | undefined;
    /**
     * The SCTE 'out' splice_info_section of the date range cue.
     */
    scte35Out: ArrayBuffer | undefined;
    /**
     * The SCTE 'in' splice_info_section of the date range cue.
     */
    scte35In: ArrayBuffer | undefined;
    /**
     * The custom attributes of the date range cue.
     *
     * @remarks
     * <br/> - The attribute name in the record does not include the 'X-' prefix present in the manifest.
     */
    customAttributes: Record<string, string | number | ArrayBuffer>;
}

/**
 * Represents a cue of an emsg metadata text track.
 *
 * @category Media and Text Tracks
 * @public
 */
interface EmsgCue extends TextTrackCue {
    /**
     * The schemeIDURI of the cue.
     */
    schemeIDURI: string;
    /**
     * The SCTE 35 PID (Program Identifier) of the cue.
     */
    value: string;
    /**
     * The emsg identifier of the cue.
     *
     * @remarks
     * <br/> - The identifier is unique within the scope of the period.
     */
    emsgID: number;
}

/**
 * Represents a cue of an Event Stream metadata text track.
 *
 * @category Media and Text Tracks
 * @public
 */
interface EventStreamCue extends TextTrackCue {
    /**
     * The attributes of the cue.
     *
     * @remarks
     * <br/> - The attributes are parsed from the XML tags in the manifest, where the tag names are the keys and the values are the contents of the respective tags.
     */
    attributes: {
        [attributeName: string]: string;
    };
    /**
     * The identifier of the event.
     */
    eventID: string;
}

/**
 * Represents a generic ID3 frame.
 *
 * @category Media and Text Tracks
 * @public
 */
interface ID3BaseFrame {
    /**
     * The identifier of the frame.
     *
     * @remarks
     * <br/> - See {@link https://id3.org/id3v2.4.0-frames | id3v2.4.0-frames - ID3.org}.
     */
    id: string;
}
/**
 * Represents an unknown ID3 frame.
 *
 * @category Media and Text Tracks
 * @public
 */
interface ID3Unknown extends ID3BaseFrame {
    /**
     * The raw data of the frame.
     */
    data: ArrayBuffer | undefined;
}
/**
 * Represents an attached picture ID3 frame.
 *
 * @category Media and Text Tracks
 * @public
 */
interface ID3AttachedPicture extends ID3BaseFrame {
    /**
     * The identifier of the frame.
     */
    id: 'APIC' | 'PIC';
    /**
     * The mime type of the attached picture.
     */
    mimeType: string;
    /**
     * The type of the attached picture.
     *
     * @remarks
     * <br/> - See section 4.14 of {@link https://id3.org/id3v2.4.0-frames | id3v2.4.0-frames - ID3.org}.
     */
    pictureType: number;
    /**
     * The description of the attached picture.
     */
    description: string;
    /**
     * The data of the attached picture.
     *
     * @remarks
     * <br/> - If {@link ID3AttachedPicture.mimeType} is `'-->'` the data is an URL for a picture resource as a string. Otherwise the data is an ArrayBuffer.
     */
    data: string | ArrayBuffer;
}
/**
 * Represents a comments ID3 frame.
 *
 * @category Media and Text Tracks
 * @public
 */
interface ID3Comments extends ID3BaseFrame {
    /**
     * The identifier of the frame.
     */
    id: 'COMM' | 'COM';
    /**
     * The language of the comments.
     */
    language: string;
    /**
     * The description of the comments.
     */
    description: string;
    /**
     * The content of the comments.
     */
    text: string;
}
/**
 * Represents a commercial ID3 frame.
 *
 * @category Media and Text Tracks
 * @public
 */
interface ID3CommercialFrame extends ID3BaseFrame {
    /**
     * The identifier of the frame.
     */
    id: 'COMR';
    /**
     * The price of the product.
     */
    price: string;
    /**
     * The expiration date of the offer.
     *
     * @remarks
     * <br/> - The format of this property is `'YYYYMMDD'`
     */
    validUntil: string;
    /**
     * The contact URL for the product.
     */
    contactURL: string;
    /**
     * The delivery method of the product, represented by a value from the following list:
     * <br/> - `0`: Other
     * <br/> - `1`: Standard CD album with other songs
     * <br/> - `2`: Compressed audio on CD
     * <br/> - `3`: File over the Internet
     * <br/> - `4`: Stream over the Internet
     * <br/> - `5`: As note sheets
     * <br/> - `6`: As note sheets in a book with other sheets
     * <br/> - `7`: Music on other media
     * <br/> - `8`: Non-musical merchandise
     */
    receivedAs: number;
    /**
     * The name of the seller of the product.
     */
    nameOfSeller: string;
    /**
     * The description of the product.
     */
    description: string;
    /**
     * The mime type of the company logo.
     *
     * @remarks
     * <br/> - This mime type is applicable on the data in {@link ID3CommercialFrame.sellerLogo}.
     * <br/> - Only `'image/png'` and `'image/jpeg'` are allowed.
     */
    pictureMimeType?: string;
    /**
     * The data for the company logo.
     */
    sellerLogo?: ArrayBuffer;
}
/**
 * Represents a general encapsulated object ID3 frame.
 *
 * @category Media and Text Tracks
 * @public
 */
interface ID3GenericEncapsulatedObject extends ID3BaseFrame {
    /**
     * The identifier of the frame.
     */
    id: 'GEOB' | 'GEO';
    /**
     * The mime type of the encapsulated object.
     */
    mimeType: string;
    /**
     * The file name of the encapsulated object.
     */
    fileName: string;
    /**
     * The description of the encapsulated object.
     */
    description: string;
    /**
     * The data of the encapsulated object.
     */
    data: ArrayBuffer;
}
/**
 * Represents an involved people list ID3 frame.
 *
 * @category Media and Text Tracks
 * @public
 */
interface ID3InvolvedPeopleList extends ID3BaseFrame {
    /**
     * The identifier of the frame.
     */
    id: 'IPLS' | 'IPL';
    /**
     * List of the involved people.
     */
    entries: Array<{
        involvement: string;
        involvee: string;
    }>;
}
/**
 * Represents a private ID3 frame.
 *
 * @category Media and Text Tracks
 * @public
 */
interface ID3PrivateFrame extends ID3BaseFrame {
    /**
     * The identifier of the frame.
     */
    id: 'PRIV';
    /**
     * The identifier of the owner.
     */
    ownerIdentifier: string;
    /**
     * The data of the frame.
     */
    data: ArrayBuffer;
}
/**
 * Represents an position synchronisation ID3 frame.
 *
 * @category Media and Text Tracks
 * @public
 */
interface ID3PositionSynchronisationFrame extends ID3BaseFrame {
    /**
     * The identifier of the frame.
     */
    id: 'POSS';
    /**
     * The format of the timestamp, represented by a value from the following list:
     * <br/> - `1`: Absolute time, 32 bit sized, in MPEG frames.
     * <br/> - `2`: Absolute time, 32 bit sized, in milliseconds.
     */
    format: number;
    /**
     * The timestamp of the frame.
     */
    position: number;
}
/**
 * Represents a synchronised lyrics/text ID3 frame.
 *
 * @category Media and Text Tracks
 * @public
 */
interface ID3SynchronizedLyricsText extends ID3BaseFrame {
    /**
     * The identifier of the frame.
     */
    id: 'SYLT' | 'SLT';
    /**
     * The language of the lyrics/text.
     */
    language: string;
    /**
     * The format of the timestamp, represented by a value from the following list:
     * <br/> - `1`: Absolute time, 32 bit sized, in MPEG frames.
     * <br/> - `2`: Absolute time, 32 bit sized, in milliseconds.
     */
    format: number;
    /**
     * The content type of the frame, represented by a value from the following list:
     * <br/> - `0`: The frame contains other data.
     * <br/> - `1`: The frame contains lyrics.
     * <br/> - `2`: The frame contains text transcription.
     * <br/> - `3`: The frame contains a movement/part name (e.g. "Adagio").
     * <br/> - `4`: The frame contains an events (e.g. "Don Quijote enters the stage").
     * <br/> - `5`: The frame contains a chord (e.g. "Bb F Fsus").
     * <br/> - `6`: The frame contains trivia/'pop up' information.
     * <br/> - `7`: The frame contains URLs to webpages.
     * <br/> - `8`: The frame contains URLs to images.
     */
    contentType: number;
    /**
     * The description of the lyrics/text.
     */
    description: string;
    /**
     * List of lyrics/text.
     */
    entries: Array<{
        text: string;
        timestamp: number;
    }>;
}
/**
 * Represents a text information ID3 frame.
 *
 * @category Media and Text Tracks
 * @public
 */
interface ID3Text extends ID3BaseFrame {
    /**
     * The identifier of the frame.
     *
     * @remarks
     * <br/> - Applicable values are "T000" to "TZZZ" and "T00" to "TZZ", excluding "TXX" and "TXXX".
     */
    id: string;
    /**
     * The content of the text.
     */
    text: string;
}
/**
 * Represents a used defined text ID3 frame.
 *
 * @category Media and Text Tracks
 * @public
 */
interface ID3UserDefinedText extends ID3BaseFrame {
    /**
     * The identifier of the frame.
     */
    id: 'TXXX' | 'TXX';
    /**
     * The description of the text.
     */
    description: string;
    /**
     * The content of the text.
     */
    text: string;
}
/**
 * Represents a unique file identifier ID3 frame.
 *
 * @category Media and Text Tracks
 * @public
 */
interface ID3UniqueFileIdentifier extends ID3BaseFrame {
    /**
     * The identifier of the frame.
     */
    id: 'UFID' | 'UFI';
    /**
     * The identifier of the owner of the file.
     */
    ownerIdentifier: string;
    /**
     * The identifier of the file.
     */
    identifier: ArrayBuffer;
}
/**
 * Represents a terms of use ID3 frame.
 *
 * @category Media and Text Tracks
 * @public
 */
interface ID3TermsOfUse extends ID3BaseFrame {
    /**
     * The identifier of the frame.
     */
    id: 'USER';
    /**
     * The language of the terms of use.
     */
    language: string;
    /**
     * The content of the terms of use.
     */
    text: string;
}
/**
 * Represents a unsynchronised lyrics/text transcription ID3 frame.
 *
 * @category Media and Text Tracks
 * @public
 */
interface ID3UnsynchronisedLyricsTextTranscription extends ID3BaseFrame {
    /**
     * The identifier of the frame.
     */
    id: 'USLT' | 'ULT';
    /**
     * The language of the lyrics/text.
     */
    language: string;
    /**
     * The description of the lyrics/text.
     */
    description: string;
    /**
     * The content of the lyrics/text.
     */
    text: string;
}
/**
 * Represents a URL link ID3 frame.
 *
 * @category Media and Text Tracks
 * @public
 */
interface ID3UrlLink extends ID3BaseFrame {
    /**
     * The identifier of the frame.
     *
     * @remarks
     * <br/> - Applicable values are "W000" to "WZZZ" and "W00" to "WZZ", excluding "WXX" and "WXXX".
     */
    id: string;
    /**
     * The URL.
     */
    url: string;
}
/**
 * Represents a user defined URL link ID3 frame.
 *
 * @category Media and Text Tracks
 * @public
 */
interface ID3UserDefinedUrlLink extends ID3BaseFrame {
    /**
     * The identifier of the frame.
     */
    id: 'WXXX' | 'WXX';
    /**
     * The description of the URL.
     */
    description: string;
    /**
     * The URL.
     */
    url: string;
}
/**
 * The identifier of a Yospace's ID3 frame, represented by a value from the following list:
 * <br/> - `'YMID'`: This frame contains the media ID of the ad.
 * <br/> - `'YTYP'`: This frame contains the type of metadata.
 * <br/> - `'YSEQ'`: This frame contains the sequence number of the segment.
 * <br/> - `'YDUR'`: This frame contains the offset/duration from the beginning of the segment that contains the metadata.
 * <br/> - `'YCSP'`: This frame contains the customer-specific identifier.
 *
 * @remarks
 * <br/> - The format of type of metadata is 'S', 'M' or 'E', respectively for the start, middle and end.
 * <br/> - The format of sequence number of the segment is 'N:T' where 'N' is the segment number and 'T' is the total count of segments in this ad.
 *
 * @example
 * This is the first segment in an ad which consists out of five segments.
 * ```
 * const yseqFrame = {
 *     id: 'yseq',
 *     text: '1:5'
 * };
 * ```
 *
 * @category Media and Text Tracks
 * @category SSAI
 * @public
 */
type YospaceId = 'YMID' | 'YTYP' | 'YSEQ' | 'YDUR' | 'YCSP';
/**
 * Represents a Yospace ID3 frame.
 *
 * @category Media and Text Tracks
 * @category SSAI
 * @public
 */
interface ID3Yospace extends ID3BaseFrame {
    /**
     * The identifier of the frame.
     */
    id: YospaceId;
    /**
     * The content of the frame.
     */
    text: string;
}
/**
 * The possible types of an ID3 frame.
 *
 * @category Media and Text Tracks
 * @public
 */
type ID3Frame = ID3Unknown | ID3AttachedPicture | ID3GenericEncapsulatedObject | ID3Comments | ID3CommercialFrame | ID3InvolvedPeopleList | ID3PositionSynchronisationFrame | ID3PrivateFrame | ID3SynchronizedLyricsText | ID3Text | ID3UserDefinedText | ID3UniqueFileIdentifier | ID3TermsOfUse | ID3UnsynchronisedLyricsTextTranscription | ID3UrlLink | ID3UserDefinedUrlLink | ID3Yospace;

/**
 * Represents a cue of an ID3 metadata text track.
 *
 * @category Media and Text Tracks
 * @public
 */
interface ID3Cue extends TextTrackCue {
    /**
     * The content of the cue.
     */
    readonly content: ID3Frame;
}

/**
 * Record of style properties.
 * Each entry contains the style property name with associated value.
 *
 * @category Media and Text Tracks
 * @public
 */
type StylePropertyRecord = Record<string, string>;
/**
 * Represents the extent of a TTML element,
 * as specified by its `tts:extent` attribute.
 *
 * @remarks
 * - Available since v8.1.1.
 *
 * @see https://www.w3.org/TR/ttml2/#style-attribute-extent
 * @category Media and Text Tracks
 * @public
 */
interface TTMLExtent {
    /**
     * The width, in pixels.
     */
    width: number;
    /**
     * The height, in pixels.
     */
    height: number;
}
/**
 * Represents a cue of a TTML text track.
 *
 * @category Media and Text Tracks
 * @public
 */
interface TTMLCue extends TextTrackCue {
    /**
     * The content of the cue.
     *
     * @remarks
     * <br/> - The content is an intermediate TTML document’s body element. This is a view of a TTML document where all nodes in the document are active during the cue’s startTime and endTime. As a result, all begin, dur and end properties have been removed. TTML Styles, Regions and Metadata are stored in cue.styles, cue.regions, cue.metadata respectively. Combining those properties with the given content should suffice to render a TTML cue.
     */
    content: any;
    /**
     * A record of styles for the cue.
     * Each entry contains all style properties for a style id.
     */
    styles: Record<string, StylePropertyRecord>;
    /**
     * A record of style for the cue.
     * Each entry contains all style properties for a region id.
     */
    regions: Record<string, StylePropertyRecord>;
    /**
     * The extent of the TTML root container region,
     * as specified by the `tts:extent` attribute of the `<tt>` element.
     *
     * @remarks
     * - Available since v8.1.1.
     *
     * @see https://www.w3.org/TR/ttml2/#style-attribute-extent
     */
    extent: TTMLExtent | undefined;
    /**
     * The `<metadata>` Element of the corresponding TTML document.
     */
    metadata: any;
}

/**
 * Represents a metadata cue of a Millicast source.
 *
 * @remarks
 * In order to receive Millicast metadata, you must set `metadata` to `true` in {@link MillicastSource.connectOptions}.
 *
 * @see https://docs.dolby.io/streaming-apis/docs/frame-metadata
 *
 * @category Media and Text Tracks
 * @category Millicast
 * @public
 */
interface MillicastMetadataCue extends TextTrackCue {
    /**
     * Unused.
     *
     * @remarks
     * <br/> - Use {@link timecode} and/or {@link unregistered} to retrieve the contents of the Millicast metadata.
     */
    readonly content: undefined;
    /**
     * The media identifier of the track that contains the metadata.
     */
    readonly mid: string;
    /**
     * The UUID of the metadata.
     */
    readonly uuid: string | undefined;
    /**
     * Timecode of when the metadata was generated.
     */
    readonly timecode: Date | undefined;
    /**
     * Unregistered data.
     *
     * @remarks
     * <br/> - If the metadata content is valid JSON, then this is the parsed JSON object.
     *         Otherwise, it's the raw data as a {@link Uint8Array}.
     */
    readonly unregistered: object | Uint8Array | undefined;
}

/**
 * Describes a THEOads ad break request.
 *
 * @remarks
 * <br/> - For THEOads, one configured ad break request enables server guided ad playback for the entire stream.
 * <br/> - The player must have {@link AdsConfiguration.theoads} enabled in its {@link PlayerConfiguration}.
 *
 * @category Ads
 */
interface TheoAdDescription extends AdDescription {
    /**
     * The integration of the ad break.
     */
    integration: 'theoads';
    /**
     * Default GAM network code to use for ad requests.
     *
     * @remarks
     * <br/> - This will be overridden by network codes parsed from THEOads ad markers.
     * <br/> - If no network code is configured, and it cannot be parsed from the THEOads ad marker, ads will not be loaded.
     */
    networkCode?: string;
    /**
     * Default GAM custom asset key to use for ad requests.
     *
     * @remarks
     * <br/> - This will be overridden by custom asset keys parsed from THEOads ad markers.
     * <br/> - If no custom asset key is configured, and it cannot be parsed from the THEOads ad marker, ads will not be loaded.
     */
    customAssetKey?: string;
    /**
     * Default backdrop image URI to be used as a background for ads in double box layout.
     *
     * @remarks
     * <br/> - This will be overridden by backdrop image URIs parsed from THEOads ad markers or returned in the ad response.
     * <br/> - If no URI is configured, and no backdrop companion is parsed from the marker or returned in the ad response, a black screen will be shown as background.
     */
    backdropDoubleBox?: string;
    /**
     * Default backdrop image URI to be used as a background for ads in L-shape layout.
     *
     * @remarks
     * <br/> - This will be overridden by backdrop image URIs parsed from THEOads ad markers or returned in the ad response.
     * <br/> - If no URI is configured, and no backdrop companion is parsed from the marker or returned in the ad response, a black screen will be shown as background.
     */
    backdropLShape?: string;
    /**
     * Override the layout of all THEOads ad breaks, if set.
     */
    overrideLayout?: TheoAdsLayoutOverride;
    /**
     * Overrides the ad source of all THEOads ad breaks, if set.
     *
     * @remarks
     * <br/> - Only VOD streams are currently supported
     *
     * @internal
     */
    overrideAdSrc?: string;
    /**
     * The ad tag parameters added to the GAM stream request.
     *
     * @remarks
     * <br/> - Each entry contains the parameter name with associated value.
     * <br/> - Values added must be strings.
     */
    adTagParameters?: Record<string, string>;
    /**
     * The streamActivityMonitorId added to the GAM Pod stream request.
     */
    streamActivityMonitorId?: string;
    /**
     * Whether to use the Id3 based operating mode.
     *
     * @defaultValue `false`
     *
     * @remarks
     * <br/> - Only applicable for specific use-cases.
     * <br/> - Contact THEO Technologies for more information.
     */
    useId3?: boolean;
    /**
     * The URI from where to retrieve the PodID's as returned from the EABN service from Google.
     *
     */
    retrievePodIdURI?: string;
    /**
     * The endpoint from where to retrieve the server-sent events.
     *
     * @remarks
     * <br/> - If configured through THEOlive the configured value is used automatically unless it is defined in the ad source here.
     */
    sseEndpoint?: string;
}
/**
 * Describes how and when the layout of a THEOads ad break should be overridden:
 *  - `'single'`: Override to play all ad breaks using the "single" layout mode.
 *  - `'l-shape'`: Override to play all ad breaks using the "l-shape" layout mode.
 *  - `'double'`: Override to play all ad breaks using the "double" layout mode.
 *  - `'single-if-mobile'`: When on a mobile device, override to play all ad breaks using the "single" layout mode.
 *
 * @category Ads
 */
type TheoAdsLayoutOverride = TheoAdsLayout | 'single-if-mobile';

/**
 * @category HESP
 * @public
 */
type HespMediaType = 'audio' | 'video' | 'metadata';

/**
 * The identifier of the Agama integration.
 *
 * @category Analytics
 * @public
 */
type AgamaAnalyticsIntegrationID = 'agama';
/**
 * The type of log level for the Agama integration, represented by a value from the following list:
 * <br/> - `'info'`
 * <br/> - `'debug'`
 * <br/> - `'warning'`
 * <br/> - `'error'`
 * <br/> - `'fatal'`
 *
 * @category Analytics
 * @public
 */
type AgamaLogLevelType = 'info' | 'debug' | 'warning' | 'error' | 'fatal';
/**
 * Describes the configuration of Agama.
 *
 * @category Analytics
 * @public
 */
interface AgamaConfiguration extends AnalyticsDescription {
    /**
     * {@inheritDoc AnalyticsDescription.integration}
     */
    integration: AgamaAnalyticsIntegrationID;
}
/**
 * Describes the configuration of Agama.
 *
 * @remarks
 * <br/> - Available since v2.45.6.
 *
 * @category Analytics
 * @public
 */
interface AgamaPlayerConfiguration extends AgamaConfiguration {
    /**
     * The initial base configuration.
     *
     * @remarks
     * <br/> - For more information, consult the Agama documentation.
     *
     * @example
     * <br/> - 'emp_service=http://127.0.0.1:8191/report;report_interval=60;id_report_interval=240;operator_id=fooSoo'
     */
    config: string;
    /**
     * The type of log level.
     *
     * @defaultValue `'fatal'`
     */
    logLevel?: AgamaLogLevelType;
    /**
     * The name of your application.
     *
     * @remarks
     * <br/> - Available since v2.61.0.
     * <br/> - Will not be reported to Agama if not present
     */
    application?: string;
    /**
     * The version of your application
     *
     * @remarks
     * <br/> - Available since v2.61.0.
     * <br/> - Will not be reported to Agama if not present
     */
    applicationVersion?: string;
    /**
     * The identifier of the user account.
     *
     * @remarks
     * <br/> - Available since v2.61.0.
     * <br/> - Will not be reported to Agama if not present
     */
    userAccountID?: string;
    /**
     * Network connection the device is currently using.
     *
     * @remarks
     * <br/> - These pre-defined Device type values must be used if the Device matches one of following: `'ethernet'`, `'wlan'`, `'mobile/3G'`, `'mobile/4G'`, `'mobile/5G'`.
     * <br/> - If no value is passed, the player will determine this based on the available browser APIs.
     * <br/> - Available since v6.5.0.
     */
    connectionType?: string;
    /**
     * The identifier of the device.
     *
     * @remarks
     * <br/> - Available since v4.1.0.
     * <br/> - Make sure to pass a valid string as indicated by the Agama SDK documentation. No specific value format validation is performed on this
     * as that is deemed the responsibility of the one setting this value externally via this configuration property.
     * <br/> - Will be generated internally for each session if not present
     */
    deviceID?: string;
    /**
     * The manufacturer of the device
     *
     * @remarks
     * <br/> - Available since v5.3.0
     */
    deviceManufacturer?: string;
    /**
     * The model name of the Device, including the "submodel".
     *
     * @remarks
     * <br/> - Use the spelling set by the manufacturer.
     * <br/> - Available since v5.3.0
     */
    deviceModel?: string;
    /**
     * The name of the OS that the device is running.
     *
     * @remarks
     * <br/> - Use in combination with `deviceOsVersion`.
     * <br/> - Include platform's name if the software can be used on various devices (e.g. case of Android platform).
     * <br/> - Available since v5.9.0
     */
    deviceOs?: string;
    /**
     * The version of the OS the device is running.
     *
     * @remarks
     * <br/> - Version should be reported in major.minor.patch notation (i.e. without build information).
     * <br/> - Available since v5.9.0
     */
    deviceOsVersion?: string;
    /**
     * A string describing the physical Device type
     *
     * @remarks
     * <br/> - These pre-defined Device type values must be used if the Device matches one of following: `'tablet'`, `'mobile'`, `'pc'`, `'media-streamer'` (used for Chromecast, Apple TV), `'game-console'`, `'tv'`.
     * <br/> - If no value is passed, the player will determine this based on the user agent.
     * <br/> - Available since v6.4.0
     */
    deviceType?: string;
}
/**
 * The stream type, represented by a value from the following list:
 * <br/> - `'live'`
 * <br/> - `'vod'`
 *
 * @category Analytics
 * @public
 */
type AgamaStreamType = 'live' | 'vod';
/**
 * The service name, represented by a value from the following list:
 * <br/> - `'live'`
 * <br/> - `'svod'`
 * <br/> - `'nvod'`
 * <br/> - `'tvod'`
 * <br/> - `'avod'`
 * <br/> - `'catchuptv'`
 *
 * @category Analytics
 * @public
 */
type AgamaServiceName = 'live' | 'svod' | 'nvod' | 'tvod' | 'avod' | 'catchuptv';
/**
 * Describes the configuration of Agama for this source.
 *
 * @remarks
 * <br/> - Available since v2.45.6.
 * <br/> - Overrides the {@link AgamaPlayerConfiguration}.
 *
 * @category Analytics
 * @public
 */
interface AgamaSourceConfiguration extends AgamaConfiguration {
    /**
     * The identifier of the asset.
     */
    asset: string;
    /**
     * The stream type of the session.
     */
    streamType: AgamaStreamType;
    /**
     * The service name.
     *
     * @remarks
     * <br/> - Available since v2.61.0.
     * <br/> - Will not be reported to Agama if not present
     */
    serviceName?: AgamaServiceName;
    /**
     * The CDN from which the content is served.
     *
     * @remarks
     * <br/> - Available since v2.61.0.
     * <br/> - Will not be reported to Agama if not present
     */
    cdn?: string;
    /**
     * The title of the content.
     *
     * @remarks
     * <br/> - Available since v2.61.0.
     * <br/> - Will not be reported to Agama if not present
     * <br/> - The format is `title` or `title/season` or `title/season/episode` (e.g. Game of Thrones/Season 4/Episode 7)
     */
    contentTitle?: string;
    /**
     * The type of the content.
     *
     * @remarks
     * <br/> - Available since v2.61.0.
     * <br/> - Will not be reported to Agama if not present
     * <br/> - Suggested values are 'trailer', 'movie', 'news', 'documentary', ...
     */
    contentType?: string;
    /**
     * The description of the content.
     *
     * @remarks
     * <br/> - Available since v2.61.0.
     * <br/> - Will not be reported to Agama if not present
     */
    contentDescription?: string;
}

/**
 * The identifier of the Moat integration.
 *
 * @category Analytics
 * @public
 */
type MoatAnalyticsIntegrationID = 'moat';
/**
 * Describes configuration of the Moat integration.
 *
 * @remarks
 * <br/> - Available since v2.27.0.
 *
 * @category Analytics
 * @public
 */
interface MoatConfiguration extends AnalyticsDescription {
    /**
     * {@inheritDoc AnalyticsDescription.integration}
     */
    integration: MoatAnalyticsIntegrationID;
    /**
     * The Moat partner code.
     */
    partnerCode: string;
}

/**
 * Describes the configuration of the Media Melon integration.
 *
 * @category Analytics
 * @public
 */
interface MediaMelonConfiguration {
    /**
     * The identifier of the Media Melon customer.
     *
     * @remarks
     * <br/> - This id should be obtained through Media Melon.
     */
    customerID: string;
    /**
     * The domain name of the content owner.
     *
     * @remarks
     * <br/> - When omitted, will not be reported to Media Melon.
     * <br/> - It should be used to categorize analytics based on a group or application (e.g. resellers).
     */
    domainName?: string;
    /**
     * Your player solution's name.
     *
     * @remarks
     * <br/> - It can be a custom name, or `'THEOplayer'`.
     */
    playerName: string;
    /**
     * The identifier of the subscriber.
     *
     * @remarks
     * <br/> - When omitted, will not be reported to Media Melon.
     */
    subscriberID?: string;
    /**
     * The URL of the media metadata.
     */
    metaURL?: string;
    /**
     * The content asset identifier.
     */
    assetID?: string;
}

/**
 * The identifier of the Media Melon SmartSight integration.
 *
 * @category Analytics
 * @public
 */
type SmartSightIntegrationID = 'smartsight';
/**
 * Describes the configuration of the Media Melon SmartSight integration.
 *
 * @remarks
 * <br/> - Available since v2.33.2.
 *
 * @category Analytics
 * @public
 */
interface SmartSightConfiguration extends AnalyticsDescription, MediaMelonConfiguration {
    /**
     * {@inheritDoc AnalyticsDescription.integration}
     */
    integration: SmartSightIntegrationID;
}

/**
 * The identifier of the Stream One integration.
 *
 * @category Analytics
 * @public
 */
type StreamOneAnalyticsIntegrationID = 'streamone';
/**
 * Describes the configuration of the Stream One integration.
 *
 * @remarks
 * <br/> - Available since v2.32.0.
 *
 * @category Analytics
 * @public
 */
interface StreamOneConfiguration extends AnalyticsDescription {
    /**
     * {@inheritDoc AnalyticsDescription.integration}
     */
    integration: StreamOneAnalyticsIntegrationID;
    /**
     * The identifier of the StreamOne account.
     */
    accountID: string;
    /**
     * The identifier of the StreamOne content item.
     */
    itemID: string;
    /**
     * The title of the StreamOne content item.
     */
    itemTitle: string;
}

/**
 * The identifier of the Youbora integration.
 *
 * @category Analytics
 * @public
 */
type YouboraAnalyticsIntegrationID = 'youbora';
/**
 * Describes the options of the Youbora integration.
 *
 * @remarks
 * The YouboraOptions object is a dictionary of Youbora options. The THEOplayer Youbora integration is built upon Youbora v6.
 * For a detailed overview of all available properties, please consult the Youbora options documentation page:
 * See {@link http://developer.nicepeopleatwork.com/plugins/general/setting-youbora-options/ | Setting Youbora options}
 *
 * Make sure to load the Youbora library with the THEOplayer adapter before initializing the player with YouboraOptions
 * See {@link http://developer.nicepeopleatwork.com/plugins/integration/js-browser/theo-player-2-v6/ | THEOplayer 2 v6}
 *
 * Note: the integration automatically tracks these content related properties:
 * <br/> - content.duration
 * <br/> - content.resource
 * <br/> - content.isLive
 * <br/> - content.rendition
 *
 * Available since v2.21.2.
 *
 * @category Analytics
 * @public
 */
interface YouboraOptions extends AnalyticsDescription {
    /**
     * {@inheritDoc AnalyticsDescription.integration}
     */
    integration: YouboraAnalyticsIntegrationID;
    /**
     * An entry which contains a Youbora option with associated value.
     */
    [key: string]: string | {
        [key: string]: string;
    };
}

/**
 * The layout of the MultiViewPlayer.
 * <br/> - `'gallery'`: The views are structured in a grid.
 * <br/> - `'spotlight'`: One view is larger while the others are smaller and positioned to the right of the focused view.
 * <br/> - `'overlay'`: One view takes up the whole player, the remaining views float on top of the focused view.
 *
 * @category Multi-view
 * @public
 */
type MultiViewPlayerLayout = 'gallery' | 'spotlight' | 'overlay';
/**
 * The View API
 *
 * @category Multi-view
 * @public
 */
interface View {
    /**
     * The label with which the view was created.
     */
    readonly label: string;
    /**
     * The position in {@link MultiViewPlayer.views}.
     *
     * @remarks
     * <br/> - Only the position of an enabled view can be set to zero.
     */
    position: number;
    /**
     * Whether audio is muted.
     *
     * @remarks
     * <br/> Only one view can be unmuted at a time.
     * <br/> Setting this value will give audio focus to the view.
     */
    muted: boolean;
    /**
     * Returns if the View can be resized.
     *
     * @remarks
     * <br/> - Returns true if {@link MultiViewPlayer.layout} is set to `'overlay'` and the position is not equal to zero.
     */
    readonly canResize: boolean;
    /**
     * The horizontal offset in percentage.
     *
     * @remarks
     * <br/> - It describes the offset of the top left corner of the view relative to the top left corner of the MultiViewPlayer.
     * <br/> - Cannot be set if canResize is false.
     */
    x: number;
    /**
     * The vertical offset in percentage.
     *
     * @remarks
     * <br/> - It describes the offset of the top left corner of the view relative to the top left corner of the MultiViewPlayer.
     * <br/> - Cannot be set if canResize is false.
     */
    y: number;
    /**
     * The percentage relative to the total width of the containing MultiViewPlayer.
     *
     * @remarks
     * <br/> - Cannot be set if canResize is false.
     */
    width: number;
    /**
     * The percentage relative to the total height of the containing MultiViewPlayer.
     *
     * @remarks
     * <br/> - Cannot be set if canResize is false.
     */
    height: number;
    /**
     * Whether the view is visible or not.
     *
     * @remarks
     * <br/> - The view at position zero is always enabled.
     */
    enabled: boolean;
    /**
     * The offset in milliseconds used for improving synchronization between views.
     */
    offset: number;
    /**
     * Destroys the associated player and removes the view from the MultiViewPlayer.
     *
     * @remarks
     * <br/> - The view at position zero cannot be removed.
     */
    remove(): void;
}
/**
 * The MultiViewPlayer API
 *
 * @category Multi-view
 * @public
 */
interface MultiViewPlayerEventMap {
    /**
     * Fired when the first {@link View} enters {@link MultiViewPlayer.views} or all views are removed.
     */
    sourcechange: SourceChangeEvent;
    /**
     * Fired when {@link MultiViewPlayer.paused} changes to `false`.
     *
     * @remarks
     * <br/> - Either fired after the play() method has returned, or when the {@link MultiViewPlayer.autoplay} attribute has caused playback to begin.
     */
    play: PlayEvent;
    /**
     * Fired when {@link MultiViewPlayer.paused} changes to `true`.
     *
     * @remarks
     * <br/> - Fired after the `pause()` method has returned.
     */
    pause: PauseEvent;
    /**
     * Fired when {@link MultiViewPlayer.seeking} changes to `true`, and the player has started seeking to a new position.
     */
    seeking: SeekingEvent;
    /**
     * Fired when {@link MultiViewPlayer.seeking} changes to `false` after the current playback position was changed.
     */
    seeked: SeekedEvent;
    /**
     * Fired when the current playback position changed as part of normal playback or in an especially interesting way, for example discontinuously.
     */
    timeupdate: TimeUpdateEvent;
    /**
     * Fired when playback has stopped because the end of the media resource was reached.
     */
    ended: EndedEvent;
    /**
     * Fired when playback is ready to start after having been paused or delayed due to lack of media data.
     */
    playing: PlayingEvent;
    /**
     * Fired when playback has stopped because the next frame is not available, but the player expects that frame to become available in due course.
     */
    waiting: WaitingEvent;
    /**
     * Fired when {@link MultiViewPlayer.readyState} changes.
     */
    readystatechange: ReadyStateChangeEvent;
    /**
     * Fired when the player determines the duration and dimensions of the media resources for all {@link View}s.
     *
     * @remarks
     * <br/> - See {@link https://html.spec.whatwg.org/multipage/media.html#mediaevents:dom-media-readystate | HTML media - network state events}.
     * <br/> - The {@link MultiViewPlayer.seekable | seekable range} should be available as soon as the {@link MultiViewPlayer.duration | duration} is known. However, certain browsers (e.g. Safari) do not make it available until the `loadeddata` event is fired.
     */
    loadedmetadata: LoadedMetadataEvent;
    /**
     * Fired when the player can render the media data at the current playback position for the first time.
     *
     * @remarks
     * <br/> - See {@link https://html.spec.whatwg.org/multipage/media.html#mediaevents:dom-media-readystate | HTML media - network state events}.
     */
    loadeddata: LoadedDataEvent;
    /**
     * Fired when the player can resume playback of the media data.
     *
     * @remarks
     * <br/> - In comparison to `canplaythrough`, the player estimates that if playback were to be started now, the media resource could not be rendered at the current playback rate up to its end without having to stop for further buffering of content.
     * <br/> - See {@link https://html.spec.whatwg.org/multipage/media.html#mediaevents:dom-media-readystate | HTML media - network state events}.
     */
    canplay: CanPlayEvent;
    /**
     * Fired when the player can resume playback of the media data and buffering is unlikely.
     *
     * @remarks
     * <br/> - In comparison to `canplay`, the player estimates that if playback were to be started now, the media resource could be rendered at the current playback rate all the way to its end without having to stop for further buffering.
     * <br/> - See {@link https://html.spec.whatwg.org/multipage/media.html#mediaevents:dom-media-readystate | HTML media - network state events}.
     */
    canplaythrough: CanPlayThroughEvent;
    /**
     * Fired when the player has started loading the manifest of all {@link View}s.
     *
     * @remarks
     * <br/> - See {@link https://html.spec.whatwg.org/multipage/media.html#mediaevents:dom-media-networkstate | HTML media - network state events}.
     */
    loadstart: Event<'loadstart'>;
    /**
     * Fired when the player loaded media data.
     *
     * @remarks
     * <br/> - For DASH streams, the event is fired every 350ms or for every byte received whichever is least frequent.
     * <br/> - See {@link https://html.spec.whatwg.org/multipage/media.html#mediaevents:dom-media-networkstate | HTML media - network state events}.
     */
    progress: ProgressEvent;
    /**
     * Fired when {@link MultiViewPlayer.duration} changes.
     *
     * @remarks
     * <br/> - Fired after {@link MultiViewPlayer.readyState} has loaded metadata, or when the last segment is appended and there is a mismatch with the original duration.
     */
    durationchange: DurationChangeEvent;
    /**
     * Fired when {@link MultiViewPlayer.volume} changes.
     */
    volumechange: VolumeChangeEvent;
    /**
     * Fired when {@link MultiViewPlayer.playbackRate} changes.
     */
    ratechange: RateChangeEvent;
    /**
     * Fired when an error occurs.
     */
    error: ErrorEvent;
    /**
     * Fired when the player goes into or out of fullscreen.
     */
    fullscreenchange: Event<'fullscreenchange'>;
    /**
     * Fired when a {@link View} is added.
     */
    addview: AddViewEvent;
    /**
     * Fired when a {@link View} is removed.
     */
    removeview: RemoveViewEvent;
    /**
     * Fired when a view's {@link View.enabled | enabled} changes.
     */
    viewchange: ViewChangeEvent;
    /**
     * Fired when a {@link View} swapped positions in the list.
     */
    viewpositionchange: ViewPositionChangeEvent;
    /**
     * Fired when {@link MultiViewPlayer.layout} changes.
     */
    layoutchange: LayoutChangeEvent;
}
/**
 * The MultiViewPlayer API.
 *
 * @remarks
 * <br/> - Available since v4.3.0
 * <br/> - Only available with the feature `'multiview'`.
 * <br/> - Only supported on modern browsers such as evergreen Chrome, Firefox and Safari. Not supported on Internet Explorer.
 *
 * @category API
 * @category Multi-view
 * @public
 */
declare class MultiViewPlayer implements EventDispatcher<MultiViewPlayerEventMap> {
    constructor(element: HTMLElement, configuration?: UIPlayerConfiguration);
    /**
     * Returns all {@link View}s in their respective order.
     */
    readonly views: ReadonlyArray<View>;
    /**
     * The currently selected layout.
     */
    layout: MultiViewPlayerLayout;
    /**
     * Returns a TimeRanges object that represents the intersection of all buffered properties of the underlying players.
     */
    readonly buffered: TimeRanges;
    /**
     * The current playback position of the player currently at position zero.
     */
    currentTime: number;
    /**
     *  Whether the player should immediately start playback.
     *
     *  @remarks
     *  <br/> - To autoplay with sound on certain platforms, {@link MultiViewPlayer.prepareWithUserAction} must be called at least once.
     *  <br/> - To autoplay without sound, {@link PlayerConfiguration.mutedAutoplay} must be configured.
     */
    autoplay: boolean;
    /**
     * Returns the minimum of all duration properties of the underlying players.
     */
    readonly duration: number;
    /**
     * Whether any of the underlying players is ended.
     */
    readonly ended: boolean;
    /**
     * Returns the last error that occurred of the underlying players.
     */
    readonly errorObject: THEOplayerError | undefined;
    /**
     * Whether all the underlying players are muted.
     */
    muted: boolean;
    /**
     * The {@link View} whose audio is in focus.
     *
     * @remarks
     * <br/> Only one view can have audio focus at a time.
     */
    readonly mainAudioView: View | undefined;
    /**
     * The {@link View} whose video is in focus.
     *
     * @remarks
     * <br/> This is the same as the {@link View} at position zero.
     */
    readonly mainVideoView: View | undefined;
    /**
     * The Video.js player on which the UI is built.
     */
    readonly ui: videojs.Player;
    /**
     * Whether any of the underlying players is muted.
     */
    readonly paused: boolean;
    /**
     * Returns the playbackRate of the player at position zero.
     */
    playbackRate: number;
    /**
     * Returns the intersection of all played properties of the underlying players.
     */
    readonly played: TimeRanges;
    /**
     * Returns the minimum of all readyState properties of the underlying players.
     */
    readonly readyState: number;
    /**
     * Returns the intersection of all seekable properties of the underlying players.
     */
    readonly seekable: TimeRanges;
    /**
     * Whether any of the underlying players is seeking.
     */
    readonly seeking: boolean;
    /**
     * Returns the volume of the player at position zero.
     */
    volume: number;
    /**
     * Creates a new view.
     *
     * @param label - The name belonging to a view which is used in the multiview menu.
     * @param source - The SourceDescription set on the view.
     * @param description - A short description of the view which will be displayed on top.
     * @param offset - The offset in milliseconds used for improving synchronization between views.
     *
     * @remarks
     * <br/> - If the given label clashes with an existing label, the existing view will be returned.
     * <br/> - A player which is created is with position set to the length of {@link MultiViewPlayer.views}.
     */
    load(label: string, source: SourceDescription, description?: string, offset?: number): View;
    /**
     * Calls play() on all underlying players and starts in-sync playback.
     */
    play(): void;
    /**
     * Calls pause() on all underlying players.
     */
    pause(): void;
    /**
     * Stops playback and removes all views.
     */
    stop(): void;
    /**
     * Calls destroy() on all underlying players and removes all views.
     */
    destroy(): void;
    /**
     * Enables fullscreen mode on the element of the MultiViewPlayer.
     */
    requestFullscreen(options?: FullscreenOptions): void;
    /**
     * Disables fullscreen mode.
     */
    exitFullscreen(): void;
    /**
     * Calls prepareWithUserAction() on all underlying players.
     */
    prepareWithUserAction(): void;
    /**
     * {@inheritDoc EventDispatcher.addEventListener}
     */
    addEventListener<TType extends StringKeyOf<MultiViewPlayerEventMap>>(type: TType | readonly TType[], listener: EventListener<MultiViewPlayerEventMap[TType]>): void;
    /**
     * {@inheritDoc EventDispatcher.removeEventListener}
     */
    removeEventListener<TType extends StringKeyOf<MultiViewPlayerEventMap>>(type: TType | readonly TType[], listener: EventListener<MultiViewPlayerEventMap[TType]>): void;
}

/**
 * Fired when a new {@link View} has been added to the {@link MultiViewPlayer}.
 *
 * @category Multi-view
 * @category Events
 * @public
 */
interface AddViewEvent extends Event<'addview'> {
    /**
     * The view that has been added.
     */
    readonly view: View;
}
/**
 * Fired when a {@link View} has been removed from the {@link MultiViewPlayer}.
 *
 * @category Multi-view
 * @category Events
 * @public
 */
interface RemoveViewEvent extends Event<'removeview'> {
    /**
     * The view that has been removed.
     */
    readonly view: View;
}
/**
 * Fired when a view's {@link View.enabled | enabled} changes.
 *
 * @category Multi-view
 * @category Events
 * @public
 */
interface ViewChangeEvent extends Event<'viewchange'> {
    /**
     * The view that has been changed.
     */
    readonly view: View;
}
/**
 * Fired when a {@link View} has swapped positions in the list.
 *
 * @category Multi-view
 * @category Events
 * @public
 */
interface ViewPositionChangeEvent extends Event<'viewpositionchange'> {
    /**
     * The position of the view whose position has changed.
     */
    readonly oldPosition: number;
    /**
     * The new position of the view
     */
    readonly newPosition: number;
}
/**
 * Fired when {@link MultiViewPlayer.layout} changes.
 *
 * @category Multi-view
 * @category Events
 * @public
 */
interface LayoutChangeEvent extends Event<'layoutchange'> {
    /**
     * The new layout of the player.
     */
    readonly layout: MultiViewPlayerLayout;
}

/**
 * The version of the THEOplayer SDK.
 *
 * @category API
 * @public
 */
declare const version: string;
/**
 * The features included in the THEOplayer SDK.
 *
 * @category API
 * @public
 */
declare const features: readonly string[];
/**
 * List of players.
 *
 * @category API
 * @public
 */
declare const players: PlayerList;
/**
 * The global cast API.
 *
 * @category API
 * @category Casting
 * @public
 */
declare const cast: GlobalCast;
/**
 * The global cache API.
 *
 * @category API
 * @category Caching
 * @public
 */
declare const cache: Cache;
/**
 * Register a content protection integration
 *
 * @param integrationId - An id of the integration. The {@link ContentProtectionIntegrationFactory} will be used when the
 * {@link DRMConfiguration.integration} property of the source is set to this id.
 * @param keySystem - The {@link KeySystemId} for which the {@link ContentProtectionIntegrationFactory} should be used.
 * @param integrationFactory - Factory that will construct a {@link ContentProtectionIntegration}.
 *
 * @remarks
 * This function allows for registering a {@link ContentProtectionIntegrationFactory} for a specific integrationId and keySystem. If a source is
 * set with the {@link DRMConfiguration.integration} property set to this id, on a platform where the player will use the keySystem that corresponds
 * with the given {@link KeySystemId}, this {@link ContentProtectionIntegrationFactory} will be used to construct a
 * {@link ContentProtectionIntegration} based on the {@link DRMConfiguration}. This {@link ContentProtectionIntegration} allows for altering license
 * and certificate requests and responses.
 *
 * @category API
 * @category Content Protection
 * @public
 */
declare function registerContentProtectionIntegration(integrationId: string, keySystem: KeySystemId, integrationFactory: ContentProtectionIntegrationFactory): void;
/**
 * Utils that serve common use cases. For example encoding and decoding a base64 string to Uint8Array and vice versa.
 *
 * @category API
 * @public
 */
declare const utils: CommonUtils;

export { ABRConfiguration, ABRMetadata, ABRStrategy, ABRStrategyConfiguration, ABRStrategyType, AES128KeySystemConfiguration, AccessibilityRole, Ad, AdBreak, AdBreakEvent, AdBreakInit, AdBreakInterstitial, AdBufferingEvent, AdDescription, AdEvent, AdInit, AdIntegrationKind, AdMetadataEvent, AdPreloadType, AdReadyState, AdSkipEvent, AdSource, AdSourceType, AdType, AddCachingTaskEvent, AddTrackEvent, AddViewEvent, Ads, AdsConfiguration, AdsEventMap, AdsManagerLoadedEvent, AgamaAnalyticsIntegrationID, AgamaConfiguration, AgamaLogLevelType, AgamaPlayerConfiguration, AgamaServiceName, AgamaSourceConfiguration, AgamaStreamType, AirPlay, AnalyticsDescription, AnalyticsIntegrationID, AudioQuality, AxinomDRMConfiguration, AxinomIntegrationID, AzureDRMConfiguration, AzureIntegrationID, Base64Util, BaseSource, Boundary, BoundaryC3, BoundaryC7, BoundaryHalftime, BoundaryInfo, BufferSource, BufferedSegments, Cache, CacheEventMap, CacheStatus, CacheTaskStatus, CachingTask, CachingTaskEventMap, CachingTaskLicense, CachingTaskList, CachingTaskListEventMap, CachingTaskParameters, CanPlayEvent, CanPlayThroughEvent, Canvas, Cast, CastConfiguration, CastEventMap, CastState, CastStateChangeEvent, CertificateRequest, CertificateResponse, Chromecast, ChromecastConfiguration, ChromecastConnectionCallback, ChromecastError, ChromecastErrorCode, ChromecastErrorEvent, ChromecastEventMap, ChromecastMetadataDescription, ChromecastMetadataImage, ChromecastMetadataType, ChromelessPlayer, ClearkeyDecryptionKey, ClearkeyKeySystemConfiguration, Clip, ClipEventMap, ClosedCaptionFile, ComcastDRMConfiguration, ComcastIntegrationID, CommonUtils, CompanionAd, ConaxDRMConfiguration, ConaxIntegrationID, ContentProtectionError, ContentProtectionErrorCode, ContentProtectionErrorEvent, ContentProtectionIntegration, ContentProtectionIntegrationFactory, ContentProtectionRequest, ContentProtectionRequestSubType, ContentProtectionResponse, CrossOriginSetting, CsaiAdDescription, CurrentSourceChangeEvent, CustomAdIntegrationKind, CustomTextTrackMap, CustomTextTrackOptions, CustomWebVTTTextTrack, DAIAvailabilityType, DRMConfiguration, DRMTodayDRMConfiguration, DRMTodayIntegrationID, DashPlaybackConfiguration, DateRangeCue, DeliveryType, DeviceBasedTitaniumDRMConfiguration, DimensionChangeEvent, DirectionChangeEvent, DurationChangeEvent, EdgeStyle, EmptiedEvent, EmsgCue, EncryptedEvent, EndedEvent, EnterBadNetworkModeEvent, ErrorCategory, ErrorCode, ErrorEvent, Event, EventDispatcher, EventListener, EventMap, EventStreamCue, EventedList, ExitBadNetworkModeEvent, ExpressPlayDRMConfiguration, ExpressPlayIntegrationID, EzdrmDRMConfiguration, EzdrmIntegrationID, FairPlayKeySystemConfiguration, FreeWheelAdDescription, FreeWheelAdUnitType, FreeWheelCue, FullscreenOptions$1 as FullscreenOptions, Geo, GlobalCast, GlobalChromecast, GoogleDAI, GoogleDAIConfiguration, GoogleDAILiveConfiguration, GoogleDAISSAIIntegrationID, GoogleDAITypedSource, GoogleDAIVodConfiguration, GoogleImaAd, GoogleImaConfiguration, HTTPHeaders, HespApi, HespApiEventMap, HespMediaType, HespSourceConfiguration, HespTypedSource, HlsDiscontinuityAlignment, HlsPlaybackConfiguration, ID3AttachedPicture, ID3BaseFrame, ID3Comments, ID3CommercialFrame, ID3Cue, ID3Frame, ID3GenericEncapsulatedObject, ID3InvolvedPeopleList, ID3PositionSynchronisationFrame, ID3PrivateFrame, ID3SynchronizedLyricsText, ID3TermsOfUse, ID3Text, ID3UniqueFileIdentifier, ID3Unknown, ID3UnsynchronisedLyricsTextTranscription, ID3UrlLink, ID3UserDefinedText, ID3UserDefinedUrlLink, ID3Yospace, IMAAdDescription, IntentToFallbackEvent, InterceptableRequest, InterceptableResponse, Interstitial, InterstitialEvent, InterstitialType, IrdetoDRMConfiguration, IrdetoIntegrationID, JoinStrategy, KeyOSDRMConfiguration, KeyOSFairplayKeySystemConfiguration, KeyOSIntegrationID, KeyOSKeySystemConfiguration, KeySystemConfiguration, KeySystemId, Latencies, LatencyConfiguration, LatencyManager, LayoutChangeEvent, LicenseRequest, LicenseResponse, LicenseType, LinearAd, List, LoadedDataEvent, LoadedMetadataEvent, MaybeAsync, MeasurableNetworkEstimator, MediaError, MediaErrorCode, MediaFile, MediaMelonConfiguration, MediaTailorSource, MediaTrack, MediaTrackEventMap, MediaTrackList, MediaType, MetadataDescription, Metrics, MillicastMetadataCue, MillicastSource, MoatAnalyticsIntegrationID, MoatConfiguration, MultiViewPlayer, MultiViewPlayerEventMap, MultiViewPlayerLayout, MutedAutoplayConfiguration, Network, NetworkEstimator, NetworkEstimatorController, NetworkEventMap, NetworkInterceptorController, NodeStyleVoidCallback, NonLinearAd, OverlayInterstitial, OverlayPosition, OverlaySize, PauseEvent, PiPConfiguration, PiPPosition, PlayEvent, PlayReadyKeySystemConfiguration, PlayerConfiguration, PlayerEventMap, PlayerList, PlayingEvent, PreloadType, Presentation, PresentationEventMap, PresentationMode, PresentationModeChangeEvent, ProgressEvent, PublicationLoadStartEvent, PublicationLoadedEvent, PublicationOfflineEvent, Quality, QualityEvent, QualityEventMap, QualityList, RateChangeEvent, ReadyStateChangeEvent, RelatedChangeEvent, RelatedContent, RelatedContentEventMap, RelatedContentSource, RelatedHideEvent, RelatedShowEvent, RemoveCachingTaskEvent, RemoveTrackEvent, RemoveViewEvent, Representation, RepresentationChangeEvent, Request, RequestBody, RequestInit, RequestInterceptor, RequestLike, RequestMeasurer, RequestMethod, RequestSubType, RequestType, ResponseBody, ResponseInit, ResponseInterceptor, ResponseLike, ResponseType, RetryConfiguration, SSAIIntegrationId, SeamlessPeriodSwitchStrategy, SeamlessSwitchStrategy, SeekedEvent, SeekingEvent, ServerSideAdInsertionConfiguration, ServerSideAdIntegrationController, ServerSideAdIntegrationFactory, ServerSideAdIntegrationHandler, SkippedAdStrategy, SmartSightConfiguration, SmartSightIntegrationID, Source, SourceAbrConfiguration, SourceChangeEvent, SourceConfiguration, SourceDescription, SourceIntegrationId, SourceLatencyConfiguration, Sources, SpotXAdDescription, SpotxData, SpotxQueryParameter, StateChangeEvent, StereoChangeEvent, StreamOneAnalyticsIntegrationID, StreamOneConfiguration, StreamType, StringKeyOf, StylePropertyRecord, SupportedCustomTextTrackCueTypes, THEOplayerAdDescription, THEOplayerError, TTMLCue, TTMLExtent, TargetQualityChangedEvent, TextTrack, TextTrackAddCueEvent, TextTrackCue, TextTrackCueChangeEvent, TextTrackCueEnterEvent, TextTrackCueEventMap, TextTrackCueExitEvent, TextTrackCueList, TextTrackCueUpdateEvent, TextTrackDescription, TextTrackEnterCueEvent, TextTrackError, TextTrackErrorCode, TextTrackErrorEvent, TextTrackEventMap, TextTrackExitCueEvent, TextTrackReadyState, TextTrackReadyStateChangeEvent, TextTrackRemoveCueEvent, TextTrackStyle, TextTrackStyleEventMap, TextTrackType, TextTrackTypeChangeEvent, TextTrackUpdateCueEvent, TextTracksList, TheoAdDescription, TheoAds, TheoAdsEventsMap, TheoAdsLayout, TheoAdsLayoutOverride, TheoLiveApi, TheoLiveApiEventMap, TheoLiveConfiguration, TheoLivePublication, TheoLiveSource, ThumbnailResolution, TimeRanges, TimeUpdateEvent, TitaniumDRMConfiguration, TitaniumIntegrationID, TokenBasedTitaniumDRMConfiguration, Track, TrackChangeEvent, TrackEventMap, TrackList, TrackListEventMap, TrackUpdateEvent, TypedSource, UIConfiguration, UILanguage, UIPlayerConfiguration, UIRelatedContent, UIRelatedContentEventMap, UniversalAdId, UpdateQualityEvent, Uplynk, UplynkAd, UplynkAdBeginEvent, UplynkAdBreak, UplynkAdBreakBeginEvent, UplynkAdBreakEndEvent, UplynkAdBreakEventMap, UplynkAdBreakList, UplynkAdBreakListEventMap, UplynkAdBreakSkipEvent, UplynkAdCompleteEvent, UplynkAdEndEvent, UplynkAdEventMap, UplynkAdFirstQuartileEvent, UplynkAdList, UplynkAdListEventMap, UplynkAdMidpointEvent, UplynkAdThirdQuartileEvent, UplynkAddAdBreakEvent, UplynkAddAssetEvent, UplynkAds, UplynkAsset, UplynkAssetEventMap, UplynkAssetId, UplynkAssetInfoResponse, UplynkAssetInfoResponseEvent, UplynkAssetList, UplynkAssetMovieRating, UplynkAssetTvRating, UplynkAssetType, UplynkConfiguration, UplynkDRMConfiguration, UplynkEventMap, UplynkExternalId, UplynkIntegrationID, UplynkPingConfiguration, UplynkPingErrorEvent, UplynkPingResponse, UplynkPingResponseEvent, UplynkPreplayBaseResponse, UplynkPreplayLiveResponse, UplynkPreplayResponse, UplynkPreplayResponseEvent, UplynkPreplayResponseType, UplynkPreplayVodResponse, UplynkRemoveAdBreakEvent, UplynkRemoveAdEvent, UplynkRemoveAssetEvent, UplynkResponseDrm, UplynkResponseLiveAd, UplynkResponseLiveAdBreak, UplynkResponseLiveAds, UplynkResponseVodAd, UplynkResponseVodAdBreak, UplynkResponseVodAdBreakOffset, UplynkResponseVodAdPlaceholder, UplynkResponseVodAds, UplynkSource, UplynkUiConfiguration, UplynkUpdateAdBreakEvent, UserActions, VPAIDMode, VR, VRConfiguration, VRDirection, VREventMap, VRPanoramaMode, VRPlayerConfiguration, VRState, VRStereoMode, VTTAlignSetting, VTTDirectionSetting, VTTLine, VTTLineAlignSetting, VTTPosition, VTTPositionAlignSetting, VTTScrollSetting, VendorCast, VendorCastEventMap, VerimatrixDRMConfiguration, VerimatrixIntegrationID, VideoFrameCallbackMetadata, VideoFrameRequestCallback, VideoQuality, View, ViewChangeEvent, ViewPositionChangeEvent, VimondDRMConfiguration, VimondIntegrationID, Visibility, VisibilityObserver, VisibilityObserverCallback, VoidPromiseCallback, VolumeChangeEvent, VudrmDRMConfiguration, VudrmIntegrationID, WaitUntilCallback, WaitingEvent, WebAudio, WebVTTCue, WebVTTRegion, WidevineKeySystemConfiguration, XstreamDRMConfiguration, XstreamIntegrationID, YospaceId, YouboraAnalyticsIntegrationID, YouboraOptions, cache, cast, features, players, registerContentProtectionIntegration, utils, version, videojs };
