define(["handlebars"],function(e){return e.template(function(e,t,n,r,i){this.compilerInfo=[4,">= 1.0.0"],n=this.merge(n,e.helpers),i=i||{};var s="",o,u,a="function",f=this.escapeExpression,l=n.helperMissing;return s+='<li class="',(o=n.cls)?o=o.call(t,{hash:{},data:i}):(o=t&&t.cls,o=typeof o===a?o.call(t,{hash:{},data:i}):o),s+=f(o)+'">\n  <a href="',(o=n.url)?o=o.call(t,{hash:{},data:i}):(o=t&&t.url,o=typeof o===a?o.call(t,{hash:{},data:i}):o),s+=f(o)+'">',u={hash:{},data:i},s+=f((o=n.safe||t&&t.safe,o?o.call(t,t&&t.val,u):l.call(t,"safe",t&&t.val,u)))+"</a>\n</li>\n",s})});