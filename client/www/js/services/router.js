(function(){var e={}.hasOwnProperty,t=function(t,n){function i(){this.constructor=t}for(var r in n)e.call(n,r)&&(t[r]=n[r]);return i.prototype=n.prototype,t.prototype=new i,t.__super__=n.prototype,t};define(["sandbox/service"],function(e){var n;return n=function(e){function n(){return n.__super__.constructor.apply(this,arguments)}return t(n,e),n.prototype.pageRoutes={"":"home",":tag":"tags/read",":tag/:page":"tags/read","links/:id":"links/read","links/new":"links/create"},n}(e.routing.Router),new n})}).call(this);