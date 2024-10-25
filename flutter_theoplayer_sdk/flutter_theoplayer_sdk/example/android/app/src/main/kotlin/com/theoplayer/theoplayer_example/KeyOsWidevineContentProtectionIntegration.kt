package com.theoplayer.theoplayer_example

import com.theoplayer.android.api.contentprotection.ContentProtectionIntegration
import com.theoplayer.android.api.contentprotection.LicenseRequestCallback
import com.theoplayer.android.api.contentprotection.Request
import com.theoplayer.android.api.source.drm.DRMConfiguration

class KeyOsWidevineContentProtectionIntegration(private val contentProtectionConfiguration: DRMConfiguration) :
    ContentProtectionIntegration() {
    override fun onLicenseRequest(request: Request, callback: LicenseRequestCallback) {
        if (contentProtectionConfiguration.widevine == null) {
            throw NullPointerException("The license acquisition URL can not be null")
        }
        request.url = contentProtectionConfiguration.widevine!!.licenseAcquisitionURL
        request.headers["x-keyos-authorization"] =
            contentProtectionConfiguration.integrationParameters["x-keyos-authorization"].toString()
        callback.request(request)
    }
}