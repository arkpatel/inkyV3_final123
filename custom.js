/* ============================================================
   custom.js  —  Financial Choices  |  Flash Game Layer
   Animated GIF-style SVG sprites + always-on HUD
   ============================================================ */

(function () {
  "use strict";

  /* ══════════════════════════════════════════════════════════
     ANIMATED SVG SPRITES  (one per theme — loop like GIFs)
     ══════════════════════════════════════════════════════════ */
  var SPRITES = {

    /* ─── NEUTRAL: pulsing coin + floating $$ ─── */
    neutral:
      '<svg viewBox="0 0 760 200" xmlns="http://www.w3.org/2000/svg">' +
      '<rect width="760" height="200" fill="#000"/>' +
      /* pixel grid */
      '<line x1="0" y1="50" x2="760" y2="50" stroke="#0a200a" stroke-width="1"/>' +
      '<line x1="0" y1="100" x2="760" y2="100" stroke="#0a200a" stroke-width="1"/>' +
      '<line x1="0" y1="150" x2="760" y2="150" stroke="#0a200a" stroke-width="1"/>' +
      /* big $ pulse */
      '<text x="380" y="115" text-anchor="middle" dominant-baseline="middle" font-family="monospace" font-size="90" font-weight="bold" fill="#00ff41" opacity="0.12">' +
      '$<animate attributeName="opacity" values="0.1;0.22;0.1" dur="2.2s" repeatCount="indefinite"/>' +
      '<animateTransform attributeName="transform" type="scale" values="1;1.04;1" dur="2.2s" additive="sum" repeatCount="indefinite"/>' +
      '</text>' +
      /* floating mini $ */
      '<text x="80"  y="60" font-family="monospace" font-size="16" fill="#00ff41" opacity="0.4">$<animateTransform attributeName="transform" type="translate" values="0 0;0 -50" dur="3s" repeatCount="indefinite"/><animate attributeName="opacity" values="0.4;0" dur="3s" repeatCount="indefinite"/></text>' +
      '<text x="200" y="140" font-family="monospace" font-size="12" fill="#00cc33" opacity="0.3">$<animateTransform attributeName="transform" type="translate" values="0 0;0 -60" dur="4s" begin="1s" repeatCount="indefinite"/><animate attributeName="opacity" values="0.3;0" dur="4s" begin="1s" repeatCount="indefinite"/></text>' +
      '<text x="560" y="80" font-family="monospace" font-size="14" fill="#00ff41" opacity="0.35">$<animateTransform attributeName="transform" type="translate" values="0 0;0 -45" dur="3.5s" begin="0.5s" repeatCount="indefinite"/><animate attributeName="opacity" values="0.35;0" dur="3.5s" begin="0.5s" repeatCount="indefinite"/></text>' +
      '<text x="680" y="120" font-family="monospace" font-size="18" fill="#00cc33" opacity="0.3">$<animateTransform attributeName="transform" type="translate" values="0 0;0 -55" dur="5s" begin="2s" repeatCount="indefinite"/><animate attributeName="opacity" values="0.3;0" dur="5s" begin="2s" repeatCount="indefinite"/></text>' +
      /* title */
      '<text x="380" y="30" text-anchor="middle" font-family="monospace" font-size="13" fill="#00ff41" opacity="0.75" letter-spacing="6">FINANCIAL CHOICES</text>' +
      '<text x="380" y="185" text-anchor="middle" font-family="monospace" font-size="9" fill="#336633" letter-spacing="4">AGE 18  ·  $1,000  ·  ONE DECISION</text>' +
      '</svg>',

    /* ─── INVEST: stock chart draws itself ─── */
    invest:
      '<svg viewBox="0 0 760 200" xmlns="http://www.w3.org/2000/svg">' +
      '<rect width="760" height="200" fill="#000"/>' +
      /* grid lines */
      '<line x1="50" y1="35" x2="750" y2="35" stroke="#0d2a0d" stroke-width="1"/>' +
      '<line x1="50" y1="70" x2="750" y2="70" stroke="#0d2a0d" stroke-width="1"/>' +
      '<line x1="50" y1="105" x2="750" y2="105" stroke="#0d2a0d" stroke-width="1"/>' +
      '<line x1="50" y1="140" x2="750" y2="140" stroke="#0d2a0d" stroke-width="1"/>' +
      '<line x1="50" y1="175" x2="750" y2="175" stroke="#0d2a0d" stroke-width="1"/>' +
      /* y-axis */
      '<line x1="50" y1="20" x2="50" y2="180" stroke="#1a4a1a" stroke-width="1.5"/>' +
      /* chart fill */
      '<polygon points="50,168 160,150 270,128 380,100 490,70 600,45 700,22 730,15 730,180 50,180" fill="#00e676" opacity="0.07"/>' +
      /* animated chart line */
      '<polyline points="50,168 160,150 270,128 380,100 490,70 600,45 700,22 730,15"' +
      ' fill="none" stroke="#00e676" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"' +
      ' stroke-dasharray="920" stroke-dashoffset="920">' +
      '<animate attributeName="stroke-dashoffset" from="920" to="0" dur="2.8s" fill="freeze" repeatCount="indefinite" begin="0s"/>' +
      '</polyline>' +
      /* glowing peak dot */
      '<circle cx="730" cy="15" r="5" fill="#69f0ae" opacity="0">' +
      '<animate attributeName="opacity" values="0;0;0;1" keyTimes="0;0.85;0.9;1" dur="2.8s" fill="freeze" repeatCount="indefinite"/>' +
      '<animate attributeName="r" values="5;8;5" dur="1.4s" begin="2.8s" repeatCount="indefinite"/>' +
      '</circle>' +
      /* +% label (appears after draw) */
      '<text x="695" y="10" font-family="monospace" font-size="10" fill="#69f0ae" opacity="0">' +
      '▲+247%<animate attributeName="opacity" values="0;0;1" keyTimes="0;0.9;1" dur="2.8s" fill="freeze" repeatCount="indefinite"/>' +
      '</text>' +
      /* axis labels */
      '<text x="4" y="178" font-family="monospace" font-size="8" fill="#1a4a1a">$0</text>' +
      '<text x="4" y="30" font-family="monospace" font-size="8" fill="#1a4a1a">∞</text>' +
      '<text x="55" y="194" font-family="monospace" font-size="9" fill="#00e676" opacity="0.5" letter-spacing="3">PORTFOLIO GROWTH</text>' +
      '</svg>',

    /* ─── CRYPTO: chaotic candles + blinking CRASH ─── */
    crypto:
      '<svg viewBox="0 0 760 200" xmlns="http://www.w3.org/2000/svg">' +
      '<rect width="760" height="200" fill="#000"/>' +
      /* grid */
      '<line x1="0" y1="50" x2="760" y2="50" stroke="#1a003a" stroke-width="1"/>' +
      '<line x1="0" y1="100" x2="760" y2="100" stroke="#1a003a" stroke-width="1"/>' +
      '<line x1="0" y1="150" x2="760" y2="150" stroke="#1a003a" stroke-width="1"/>' +
      /* candles — each appears after a delay */
      /* green candles (up) */
      '<g opacity="0"><rect x="40" y="70" width="18" height="60" fill="#00e676"/><line x1="49" y1="55" x2="49" y2="70" stroke="#00e676" stroke-width="2"/><line x1="49" y1="130" x2="49" y2="155" stroke="#00e676" stroke-width="2"/><animate attributeName="opacity" from="0" to="1" dur="0.2s" begin="0.1s" fill="freeze"/></g>' +
      '<g opacity="0"><rect x="110" y="55" width="18" height="75" fill="#00e676"/><line x1="119" y1="40" x2="119" y2="55" stroke="#00e676" stroke-width="2"/><line x1="119" y1="130" x2="119" y2="160" stroke="#00e676" stroke-width="2"/><animate attributeName="opacity" from="0" to="1" dur="0.2s" begin="0.3s" fill="freeze"/></g>' +
      /* red candles (down) */
      '<g opacity="0"><rect x="180" y="95" width="18" height="70" fill="#ff5252"/><line x1="189" y1="75" x2="189" y2="95" stroke="#ff5252" stroke-width="2"/><line x1="189" y1="165" x2="189" y2="180" stroke="#ff5252" stroke-width="2"/><animate attributeName="opacity" from="0" to="1" dur="0.2s" begin="0.5s" fill="freeze"/></g>' +
      '<g opacity="0"><rect x="250" y="45" width="18" height="50" fill="#00e676"/><line x1="259" y1="30" x2="259" y2="45" stroke="#00e676" stroke-width="2"/><line x1="259" y1="95" x2="259" y2="120" stroke="#00e676" stroke-width="2"/><animate attributeName="opacity" from="0" to="1" dur="0.2s" begin="0.7s" fill="freeze"/></g>' +
      '<g opacity="0"><rect x="320" y="110" width="18" height="65" fill="#ff5252"/><line x1="329" y1="85" x2="329" y2="110" stroke="#ff5252" stroke-width="2"/><line x1="329" y1="175" x2="329" y2="190" stroke="#ff5252" stroke-width="2"/><animate attributeName="opacity" from="0" to="1" dur="0.2s" begin="0.9s" fill="freeze"/></g>' +
      '<g opacity="0"><rect x="390" y="30" width="18" height="90" fill="#00e676"/><line x1="399" y1="15" x2="399" y2="30" stroke="#00e676" stroke-width="2"/><line x1="399" y1="120" x2="399" y2="145" stroke="#00e676" stroke-width="2"/><animate attributeName="opacity" from="0" to="1" dur="0.2s" begin="1.1s" fill="freeze"/></g>' +
      /* CRASH zone — big red candles */
      '<g opacity="0"><rect x="460" y="120" width="18" height="70" fill="#ff5252"/><line x1="469" y1="90" x2="469" y2="120" stroke="#ff5252" stroke-width="2"/><line x1="469" y1="190" x2="469" y2="200" stroke="#ff5252" stroke-width="2"/><animate attributeName="opacity" from="0" to="1" dur="0.2s" begin="1.3s" fill="freeze"/></g>' +
      '<g opacity="0"><rect x="530" y="140" width="18" height="55" fill="#ff5252"/><line x1="539" y1="110" x2="539" y2="140" stroke="#ff5252" stroke-width="2"/><animate attributeName="opacity" from="0" to="1" dur="0.2s" begin="1.5s" fill="freeze"/></g>' +
      /* crash divider */
      '<line x1="450" y1="5" x2="450" y2="200" stroke="#ff5252" stroke-width="1.2" stroke-dasharray="5,4" opacity="0.5">' +
      '<animate attributeName="opacity" values="0;0;0.5" keyTimes="0;0.8;1" dur="1.5s" fill="freeze"/>' +
      '</line>' +
      /* CRASH text */
      '<text x="458" y="22" font-family="monospace" font-size="14" fill="#ff5252" font-weight="bold" opacity="0">' +
      '⚠ CRASH<animate attributeName="opacity" values="0;0;1;0;1;0;1" keyTimes="0;0.82;0.85;0.88;0.91;0.95;1" dur="4s" repeatCount="indefinite"/>' +
      '</text>' +
      '<text x="10" y="20" font-family="monospace" font-size="10" fill="#ea80fc" opacity="0.65" letter-spacing="2">$DONUT  LIVE CHART</text>' +
      '</svg>',

    /* ─── GAMBLE: spinning coin + slot symbols ─── */
    gamble:
      '<svg viewBox="0 0 760 200" xmlns="http://www.w3.org/2000/svg">' +
      '<rect width="760" height="200" fill="#000"/>' +
      /* spinning coin (scaleX oscillates 1→0.15→-1→0.15→1 = spin illusion) */
      '<g transform="translate(380,100)">' +
      '<ellipse cx="0" cy="0" rx="55" ry="55" fill="#b8860b" stroke="#ffd700" stroke-width="3">' +
      '<animate attributeName="rx" values="55;8;55;8;55" dur="2s" repeatCount="indefinite"/>' +
      '</ellipse>' +
      '<text x="0" y="8" text-anchor="middle" font-family="monospace" font-size="28" fill="#ffd700" font-weight="bold">' +
      '$<animate attributeName="opacity" values="1;0;1;0;1" dur="2s" repeatCount="indefinite"/>' +
      '</text>' +
      '</g>' +
      /* card symbols */
      '<text x="80"  y="110" font-family="serif" font-size="48" fill="#ff5252" opacity="0.7">♥</text>' +
      '<text x="150" y="110" font-family="serif" font-size="48" fill="#eee"    opacity="0.7">♠</text>' +
      '<text x="590" y="110" font-family="serif" font-size="48" fill="#ff5252" opacity="0.7">♦</text>' +
      '<text x="660" y="110" font-family="serif" font-size="48" fill="#eee"    opacity="0.7">♣</text>' +
      /* dice */
      '<rect x="60" y="130" width="40" height="40" rx="4" fill="#eee" opacity="0.85"/>' +
      '<circle cx="75" cy="145" r="4" fill="#111"/>' +
      '<circle cx="95" cy="145" r="4" fill="#111"/>' +
      '<circle cx="85" cy="160" r="4" fill="#111"/>' +
      /* slot machine frame */
      '<rect x="310" y="148" width="140" height="46" rx="3" fill="#1a0303" stroke="#ff5252" stroke-width="2"/>' +
      '<text x="380" y="174" text-anchor="middle" font-family="monospace" font-size="11" fill="#ffd700">$100</text>' +
      /* flashing text */
      '<text x="380" y="20" text-anchor="middle" font-family="monospace" font-size="11" fill="#ff5252" letter-spacing="4" opacity="0.8">' +
      'THE HOUSE ALWAYS WINS<animate attributeName="opacity" values="0.8;0.2;0.8" dur="1.8s" repeatCount="indefinite"/>' +
      '</text>' +
      '</svg>',

    /* ─── SPEND: money flying + bouncing bag ─── */
    spend:
      '<svg viewBox="0 0 760 200" xmlns="http://www.w3.org/2000/svg">' +
      '<rect width="760" height="200" fill="#000"/>' +
      /* shopping bag 1 */
      '<rect x="80" y="70" width="60" height="80" rx="4" fill="#1a0d00" stroke="#ffab40" stroke-width="2"/>' +
      '<path d="M92,70 Q110,48 128,70" fill="none" stroke="#ffab40" stroke-width="2.5"/>' +
      '<text x="100" y="115" font-family="monospace" font-size="14" fill="#ffab40">🛍</text>' +
      /* shopping bag 2 */
      '<rect x="180" y="60" width="75" height="90" rx="4" fill="#1a0d00" stroke="#ff6d00" stroke-width="2"/>' +
      '<path d="M195,60 Q218,35 240,60" fill="none" stroke="#ff6d00" stroke-width="2.5"/>' +
      '<text x="200" y="110" font-family="monospace" font-size="16" fill="#ff6d00">🛍</text>' +
      /* bouncing money bag */
      '<g>' +
      '<animateTransform attributeName="transform" type="translate" values="0,0;0,-18;0,0;0,-10;0,0" dur="1.4s" repeatCount="indefinite"/>' +
      '<circle cx="540" cy="105" r="45" fill="#b8860b" stroke="#ffd700" stroke-width="3"/>' +
      '<text x="540" y="115" text-anchor="middle" font-family="monospace" font-size="22" fill="#ffd700" font-weight="bold">$</text>' +
      '</g>' +
      /* floating $ symbols */
      '<text x="490" y="160" font-family="monospace" font-size="16" fill="#ffd740" opacity="0.9">$<animateTransform attributeName="transform" type="translate" values="0,0;10,-80" dur="1.6s" repeatCount="indefinite"/><animate attributeName="opacity" values="0.9;0" dur="1.6s" repeatCount="indefinite"/></text>' +
      '<text x="560" y="175" font-family="monospace" font-size="13" fill="#ffab40" opacity="0.8">$<animateTransform attributeName="transform" type="translate" values="0,0;-8,-70" dur="2s" begin="0.4s" repeatCount="indefinite"/><animate attributeName="opacity" values="0.8;0" dur="2s" begin="0.4s" repeatCount="indefinite"/></text>' +
      '<text x="600" y="155" font-family="monospace" font-size="18" fill="#ffd740" opacity="0.7">$<animateTransform attributeName="transform" type="translate" values="0,0;5,-85" dur="1.8s" begin="0.9s" repeatCount="indefinite"/><animate attributeName="opacity" values="0.7;0" dur="1.8s" begin="0.9s" repeatCount="indefinite"/></text>' +
      /* receipt */
      '<rect x="650" y="30" width="65" height="140" rx="2" fill="#f0f0e8" opacity="0.85"/>' +
      '<text x="658" y="48" font-family="monospace" font-size="7" fill="#333">RECEIPT</text>' +
      '<text x="658" y="62" font-family="monospace" font-size="6" fill="#555">———————</text>' +
      '<text x="658" y="76" font-family="monospace" font-size="6" fill="#555">ITEM 1  $140</text>' +
      '<text x="658" y="88" font-family="monospace" font-size="6" fill="#555">ITEM 2  $280</text>' +
      '<text x="658" y="100" font-family="monospace" font-size="6" fill="#555">ITEM 3   $80</text>' +
      '<text x="658" y="112" font-family="monospace" font-size="6" fill="#555">ITEM 4  $500</text>' +
      '<text x="658" y="124" font-family="monospace" font-size="6" fill="#555">———————</text>' +
      '<text x="658" y="138" font-family="monospace" font-size="7" fill="#e65100" font-weight="bold">TOT $1000</text>' +
      '<text x="10" y="190" font-family="monospace" font-size="10" fill="#ffab40" opacity="0.6" letter-spacing="3">TREAT YOURSELF</text>' +
      '</svg>',

    /* ─── DEBT: credit card + ticking counter ─── */
    debt:
      '<svg viewBox="0 0 760 200" xmlns="http://www.w3.org/2000/svg">' +
      '<rect width="760" height="200" fill="#000"/>' +
      /* credit card */
      '<rect x="50" y="45" width="280" height="160" rx="14" fill="#0a1a2a" stroke="#40c4ff" stroke-width="2"/>' +
      /* chip */
      '<rect x="78" y="80" width="44" height="34" rx="4" fill="#b8860b" stroke="#ffd700" stroke-width="1.5" opacity="0.9"/>' +
      '<line x1="78" y1="97" x2="122" y2="97" stroke="#8B6914" stroke-width="1"/>' +
      '<line x1="100" y1="80" x2="100" y2="114" stroke="#8B6914" stroke-width="1"/>' +
      /* card number */
      '<text x="78" y="148" font-family="monospace" font-size="11" fill="#40c4ff" opacity="0.8" letter-spacing="4">4242 4242 4242</text>' +
      '<text x="78" y="166" font-family="monospace" font-size="9" fill="#40c4ff" opacity="0.6">24.99% APR</text>' +
      '<text x="265" y="166" font-family="monospace" font-size="9" fill="#40c4ff" opacity="0.6">18</text>' +
      /* interest meter label */
      '<text x="380" y="42" font-family="monospace" font-size="9" fill="#40c4ff" opacity="0.7" letter-spacing="2">INTEREST PAID</text>' +
      /* interest bar fills up */
      '<rect x="380" y="55" width="340" height="18" rx="3" fill="#001020"/>' +
      '<rect x="380" y="55" width="0" height="18" rx="3" fill="#0091ea" opacity="0.8">' +
      '<animate attributeName="width" from="0" to="310" dur="4s" repeatCount="indefinite"/>' +
      '</rect>' +
      '<text x="384" y="68" font-family="monospace" font-size="9" fill="#fff" opacity="0.9">$680 INTEREST</text>' +
      /* debt counter: cycling numbers */
      '<text x="380" y="110" font-family="monospace" font-size="13" fill="#40c4ff" opacity="0.7">BALANCE OWING:</text>' +
      '<text x="380" y="135" font-family="monospace" font-size="18" fill="#ef5350" font-weight="bold">' +
      '$1,000<animate attributeName="opacity" values="1;0" dur="0.6s" begin="0s" fill="freeze"/>' +
      '</text>' +
      '<text x="380" y="135" font-family="monospace" font-size="18" fill="#ef5350" font-weight="bold" opacity="0">' +
      '$1,025<animate attributeName="opacity" values="0;1;1;0" dur="1.2s" begin="0.6s" fill="freeze"/>' +
      '</text>' +
      '<text x="380" y="135" font-family="monospace" font-size="18" fill="#ef5350" font-weight="bold" opacity="0">' +
      '$1,051<animate attributeName="opacity" values="0;1;1;0" dur="1.2s" begin="1.8s" fill="freeze"/>' +
      '</text>' +
      '<text x="380" y="135" font-family="monospace" font-size="18" fill="#ef5350" font-weight="bold" opacity="0">' +
      '$1,078<animate attributeName="opacity" values="0;1" dur="0.4s" begin="3s" fill="freeze"/>' +
      '</text>' +
      '<text x="380" y="165" font-family="monospace" font-size="9" fill="#40c4ff" opacity="0.5" letter-spacing="2">minimum payment accepted</text>' +
      '</svg>',

    /* ─── MLM: pyramid levels lighting up ─── */
    mlm:
      '<svg viewBox="0 0 760 200" xmlns="http://www.w3.org/2000/svg">' +
      '<rect width="760" height="200" fill="#000"/>' +
      /* pyramid outline */
      '<polygon points="380,12 600,185 160,185" fill="none" stroke="#ffd740" stroke-width="2" opacity="0.6"/>' +
      /* level fills (appear bottom to top) */
      '<rect x="160" y="163" width="440" height="22" fill="#ffd740" opacity="0">' +
      '<animate attributeName="opacity" values="0;0.12" dur="0.4s" begin="0.3s" fill="freeze"/>' +
      '</rect>' +
      '<rect x="211" y="138" width="338" height="22" fill="#ffd740" opacity="0">' +
      '<animate attributeName="opacity" values="0;0.15" dur="0.4s" begin="0.8s" fill="freeze"/>' +
      '</rect>' +
      '<rect x="260" y="113" width="240" height="22" fill="#ffd740" opacity="0">' +
      '<animate attributeName="opacity" values="0;0.18" dur="0.4s" begin="1.3s" fill="freeze"/>' +
      '</rect>' +
      '<rect x="308" y="88" width="144" height="22" fill="#ffd740" opacity="0">' +
      '<animate attributeName="opacity" values="0;0.22" dur="0.4s" begin="1.8s" fill="freeze"/>' +
      '</rect>' +
      '<rect x="344" y="63" width="72" height="22" fill="#ffd740" opacity="0">' +
      '<animate attributeName="opacity" values="0;0.28" dur="0.4s" begin="2.3s" fill="freeze"/>' +
      '</rect>' +
      /* apex node */
      '<circle cx="380" cy="14" r="9" fill="#f9a825" opacity="0">' +
      '<animate attributeName="opacity" values="0;1" dur="0.4s" begin="2.8s" fill="freeze"/>' +
      '<animate attributeName="r" values="9;13;9" dur="1.4s" begin="3s" repeatCount="indefinite"/>' +
      '</circle>' +
      /* level nodes */
      '<circle cx="267" cy="152" r="5" fill="#ffd740" opacity="0"><animate attributeName="opacity" from="0" to="1" dur="0.3s" begin="1.2s" fill="freeze"/></circle>' +
      '<circle cx="493" cy="152" r="5" fill="#ffd740" opacity="0"><animate attributeName="opacity" from="0" to="1" dur="0.3s" begin="1.2s" fill="freeze"/></circle>' +
      /* connection lines */
      '<line x1="380" y1="23" x2="267" y2="152" stroke="#f9a825" stroke-width="1" opacity="0"><animate attributeName="opacity" from="0" to="0.5" dur="0.4s" begin="1.3s" fill="freeze"/></line>' +
      '<line x1="380" y1="23" x2="493" y2="152" stroke="#f9a825" stroke-width="1" opacity="0"><animate attributeName="opacity" from="0" to="0.5" dur="0.4s" begin="1.3s" fill="freeze"/></line>' +
      /* blinking text */
      '<text x="380" y="195" text-anchor="middle" font-family="monospace" font-size="10" fill="#ffd740" opacity="0.75" letter-spacing="3">' +
      'FINANCIAL FREEDOM<animate attributeName="opacity" values="0.75;0.2;0.75" dur="2.5s" repeatCount="indefinite"/>' +
      '</text>' +
      '<text x="10" y="22" font-family="monospace" font-size="9" fill="#ffd740" opacity="0.5">OPPORTUNITY  UNLIMITED</text>' +
      '</svg>',

    /* ─── PARTY: rotating disco ball + falling confetti ─── */
    party:
      '<svg viewBox="0 0 760 200" xmlns="http://www.w3.org/2000/svg">' +
      '<rect width="760" height="200" fill="#000"/>' +
      /* disco ball: circle + rotating lines */
      '<g transform="translate(380,80)">' +
      '<circle cx="0" cy="0" r="52" fill="#111" stroke="#555" stroke-width="1.5"/>' +
      /* horizontal mirror strips */
      '<rect x="-52" y="-12" width="104" height="10" fill="#333" opacity="0.8"/>' +
      '<rect x="-52" y="4"   width="104" height="10" fill="#333" opacity="0.8"/>' +
      '<rect x="-52" y="-28" width="104" height="10" fill="#333" opacity="0.8"/>' +
      /* rotating sparkles */
      '<g><animateTransform attributeName="transform" type="rotate" from="0" to="360" dur="3s" repeatCount="indefinite"/>' +
      '<line x1="0" y1="-65" x2="0" y2="-52" stroke="#ff4081" stroke-width="3" opacity="0.9"/>' +
      '<line x1="65" y1="0" x2="52" y2="0" stroke="#ea80fc" stroke-width="3" opacity="0.9"/>' +
      '<line x1="0" y1="65" x2="0" y2="52" stroke="#ffd740" stroke-width="3" opacity="0.9"/>' +
      '<line x1="-65" y1="0" x2="-52" y2="0" stroke="#40c4ff" stroke-width="3" opacity="0.9"/>' +
      '<line x1="46" y1="-46" x2="37" y2="-37" stroke="#ff4081" stroke-width="2" opacity="0.7"/>' +
      '<line x1="46" y1="46" x2="37" y2="37" stroke="#69f0ae" stroke-width="2" opacity="0.7"/>' +
      '<line x1="-46" y1="46" x2="-37" y2="37" stroke="#ffd740" stroke-width="2" opacity="0.7"/>' +
      '<line x1="-46" y1="-46" x2="-37" y2="-37" stroke="#40c4ff" stroke-width="2" opacity="0.7"/>' +
      '</g>' +
      /* hanging wire */
      '<line x1="0" y1="-52" x2="0" y2="-80" stroke="#666" stroke-width="1.5"/>' +
      '</g>' +
      /* falling confetti */
      '<circle cx="80"  cy="-10" r="7" fill="#ff4081"><animateTransform attributeName="transform" type="translate" values="0,0;20,240" dur="2.5s" repeatCount="indefinite"/><animate attributeName="opacity" values="1;0" dur="2.5s" repeatCount="indefinite"/></circle>' +
      '<circle cx="160" cy="-10" r="5" fill="#ffd740"><animateTransform attributeName="transform" type="translate" values="0,0;-15,240" dur="2s" begin="0.3s" repeatCount="indefinite"/><animate attributeName="opacity" values="1;0" dur="2s" begin="0.3s" repeatCount="indefinite"/></circle>' +
      '<circle cx="260" cy="-10" r="6" fill="#69f0ae"><animateTransform attributeName="transform" type="translate" values="0,0;10,240" dur="2.8s" begin="0.7s" repeatCount="indefinite"/><animate attributeName="opacity" values="1;0" dur="2.8s" begin="0.7s" repeatCount="indefinite"/></circle>' +
      '<circle cx="520" cy="-10" r="8" fill="#ea80fc"><animateTransform attributeName="transform" type="translate" values="0,0;-20,240" dur="2.3s" begin="1.1s" repeatCount="indefinite"/><animate attributeName="opacity" values="1;0" dur="2.3s" begin="1.1s" repeatCount="indefinite"/></circle>' +
      '<circle cx="620" cy="-10" r="5" fill="#40c4ff"><animateTransform attributeName="transform" type="translate" values="0,0;15,240" dur="2.6s" begin="0.5s" repeatCount="indefinite"/><animate attributeName="opacity" values="1;0" dur="2.6s" begin="0.5s" repeatCount="indefinite"/></circle>' +
      '<circle cx="700" cy="-10" r="7" fill="#ff4081"><animateTransform attributeName="transform" type="translate" values="0,0;-10,240" dur="2.1s" begin="1.6s" repeatCount="indefinite"/><animate attributeName="opacity" values="1;0" dur="2.1s" begin="1.6s" repeatCount="indefinite"/></circle>' +
      '<text x="380" y="185" text-anchor="middle" font-family="monospace" font-size="11" fill="#ff4081" opacity="0.8" letter-spacing="4">' +
      'LIVE FOR THE MOMENT<animate attributeName="opacity" values="0.8;0.3;0.8" dur="2s" repeatCount="indefinite"/>' +
      '</text>' +
      '</svg>',

    /* ─── RECOVERY: growing plant + rising sun ─── */
    recovery:
      '<svg viewBox="0 0 760 200" xmlns="http://www.w3.org/2000/svg">' +
      '<rect width="760" height="200" fill="#000"/>' +
      /* rising sun (moves up) */
      '<g opacity="0">' +
      '<animate attributeName="opacity" values="0;0.55" dur="2s" begin="0s" fill="freeze"/>' +
      '<animateTransform attributeName="transform" type="translate" values="0,40;0,0" dur="2s" begin="0s" fill="freeze"/>' +
      '<path d="M 380 120 m -60 0 a 60 60 0 0 1 120 0" fill="#ffd740" opacity="0.5"/>' +
      '<line x1="380" y1="48" x2="380" y2="35" stroke="#ffd740" stroke-width="2.5" opacity="0.6"/>' +
      '<line x1="422" y1="60" x2="432" y2="50" stroke="#ffd740" stroke-width="2.5" opacity="0.6"/>' +
      '<line x1="338" y1="60" x2="328" y2="50" stroke="#ffd740" stroke-width="2.5" opacity="0.6"/>' +
      '</g>' +
      /* soil */
      '<rect x="0" y="162" width="760" height="38" fill="#1a0d00" opacity="0.9"/>' +
      '<rect x="0" y="158" width="760" height="6" fill="#2a1500" opacity="0.8"/>' +
      /* growing stem (stroke-dashoffset draws upward) */
      '<line x1="380" y1="162" x2="380" y2="60" stroke="#4caf50" stroke-width="4" stroke-linecap="round"' +
      ' stroke-dasharray="102" stroke-dashoffset="102">' +
      '<animate attributeName="stroke-dashoffset" from="102" to="0" dur="2.2s" fill="freeze" repeatCount="indefinite"/>' +
      '</line>' +
      /* leaves (appear after stem) */
      '<ellipse cx="350" cy="115" rx="24" ry="13" fill="#388e3c" opacity="0" transform="rotate(-30 350 115)">' +
      '<animate attributeName="opacity" values="0;0.9" dur="0.5s" begin="1.2s" fill="freeze"/>' +
      '</ellipse>' +
      '<ellipse cx="410" cy="100" rx="24" ry="13" fill="#4caf50" opacity="0" transform="rotate(30 410 100)">' +
      '<animate attributeName="opacity" values="0;0.9" dur="0.5s" begin="1.6s" fill="freeze"/>' +
      '</ellipse>' +
      '<ellipse cx="360" cy="80" rx="20" ry="11" fill="#81c784" opacity="0" transform="rotate(-15 360 80)">' +
      '<animate attributeName="opacity" values="0;0.85" dur="0.5s" begin="2s" fill="freeze"/>' +
      '</ellipse>' +
      /* progress bar */
      '<rect x="50" y="138" width="660" height="12" rx="3" fill="#001a10"/>' +
      '<rect x="50" y="138" width="0" height="12" rx="3" fill="#69f0ae" opacity="0.85">' +
      '<animate attributeName="width" from="0" to="660" dur="2.5s" fill="freeze" repeatCount="indefinite"/>' +
      '</rect>' +
      '<text x="380" y="148" text-anchor="middle" font-family="monospace" font-size="7" fill="#000">RECOVERY PROGRESS</text>' +
      '<text x="380" y="190" text-anchor="middle" font-family="monospace" font-size="9" fill="#69f0ae" opacity="0.7" letter-spacing="4">ONE DAY AT A TIME</text>' +
      '</svg>'
  };

  /* ══════════════════════════════════════════════════════════
     STATE
     ══════════════════════════════════════════════════════════ */
  var THEMES = ["invest","crypto","gamble","spend","debt","mlm","party","recovery","neutral"];
  var THEME_LABELS = {
    invest:"◈ INVEST", crypto:"◈ CRYPTO", gamble:"◈ GAMBLE",
    spend:"◈ SPEND", debt:"◈ DEBT", mlm:"◈ MLM",
    party:"◈ PARTY", recovery:"◈ RECOVERY", neutral:"◈ NEUTRAL"
  };
  var SCENE_BADGES = {
    invest:"PORTFOLIO MODE", crypto:"CRYPTO MODE", gamble:"CASINO MODE",
    spend:"SPEND MODE", debt:"DEBT MODE", mlm:"MLM MODE",
    party:"PARTY MODE", recovery:"RECOVERY MODE", neutral:"SELECT YOUR PATH"
  };

  var currentTheme  = null;
  var currentEnding = null;

  var stats = {
    age:18, hp:100, mp:100, money:1000, rep:100,
    streak:0, debt:0, debtMoney:0,
    mentor:false, fund:false, side:false
  };

  /* ══════════════════════════════════════════════════════════
     DOM REFS
     ══════════════════════════════════════════════════════════ */
  var sceneAnimEl  = null;
  var sceneBadgeEl = null;

  var hudMoneyEl = null;
  var hudAgeEl   = null;
  var hudDebtEl  = null;

  var barHpEl  = null; var numHpEl  = null;
  var barMpEl  = null; var numMpEl  = null;
  var barRepEl = null; var numRepEl = null;

  var flMentor  = null; var flFund   = null;
  var flSide    = null; var flStreak = null;
  var flDebt    = null; var flTheme  = null;

  /* ══════════════════════════════════════════════════════════
     HELPERS
     ══════════════════════════════════════════════════════════ */
  function clearClasses(prefix) {
    var rem = [];
    document.body.classList.forEach(function(c) { if (c.startsWith(prefix)) rem.push(c); });
    rem.forEach(function(c) { document.body.classList.remove(c); });
  }

  function setFlag(el, on) {
    if (!el) return;
    el.classList.toggle("on", on);
    el.classList.toggle("off", !on);
  }

  function hpLevel(v) {
    if (v >= 80) return "high";
    if (v >= 55) return "medium";
    if (v >= 30) return "low";
    return "critical";
  }

  function pct(val, max) {
    return Math.max(0, Math.min(100, Math.round(val / max * 100))) + "%";
  }

  function fmtMoney(n) {
    if (n < 0) return "-$" + Math.abs(n).toLocaleString();
    return "$" + n.toLocaleString();
  }

  /* ══════════════════════════════════════════════════════════
     THEME + SCENE
     ══════════════════════════════════════════════════════════ */
  function setTheme(name) {
    if (name === currentTheme) return;
    if (THEMES.indexOf(name) === -1) return;
    currentTheme = name;
    clearClasses("fc-theme-");
    document.body.classList.add("fc-theme-" + name);

    if (sceneAnimEl) {
      sceneAnimEl.innerHTML = SPRITES[name] || SPRITES.neutral;
    }
    if (sceneBadgeEl) {
      sceneBadgeEl.textContent = SCENE_BADGES[name] || "SELECT YOUR PATH";
    }
    if (flTheme) {
      flTheme.textContent = THEME_LABELS[name] || "◈ NEUTRAL";
      setFlag(flTheme, true);
    }
  }

  function setEnding(type) {
    if (type === currentEnding) return;
    currentEnding = type;
    clearClasses("fc-ending-");
    clearClasses("ending-");
    if (type) {
      document.body.classList.add("fc-ending-" + type);
      document.body.classList.add("ending-" + type);
    }
  }

  /* ══════════════════════════════════════════════════════════
     HUD UPDATE
     ══════════════════════════════════════════════════════════ */
  function updateHud() {
    if (hudMoneyEl) hudMoneyEl.textContent = fmtMoney(stats.money);
    if (hudAgeEl)   hudAgeEl.textContent   = stats.age;
    if (hudDebtEl)  hudDebtEl.textContent  = stats.debtMoney > 0 ? fmtMoney(stats.debtMoney) : "$0";

    if (barHpEl)  barHpEl.style.width  = pct(stats.hp, 100);
    if (numHpEl)  numHpEl.textContent  = stats.hp;
    if (barMpEl)  barMpEl.style.width  = pct(stats.mp, 100);
    if (numMpEl)  numMpEl.textContent  = stats.mp;
    if (barRepEl) barRepEl.style.width = pct(stats.rep, 150);
    if (numRepEl) numRepEl.textContent = stats.rep;

    /* HP color class */
    clearClasses("fc-hp-");
    document.body.classList.add("fc-hp-" + hpLevel(stats.hp));

    /* flags */
    setFlag(flMentor, stats.mentor);
    setFlag(flFund,   stats.fund);
    setFlag(flSide,   stats.side);

    if (flStreak) {
      flStreak.textContent = "🌿SOBER:" + stats.streak + "mo";
      setFlag(flStreak, stats.streak > 0);
    }
    if (flDebt) {
      flDebt.textContent = "💳DEBTS:" + stats.debt;
      setFlag(flDebt, stats.debt > 0);
    }

    /* money color in HUD */
    if (hudMoneyEl) {
      hudMoneyEl.style.color = stats.money < 0 ? "#ef5350" : "";
    }
    if (hudDebtEl) {
      hudDebtEl.style.color = stats.debtMoney > 0 ? "#ef5350" : "";
    }
  }

  /* ══════════════════════════════════════════════════════════
     STAT SCRAPER
     Reads values from ink story text as paragraphs appear
     ══════════════════════════════════════════════════════════ */
  function scrapeStats(text) {
    var m;
    if ((m = text.match(/\bHP[:\s]+(-?\d+)/i)))    stats.hp    = parseInt(m[1], 10);
    if ((m = text.match(/\bMP[:\s]+(-?\d+)/i)))    stats.mp    = parseInt(m[1], 10);
    if ((m = text.match(/\bREP[:\s]+(-?\d+)/i)))   stats.rep   = parseInt(m[1], 10);
    if ((m = text.match(/\bAGE[:\s]+(\d+)/i)))     stats.age   = parseInt(m[1], 10);
    if ((m = text.match(/\$\s*(-?[\d,]+)/)))        stats.money = parseInt(m[1].replace(/,/g,""),10);
    if ((m = text.match(/STREAK[:\s]+(\d+)/i)))    stats.streak = parseInt(m[1], 10);
    if ((m = text.match(/\bDEBT[:\s]+(\d+)/i)))    stats.debt   = parseInt(m[1], 10);
    if ((m = text.match(/DEBT.{1,8}\$\s*([\d,]+)/i))) stats.debtMoney = parseInt(m[1].replace(/,/g,""),10);

    if (/MENTOR ACTIVE|MENTOR\s*[•·]|🧭/.test(text))   stats.mentor = true;
    if (/EMERGENCY FUND/i.test(text))                    stats.fund   = true;
    if (/SIDE INCOME/i.test(text))                       stats.side   = true;
  }

  /* ══════════════════════════════════════════════════════════
     PARAGRAPH SCANNER
     Called by MutationObserver whenever main.js adds a <p>
     ══════════════════════════════════════════════════════════ */
  function scanParagraph(p) {
    var text = p.textContent || "";

    /* detect theme/ending commands embedded in story text */
    var themeM  = text.match(/#theme[:\s]+(\w+)/i);
    var endingM = text.match(/#ending[:\s]+(\w+)/i);
    if (themeM)  setTheme(themeM[1].toLowerCase());
    if (endingM) setEnding(endingM[1].toLowerCase());

    /* scrape stats and refresh HUD */
    scrapeStats(text);
    updateHud();

    /* add reveal class */
    p.classList.add("fc-new-para");

    /* tag hidden stat-dump lines */
    if (/^\s*#\w+:\w+/.test(text.trim()) || /^\s*#theme/i.test(text.trim())) {
      p.style.display = "none";
    }

    /* style chapter header dashes */
    if (/^[\s━─═╔╗╚╝║═\-─]{3,}/.test(text.trim())) {
      p.classList.add("fc-header-line");
    }

    /* color HP values inline */
    if (/HP:\s*-?\d+/i.test(text)) {
      p.innerHTML = p.innerHTML.replace(/\bHP:(\s*)(-?\d+)/gi,
        'HP:$1<span style="color:var(--accent);text-shadow:0 0 6px var(--glow)">$2</span>');
    }
  }

  /* ══════════════════════════════════════════════════════════
     MUTATION OBSERVER — watches for new paragraphs
     ══════════════════════════════════════════════════════════ */
  function observeStory() {
    var storyEl = document.getElementById("story");
    if (!storyEl) return;

    storyEl.querySelectorAll("p").forEach(scanParagraph);

    var obs = new MutationObserver(function(mutations) {
      mutations.forEach(function(m) {
        m.addedNodes.forEach(function(node) {
          if (node.nodeType !== 1) return;
          if (node.tagName === "P") scanParagraph(node);
          if (node.querySelectorAll) node.querySelectorAll("p").forEach(scanParagraph);
        });
      });
    });
    obs.observe(storyEl, { childList: true, subtree: true });
  }

  /* ══════════════════════════════════════════════════════════
     FLASH INTRO
     ══════════════════════════════════════════════════════════ */
  function setupIntro() {
    var intro = document.getElementById("flash-intro");
    if (!intro) return;

    function dismiss(e) {
      e.stopPropagation();
      intro.style.transition = "opacity 0.4s steps(4)";
      intro.style.opacity = "0";
      setTimeout(function() { intro.style.display = "none"; }, 420);
    }

    intro.addEventListener("click", dismiss);
    document.addEventListener("keydown", function(e) {
      if (intro.style.display !== "none") dismiss(e);
    }, { once: true });
  }

  /* ══════════════════════════════════════════════════════════
     HUD BUTTONS — proxy to hidden main.js controls
     ══════════════════════════════════════════════════════════ */
  function setupHudButtons() {
    /* RESTART: reset our state then trigger main.js rewind */
    var restartBtn = document.getElementById("hud-restart-btn");
    var rewindEl   = document.getElementById("rewind");
    if (restartBtn && rewindEl) {
      restartBtn.addEventListener("click", function() {
        stats = { age:18, hp:100, mp:100, money:1000, rep:100,
                  streak:0, debt:0, debtMoney:0,
                  mentor:false, fund:false, side:false };
        setTheme("neutral");
        setEnding(null);
        updateHud();
        rewindEl.click();
      });
    }

    /* SAVE */
    var saveBtn = document.getElementById("hud-save-btn");
    var saveEl  = document.getElementById("save");
    if (saveBtn && saveEl) {
      saveBtn.addEventListener("click", function() {
        saveEl.click();
        /* brief flash feedback */
        saveBtn.textContent = "✓ OK!";
        setTimeout(function() { saveBtn.textContent = "💾SAV"; }, 900);
      });
    }

    /* LOAD */
    var loadBtn = document.getElementById("hud-load-btn");
    var reloadEl = document.getElementById("reload");
    if (loadBtn && reloadEl) {
      loadBtn.addEventListener("click", function() { reloadEl.click(); });
    }
  }

  /* ══════════════════════════════════════════════════════════
     INIT
     ══════════════════════════════════════════════════════════ */
  function init() {
    sceneAnimEl  = document.getElementById("scene-anim");
    sceneBadgeEl = document.getElementById("scene-badge");
    hudMoneyEl   = document.getElementById("hud-money");
    hudAgeEl     = document.getElementById("hud-age");
    hudDebtEl    = document.getElementById("hud-debt");
    barHpEl      = document.getElementById("bar-hp");
    numHpEl      = document.getElementById("num-hp");
    barMpEl      = document.getElementById("bar-mp");
    numMpEl      = document.getElementById("num-mp");
    barRepEl     = document.getElementById("bar-rep");
    numRepEl     = document.getElementById("num-rep");
    flMentor     = document.getElementById("fl-mentor");
    flFund       = document.getElementById("fl-fund");
    flSide       = document.getElementById("fl-side");
    flStreak     = document.getElementById("fl-streak");
    flDebt       = document.getElementById("fl-debt");
    flTheme      = document.getElementById("fl-theme-badge");

    /* set initial theme */
    setTheme("neutral");
    document.body.classList.add("fc-hp-high");
    updateHud();

    setupHudButtons();
    setupIntro();
    observeStory();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }

}());
