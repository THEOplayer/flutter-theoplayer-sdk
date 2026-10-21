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

 Version: 11.14.0
 Created: 2026-10-21T09:54:42.910Z
 */var r="u">typeof globalThis?globalThis:"u">typeof self?self:void 0!==o?o:"u">typeof global?global:this,o=r.window;r.document,r.location,r.navigator,r.setTimeout,r.clearTimeout,r.setInterval,r.clearInterval,r.Error,r.TypeError,r.SyntaxError,r.Object,r.Math,r.parseInt,r.parseFloat,r.isNaN,r.Uint8Array,r.Worker,r.WorkerGlobalScope,r.XMLHttpRequest,function(r){var o="function"==typeof r&&!!r.iterator;if(!o||!r.for||!r.dispose||!r.asyncDispose){var a=0,e=o?function(o){return r(o)}:function(r){return"r"+r+"_"+ ++a},s=o?r.for||r:function(r){return"r"+r};e.for=s,e.iterator=t("iterator"),e.asyncIterator=t("asyncIterator"),e.dispose=t("dispose"),e.asyncDispose=t("asyncDispose")}function t(a){return o&&r[a]||s("Symbol."+a)}}(r.Symbol);import{_ as a,d as e,dt as s,f as t,g as n,i as i,o as l,p as c,u as u,ut as y}from"./THEOplayer.common.esm.js";export{a as ChromelessPlayer,a as Player,y as ErrorCategory,s as ErrorCode,i as cache,l as cast,c as features,u as players,e as registerContentProtectionIntegration,n as utils,t as version};