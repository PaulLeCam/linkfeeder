(function(){var e=[].slice;define(["sandbox/component"],function(t){return{initialize:function(n){var r,i,s;return r=t.deferred(),n!=null?t.util.isArray(n)?(s=function(){var e,t,r;r=[];for(e=0,t=n.length;e<t;e++)i=n[e],r.push(this.instanciate(i));return r}.call(this),t.when.apply(t,s).then(function(){var t;return t=1<=arguments.length?e.call(arguments,0):[],r.resolve(t)},r.reject)):t.util.isObject(n)?this.instanciate(n).pipe(r.resolve,r.reject):r.reject(new Error("Unhandled initialize argument")):r.resolve(),r.promise()},instanciate:function(e){var n,r=this;return e==null&&(e={}),n=t.deferred(),e.load!=null?this.load(e.load).fail(n.reject).done(function(t){return r.factory(t,e).pipe(n.resolve,n.reject)}):n.reject(new Error("No load path provided")),n.promise()},load:function(e){var n;return n=t.deferred(),require([e],n.resolve,n.reject),n.promise()},factory:function(e,n){var r,i;return r=t.deferred(),i=new e(n.data),n.fetch&&n.fetch===!0?i.fetch().then(r.resolve,r.reject):r.resolve(i),r.promise()}}})}).call(this);