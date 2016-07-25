Prompted = Class.create();
Prompted.prototype = {
  initialize: function(el) {
    this.element = $(el);
    this.prompted_value = $F(this.element);
    this.onfocus = null;
    this.addEvents();
    this.clearValue();
  },
  addEvents: function() {
    this.element.onfocus = this.clearValue.bind(this);
    this.element.onblur = function() {
      this.element.toggleClassName("prompted");
      if($F(this.element).empty()) {
        this.element.value = this.prompted_value;
      }
    }.bind(this)
  },
  clearValue: function() {
    this.element.toggleClassName("prompted");
    if($F(this.element) == this.prompted_value) {
      this.element.value = "";
    }
  }
}

var Cookie = {
  set: function(name, value, daysToExpire) {
    var expire = '';
    if (daysToExpire != undefined) {
      var d = new Date();
      d.setTime(d.getTime() + (86400000 * parseFloat(daysToExpire)));
      expire = '; expires=' + d.toGMTString();
    }
    return (document.cookie = escape(name) + '=' + escape(value || '') + expire + "; path=/");
  },
  get: function(name) {
    var cookie = document.cookie.match(new RegExp('(^|;)\\s*' + escape(name) + '=([^;\\s]*)'));
    return (cookie ? unescape(cookie[2]) : null);
  },
  erase: function(name) {
    var cookie = Cookie.get(name) || true;
    Cookie.set(name, '', -1);
    return cookie;
  },
  accept: function() {
    if (typeof navigator.cookieEnabled == 'boolean') {
      return navigator.cookieEnabled;
    }
    Cookie.set('_test', '1');
    return (Cookie.erase('_test') === '1');
  }
};


LiveSearch = Class.create();
LiveSearch.prototype = {
  initialize: function(searcher_el, search_url) {
    this.timeout; 
    this.last_query;
    this.searcher_el =    $(searcher_el);
    this.search_url =     search_url;
    this.spinner =        this.searcher_el.down('img');
    this.results =        this.getResultsElement();
    this.input =          this.searcher_el.down('input');
    this.input.onkeyup =  this.run.bind(this);
    this.input.onblur =   this.kill.bind(this);
    this.input.setAttribute("autocomplete", "off")
  },
  run: function(event, offset, delay) {
    offset = offset == undefined ? null : offset;
    clearTimeout(this.timeout);
    delay = delay == undefined ? 1000 : delay
    this.timeout = setTimeout(function() {
      this.query = $F(this.input);
      this.can_search = this.query != this.last_query || offset != null ? true : false;
      this.results.onMouseOutside(this.searcher_el, this.blur.bind(this));
      if(this.query.length > 2 && this.can_search) {
        this.spinner.show();
        new Ajax.Request(this.search_url, {
          asynchronous:true,
          evalScripts:true,
          parameters:'query='+this.query+'&offset='+offset,
          method:'get',
          onSuccess: function() {
            this.spinner.hide();
          }.bind(this),
          onFailure: function() {
            this.results.update("<li><p><strong>Woops!</strong> Something broke.</p></li>").show();
            this.kill();
          }.bind(this)
        });
      }
      if(this.query.length < 2) {
        this.results.hide();
      }
      this.last_query = this.query;
    }.bind(this), delay);
  },
  run_with_offset: function(offset) {
    this.run(this, offset, 10)
  },
  kill: function() {
    this.spinner.hide();
    clearTimeout(this.timeout);
  },
  blur: function() {
    this.results = this.getResultsElement()
    this.results.hide();
    this.kill();
  },
  reset: function() {
    this.blur();
    this.last_query = "";
    this.input.setValue('');
    this.input.focus();
    this.results.hide();
  },
  getResultsElement: function() {
    return this.searcher_el.down('.results');
  }
}

Element.addMethods({
  
  onMouseOutside: function(element, boundary, callback) {
    element = $(element);
    document.getElementsByTagName('body')[0].onmousedown = element.targetOutside.bind({element: boundary, callback: callback});
  },
  
  targetOutside: function(options, event) {
    element = $(options.element);
    var target = document.all ? window.event.srcElement : event.target;
    if($(target).outside(element)) {
      document.getElementsByTagName('body')[0].onmousedown = null;
      if(options.callback != null) options.callback();
    }
  },
  
  outside: function(element, scope) {
    element = $(element).firstChild != null ? $(element).firstChild : $(element);
    scope = $(scope);
    return !Element.childOf(element, scope);
  }
  
});

unset_trackback = function() {
  set_trackback = function() {}
}

set_trackback = function() {
  Cookie.erase('trackback');
  Cookie.set('trackback', location.href);
}

Facebox = Class.create();
Facebox.prototype = {
  initialize: function(c) {
    this.fb = $('facebox');
    this.load(c);
    this.show();
  },
  load: function(c) {
    this.fb.down('.content').update(c);
  },
  show: function() {
    $('overlay').show();
    this.fb.show();
  },
  close: function() {
    this.fb.hide();
    $('overlay').hide();
  }
}

over_rating = function(el, index) {
  var stars = $(el).up('.rating').select('a');
  stars.each(function(star, i) {
    if(i < index) {
      star.addClassName("on");
    } else {
      star.removeClassName("on");
    }
  });
}

reset_rating = function(el, index) {
  var stars = $(el).select('a');
  stars.each(function(star, i) {
    if(i < index) {
      star.addClassName("on");
    } else {
      star.removeClassName("on");
    }
  });
}

show_flash = function(msg) {
  if(msg) {
    $('flash_notice').update(msg)
  }
  new Effect.Appear('flash_notice', {duration: 0.6});      
  new Effect.Fade('flash_notice', {delay: 3});
}

show_feedback_widget_for = function(style) {
  feedback_widget.show();
}