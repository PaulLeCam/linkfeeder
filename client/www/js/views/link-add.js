(function(){var e,t,n,r={}.hasOwnProperty,i=function(e,t){function i(){this.constructor=e}for(var n in t)r.call(t,n)&&(e[n]=t[n]);return i.prototype=t.prototype,e.prototype=new i,e.__super__=t.prototype,e};t=function(e,t,n){var r;return n(r=function(e){function n(){return n.__super__.constructor.apply(this,arguments)}return i(n,e),n.prototype.template=t,n.prototype.render=function(){return this.renderer(this.template())},n}(e.View))},typeof exports=="undefined"?define(["ext/framework","templates/link-add"],function(e,n){return t(e.mvc,n,function(e){return e})}):(e=require("slob").framework,n=e.template.compile(require("fs").readFileSync(""+__dirname+"/../templates/Link-add.htm").toString()),t(e.mvc,n,function(e){return module.exports=e}))}).call(this);