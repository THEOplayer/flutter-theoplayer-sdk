/*!
 THEOplayer

 Usage of this software is limited by the THEOplayer License.

 It is prohibited to reverse engineer, decompile, translate,
 disassemble, decipher, decrypt, or otherwise attempt to
 discover the source code of this software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.

 For more information, visit https://www.theoplayer.com or contact
 contact @ theoplayer . com

 This product makes use of Open Source Software: video.js
 (Apache 2.0 - Copyright Brightcove, Inc.), long.js (Apache 2.0),
 nodejs-langs (MIT - Copyright Andrew Lawson), promise-polyfill
 (MIT - Copyright (c) 2014 Taylor Hakes & Forbes Lindesay),
 shaka-player (Apache 2.0 - Copyright 2016 Google LLC)
 The code of these projects has been heavily modified during
 integration.
 More information on the licenses can be found here: Apache 2.0
 (http://www.apache.org/licenses/LICENSE-2.0), MIT
 (https://opensource.org/licenses/MIT)


 THEOplayer is based on patented technology developed by
 THEO Technologies (https://www.theoplayer.com).

 Version: 11.15.0
 Created: 2026-11-05T13:18:57.412Z
 */var r="u">typeof globalThis?globalThis:"u">typeof self?self:void 0!==o?o:"u">typeof global?global:this,o=r.window,a=(r.document,r.location,r.navigator,r.setTimeout,r.clearTimeout,r.setInterval,r.clearInterval,r.Error,r.TypeError,r.SyntaxError,r.Object,r.Math);r.parseInt,r.parseFloat,r.isNaN,r.Uint8Array,r.Worker,r.WorkerGlobalScope,r.XMLHttpRequest,function(r){var o="function"==typeof r&&!!r.iterator;if(!o||!r.for||!r.dispose||!r.asyncDispose){var e=0,t=a.random().toString(36).slice(2),s=o?function(o){return r(o)}:function(r){return"Symbol$"+r+"$"+t+"$"+ ++e},n=o?r.for||r:function(r){return"Symbol$"+r};s.for=n,s.iterator=i("iterator"),s.asyncIterator=i("asyncIterator"),s.dispose=i("dispose"),s.asyncDispose=i("asyncDispose")}function i(a){return o&&r[a]||n("Symbol."+a)}}(r.Symbol);import{_ as e,d as t,dt as s,f as n,g as i,i as l,o as c,p as u,u as y,ut as p}from"./THEOplayer.common.esm.js";export{e as ChromelessPlayer,e as Player,p as ErrorCategory,s as ErrorCode,l as cache,c as cast,u as features,y as players,t as registerContentProtectionIntegration,i as utils,n as version};