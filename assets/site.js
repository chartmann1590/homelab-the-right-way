(function(){
var RM=window.matchMedia&&window.matchMedia('(prefers-reduced-motion: reduce)').matches;
document.documentElement.classList.remove('no-js');
/* scroll reveal */
var els=[].slice.call(document.querySelectorAll('.reveal'));
if(RM||!('IntersectionObserver' in window)){els.forEach(function(e){e.classList.add('in')});}
else{var io=new IntersectionObserver(function(en){en.forEach(function(x){if(x.isIntersecting){x.target.classList.add('in');io.unobserve(x.target)}})},{rootMargin:'0px 0px -8% 0px',threshold:.08});els.forEach(function(e){io.observe(e)});}
/* reading progress */
var bar=document.querySelector('.progress span');
function prog(){if(!bar)return;var h=document.documentElement,s=h.scrollTop||document.body.scrollTop,m=h.scrollHeight-h.clientHeight;bar.style.width=(m>0?Math.min(100,s/m*100):0)+'%';}
window.addEventListener('scroll',prog,{passive:true});prog();
/* typed terminal */
var lines=[].slice.call(document.querySelectorAll('.term-body .ln'));
if(lines.length){if(RM){lines.forEach(function(l){l.textContent=l.getAttribute('data-line')});}
else{var li=0,ci=0;(function tick(){if(li>=lines.length){return;}var t=lines[li].getAttribute('data-line');if(ci<=t.length){lines[li].textContent=t.slice(0,ci);ci++;setTimeout(tick,22+Math.random()*30);}else{li++;ci=0;setTimeout(tick,420);}})();}}
/* animated network canvas */
var c=document.getElementById('net');
if(c&&!RM&&c.getContext){var ctx=c.getContext('2d'),W,H,pts=[],N,raf,DPR=Math.min(2,window.devicePixelRatio||1);
function size(){var r=c.parentNode.getBoundingClientRect();W=r.width;H=r.height;c.width=W*DPR;c.height=H*DPR;ctx.setTransform(DPR,0,0,DPR,0,0);N=Math.max(28,Math.min(80,Math.round(W*H/16000)));pts=[];for(var i=0;i<N;i++)pts.push({x:Math.random()*W,y:Math.random()*H,vx:(Math.random()-.5)*.35,vy:(Math.random()-.5)*.35,r:1+Math.random()*1.6});}
var mx=-1e4,my=-1e4;c.parentNode.addEventListener('pointermove',function(e){var r=c.getBoundingClientRect();mx=e.clientX-r.left;my=e.clientY-r.top;},{passive:true});
function draw(){ctx.clearRect(0,0,W,H);
/* grid */
ctx.strokeStyle='rgba(25,198,192,.07)';ctx.lineWidth=1;var g=48;for(var x=(Date.now()/60)%g;x<W;x+=g){ctx.beginPath();ctx.moveTo(x,0);ctx.lineTo(x,H);ctx.stroke();}for(var y=0;y<H;y+=g){ctx.beginPath();ctx.moveTo(0,y);ctx.lineTo(W,y);ctx.stroke();}
for(var i=0;i<N;i++){var p=pts[i];p.x+=p.vx;p.y+=p.vy;if(p.x<0||p.x>W)p.vx*=-1;if(p.y<0||p.y>H)p.vy*=-1;
var dx=p.x-mx,dy=p.y-my,dm=dx*dx+dy*dy;if(dm<16000){p.x+=dx*.01;p.y+=dy*.01;}
for(var j=i+1;j<N;j++){var q=pts[j],ex=p.x-q.x,ey=p.y-q.y,d=ex*ex+ey*ey;if(d<17000){var a=1-d/17000;ctx.strokeStyle='rgba(25,198,192,'+(a*.35)+')';ctx.beginPath();ctx.moveTo(p.x,p.y);ctx.lineTo(q.x,q.y);ctx.stroke();}}
ctx.fillStyle=i%7===0?'rgba(245,185,66,.9)':'rgba(25,198,192,.9)';ctx.beginPath();ctx.arc(p.x,p.y,p.r,0,6.283);ctx.fill();}
raf=requestAnimationFrame(draw);}
size();draw();var to;window.addEventListener('resize',function(){clearTimeout(to);to=setTimeout(size,150)});
document.addEventListener('visibilitychange',function(){if(document.hidden){cancelAnimationFrame(raf)}else{draw()}});}
/* 3D tilt on book cards */
if(!RM&&window.matchMedia('(hover:hover)').matches){[].forEach.call(document.querySelectorAll('.tilt'),function(el){el.addEventListener('pointermove',function(e){var r=el.getBoundingClientRect(),x=(e.clientX-r.left)/r.width-.5,y=(e.clientY-r.top)/r.height-.5;el.style.transform='translateY(-6px) perspective(900px) rotateY('+(x*8)+'deg) rotateX('+(-y*8)+'deg)';});el.addEventListener('pointerleave',function(){el.style.transform='';});});}
/* toc highlight */
var toc=document.querySelectorAll('.toc a');if(toc.length&&'IntersectionObserver' in window){var map={};toc.forEach(function(a){map[a.getAttribute('href').slice(1)]=a});var hs=document.querySelectorAll('.prose h2[id]');var o2=new IntersectionObserver(function(en){en.forEach(function(x){if(x.isIntersecting){toc.forEach(function(a){a.classList.remove('active')});var a=map[x.target.id];if(a)a.classList.add('active');}})},{rootMargin:'-20% 0px -70% 0px'});hs.forEach(function(h){o2.observe(h)});}
/* click-to-play YouTube */
document.addEventListener('click',function(e){var a=e.target.closest('.yt-link');if(!a)return;var box=a.parentNode,id=box.getAttribute('data-id');if(!id)return;e.preventDefault();var f=document.createElement('iframe');f.src='https://www.youtube-nocookie.com/embed/'+id+'?autoplay=1&rel=0';f.title='YouTube video';f.allow='accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture; fullscreen';f.allowFullscreen=true;box.innerHTML='';box.appendChild(f);});
})();
