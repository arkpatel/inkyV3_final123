/* ============================================================
   custom.js  —  Financial Choices visual layer

   Drop into your Inky web export folder.
   DO NOT replace main.js — this runs alongside it.

   Add to index.html (before </body>):
     <script src="custom.js"></script>

   Add to index.html (replacing <div id="story"></div>):
     <div id="fc-restart-btn">↻ Restart</div>
     <div id="fc-hud"></div>
     <div id="path-banner"></div>
     <div id="story"></div>
   ============================================================ */

(function () {
  "use strict";

  /* ══════════════════════════════════════════════════════════
     SVG BANNER IMAGES — one illustrated scene per path
     ══════════════════════════════════════════════════════════ */
  var BANNERS = {

    invest: '<svg viewBox="0 0 720 150" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="ig" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#05120b"/><stop offset="100%" stop-color="#091a0e"/></linearGradient></defs><rect width="720" height="150" fill="url(#ig)"/><g stroke="#1b5e20" stroke-width="0.5" opacity="0.4"><line x1="0" y1="30" x2="720" y2="30"/><line x1="0" y1="60" x2="720" y2="60"/><line x1="0" y1="90" x2="720" y2="90"/><line x1="0" y1="120" x2="720" y2="120"/></g><polygon points="40,130 120,110 200,100 280,80 360,65 440,45 520,35 600,20 680,10 680,150 40,150" fill="#4caf50" opacity="0.08"/><polyline points="40,130 120,110 200,100 280,80 360,65 440,45 520,35 600,20 680,10" fill="none" stroke="#4caf50" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/><circle cx="600" cy="20" r="6" fill="#81c784"/><text x="36" y="26" font-family="monospace" font-size="12" fill="#4caf50" opacity="0.7">PORTFOLIO GROWTH</text></svg>',

    crypto: '<svg viewBox="0 0 720 150" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="cg" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#08001a"/><stop offset="100%" stop-color="#100025"/></linearGradient></defs><rect width="720" height="150" fill="url(#cg)"/><polyline points="20,80 60,40 100,95 140,30 180,110 220,50 260,120 300,35 340,90 380,20 420,100 460,55 500,130 540,40 580,70 620,25 680,85" fill="none" stroke="#ce93d8" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/><circle cx="380" cy="20" r="7" fill="#e040fb" opacity="0.9"/><line x1="490" y1="10" x2="510" y2="145" stroke="#ef5350" stroke-width="1.2" stroke-dasharray="4,3" opacity="0.6"/><text x="514" y="22" font-family="monospace" font-size="9" fill="#ef5350" opacity="0.8">CRASH</text><text x="22" y="22" font-family="monospace" font-size="11" fill="#ce93d8" opacity="0.7">$DONUT  •  LIVE CHART</text></svg>',

    gamble: '<svg viewBox="0 0 720 150" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="gg" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#1a0303"/><stop offset="100%" stop-color="#0d0101"/></linearGradient></defs><rect width="720" height="150" fill="url(#gg)"/><rect x="80" y="35" width="52" height="76" rx="5" fill="#111" stroke="#444" stroke-width="1"/><rect x="84" y="39" width="44" height="68" rx="3" fill="#1a1a1a"/><text x="88" y="58" font-family="Georgia,serif" font-size="20" fill="#ef5350">A</text><text x="88" y="78" font-family="Georgia,serif" font-size="16" fill="#ef5350">♠</text><rect x="148" y="35" width="52" height="76" rx="5" fill="#111" stroke="#444" stroke-width="1"/><rect x="152" y="39" width="44" height="68" rx="3" fill="#1a1a1a"/><text x="156" y="58" font-family="Georgia,serif" font-size="20" fill="#e8e8e0">K</text><text x="156" y="78" font-family="Georgia,serif" font-size="16" fill="#e8e8e0">♦</text><rect x="560" y="40" width="50" height="50" rx="8" fill="#e8e8e0"/><circle cx="575" cy="55" r="4" fill="#111"/><circle cx="595" cy="55" r="4" fill="#111"/><circle cx="585" cy="65" r="4" fill="#111"/><circle cx="575" cy="75" r="4" fill="#111"/><circle cx="595" cy="75" r="4" fill="#111"/><circle cx="340" cy="80" r="22" fill="#1b5e20" stroke="#4caf50" stroke-width="2"/><text x="328" y="85" font-family="Georgia" font-size="11" fill="#fff" font-weight="bold">$100</text><text x="22" y="24" font-family="sans-serif" font-size="12" fill="#ef5350" opacity="0.7" letter-spacing="2">THE HOUSE ALWAYS WINS</text></svg>',

    spend: '<svg viewBox="0 0 720 150" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="spg" x1="0" y1="0" x2="1" y2="0"><stop offset="0%" stop-color="#150e00"/><stop offset="100%" stop-color="#1a1200"/></linearGradient></defs><rect width="720" height="150" fill="url(#spg)"/><rect x="60" y="50" width="55" height="65" rx="4" fill="#222" stroke="#e65100" stroke-width="1.5"/><path d="M70,50 Q87,30 105,50" fill="none" stroke="#e65100" stroke-width="2"/><rect x="130" y="45" width="65" height="72" rx="4" fill="#1a1a1a" stroke="#ffb74d" stroke-width="1.5"/><path d="M142,45 Q163,22 178,45" fill="none" stroke="#ffb74d" stroke-width="2"/><rect x="460" y="20" width="80" height="115" rx="2" fill="#f5f5f5" opacity="0.9"/><text x="465" y="35" font-family="monospace" font-size="8" fill="#333">RECEIPT</text><text x="465" y="115" font-family="monospace" font-size="8" fill="#e65100" font-weight="bold">TOTAL: $1,000</text><text x="22" y="24" font-family="sans-serif" font-size="12" fill="#ffb74d" opacity="0.7">TREAT YOURSELF</text></svg>',

    debt: '<svg viewBox="0 0 720 150" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="dg" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#010e1a"/><stop offset="100%" stop-color="#011422"/></linearGradient></defs><rect width="720" height="150" fill="url(#dg)"/><rect x="60" y="30" width="200" height="110" rx="12" fill="#1a2744" stroke="#1565c0" stroke-width="1.5"/><rect x="60" y="65" width="200" height="22" fill="#1565c0" opacity="0.4"/><rect x="82" y="44" width="32" height="24" rx="4" fill="#ffd54f" opacity="0.8"/><text x="82" y="128" font-family="monospace" font-size="10" fill="#90caf9" opacity="0.8">24.99% APR</text><rect x="340" y="35" width="280" height="18" rx="4" fill="#0d1f33"/><rect x="340" y="35" width="210" height="18" rx="4" fill="#1565c0" opacity="0.7"/><text x="344" y="48" font-family="monospace" font-size="9" fill="#64b5f6">INTEREST PAID: $680</text><text x="22" y="24" font-family="Georgia,serif" font-size="12" fill="#64b5f6" opacity="0.7" font-style="italic">minimum payment accepted</text></svg>',

    mlm: '<svg viewBox="0 0 720 150" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="mg" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#110d00"/><stop offset="100%" stop-color="#181400"/></linearGradient></defs><rect width="720" height="150" fill="url(#mg)"/><polygon points="360,15 520,130 200,130" fill="none" stroke="#ffd54f" stroke-width="2"/><polygon points="360,15 430,72 290,72" fill="#ffd54f" opacity="0.07"/><circle cx="360" cy="22" r="8" fill="#f9a825" opacity="0.9"/><circle cx="300" cy="68" r="6" fill="#ffd54f" opacity="0.7"/><circle cx="420" cy="68" r="6" fill="#ffd54f" opacity="0.7"/><circle cx="240" cy="118" r="5" fill="#ffd54f" opacity="0.5"/><circle cx="320" cy="118" r="5" fill="#ffd54f" opacity="0.5"/><circle cx="400" cy="118" r="5" fill="#ffd54f" opacity="0.5"/><circle cx="480" cy="118" r="5" fill="#ffd54f" opacity="0.5"/><line x1="360" y1="30" x2="300" y2="62" stroke="#f9a825" stroke-width="1" opacity="0.5"/><line x1="360" y1="30" x2="420" y2="62" stroke="#f9a825" stroke-width="1" opacity="0.5"/><text x="22" y="24" font-family="monospace" font-size="11" fill="#ffd54f" opacity="0.7">FINANCIAL FREEDOM OPPORTUNITY</text></svg>',

    party: '<svg viewBox="0 0 720 150" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="pg" x1="0" y1="0" x2="1" y2="1"><stop offset="0%" stop-color="#12000e"/><stop offset="100%" stop-color="#1a0018"/></linearGradient></defs><rect width="720" height="150" fill="url(#pg)"/><circle cx="80" cy="30" r="5" fill="#f06292"/><circle cx="150" cy="60" r="3" fill="#ce93d8"/><circle cx="50" cy="100" r="4" fill="#ffd54f"/><circle cx="200" cy="20" r="3" fill="#4fc3f7"/><circle cx="250" cy="80" r="5" fill="#f06292"/><circle cx="500" cy="25" r="4" fill="#ffb74d"/><circle cx="560" cy="70" r="5" fill="#ce93d8"/><circle cx="620" cy="30" r="3" fill="#f06292"/><circle cx="680" cy="90" r="4" fill="#ffd54f"/><polyline points="300,90 308,60 316,100 324,50 332,85 340,70 348,95 356,55 364,80 372,65 380,90" fill="none" stroke="#f06292" stroke-width="2" opacity="0.5"/><text x="22" y="24" font-family="sans-serif" font-size="14" fill="#f06292" opacity="0.7" letter-spacing="3">LIVE FOR THE MOMENT</text></svg>',

    recovery: '<svg viewBox="0 0 720 150" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="rg" x1="0" y1="0" x2="1" y2="1"><stop offset="0%" stop-color="#001614"/><stop offset="100%" stop-color="#001f1c"/></linearGradient></defs><rect width="720" height="150" fill="url(#rg)"/><line x1="0" y1="105" x2="720" y2="105" stroke="#00796b" stroke-width="0.8" opacity="0.4"/><circle cx="360" cy="115" r="45" fill="#4db6ac" opacity="0.1"/><circle cx="360" cy="115" r="28" fill="#4db6ac" opacity="0.15"/><circle cx="360" cy="115" r="14" fill="#80cbc4" opacity="0.3"/><line x1="560" y1="105" x2="560" y2="75" stroke="#4caf50" stroke-width="2"/><ellipse cx="553" cy="82" rx="10" ry="6" fill="#388e3c" opacity="0.7" transform="rotate(-20 553 82)"/><ellipse cx="568" cy="78" rx="10" ry="6" fill="#4caf50" opacity="0.7" transform="rotate(20 568 78)"/><text x="22" y="24" font-family="Georgia,serif" font-size="12" fill="#4db6ac" opacity="0.7" font-style="italic">one day at a time</text></svg>',

    neutral: '<svg viewBox="0 0 720 150" xmlns="http://www.w3.org/2000/svg"><rect width="720" height="150" fill="#0d0d0d"/><text x="360" y="65" dominant-baseline="middle" text-anchor="middle" font-family="Georgia,serif" font-size="28" fill="#9e9e9e" opacity="0.5" font-style="italic">Financial Choices</text><text x="360" y="100" dominant-baseline="middle" text-anchor="middle" font-family="monospace" font-size="11" fill="#555" letter-spacing="4">AGE 18  ·  $1,000  ·  ONE DECISION</text></svg>'
  };

  /* ══════════════════════════════════════════════════════════
     STATE
     ══════════════════════════════════════════════════════════ */
  var THEMES = ["invest","crypto","gamble","spend","debt","mlm","party","recovery","neutral"];

  var currentTheme  = null;
  var currentEnding = null;
  var bannerEl      = null;
  var hudEl         = null;
  var restartBtnEl  = null;

  // Tracked stats — live values, scraped from the story text
  var stats = {
    age:    18,
    hp:     100,
    mp:     100,
    money:  1000,
    rep:    100,
    streak: 0,
    debt:   0,
    mentor: false,
    fund:   false,
    side:   false
  };

  /* ══════════════════════════════════════════════════════════
     HELPERS
     ══════════════════════════════════════════════════════════ */

  function clearClasses(prefix) {
    var remove = [];
    document.body.classList.forEach(function(c) {
      if (c.startsWith(prefix)) remove.push(c);
    });
    remove.forEach(function(c) { document.body.classList.remove(c); });
  }

  function setTheme(name) {
    if (name === currentTheme) return;
    if (THEMES.indexOf(name) === -1) return;
    currentTheme = name;
    clearClasses("fc-theme-");
    document.body.classList.add("fc-theme-" + name);

    if (bannerEl) {
      bannerEl.innerHTML = BANNERS[name] || BANNERS.neutral;
      bannerEl.style.display = "block";
      bannerEl.style.animation = "none";
      bannerEl.offsetHeight;
      bannerEl.style.animation = "";
    }
  }

  function setEnding(type) {
    if (type === currentEnding) return;
    currentEnding = type;
    clearClasses("fc-ending-");
    if (type) document.body.classList.add("fc-ending-" + type);
  }

  function hpLevel(val) {
    if (val >= 80) return "high";
    if (val >= 55) return "medium";
    if (val >= 30) return "low";
    return "critical";
  }

  function applyHpClass() {
    clearClasses("fc-hp-");
    document.body.classList.add("fc-hp-" + hpLevel(stats.hp));
  }

  /* ══════════════════════════════════════════════════════════
     STAT SCRAPER
     Reads numbers off the story text whenever a paragraph
     appears, so the HUD can update live.
     ══════════════════════════════════════════════════════════ */

  function scrapeStats(text) {
    // HP
    var m;
    if ((m = text.match(/\bHP[:\s]+(-?\d+)/i)))    stats.hp = parseInt(m[1], 10);
    if ((m = text.match(/\bMP[:\s]+(-?\d+)/i)))    stats.mp = parseInt(m[1], 10);
    if ((m = text.match(/\bREP[:\s]+(-?\d+)/i)))   stats.rep = parseInt(m[1], 10);
    if ((m = text.match(/\bAGE[:\s]+(\d+)/i)))     stats.age = parseInt(m[1], 10);
    if ((m = text.match(/\$\s*(-?[\d,]+)/)))       stats.money = parseInt(m[1].replace(/,/g, ""), 10);
    if ((m = text.match(/STREAK[:\s]+(\d+)/i)))    stats.streak = parseInt(m[1], 10);
    if ((m = text.match(/\bDEBT[:\s]+(\d+)/i)))    stats.debt = parseInt(m[1], 10);

    // Boolean flags from text content
    if (/MENTOR ACTIVE|MENTOR \•|🧭/.test(text))   stats.mentor = true;
    if (/EMERGENCY FUND/i.test(text))               stats.fund = true;
    if (/SIDE INCOME/i.test(text))                  stats.side = true;
  }

  /* ══════════════════════════════════════════════════════════
     HUD
     ══════════════════════════════════════════════════════════ */

  function buildHud() {
    if (!hudEl) return;

    function bar(label, val, max, cls) {
      var pct = Math.max(0, Math.min(100, Math.round(val / max * 100)));
      return ''
        + '<div class="fc-hud-bar ' + cls + '">'
        +   '<div class="fc-hud-bar-label">'
        +     '<span>' + label + '</span>'
        +     '<span class="fc-hud-bar-val">' + val + '</span>'
        +   '</div>'
        +   '<div class="fc-hud-bar-track">'
        +     '<div class="fc-hud-bar-fill" style="width:' + pct + '%"></div>'
        +   '</div>'
        + '</div>';
    }

    function flag(label, on, icon) {
      return '<div class="fc-hud-flag ' + (on ? 'on' : 'off') + '"><span>' + icon + '</span> ' + label + '</div>';
    }

    var moneyDisplay = stats.money >= 0
      ? "$" + stats.money.toLocaleString()
      : "-$" + Math.abs(stats.money).toLocaleString();

    hudEl.innerHTML = ''
      + '<div class="fc-hud-row fc-hud-top">'
      +   '<div class="fc-hud-stat-block"><span class="fc-hud-key">AGE</span><span class="fc-hud-num">' + stats.age + '</span></div>'
      +   '<div class="fc-hud-stat-block fc-hud-money"><span class="fc-hud-key">CASH</span><span class="fc-hud-num">' + moneyDisplay + '</span></div>'
      + '</div>'
      + '<div class="fc-hud-bars">'
      +   bar("Physical Health", stats.hp, 100, "fc-bar-hp")
      +   bar("Mental Health",   stats.mp, 100, "fc-bar-mp")
      +   bar("Friends / Rep",   stats.rep, 150, "fc-bar-rep")
      + '</div>'
      + '<div class="fc-hud-flags">'
      +   flag("Mentor",         stats.mentor, "🧭")
      +   flag("Emergency Fund", stats.fund,   "🛡️")
      +   flag("Side Income",    stats.side,   "💼")
      + (stats.streak > 0 ? '<div class="fc-hud-flag on"><span>🌿</span> Sober ' + stats.streak + 'mo</div>' : '')
      + (stats.debt > 0 ? '<div class="fc-hud-flag on fc-hud-debt"><span>💳</span> Debts: ' + stats.debt + '</div>' : '')
      + '</div>';

    applyHpClass();
  }

  /* ══════════════════════════════════════════════════════════
     RESTART BUTTON
     ══════════════════════════════════════════════════════════ */

  function setupRestartButton() {
    if (!restartBtnEl) return;
    restartBtnEl.addEventListener("click", function () {
      if (!confirm("Restart the story from the beginning?")) return;

      // Reset visual state
      stats = { age:18, hp:100, mp:100, money:1000, rep:100,
                streak:0, debt:0, mentor:false, fund:false, side:false };
      buildHud();
      setTheme("neutral");
      setEnding(null);

      // Reload — the cleanest restart since we don't know
      // exactly how Inky's main.js manages state.
      window.location.reload();
    });
  }

  /* ══════════════════════════════════════════════════════════
     PARAGRAPH OBSERVER
     ══════════════════════════════════════════════════════════ */

  function scanParagraph(p) {
    var text = p.textContent || "";

    // Tag detection
    var themeMatch  = text.match(/#theme:(\w+)/);
    var endingMatch = text.match(/#ending:(\w+)/);

    if (themeMatch)  setTheme(themeMatch[1]);
    if (endingMatch) setEnding(endingMatch[1]);

    // Scrape stats
    scrapeStats(text);
    buildHud();

    // Visual class
    p.classList.add("fc-new-para");
    if (/^[\s━╔╗╚╝║═]+/.test(text.trim())) {
      p.classList.add("fc-header-line");
    }

    // Hide raw "#theme:" / "#ending:" tag lines if Inky leaks them
    if (/^\s*#\w+:\w+/.test(text.trim())) {
      p.style.display = "none";
    }

    // Wrap HP value with coloured span
    if (/HP:\s*-?\d+/i.test(text)) {
      p.innerHTML = p.innerHTML.replace(
        /\bHP:(\s*)(-?\d+)/gi,
        'HP:$1<span class="fc-hp-val">$2</span>'
      );
    }
  }

  function observeStory() {
    var storyEl = document.getElementById("story");
    if (!storyEl) return;

    // Scan anything already there
    storyEl.querySelectorAll("p").forEach(scanParagraph);

    var observer = new MutationObserver(function (mutations) {
      mutations.forEach(function (m) {
        m.addedNodes.forEach(function (node) {
          if (node.nodeType === 1) {
            if (node.tagName === "P") scanParagraph(node);
            node.querySelectorAll && node.querySelectorAll("p").forEach(scanParagraph);
          }
        });
      });
    });
    observer.observe(storyEl, { childList: true, subtree: true });
  }

  /* ══════════════════════════════════════════════════════════
     INIT
     ══════════════════════════════════════════════════════════ */

  function init() {
    bannerEl     = document.getElementById("path-banner");
    hudEl        = document.getElementById("fc-hud");
    restartBtnEl = document.getElementById("fc-restart-btn");

    document.body.classList.add("fc-theme-neutral");
    document.body.classList.add("fc-hp-high");
    currentTheme = "neutral";

    if (bannerEl) {
      bannerEl.innerHTML = BANNERS.neutral;
      bannerEl.style.display = "block";
    }

    setupRestartButton();
    buildHud();
    observeStory();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }

}());
