(function(a){jQuery.fn.droppable=function(k){if(k.accept==null){return}var e=k.accept,d=k.activeClass,g=k.hoverClass,c=k.drop,b=k.liveSelector;var i=droping=center=offset=null,j=this,f=this.length,h=$.map(j.toArray(),function(m){var l=$(m);offset=l.offset();return{minX:offset.left,maxX:offset.left+l[0].offsetWidth,minY:offset.top,maxY:offset.top+l[0].offsetHeight}});$(e).live("mousedown",function(){i=$(this);if(b!=null){j=$(b);f=j.length;h=$.map(j.toArray(),function(m){var l=$(m);offset=l.offset();return{minX:offset.left,maxX:offset.left+l[0].offsetWidth,minY:offset.top,maxY:offset.top+l[0].offsetHeight}})}d?j.addClass(d):""});$(e).live("mouseup",function(){d?j.removeClass(d):"";g?j.removeClass(g):"";if(droping!=null&&i!=null&&c!=null){c(i,droping)}i=null;droping=null});$(e).live("mousemove",function(l){if(i!=null){offset=i.offset();center={x:offset.left+i[0].offsetWidth/2,y:offset.top+i[0].offsetHeight/2};$.each(h,function(m,n){if(center.x>n.minX&&center.x<n.maxX&&center.y>n.minY&&center.y<n.maxY){droping=$(j[m]);droping.addClass(g);return false}if(m==f-1&&droping!=null){droping.addClass(d);droping.removeClass(g);droping=null}})}});return this}})(jQuery);