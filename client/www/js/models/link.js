(function(){var e,t,n={}.hasOwnProperty,r=function(e,t){function i(){this.constructor=e}for(var r in t)n.call(t,r)&&(e[r]=t[r]);return i.prototype=t.prototype,e.prototype=new i,e.__super__=t.prototype,e};t=function(e,t){var n;return t(n=function(e){function t(){return t.__super__.constructor.apply(this,arguments)}return r(t,e),t.prototype.idAttribute="_id",t.prototype.urlRoot="/links",t.prototype.parseTags=function(){var e,t,n,r,i,s,o;e=this.get("description"),this.has("tags")||(i=e.split(" "),this.set("tags",function(){var e,t,n;n=[];for(e=0,t=i.length;e<t;e++)r=i[e],r.charAt(0)==="#"&&r.length>1&&n.push(r.substring(1,r.length));return n}())),n=this.get("tags");if(n.length){for(s=0,o=n.length;s<o;s++)t=n[s],e=e.replace("#"+t,"<a href='/"+t+"'>#"+t+"</a>");this.set("description",e)}return this},t}(e.Model))},typeof exports=="undefined"?define(["ext/framework"],function(e){return t(e.mvc,function(e){return e})}):(e=require("slob").framework,t(e.mvc,function(e){return module.exports=e}))}).call(this);