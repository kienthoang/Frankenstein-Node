/*! Copyright 2012, Ben Lin (http://dreamerslab.com/)
* Licensed under the MIT License (LICENSE.txt).
*
* Version: 1.0.10
*
* Requires: jQuery 1.2.3 ~ 1.8.0
*/
;(function(a){a.fn.extend({actual:function(b,l){if(!this[b]){throw'$.actual => The jQuery method "'+b+'" you called does not exist';}var f={absolute:false,clone:false,includeMargin:false};var i=a.extend(f,l);var e=this;var h,j;if(i.clone===true){h=function(){var m="position: absolute !important; top: -1000 !important; ";e=e.filter(":first").clone().attr("style",m).appendTo("body");};j=function(){e.remove();};}else{var g=[];var d,c;h=function(){d=e.parents().andSelf().filter(":hidden");c+="visibility: hidden !important; display: block !important; ";if(i.absolute===true){c+="position: absolute !important; ";}d.each(function(){var m=a(this);g.push(m.attr("style"));m.attr("style",c);});};j=function(){d.each(function(m){var o=a(this);var n=g[m];if(n===undefined){o.removeAttr("style");}else{o.attr("style",n);}});};}h();var k=/(outer)/g.test(b)?e[b](i.includeMargin):e[b]();j();return k;}});})(jQuery);