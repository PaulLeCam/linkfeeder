(function(){var e={}.hasOwnProperty,t=function(t,n){function i(){this.constructor=t}for(var r in n)e.call(n,r)&&(t[r]=n[r]);return i.prototype=n.prototype,t.prototype=new i,t.__super__=n.prototype,t};define(["ext/framework","sandbox/widget"],function(e,n){var r,i;return r=function(e){function r(){return i=r.__super__.constructor.apply(this,arguments),i}return t(r,e),r.prototype.start=function(e){if(e!=null)return this.load()},r.prototype.stop=function(){},r.prototype.load=function(e){var t;return e==null&&(e=this.url),t=n.deferred(),this.$el!=null&&e!=null?this.$el.load(e,t.resolve):t.reject(),t.promise()},r}(e.mvc.View)})}).call(this);