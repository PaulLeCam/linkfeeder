(function(){var e=[].slice;define(["jquery"],function(t){return{find:function(e,n){return n==null&&(n=document),e===n?t(n):t(n).find(e)},data:function(){var n,r;return r=arguments[0],n=2<=arguments.length?e.call(arguments,1):[],t(r).data.apply(t,n)},on:function(){var n,r;return r=arguments[0],n=2<=arguments.length?e.call(arguments,1):[],t(r).on.apply(t,n)},off:function(){var n,r;return r=arguments[0],n=2<=arguments.length?e.call(arguments,1):[],t(r).off.apply(t,n)},once:function(){var n,r;return r=arguments[0],n=2<=arguments.length?e.call(arguments,1):[],t(r).one.apply(t,n)},ready:function(e){return t(function(){return e()})}}})}).call(this);