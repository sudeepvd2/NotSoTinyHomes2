// Adds any extra photos found in a model's image folder.
// Name new photos with the next number, e.g. images/freedom-20ft/exterior-05.jpg, then push.
(function () {
  var EXTS = ['jpg', 'jpeg', 'png', 'webp'];
  var script = document.currentScript;
  var root = script.src.replace(/assets\/gallery\.js.*$/, '');
  function probe(base, i, done) {
    if (i >= EXTS.length) return done(null);
    var url = base + '.' + EXTS[i], im = new Image();
    im.onload = function () { done(url); };
    im.onerror = function () { probe(base, i + 1, done); };
    im.src = url;
  }
  function addSlide(box, url, alt, kind) {
    var imgs = Array.prototype.slice.call(box.querySelectorAll('img'));
    var same = imgs.filter(function (i) { return (i.getAttribute('src') || i.dataset.src || '').indexOf(kind + '-') > -1; });
    var after = same.length ? same[same.length - 1] : imgs[imgs.length - 1];
    var n = after.cloneNode(false);
    ['srcset', 'sizes', 'data-src', 'data-srcset', 'width', 'height', 'loading'].forEach(function (a) { n.removeAttribute(a); });
    n.classList.remove('active'); n.src = url; n.alt = alt;
    after.parentNode.insertBefore(n, after.nextSibling);
    var dots = document.getElementById('d' + box.id.slice(1));
    if (dots && window.goToSlide) {
      var d = document.createElement('button');
      d.className = 'gdot'; dots.appendChild(d);
      var list = dots.querySelectorAll('.gdot'), active = Array.prototype.slice.call(box.querySelectorAll('img')).findIndex(function (i) { return i.classList.contains('active'); });
      list.forEach(function (dot, idx) {
        dot.setAttribute('aria-label', 'Show photo ' + (idx + 1));
        dot.classList.toggle('on', idx === active);
        dot.onclick = function () { window.goToSlide(box.id, idx); };
      });
    }
  }
  function addThumb(box, url, alt) {
    if (!box.querySelector('img')) {
      box.textContent = '';
      box.style.display = 'grid'; box.style.gridTemplateColumns = 'repeat(3,1fr)'; box.style.gap = '8px';
      var a = document.createElement('a'), first = document.createElement('img');
      first.style.cssText = 'width:100%;aspect-ratio:1;object-fit:cover;border-radius:8px';
      a.appendChild(first); box.appendChild(a);
      a.href = url; first.src = url; first.alt = alt;
      return;
    }
    var item = box.querySelector('a,img').cloneNode(true), img = item.querySelector('img') || item;
    ['srcset', 'sizes', 'width', 'height'].forEach(function (a) { img.removeAttribute(a); });
    img.src = url; img.alt = alt; img.loading = 'lazy';
    if (item.tagName === 'A') item.href = url;
    box.appendChild(item);
  }
  function start() { setTimeout(run, 1500); }
  if (document.readyState === 'complete') start(); else window.addEventListener('load', start);
  function run() { document.querySelectorAll('[data-photos]').forEach(function (box) {
    var paths = box.dataset.photos.split(' ');
    (function nextPath(p) {
      if (p >= paths.length) return;
      var path = paths[p], kind = path.split('/')[1], high = 0;
      box.querySelectorAll('img').forEach(function (i) {
        var m = (i.getAttribute('src') || i.dataset.src || '').match(new RegExp(kind + '-(\\d+)'));
        if (m) high = Math.max(high, +m[1]);
      });
      (function next(n) {
        var num = n < 10 ? '0' + n : '' + n;
        probe(root + 'images/' + path + '-' + num, 0, function (url) {
          if (!url) return nextPath(p + 1);
          var alt = path.split('/')[0].replace('freedom-', '') + ' ' + kind + ' photo ' + n;
          (box.classList.contains('model-gallery') ? addSlide : addThumb)(box, url, alt, kind);
          next(n + 1);
        });
      })(high + 1);
    })(0);
  });
  }
})();
