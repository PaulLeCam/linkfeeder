(function(){var e={}.hasOwnProperty,t=function(t,n){function i(){this.constructor=t}for(var r in n)e.call(n,r)&&(t[r]=n[r]);return i.prototype=n.prototype,t.prototype=new i,t.__super__=n.prototype,t};define("pages/tags/read",["components/page"],function(e){var n;return n=function(e){function n(){return n.__super__.constructor.apply(this,arguments)}return t(n,e),n.prototype.el="#content",n.prototype.start=function(e,t,r){return r==null&&(r=1),this.url="/"+t+"/"+r,n.__super__.start.call(this,arguments)},n}(e)})}).call(this);