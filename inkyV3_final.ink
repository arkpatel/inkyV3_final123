// ============================================================
//  FINANCIAL CHOICES
//  Features: knots, stitches, functions, gathers, variables
// ============================================================

// ── VARIABLES ───────────────────────────────────────────────
VAR hp = 100
VAR mp = 100
VAR money = 1000
VAR rep = 100
VAR sober_streak = 0
VAR has_emergency_fund = false
VAR has_side_income = false
VAR has_mentor = false
VAR debt_count = 0
VAR age = 18

-> start

// ============================================================
//  FUNCTIONS
//  Reusable logic called throughout the story
// ============================================================

// Returns a financial health label based on current money
=== function get_money_status() ===
~ temp s = "in debt"
{ money >= 100000:
    ~ s = "wealthy"
- else: { money >= 20000:
    ~ s = "stable"
  - else: { money >= 1000:
      ~ s = "getting by"
    - else: { money >= 0:
        ~ s = "broke"
      }
    }
  }
}
~ return s

// Returns a health status label
=== function get_health_status() ===
~ temp s = "critical"
{ hp >= 80:
    ~ s = "healthy"
- else: { hp >= 55:
    ~ s = "worn down"
  - else: { hp >= 30:
      ~ s = "struggling"
    }
  }
}
~ return s

// Returns a reputation label
=== function get_rep_label() ===
~ temp s = "damaged"
{ rep >= 120:
    ~ s = "beloved"
- else: { rep >= 90:
    ~ s = "respected"
  - else: { rep >= 60:
      ~ s = "neutral"
    }
  }
}
~ return s

// Returns true if player has good financial discipline
=== function is_financially_healthy() ===
{ money >= 10000 && debt_count == 0:
    ~ return true
- else:
    ~ return false
}

// Returns a net worth assessment combining money and debt
=== function get_net_worth_label() ===
~ temp s = "negative net worth"
{ money >= 500000:
    ~ s = "high net worth"
- else: { money >= 100000:
    ~ s = "comfortable"
  - else: { money >= 25000 && debt_count <= 1:
      ~ s = "building wealth"
    - else: { money >= 0:
        ~ s = "treading water"
      }
    }
  }
}
~ return s

// Returns life satisfaction based on combined stats
=== function get_life_score() ===
~ temp score = 0
{ hp >= 70:    ~ score = score + 25 }
{ mp >= 70:    ~ score = score + 25 }
{ rep >= 90:   ~ score = score + 25 }
{ has_mentor:  ~ score = score + 10 }
{ has_emergency_fund: ~ score = score + 15 }
~ return score

// Returns a one-word descriptor of the player's social standing
=== function get_social_label() ===
{ rep >= 130 && has_mentor:
    ~ return "anchor"
- else: { rep >= 100:
    ~ return "trusted"
  - else: { rep >= 60:
      ~ return "private"
    - else:
      ~ return "isolated"
    }
  }
}

// Returns true if player should hit rock bottom soon
=== function in_crisis() ===
{ hp < 40 || money < -10000 || debt_count >= 3:
    ~ return true
- else:
    ~ return false
}

// ============================================================
//  RESTART / INIT
// ============================================================

=== restart ===
#theme:neutral
━━━━━━━━━━━━━━━━━━━━━━━━━━
         GAME OVER
━━━━━━━━━━━━━━━━━━━━━━━━━━
Every path teaches something.
Try again — choose differently.

+ [▶ Start over at 18]
    -> init
+ [✕ Quit]
    -> END

=== init ===
~ hp = 100
~ mp = 100
~ money = 1000
~ rep = 100
~ sober_streak = 0
~ has_emergency_fund = false
~ has_side_income = false
~ has_mentor = false
~ debt_count = 0
~ age = 18
-> start

// ============================================================
//  START
// ============================================================

=== start ===
#theme:neutral
━━━━━━━━━━━━━━━━━━━━━━━━━━
  AGE {age} • HP:{hp} • REP:{rep}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Your uncle slides a check across the table. $1,000.

"One decision can change everything," he says.

The weekend stretches ahead of you. What do you do?

+ [📈 Open a Roth IRA — invest it]
    -> invest_start
+ [🚀 Put it all on a meme coin]
    -> meme_start
+ [🎰 Head to the casino]
    -> gamble_start
+ [🛍️ Treat yourself — spend it all]
    -> spend_start
+ [💳 Credit card arbitrage trick]
    -> debt_start
+ [📦 MLM business opportunity]
    -> mlm_start
+ [🎉 Legendary party weekend]
    -> party_start

// ============================================================
//  EVENT GATEWAYS
//  These intercept the flow and roll a random unfortunate
//  event. The chance of an event depends on the player's
//  current state — healthy/wealthy players get fewer events,
//  struggling players get more.
// ============================================================

// Returns the chance (out of 10) that an event will fire
=== function get_event_chance() ===
~ temp chance = 5
// Healthy players: -2 chance
{ hp >= 80 && mp >= 80:
    ~ chance = chance - 2
}
// Wealthy + no debt: -2 chance
{ money >= 50000 && debt_count == 0:
    ~ chance = chance - 2
}
// Has emergency fund: -1 chance
{ has_emergency_fund:
    ~ chance = chance - 1
}
// In crisis state: +3 chance
{ in_crisis():
    ~ chance = chance + 3
}
// Has mentor: -1 chance (someone watches your back)
{ has_mentor:
    ~ chance = chance - 1
}
// Clamp between 1 and 9 — always some randomness
{ chance < 1:
    ~ chance = 1
}
{ chance > 9:
    ~ chance = 9
}
~ return chance

=== gateway_age25_invest ===
~ temp threshold = get_event_chance()
~ temp roll = RANDOM(1, 10)
{ roll <= threshold:
    ~ event_return = -> invest_consistent_25
    -> roll_event
- else:
    -> invest_consistent_25
}

=== gateway_age30_invest ===
~ temp threshold = get_event_chance()
~ temp roll = RANDOM(1, 10)
{ roll <= threshold:
    ~ event_return = -> invest_simple_30
    -> roll_event
- else:
    -> invest_simple_30
}

=== gateway_age30_recovery ===
~ temp threshold = get_event_chance()
~ temp roll = RANDOM(1, 10)
{ roll <= threshold:
    ~ event_return = -> seek_help_30
    -> roll_event
- else:
    -> seek_help_30
}

// New gateways for other paths
=== gateway_age25_general ===
~ temp threshold = get_event_chance()
~ temp roll = RANDOM(1, 10)
{ roll <= threshold:
    ~ event_return = -> gateway_age25_general
    -> roll_event
- else:
    -> gateway_age25_general
}

=== gateway_age30_party ===
~ temp threshold = get_event_chance()
~ temp roll = RANDOM(1, 10)
{ roll <= threshold:
    ~ event_return = -> gateway_age30_party
    -> roll_event
- else:
    -> gateway_age30_party
}

// ============================================================
//  RANDOM UNFORTUNATE EVENTS
//  Life happens — these strike regardless of your choices.
//  Each event ends by routing back to a "return target" knot.
//
//  Usage from any knot:
//    ~ event_return = -> some_knot_to_return_to
//    -> roll_event
//
//  The roll_event knot picks one of several events, applies
//  consequences, lets you react, then diverts back.
// ============================================================

VAR event_return = -> start

=== roll_event ===
~ temp roll = RANDOM(1, 6)
{ roll:
    - 1: -> event_medical
    - 2: -> event_car
    - 3: -> event_layoff
    - 4: -> event_family
    - 5: -> event_theft
    - 6: -> event_lucky_break
}

// ── Medical emergency ──────────────────────────────────────
=== event_medical ===
#theme:neutral
━━━━━━━━━━━━━━━━━━━━━━━━━━
  ⚠️ UNEXPECTED EVENT
━━━━━━━━━━━━━━━━━━━━━━━━━━

You wake up at 3am with chest pain you can't ignore. ER visit. Tests run. It's a panic attack — but the bill is real.

~ hp -= 10
$2,400 hospital bill arrives three weeks later.

{ in_crisis():
    The bill stares at you. You can feel yourself sinking.
- else:
    Annoying. Expected. Manageable.
}

How do you handle it?

+ [💳 Pay it on a credit card — deal with it later]
    ~ money -= 400
    ~ debt_count += 1
    The minimum payment kicks in. You move on.

+ [💰 Pay it from savings — take the hit]
    ~ money -= 2400
    Savings drained. No debt added. You sleep okay.

{ has_emergency_fund:
+ [🛡️ Use the emergency fund — that's what it's for]
    ~ money -= 2400
    The fund did its job. Now you have to rebuild it.
}

+ [📞 Negotiate with billing — try to lower it]
    ~ money -= 1400
    They knocked $1,000 off after a 40-minute phone call. Worth it.

- // four reactions converge at this gather
-> event_return

// ── Car breakdown ──────────────────────────────────────────
=== event_car ===
#theme:neutral
━━━━━━━━━━━━━━━━━━━━━━━━━━
  ⚠️ UNEXPECTED EVENT
━━━━━━━━━━━━━━━━━━━━━━━━━━

Your car's transmission fails on the highway. You make it to the shoulder. Tow truck. Mechanic. The estimate: $3,200.

You need the car for work.

+ [🔧 Pay for the repair]
    ~ money -= 3200
    Painful. Necessary. The car runs again.

+ [🚗 Junk it, buy a $2k beater]
    ~ money -= 2000
    Not pretty. Not reliable. Drives.

+ [🚌 Sell it for parts, switch to transit]
    ~ money += 400
    Two-hour commute now. But no car payment, no insurance, no surprises.
    ~ rep += 5

+ [💳 Finance the repair — $80/month for 4 years]
    ~ debt_count += 1
    Cheaper today. Way more expensive over time.

- // all reactions converge here
-> event_return

// ── Layoff ──────────────────────────────────────────────────
=== event_layoff ===
#theme:neutral
━━━━━━━━━━━━━━━━━━━━━━━━━━
  ⚠️ UNEXPECTED EVENT
━━━━━━━━━━━━━━━━━━━━━━━━━━

Monday morning, 9:15 AM. Calendar invite: "Quick chat with HR." You know what it is before you click.

Severance: 6 weeks. Then nothing.

~ mp -= 15

How do you respond?

+ [🚀 Job hunt aggressively — applications out by Friday]
    Three weeks of grinding. New role landed. Slight pay cut.
    ~ money -= 3000

+ [🌴 Take the severance, breathe for a month]
    First real break in years. You read three books. Then you start applying.
    ~ money -= 5000
    ~ mp += 20

+ [💼 Pivot — try freelancing]
    ~ has_side_income = true
    Year one is rough. By month eight you're billing more than your old salary.

{ has_emergency_fund:
+ [🛡️ Lean on the emergency fund — pick the right next move]
    Three months of runway means you can be picky. You take a job that's actually a step up.
    ~ money += 4000
}

- // all reactions converge here
-> event_return

// ── Family emergency ───────────────────────────────────────
=== event_family ===
#theme:neutral
━━━━━━━━━━━━━━━━━━━━━━━━━━
  ⚠️ UNEXPECTED EVENT
━━━━━━━━━━━━━━━━━━━━━━━━━━

Your mom calls. She's crying. Your dad fell. He's okay — but he can't work for three months and they're going to lose the house.

They need $4,500.

+ [💝 Send the full amount — no questions]
    ~ money -= 4500
    ~ rep += 20
    She paid you back over two years. Every dollar.

+ [💸 Send what you can — $1,500]
    ~ money -= 1500
    ~ rep += 5
    They scraped together the rest. The house didn't fall. The relationship is a little frayed.

+ [🚫 Tell them you can't help right now]
    ~ rep -= 25
    They got through it without you. Some things between you didn't get through it.
    ~ mp -= 15

+ [📋 Help them set up a payment plan with the bank instead]
    ~ rep += 15
    No money out of your pocket. Two weekends on the phone with their lender. They keep the house.

- // all reactions converge here
-> event_return

// ── Theft / scam ───────────────────────────────────────────
=== event_theft ===
#theme:neutral
━━━━━━━━━━━━━━━━━━━━━━━━━━
  ⚠️ UNEXPECTED EVENT
━━━━━━━━━━━━━━━━━━━━━━━━━━

Someone got your card number. $1,800 in fraudulent charges before you noticed. The bank says they'll investigate.

In the meantime: your account is frozen.

+ [📋 File a fraud report, wait for resolution]
    Three weeks of inconvenience. Bank refunds everything. You learn about credit freezes.

+ [💸 Just eat the loss to move on]
    ~ money -= 1800
    Faster, but you didn't have to.

+ [🚨 Report identity theft, freeze all credit]
    ~ rep += 5
    Tedious but thorough. Bank refunds. Credit locked down. You feel slightly paranoid for a year.

- // all reactions converge here
-> event_return

// ── Lucky break (the rare good event) ──────────────────────
=== event_lucky_break ===
#theme:neutral
━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✨ UNEXPECTED EVENT
━━━━━━━━━━━━━━━━━━━━━━━━━━

A class-action settlement check arrives in the mail. $850. You forgot you'd even joined the lawsuit.

+ [📈 Invest it]
    ~ money += 850
    Boring. Correct.

+ [🎁 Treat yourself — you deserve it]
    ~ money += 200
    Dinner with friends. New jacket. Worth it.

+ [💝 Donate it]
    ~ rep += 10
    A cause you care about. You don't think about the $850 again.

+ [🛡️ Boost the emergency fund]
    ~ money += 850
    ~ has_emergency_fund = true
    Future you will be grateful.


// ============================================================
//  INVEST PATH
//  Stitches: invest_start, early_years, mid_years, late_game
// ============================================================

- // all reactions converge here
-> event_return

=== invest_start ===
#theme:invest
~ money = 1000
-> open_account

= open_account
━━━━━━━━━━━━━━━━━━━━━━━━━━
  📈 INVEST PATH • AGE {age}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Roth IRA opened. Index fund selected. Confirmation email received. Zero confetti.

This is what good money decisions look like.

+ [💼 Set $200/month automatic investment]
    -> invest_start.job_19
+ [😐 Leave the $1k — contribute later]
    -> invest_start.stagnant

= job_19
~ age = 19
~ money = 3200
━━━━━━━━━━━━━━━━━━━━━━━━━━
  AGE {age} • ${ money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

First real paycheck hits. Boss offers overtime.

+ [⏰ Take overtime — bump to $300/month]
    ~ money = 4200
    ~ mp -= 20
    -> invest_start.overtime_20
+ [⚖️ Keep balance — stay at $200/month]
    -> invest_consistent_21
+ [🚗 Blow the overtime on a car you don't need]
    ~ money = 1800
    ~ debt_count += 1
    -> invest_start.car_detour

= overtime_20
~ age = 20
━━━━━━━━━━━━━━━━━━━━━━━━━━
  AGE {age} • MP:{mp}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Grinding. $300/month landing like clockwork. Burnout creeping.

+ [⚠️ Push through — the number keeps growing]
    ~ mp -= 20
    -> invest_start.burnout
+ [🧘 Cut back to $200/month — breathe again]
    -> invest_consistent_21

= burnout
~ age = 21
~ money = 7800
~ mp -= 15

You quit impulsively on a Tuesday. Three months no income. Portfolio untouched — the only good news.

+ [💻 Freelance to fill the gap]
    ~ has_side_income = true
    -> invest_freelance_22
+ [🛌 Rest, then find a new job]
    -> invest_consistent_21

= stagnant
~ age = 21
~ money = 1295

Lifestyle absorbed every raise. $1,295 sitting untouched.

+ [📈 Start $100/month — even that counts]
    -> invest_latestart_25
+ [🗓️ Maybe next year]
    -> spend_habit_25

= car_detour
~ age = 20

$12k car. 60-month loan. Investing margin gone.

+ [🔧 Sell it — buy a beater for cash]
    ~ debt_count -= 1
    -> invest_consistent_21
+ [📉 Keep it — cut investing to $50/month]
    -> invest_start.stagnant
+ [🚕 Pick up gig work to cover both]
    ~ has_side_income = true
    -> invest_consistent_21


=== invest_freelance_22 ===
#theme:invest
~ age = 22
~ money = 9100
~ has_side_income = true
━━━━━━━━━━━━━━━━━━━━━━━━━━
  AGE {age} • SIDE INCOME • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Freelance took off. Extra $500/month on your terms.

+ [📊 Split: $400 invest, $100 fun]
    -> gateway_age25_invest
+ [🏢 Reinvest all of it — grow this into a real business]
    -> invest_biz_30


=== invest_consistent_21 ===
#theme:invest
~ age = 21
~ money = 9400
━━━━━━━━━━━━━━━━━━━━━━━━━━
  AGE {age} • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$9,400 compounding. Coworkers hyping $DONUT. FOMO is loud.

+ [🧘 Stay the course — boring is working]
    -> invest_mentor_check
+ [🎲 Side bet — $2k in crypto]
    ~ money = 7400
    -> invest_crypto_side_25
+ [🚀 All-in — pull everything out for crypto]
    ~ money = 0
    -> invest_panic_crypto_25
+ [👨‍👩‍👧 Withdraw $3k to help a family member]
    ~ money = 6400
    ~ rep += 10
    -> invest_family_crisis_22


=== invest_mentor_check ===
#theme:invest
-> offer

= offer
━━━━━━━━━━━━━━━━━━━━━━━━━━
  MENTOR OPPORTUNITY
━━━━━━━━━━━━━━━━━━━━━━━━━━

A senior coworker notices your discipline. Drives a 10-year-old Camry. Offers to mentor you.

+ [✅ Accept — meet monthly]
    ~ has_mentor = true
    -> invest_mentor_check.active
+ [🙅 Decline — doing fine alone]
    -> gateway_age25_invest

= active
~ has_mentor = true
━━━━━━━━━━━━━━━━━━━━━━━━━━
  AGE 25 • MENTOR ACTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━
~ age = 25
~ money = 26000

Four years of lunches. She taught you backdoor Roth, tax-loss harvesting, HSA triple-tax advantage.

+ [🎯 Follow the advanced strategy]
    -> invest_advanced_30
+ [😌 Keep it simple — take the big ideas only]
    -> gateway_age30_invest


=== invest_family_crisis_22 ===
#theme:invest
~ age = 22
~ rep = 110
━━━━━━━━━━━━━━━━━━━━━━━━━━
  AGE {age} • REP:{rep}
━━━━━━━━━━━━━━━━━━━━━━━━━━

You gave $3k without blinking. She paid you back two years later. That's not why you did it.

+ [🔄 Rebuild contributions immediately]
    -> invest_consistent_25
+ [😤 Resentment builds — stop investing]
    -> spend_habit_25


=== invest_latestart_25 ===
#theme:invest
~ age = 25
~ money = 5200
━━━━━━━━━━━━━━━━━━━━━━━━━━
  AGE {age} • LATE START
━━━━━━━━━━━━━━━━━━━━━━━━━━

Behind the investor who started at 18. Ahead of the person who still hasn't started.

+ [🚀 Bump aggressively to $400/month]
    -> gateway_age30_invest
+ [💸 Keep $100/month — life is tight]
    -> invest_slow_30


=== invest_consistent_25 ===
#theme:invest
~ age = 25
~ money = 23000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  AGE {age} • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$23k. Coworkers drowning in debt. You have breathing room.

{ is_financially_healthy():
    Friends notice. One of them quietly asks how you do it.
}

+ [💑 Partner wants to merge — they have $8k debt]
    ~ money = 19000
    ~ rep += 5
    -> invest_simple_30
+ [📊 Open a brokerage for individual stocks]
    -> invest_brokerage_30
+ [🏦 Stay index funds, stay simple]
    -> invest_simple_30
+ [🏢 Start a side business]
    -> invest_biz_30
{ is_financially_healthy():
    + [🧭 Mentor a younger coworker — pay it forward]
        ~ rep += 15
        Your discipline becomes someone else's blueprint.
        -> invest_simple_30
}


=== invest_crypto_side_25 ===
#theme:invest
~ age = 25
~ money = 19800
━━━━━━━━━━━━━━━━━━━━━━━━━━
  AGE {age} • CRYPTO SIDE BET
━━━━━━━━━━━━━━━━━━━━━━━━━━

$2k crypto went to $800. Index untouched. Cost: $1,200 and a lesson.

+ [🔒 Never again — double down on index]
    -> invest_simple_30
+ [🎲 Try a different coin — that one was bad luck]
    -> meme_cycle_30


=== invest_panic_crypto_25 ===
#theme:crypto
~ age = 25
~ money = 3200
━━━━━━━━━━━━━━━━━━━━━━━━━━
  ALL-IN CRYPTO • LOSS
━━━━━━━━━━━━━━━━━━━━━━━━━━

Rode it 3x. Watched it crash 80%. Out with $3,200. Nine years of compounding: gone.

+ [🔄 Start over. The boring path was right.]
    -> invest_recover_30


=== invest_advanced_30 ===
#theme:invest
~ age = 30
~ money = 74000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  AGE {age} • OPTIMISED
━━━━━━━━━━━━━━━━━━━━━━━━━━

Backdoor Roth. Tax-loss harvesting. HSA triple threat. Your tax return came back $4,200 larger than your coworker's on the same salary.

+ [⬆️ Max everything legally]
    -> invest_max_40
+ [😮‍💨 Complexity fatigue — simplify]
    -> invest_simple_30


=== invest_simple_30 ===
#theme:invest
-> arrive

= arrive
~ age = 30
~ money = 62000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  AGE {age} • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$62k. Bought a house with a real down payment. Then layoffs hit the company.

+ [🔥 Layoff hits you]
    ~ mp -= 20
    -> invest_simple_30.layoff
+ [✅ Survived. Max 401k with employer match.]
    -> invest_max_40
+ [⚖️ Survived. Keep current — live more.]
    -> invest_balanced_40

= layoff
━━━━━━━━━━━━━━━━━━━━━━━━━━
  LAYOFF • 6 MONTHS
━━━━━━━━━━━━━━━━━━━━━━━━━━

Six months. You're watching the account more than you should.

{ has_emergency_fund:
    - Emergency fund. Made it six months without touching investments.
      + [💼 Land the new job. Resume investing.]
          -> invest_balanced_40
    - No emergency fund. Liquidated $8k to survive.
      ~ money -= 8000
      + [🔄 Rebuild — emergency fund first this time]
          ~ has_emergency_fund = true
          -> invest_slow_30
}


=== invest_brokerage_30 ===
#theme:invest
~ age = 30
~ money = 58000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  INDIVIDUAL STOCKS
━━━━━━━━━━━━━━━━━━━━━━━━━━

Picked winners. Picked losers. Net result: same as the index fund. Way more stress.

+ [🏦 Consolidate back to index]
    -> invest_max_40
+ [📈 Keep picking — getting better]
    -> invest_balanced_40


=== invest_biz_30 ===
#theme:invest
-> launch

= launch
~ age = 30
~ money = 41000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  BUSINESS LAUNCHED
━━━━━━━━━━━━━━━━━━━━━━━━━━

Side biz went full-time. Year two: cleared $80k. Then your appendix ruptured. Uninsured.

+ [🏥 $22k hospital bill — no insurance]
    ~ hp -= 20
    ~ money -= 22000
    -> invest_biz_30.health_scare
+ [💪 Healthy — business thriving]
    -> invest_biz_grow_40
+ [😬 Business struggling — pivot to consulting]
    -> invest_biz_30.pivot
+ [😓 Business failed — back to a job]
    -> invest_biz_fail_40

= health_scare
~ age = 31
━━━━━━━━━━━━━━━━━━━━━━━━━━
  HOSPITAL BILL • HP:{hp}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$22k bill. Negotiated to $16k. Wiped a year of contributions. The price of skipping insurance.

+ [📋 Negotiate, get insurance — never again]
    -> invest_biz_grow_40
+ [💳 Bill sent me into a debt spiral]
    -> debt_spiral_30

= pivot
~ age = 32
~ money = 33000

Original idea flopped. Pivoted to consulting.

+ [🚀 Consulting takes off]
    -> invest_biz_grow_40
+ [😞 Consulting flops — take a job]
    -> invest_biz_fail_40


=== invest_recover_30 ===
#theme:invest
~ age = 30
~ money = 38000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  RECOVERY MODE
━━━━━━━━━━━━━━━━━━━━━━━━━━

$500/month since 25. Balance $38k. Behind optimal — solidly on track.

+ [📈 Keep the steady path]
    -> invest_balanced_40


=== invest_slow_30 ===
#theme:invest
~ age = 30
~ money = 14000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  SLOW BUILD
━━━━━━━━━━━━━━━━━━━━━━━━━━

$100/month for five years. $14k. Lifestyle inflation won every raise.

+ [✂️ Cut hard — boost to $600/month]
    -> invest_balanced_40
+ [💭 Keep minimum — something will change]
    -> spend_habit_40


=== invest_max_40 ===
#theme:invest
~ age = 40
~ money = 310000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  AGE {age} • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$310k. Compound doing more work than you are. A $40k inheritance arrives.

+ [📈 Invest all of it]
    -> invest_end_great_65
+ [🏠 Pay off the house, invest the rest]
    -> invest_end_ok_65
+ [💝 Donate half, invest half]
    -> invest_end_ok_65


=== invest_balanced_40 ===
#theme:invest
~ age = 40
~ money = 180000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  BALANCED LIFE • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$180k. Lived well. No regrets yet. Then: a divorce.

+ [💔 Divorce — split assets, $95k gone]
    ~ money -= 95000
    ~ rep -= 10
    -> invest_divorce_42
+ [💑 No divorce — stable, continue]
    -> invest_end_ok_65


=== invest_divorce_42 ===
#theme:invest
~ age = 42
~ money = 85000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  STARTING OVER AT {age}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$95k gone. Tired. Starting partially over.

+ [💪 Rebuild aggressively — $800/month]
    -> invest_end_recover_65
+ [😮‍💨 Checked out — just coast]
    -> invest_end_ok_65


=== invest_biz_grow_40 ===
#theme:invest
~ age = 40
~ money = 895000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  BUSINESS • 8 EMPLOYEES
━━━━━━━━━━━━━━━━━━━━━━━━━━

$600k revenue. Wealthy on paper.

+ [🎯 Take it to 65]
    -> invest_end_biz_65


=== invest_biz_fail_40 ===
#theme:invest
~ age = 40
~ money = 52000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  AFTER THE BUSINESS
━━━━━━━━━━━━━━━━━━━━━━━━━━

Business closed at 32. Corporate job at 35. Never stopped investing.

+ [📈 Take it to 65]
    -> invest_end_recover_65


// ── INVEST ENDINGS ──────────────────────────────────────────

=== invest_end_great_65 ===
#theme:invest
#ending:win
~ age = 65
~ money = 2100000
╔══════════════════════════╗
║  FINANCIAL FREEDOM       ║
║  AGE 65 • $2.1M          ║
╚══════════════════════════╝

Retired at 62. The $1k your uncle gave you never stopped compounding.

Status: { get_money_status() } • Health: { get_health_status() }
Net worth: { get_net_worth_label() } • Standing: { get_social_label() }
Life score: { get_life_score() }/100

+ [▶ Play again]  -> restart

=== invest_end_ok_65 ===
#theme:invest
#ending:win
~ age = 65
~ money = 890000
╔══════════════════════════╗
║  COMFORTABLE — AGE 65    ║
║  $890k                   ║
╚══════════════════════════╝

Status: { get_money_status() } • Rep: { get_rep_label() }
Net worth: { get_net_worth_label() } • Life score: { get_life_score() }/100

+ [▶ Play again]  -> restart

=== invest_end_biz_65 ===
#theme:invest
#ending:win
~ age = 65
~ money = 1900000
╔══════════════════════════╗
║  BUSINESS EXIT — AGE 65  ║
║  $1.9M                   ║
╚══════════════════════════╝

Sold at 58. Bumpy road, real destination.

+ [▶ Play again]  -> restart

=== invest_end_recover_65 ===
#theme:invest
#ending:mid
~ age = 65
~ money = 520000
╔══════════════════════════╗
║  RECOVERY — AGE 65       ║
║  $520k                   ║
╚══════════════════════════╝

Started late, stumbled twice, still got here.

Status: { get_money_status() } • Health: { get_health_status() }
Net worth: { get_net_worth_label() } • Standing: { get_social_label() }
Life score: { get_life_score() }/100

+ [▶ Play again]  -> restart


// ============================================================
//  MEME COIN PATH
//  Stitches inside meme_start for the early fork
// ============================================================

=== meme_start ===
#theme:crypto
~ money = 1000
-> buy_in

= buy_in
━━━━━━━━━━━━━━━━━━━━━━━━━━
  CRYPTO PATH • AGE {age}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$DONUT. 250,000 coins. Telegram group: 80,000 members. You check the price every 20 minutes.

+ [💰 It doubled — cash out at $1,800]
    -> meme_start.cashout
+ [🙏 Hold — going to $0.10]
    -> meme_start.hold
+ [🔥 Double down — buy $500 more]
    -> meme_start.double_down

= cashout
~ age = 21
~ money = 1800
━━━━━━━━━━━━━━━━━━━━━━━━━━
  CASHED OUT • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Sold. Discord called you paper hands. Coin crashed the following week.

+ [📈 Invest it — done with crypto]
    -> invest_latestart_25
+ [🔄 Find the next coin]
    -> meme_cycle_25
+ [🛍️ Spend it — you earned it]
    -> spend_habit_25
+ [📱 Tell everyone online — you called the top]
    -> meme_influencer_22

= hold
~ age = 21
~ money = 10
━━━━━━━━━━━━━━━━━━━━━━━━━━
  RUGGED • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Dev wallets moved. $1,000 became $10 in 48 hours.

+ [🔄 Find the next coin]
    -> meme_cycle_25
+ [💼 Walk away — get a job and invest]
    -> invest_latestart_25
+ [😈 Run your own pump and dump]
    -> meme_scheme_25
+ [😤 Rage-trade alts to get it back]
    -> meme_rage_22

= double_down
~ age = 21
~ money = 40
━━━━━━━━━━━━━━━━━━━━━━━━━━
  WHALE DUMPED • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$2,300 became $40 in four hours. You sit in silence.

+ [🎓 Learn the lesson — invest and move on]
    -> invest_latestart_25
+ [😤 Chase losses — next coin will be different]
    -> meme_cycle_25


=== meme_influencer_22 ===
#theme:crypto
~ age = 22
~ money = 2200
~ rep = 115
━━━━━━━━━━━━━━━━━━━━━━━━━━
  GOING VIRAL • REP:{rep}
━━━━━━━━━━━━━━━━━━━━━━━━━━

12,000 followers overnight. You have a platform. What you do with it matters.

+ [💸 Paid promotions for other coins]
    -> meme_shill_25
+ [🏛️ Stay honest — only share what you believe]
    -> meme_educator_25


=== meme_shill_25 ===
#theme:crypto
~ age = 25
~ money = 14000
~ rep = 60
━━━━━━━━━━━━━━━━━━━━━━━━━━
  SHILL ERA • REP:{rep}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Made $14k. One coin rugged. Followers gone. Some sent messages you still think about.

+ [🛑 Quit — invest the $14k]
    -> invest_simple_30
+ [📢 Double down on shilling]
    -> meme_scheme_25


=== meme_educator_25 ===
#theme:crypto
~ age = 25
~ money = 8000
~ rep = 130
━━━━━━━━━━━━━━━━━━━━━━━━━━
  FINANCIAL CONTENT • REP:{rep}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Honest content. Slow growth. Real trust.

+ [📺 Grow the channel seriously]
    -> meme_creator_30
+ [💰 Cash out — pivot to investing]
    -> invest_simple_30


=== meme_creator_30 ===
#theme:crypto
~ age = 30
~ money = 55000
~ rep = 140
━━━━━━━━━━━━━━━━━━━━━━━━━━
  CREATOR • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$6k/month from the channel. Teaching others not to do what you almost did at 18. The irony is your brand.

+ [🎯 Take it to 65]
    -> meme_creator_65


=== meme_creator_65 ===
#theme:crypto
#ending:win
~ age = 65
~ money = 1200000
╔══════════════════════════╗
║  CREATOR WIN — AGE 65    ║
║  $1.2M                   ║
╚══════════════════════════╝

Built real wealth teaching others not to chase it.

Rep: { get_rep_label() }

+ [▶ Play again]  -> restart


=== meme_rage_22 ===
#theme:crypto
~ age = 22
~ money = -800
~ mp -= 20
━━━━━━━━━━━━━━━━━━━━━━━━━━
  RAGE TRADING • MP:{mp}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Six alts. Down $800. Borrowed from a friend who doesn't know why.

+ [🛑 Stop. Pay friend back. Move on.]
    -> invest_latestart_25
+ [🔄 One more cycle — so close to even]
    -> meme_cycle_25


=== meme_cycle_25 ===
#theme:crypto
~ age = 25
~ money = 5000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  4 YEARS OF CYCLES
━━━━━━━━━━━━━━━━━━━━━━━━━━

Net +$3k on pure luck. Exhausted. Then: an envelope from the IRS.

+ [📋 Face it — unreported crypto gains]
    -> meme_tax_audit_26
+ [💼 Cash out — index funds forever]
    -> invest_recover_30
+ [📊 Keep going — charts are cleaner now]
    -> meme_deep_30


=== meme_tax_audit_26 ===
#theme:crypto
-> audit

= audit
~ age = 26
~ money = 1200
━━━━━━━━━━━━━━━━━━━━━━━━━━
  IRS AUDIT
━━━━━━━━━━━━━━━━━━━━━━━━━━

$3,800 in back taxes and penalties. Wiped most of the gains.

+ [📝 File correctly going forward]
    -> invest_latestart_25
+ [🙈 Hide it and keep trading]
    -> meme_scheme_25


=== meme_scheme_25 ===
#theme:crypto
~ age = 25
~ money = 3000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  $ROCKETFUEL • LEGAL RISK
━━━━━━━━━━━━━━━━━━━━━━━━━━

Fake roadmap. $11k in 72 hours. Then an SEC investigator DM'd you.

+ [🤝 Cooperate — take the plea deal]
    -> meme_jail_30
+ [👻 Ghost it — lawyer up and disappear]
    -> meme_on_the_run_28


=== meme_on_the_run_28 ===
#theme:crypto
~ age = 28
~ money = -8000
~ rep = 20
━━━━━━━━━━━━━━━━━━━━━━━━━━
  WARRANT OUT • REP:{rep}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Avoided it two years. Arrest warrant issued. Lawyer: $18k.

+ [🙋 Surrender and cooperate]
    -> meme_jail_30
+ [✈️ Flee — no extradition country]
    -> meme_fugitive_end


=== meme_fugitive_end ===
#theme:crypto
#ending:loss
~ age = 35
~ money = 4000
~ rep = 5
╔══════════════════════════╗
║  FUGITIVE — AGE 35       ║
╚══════════════════════════╝

Living abroad under a different name. No family contact. $4k left. Technically free. Completely trapped.

Status: { get_money_status() } • Rep: { get_rep_label() }
Net worth: { get_net_worth_label() } • Life score: { get_life_score() }/100

+ [↩ Turn yourself in]  -> meme_jail_30
+ [▶ Play again]        -> restart


=== meme_deep_30 ===
#theme:crypto
~ age = 30
~ money = 8000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  12 YEARS IN CRYPTO
━━━━━━━━━━━━━━━━━━━━━━━━━━

Net ~$8k. Every stock market bull run: missed. The 2033 cycle is starting.

+ [🛑 Quit cold turkey — seek help]
    -> gateway_age30_recovery
+ [🚀 Ride the bull — this is your year]
    -> meme_final_cycle_35


=== meme_final_cycle_35 ===
#theme:crypto
~ age = 35
~ money = 62000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  BULL RUN • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$62k. Euphoric. Still going up.

+ [💼 Cash out EVERYTHING into index funds NOW]
    -> invest_balanced_40
+ [🙏 Ride it further — never been this right]
    -> meme_crash_37


=== meme_crash_37 ===
#theme:crypto
~ age = 37
~ money = 4000
~ mp -= 20
━━━━━━━━━━━━━━━━━━━━━━━━━━
  THE CRASH
━━━━━━━━━━━━━━━━━━━━━━━━━━

Rode it to $180k on paper. Watched it fall to $4k. Classic.

+ [🏳️ Finally done. Seek help. Rebuild.]
    -> seek_help_30


=== meme_jail_30 ===
#theme:crypto
~ age = 30
~ money = -22000
~ rep = 20
━━━━━━━━━━━━━━━━━━━━━━━━━━
  PLEA DEAL • REP:{rep}
━━━━━━━━━━━━━━━━━━━━━━━━━━

18 months probation. $22k fine. SEC press release with your name.

+ [💼 Regular job — start completely over]
    -> seek_help_30


=== meme_cycle_30 ===
#theme:crypto
~ age = 30
~ money = 14000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  STILL CYCLING
━━━━━━━━━━━━━━━━━━━━━━━━━━

Bull run at 29. $22k made. Current balance: $14k. Index funds: $0.

+ [🏦 Move everything to index funds — done]
    -> invest_balanced_40
+ [🎲 Ride one more cycle]
    -> meme_crash_37


=== meme_end_loss_65 ===
#theme:crypto
#ending:loss
~ age = 65
~ money = 14000
╔══════════════════════════╗
║  LIFETIME CHASER — 65    ║
╚══════════════════════════╝

40 years. Net lifetime loss: -$28k. Social Security is everything.

Status: { get_money_status() } • Health: { get_health_status() }
Net worth: { get_net_worth_label() } • Standing: { get_social_label() }
Life score: { get_life_score() }/100

+ [▶ Play again]  -> restart


// ============================================================
//  GAMBLING PATH
//  Stitches inside gamble_start for the opening fork
// ============================================================

=== gamble_start ===
#theme:gamble
~ money = 1400
-> first_night

= first_night
━━━━━━━━━━━━━━━━━━━━━━━━━━
  CASINO PATH • AGE {age}
━━━━━━━━━━━━━━━━━━━━━━━━━━

First night up $400. Blackjack feels like a skill. You come back the next weekend.

+ [🏃 Walk away — invest the $1,400]
    -> gamble_start.quit_early
+ [🎯 Casual visits — strict $100 loss limit]
    -> gamble_start.casual
+ [♠️ Keep playing — you have an edge]
    -> gamble_spiral_21

= quit_early
~ age = 21

Cashed out. Never went back. Most people can't do that.

+ [📈 Invest the $1,400]
    -> invest_latestart_25

= casual
~ age = 21
~ money = 2200
━━━━━━━━━━━━━━━━━━━━━━━━━━
  CASUAL GAMBLER
━━━━━━━━━━━━━━━━━━━━━━━━━━

$100/visit. Sometimes win. Mostly lose a little. Small investment account started.

+ [⚖️ Keep the balance — it's under control]
    -> gamble_trip_23
+ [⚠️ Limit is creeping up — address it now]
    -> gamble_creep_25


=== gamble_trip_23 ===
#theme:gamble
~ age = 23
━━━━━━━━━━━━━━━━━━━━━━━━━━
  VEGAS TRIP INVITE
━━━━━━━━━━━━━━━━━━━━━━━━━━

Friends invite you for a long weekend.

+ [✅ Go — strict $200 limit]
    -> gamble_rec_30
+ [🎰 Go — no limit, it's Vegas]
    -> gamble_spiral_21
+ [🏠 Skip it — weekend costs $800]
    -> gamble_rec_30


=== gamble_spiral_21 ===
#theme:gamble
~ age = 21
~ money = 400
━━━━━━━━━━━━━━━━━━━━━━━━━━
  SPIRAL BEGINS
━━━━━━━━━━━━━━━━━━━━━━━━━━

Up $800 one weekend. Down $500 the next. Net -$600. Casino knows your name.

+ [🛑 Stop cold — cut it off]
    -> gamble_stop_25
+ [💰 Take a $500 loan to get even]
    -> gamble_debt_25
+ [📱 Sports betting — way more skill]
    -> gamble_sports_25
+ [♠️ Poker — actual skill game]
    -> gamble_poker_22


=== gamble_poker_22 ===
#theme:gamble
-> learn

= learn
~ age = 22
~ money = 1800
━━━━━━━━━━━━━━━━━━━━━━━━━━
  POKER — YEAR ONE
━━━━━━━━━━━━━━━━━━━━━━━━━━

Online poker. Year one: actually profitable. Up $1,400.

+ [📚 Take it seriously — study the game]
    -> gamble_poker_22.pro
+ [😌 Get comfortable — start playing loosely]
    -> gamble_poker_22.tilt

= pro
~ age = 25
~ money = 9000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  POKER SEMI-PRO
━━━━━━━━━━━━━━━━━━━━━━━━━━

$9k net. Taxable. Owns your weekends.

+ [📊 Treat it like a business — invest profits]
    -> invest_simple_30
+ [🎯 Move up stakes — bigger risk]
    -> gamble_poker_22.high_stakes

= tilt
~ age = 24
~ money = -1200
━━━━━━━━━━━━━━━━━━━━━━━━━━
  TILT — DOWN $1,200
━━━━━━━━━━━━━━━━━━━━━━━━━━

Three bad sessions. Playing emotionally. Down $1,200 from tilt losses alone.

+ [💸 Cash out remaining bankroll — quit]
    -> invest_latestart_25
+ [🔄 Reload and grind back]
    -> gamble_debt_25

= high_stakes
~ age = 27
~ money = -4000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  HIGH STAKES LOSS
━━━━━━━━━━━━━━━━━━━━━━━━━━

Out of bankroll in one brutal month. Down $4k.

+ [🛑 Quit — invest whatever is left]
    -> invest_latestart_25
+ [💰 Borrow to reload]
    -> gamble_debt_30


=== gamble_creep_25 ===
#theme:gamble
~ age = 25
~ money = 3000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  LIMITS CREEPING
━━━━━━━━━━━━━━━━━━━━━━━━━━

$100 became $350. Down $2,800 total. Haven't told anyone.

+ [🤝 GA meeting — hard stop]
    -> seek_help_30
+ [🎰 One more run to break even]
    -> gamble_debt_30


=== gamble_stop_25 ===
#theme:gamble
~ age = 25
~ money = 8400
━━━━━━━━━━━━━━━━━━━━━━━━━━
  HARD STOP
━━━━━━━━━━━━━━━━━━━━━━━━━━

Quit at 22. Net loss $1,200. Roth IRA opened. Moved on.

+ [📈 Continue investing path]
    -> invest_simple_30


=== gamble_sports_25 ===
#theme:gamble
~ age = 25
~ money = 500
━━━━━━━━━━━━━━━━━━━━━━━━━━
  SPORTS BETTING
━━━━━━━━━━━━━━━━━━━━━━━━━━

App. 24/7 prop bets. Down $4k net.

+ [🏈 Join office fantasy football — low stakes, social]
    -> gamble_fantasy_26
+ [🗑️ Delete all apps — get help]
    -> seek_help_30
+ [🎲 One big parlay to get even]
    -> gamble_debt_30


=== gamble_fantasy_26 ===
#theme:gamble
~ age = 26
~ money = 1200
━━━━━━━━━━━━━━━━━━━━━━━━━━
  FANTASY FOOTBALL
━━━━━━━━━━━━━━━━━━━━━━━━━━

Fantasy kept it fun and social. Sports app deleted.

+ [⚖️ Keep it just fantasy — invest the rest]
    -> invest_latestart_25
+ [⚠️ Fantasy led back to sports betting]
    -> gamble_sports_25


=== gamble_debt_25 ===
#theme:gamble
~ age = 25
~ money = -1800
━━━━━━━━━━━━━━━━━━━━━━━━━━
  BORROWED TO GAMBLE
━━━━━━━━━━━━━━━━━━━━━━━━━━

$500 loan became $1,800 at 30% interest.

+ [😔 Come clean — accept help]
    -> seek_help_30
+ [🎰 Gamble to repay it]
    -> gamble_debt_30


=== gamble_rec_30 ===
#theme:gamble
~ age = 30
~ money = 44000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  RECREATIONAL • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Entertainment budget held 12 years. $44k invested alongside. Friend asks you to stake him $2k.

+ [🤝 Stake him — it's a loan]
    -> gamble_stake_31
+ [🙅 Decline — keep your money clean]
    -> gamble_end_rec_65


=== gamble_stake_31 ===
#theme:gamble
~ age = 31
~ money = 42000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  STAKED FRIEND
━━━━━━━━━━━━━━━━━━━━━━━━━━

He ran it to $6k then tilted it all away. $2k gone.

+ [✍️ Write it off — expensive lesson]
    -> gamble_end_rec_65
+ [🎰 Chase it — stake him again]
    -> gamble_debt_30


=== gamble_debt_30 ===
#theme:gamble
~ age = 30
~ money = -11000
~ hp -= 35
━━━━━━━━━━━━━━━━━━━━━━━━━━
  ROCK BOTTOM • HP:{hp}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$11k in debt. Credit 520. Called in sick twice to gamble.

Health: { get_health_status() }

+ [🏥 Check into treatment today]
    -> seek_help_30
+ [🎰 Win it back this weekend]
    -> gamble_end_loss_65


=== gamble_end_rec_65 ===
#theme:gamble
#ending:mid
~ age = 65
~ money = 340000
╔══════════════════════════╗
║  RECREATIONAL — AGE 65   ║
║  $340k                   ║
╚══════════════════════════╝

Gambling stayed entertainment. Investing stayed strategy. Two tracks that never crossed.

+ [▶ Play again]  -> restart


=== gamble_end_loss_65 ===
#theme:gamble
#ending:loss
~ age = 65
~ money = 9000
╔══════════════════════════╗
║  THE HOUSE WON — AGE 65  ║
╚══════════════════════════╝

$9k. Working part-time. Lifetime losses: ~$85k.

Status: { get_money_status() } • Health: { get_health_status() }
Net worth: { get_net_worth_label() } • Standing: { get_social_label() }
Life score: { get_life_score() }/100

+ [▶ Play again]  -> restart


// ============================================================
//  SPEND PATH
// ============================================================

=== spend_start ===
#theme:spend
~ money = 0
━━━━━━━━━━━━━━━━━━━━━━━━━━
  SPEND PATH • AGE {age}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$1k gone in three weeks. Outfit. Dinner. Concert. Shoes. Trip. All real. All gone.

+ [📈 Start fresh — invest from next paycheck]
    -> invest_latestart_25
+ [🛍️ Keep this pattern]
    -> spend_habit_25
+ [⚖️ Find balance — spend some, save some]
    -> spend_balance_25
+ [💼 Start a side hustle to fund the lifestyle]
    -> spend_hustle_20


=== spend_hustle_20 ===
#theme:spend

= launch
~ age = 20
~ money = 2400
~ has_side_income = true
━━━━━━━━━━━━━━━━━━━━━━━━━━
  RESELLER HUSTLE
━━━━━━━━━━━━━━━━━━━━━━━━━━

Sneaker reselling. Extra $600/month. Funding the lifestyle without debt.

+ [📈 Invest half the hustle income]
    -> invest_consistent_25
+ [🏢 Scale into a real business]
    -> invest_biz_30
+ [🛍️ Spend it all — hustle replaces saving]
    -> spend_habit_25


=== spend_habit_25 ===
#theme:spend
~ age = 25
~ money = 400
━━━━━━━━━━━━━━━━━━━━━━━━━━
  LIFESTYLE TRAP • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Earn $52k. Spend $51,800. One medical bill from a crisis. Friend just bought a house.

+ [🏠 Buy more than you can afford — keep up]
    -> spend_fomo_26
+ [📚 Read one finance book — do the math]
    -> spend_wake_30
+ [💭 Deal with it later]
    -> spend_habit_40


=== spend_fomo_26 ===
#theme:spend
~ age = 26
~ money = -8000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  FOMO PURCHASE
━━━━━━━━━━━━━━━━━━━━━━━━━━

$8k in credit card debt. The photos looked good.

+ [💸 Sell what you can't afford — cut losses]
    -> spend_wake_30
+ [🎭 Keep up appearances]
    -> spend_habit_40


=== spend_balance_25 ===
#theme:spend
~ age = 25
~ money = 12000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  BALANCED LIFE • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$300/month auto-invest. Rest: life. Then city rent spikes 40%.

+ [🤝 Get a roommate — protect contributions]
    -> spend_balance_40
+ [🌆 Move to a cheaper city]
    -> spend_balance_40
+ [✂️ Cut investing to cover rent]
    -> spend_wake_30


=== spend_wake_30 ===
#theme:spend
~ age = 30
~ money = 8000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  WAKE-UP CALL
━━━━━━━━━━━━━━━━━━━━━━━━━━

Did the math at 28. Could have $180k. Have $1,200. Was sick for a week thinking about it. $500/month auto-invest started.

+ [📈 Stay the course]
    -> spend_recover_65


=== spend_habit_40 ===
#theme:spend
~ age = 40
~ money = 3200
━━━━━━━━━━━━━━━━━━━━━━━━━━
  STILL DRIFTING • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$75k income. $74,800 spent. Then a health scare — no buffer.

+ [💡 Wake-up call — build fund first]
    -> spend_wake_30
+ [🚨 Extreme cut — max 401k for 25 years]
    -> spend_panic_65
+ [💭 Keep going — it will work out]
    -> spend_end_loss_65


=== spend_balance_40 ===
#theme:spend
~ age = 40
~ money = 98000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  BALANCED AT 40 • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Traveled and invested. No debt. Present for all of it.

+ [🎯 See age 65]
    -> spend_end_balance_65


=== spend_recover_65 ===
#theme:spend
#ending:mid
~ age = 65
~ money = 310000
╔══════════════════════════╗
║  LATE RECOVERY — AGE 65  ║
║  $310k                   ║
╚══════════════════════════╝
Status: { get_money_status() } • Net worth: { get_net_worth_label() }
Life score: { get_life_score() }/100
+ [▶ Play again]  -> restart

=== spend_end_balance_65 ===
#theme:spend
#ending:win
~ age = 65
~ money = 480000
╔══════════════════════════╗
║  BALANCED — AGE 65       ║
║  $480k                   ║
╚══════════════════════════╝

Stories and security both.

+ [▶ Play again]  -> restart

=== spend_panic_65 ===
#theme:spend
#ending:mid
~ age = 65
~ money = 220000
╔══════════════════════════╗
║  LATE SPRINT — AGE 65    ║
║  $220k                   ║
╚══════════════════════════╝
+ [▶ Play again]  -> restart

=== spend_end_loss_65 ===
#theme:spend
#ending:loss
~ age = 65
~ money = 8000
╔══════════════════════════╗
║  SPENT IT ALL — AGE 65   ║
╚══════════════════════════╝

The life was real. The future arrived anyway.

Status: { get_money_status() } • Net worth: { get_net_worth_label() }
Life score: { get_life_score() }/100

+ [▶ Play again]  -> restart


// ============================================================
//  DEBT PATH
//  Stitches inside debt_start
// ============================================================

=== debt_start ===
#theme:debt
~ money = 1000
-> open_card

= open_card
━━━━━━━━━━━━━━━━━━━━━━━━━━
  DEBT PATH • AGE {age}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Credit card. 24.99% APR. $800 spent day one. Minimum payment: $25.

+ [✅ Pay in full every month — use it for points]
    -> debt_start.smart
+ [💸 Minimum payments — keep the cash]
    -> debt_start.minimum
+ [🎓 Student loans too — college pays off]
    -> debt_student_25
+ [📦 Buy Now Pay Later everything]
    -> debt_start.bnpl

= smart
~ age = 25
~ money = 4200
━━━━━━━━━━━━━━━━━━━━━━━━━━
  CREDIT SMART • Score: 760
━━━━━━━━━━━━━━━━━━━━━━━━━━

Cashback covers a flight every year. Zero interest ever paid. Friend asks you to cosign.

+ [🤝 Cosign — he's good for it]
    ~ rep += 5
    -> debt_start.cosign
+ [🙅 Decline — protect your credit]
    -> invest_simple_30

= cosign
~ age = 26
~ money = 4200
~ rep = 85
━━━━━━━━━━━━━━━━━━━━━━━━━━
  COSIGN FALLOUT • REP:{rep}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Friend missed three payments. Your credit: 680.

+ [💰 Cover payments — protect your score]
    -> invest_slow_30
+ [✂️ Let it fall — cut ties]
    -> invest_latestart_25

= minimum
~ age = 25
~ money = -2400
━━━━━━━━━━━━━━━━━━━━━━━━━━
  MINIMUM TRAP • -${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Paid $680 in minimums. Still owe nearly as much. Balance grew.

+ [💪 Avalanche — every spare dollar toward it]
    -> debt_payoff_30
+ [🔄 Balance transfer to 0% for 18 months]
    -> debt_start.transfer
+ [💳 Open another card]
    -> debt_spiral_30

= transfer
~ age = 26
~ money = -2400
━━━━━━━━━━━━━━━━━━━━━━━━━━
  BALANCE TRANSFER
━━━━━━━━━━━━━━━━━━━━━━━━━━

0% for 18 months. Pay off in time: free. Miss the window: back-interest hits.

+ [📅 Disciplined — pay it off in time]
    -> debt_payoff_30
+ [😌 Treat 0% as breathing room — keep spending]
    -> debt_spiral_30

= bnpl
~ age = 21
~ money = -3200
~ debt_count = 4
━━━━━━━━━━━━━━━━━━━━━━━━━━
  BNPL SPIRAL • DEBT:{debt_count}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Four BNPL plans running. Lost track. Missed two payments.

+ [🔄 Consolidate — pay everything off]
    -> debt_payoff_30
+ [💳 Open a new card to cover payments]
    -> debt_spiral_30


=== debt_student_25 ===
#theme:debt
~ age = 25
~ money = -40000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  STUDENT LOANS • -$40k
━━━━━━━━━━━━━━━━━━━━━━━━━━

$48k salary. $430/month payment. The degree got you the job. The loan owns part of every paycheck.

+ [⚡ Aggressive 5-year payoff]
    -> debt_student_good_30
+ [📋 IDR plan — low payments, invest the difference]
    -> debt_idr_27
+ [🐢 Minimum payments for life]
    -> debt_student_bad_30


=== debt_idr_27 ===
#theme:debt
~ age = 27
~ money = 9000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  IDR PLAN • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$110/month payments. Investing the difference. Balance growing slowly.

+ [⚡ Switch to aggressive payoff]
    -> debt_student_good_30
+ [🏛️ Stay on IDR — target forgiveness at year 20]
    -> debt_forgiveness_37


=== debt_forgiveness_37 ===
#theme:debt
~ age = 37
~ money = 28000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  LOAN FORGIVENESS
━━━━━━━━━━━━━━━━━━━━━━━━━━

Loans forgiven after 20 years. $28k taxable event.

+ [📋 Had tax savings set aside — clean exit]
    -> invest_balanced_40
+ [😱 Didn't save for the tax bill]
    -> debt_spiral_30


=== debt_payoff_30 ===
#theme:debt
~ age = 30
~ money = 17000
~ has_emergency_fund = true
━━━━━━━━━━━━━━━━━━━━━━━━━━
  DEBT-FREE • EMERGENCY FUND
━━━━━━━━━━━━━━━━━━━━━━━━━━

Debt-free at 27. $400/month redirected to investing. You sleep differently now.

+ [📈 Continue building]
    -> invest_end_recover_65


=== debt_spiral_30 ===
#theme:debt
~ age = 30
~ money = -14000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  DEBT SPIRAL
━━━━━━━━━━━━━━━━━━━━━━━━━━

Four cards. $280/month in pure interest. Treading water.

Status: { get_money_status() } • Net worth: { get_net_worth_label() }
Life score: { get_life_score() }/100

+ [🤝 Nonprofit credit counseling]
    -> seek_help_30
+ [😬 Keep juggling]
    -> debt_end_loss_65
+ [⚖️ Declare Chapter 7 bankruptcy]
    -> debt_bankruptcy_32


=== debt_bankruptcy_32 ===
#theme:debt
~ age = 32
~ money = 0
~ rep = 55
━━━━━━━━━━━━━━━━━━━━━━━━━━
  BANKRUPTCY • REP:{rep}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Chapter 7 discharged. Credit destroyed for 7 years. Starting from $0.

+ [🔨 Hard reset — build carefully]
    -> seek_help_30
+ [▶ Play again]
    -> restart


=== debt_student_good_30 ===
#theme:debt
~ age = 30
~ money = 21000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  LOANS PAID • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Loans paid at 29. $600/month investing since.

+ [📈 Continue]
    -> invest_end_ok_65


=== debt_student_bad_30 ===
#theme:debt
~ age = 30
~ money = -31000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  STILL OWING • -$31k
━━━━━━━━━━━━━━━━━━━━━━━━━━

Salary stalled. Degree didn't compound the way you hoped.

+ [📈 Invest alongside loans — compound wins long-term]
    -> invest_slow_30
+ [💪 Destroy loans first]
    -> debt_payoff_30


=== debt_end_loss_65 ===
#theme:debt
#ending:loss
~ age = 65
~ money = 11000
╔══════════════════════════╗
║  LIFETIME DEBT — AGE 65  ║
╚══════════════════════════╝

$120k in lifetime interest paid. $11k saved.

Status: { get_money_status() } • Net worth: { get_net_worth_label() }
Life score: { get_life_score() }/100

+ [▶ Play again]  -> restart


// ============================================================
//  PARTY / DRUGS PATH
//  Stitches inside party_start
// ============================================================

=== party_start ===
#theme:party
~ hp = 95
~ money = 0
-> weekend

= weekend
━━━━━━━━━━━━━━━━━━━━━━━━━━
  PARTY PATH • HP:{hp}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$1k on a legendary weekend. You are the fun one. For now.

+ [🌙 Keep it recreational — weekends only]
    -> party_start.casual
+ [🌊 This is the scene now — all in]
    -> party_start.deep

= casual
~ age = 21
~ money = 500
━━━━━━━━━━━━━━━━━━━━━━━━━━
  CASUAL • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Weekends. Job during the week. Friends invite you to a summer of festivals.

+ [🎵 Summer of festivals — $3k, life-changing]
    -> party_festival_22
+ [📈 Start investing some of each paycheck]
    -> invest_latestart_25
+ [💼 Work hard, party harder — drift with it]
    -> party_drift_25

= deep
~ age = 21
~ hp -= 20
~ money = -4000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  DUI • HP:{hp} • -$4,000
━━━━━━━━━━━━━━━━━━━━━━━━━━

DUI at 20. $4k legal fees on a credit card. Friends looking at you differently.

+ [🤝 AA or NA — ask for help now]
    -> party_recovery_25
+ [😬 One mistake — I can manage this]
    -> party_addiction_25


=== party_festival_22 ===
#theme:party
~ age = 22
~ money = -800
~ rep = 115
━━━━━━━━━━━━━━━━━━━━━━━━━━
  BEST SUMMER • REP:{rep}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$3k spent. $800 overdrawn. Memories that don't fit into words.

+ [🛌 That was enough — invest now]
    -> invest_latestart_25
+ [🌊 Chase that feeling — go deeper]
    -> party_start.deep


=== party_drift_25 ===
#theme:party
~ age = 25
~ money = 800
━━━━━━━━━━━━━━━━━━━━━━━━━━
  DRIFTING • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Going out 3x/week. Friends buying houses. Got passed over for a promotion.

+ [💼 Missed promotion — two hungover mornings on record]
    -> party_promo_missed_26
+ [📈 Invest a little — find some balance]
    -> spend_balance_25
+ [🌊 Keep drifting]
    -> spend_habit_40


=== party_promo_missed_26 ===
#theme:party
~ age = 26
~ money = 2000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  COURSE CORRECT
━━━━━━━━━━━━━━━━━━━━━━━━━━

Passed over. HR record shows two late arrivals.

+ [✂️ Cut back hard — career focus + investments]
    -> spend_wake_30
+ [🏃 Quit — find a job that appreciates you]
    -> party_drift_25


=== party_recovery_25 ===
#theme:party
~ age = 25
~ hp -= 13
~ money = 1200
~ sober_streak = 14
━━━━━━━━━━━━━━━━━━━━━━━━━━
  14 MONTHS SOBER • STREAK:{sober_streak}
━━━━━━━━━━━━━━━━━━━━━━━━━━

DUI debt cleared. New job. Old friend texts: "Party Saturday?"

Health: { get_health_status() }

+ [🎉 Go — you can handle it now]
    -> party_relapse_risk_26
+ [🛡️ Skip it — protect the streak]
    -> seek_help_30


=== party_relapse_risk_26 ===
#theme:party
~ age = 26
━━━━━━━━━━━━━━━━━━━━━━━━━━
  THE TEST
━━━━━━━━━━━━━━━━━━━━━━━━━━

{ sober_streak > 12:
    - You went. You didn't drink. You left at midnight.
      ~ sober_streak = 26
      Health: { get_health_status() } • Streak: {sober_streak} months
      + [🌿 Keep building]
          -> seek_help_30
    - You went. One drink became five. Two-week relapse.
      ~ sober_streak = 0
      ~ hp -= 10
      Health: { get_health_status() }
      + [🔄 Back to the program — reset the clock]
          -> seek_help_30
}


=== party_addiction_25 ===
#theme:party
~ age = 25
~ hp -= 30
~ money = -6000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  ADDICTION • HP:{hp}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Two jobs lost. $6k borrowed from family. Body showing it.

Health: { get_health_status() }

+ [🏥 Inpatient rehab — family helping]
    -> party_rehab_30
+ [🏠 Home detox — 30 days]
    -> party_home_detox_26
+ [✈️ Move cities — fresh start]
    -> party_move_26


=== party_home_detox_26 ===
#theme:party
~ age = 26
~ hp -= 5
━━━━━━━━━━━━━━━━━━━━━━━━━━
  HOME DETOX • HP:{hp}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Made it through — barely. Medically dangerous for some substances.

+ [🏥 Follow up with outpatient program]
    -> party_rehab_30
+ [⚠️ Relapsed at week three]
    -> party_addiction_25


=== party_move_26 ===
#theme:party
~ age = 26
~ money = -8000
~ rep = 60
━━━━━━━━━━━━━━━━━━━━━━━━━━
  NEW CITY • REP:{rep}
━━━━━━━━━━━━━━━━━━━━━━━━━━

New city. Same patterns. Plus $2k moving debt. Geography didn't fix it.

+ [💡 Get real help — geography wasn't the answer]
    -> seek_help_30
+ [🌊 Spiral continues]
    -> party_deep_30


=== party_rehab_30 ===
#theme:party
~ age = 30
~ hp += 10
{ hp > 100:
    ~ hp = 100
}
~ money = -14000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  18 MONTHS CLEAN • HP:{hp}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$14k debt. Some bridges rebuilding. One day at a time.

+ [🌱 Continue recovery]
    -> seek_help_30


=== party_deep_30 ===
#theme:party
~ age = 30
~ hp -= 40
~ money = -18000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  CRISIS POINT • HP:{hp}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Fired. Evicted. Family estranged.

Health: { get_health_status() }

+ [🏥 Crisis intervention — inpatient now]
    -> party_crisis_end
+ [😤 One more attempt alone]
    -> party_end_worst
+ [▶ Play again]
    -> restart


=== party_crisis_end ===
#theme:recovery
~ age = 40
~ hp += 25
{ hp > 100:
    ~ hp = 100
}
~ money = 8000
~ sober_streak = 108
━━━━━━━━━━━━━━━━━━━━━━━━━━
  9 YEARS SOBER • STREAK:{sober_streak}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$8k saved. Some bridges rebuilt. Some burned permanently.

Health: { get_health_status() }

+ [👴 See age 70+]
    -> party_70
+ [▶ Play again]
    -> restart


=== party_70 ===
#theme:recovery
#ending:mid
~ age = 70
~ hp += 5
{ hp > 100:
    ~ hp = 100
}
~ money = 18000
~ sober_streak = 600
╔══════════════════════════╗
║  AGE 70+ — SOBER         ║
╚══════════════════════════╝

40 years sober. Never built real wealth. Present at every birthday. Every graduation. The people you almost lost came back.

Health: { get_health_status() }

+ [▶ Play again]  -> restart


=== party_end_worst ===
#theme:party
#ending:loss
~ age = 35
~ hp -= 20
~ money = 0
╔══════════════════════════╗
║  HOSPITALISED — AGE 35   ║
╚══════════════════════════╝

Hospitalised at 33. Organ damage. Recovery house at 35.

━━━━━━━━━━━━━━━━━━━━━━━━━━
  CRISIS LINE: SAMHSA 1-800-662-4357
━━━━━━━━━━━━━━━━━━━━━━━━━━

+ [▶ Play again]  -> restart


// ============================================================
//  MLM / SCAM PATH
//  Stitches inside mlm_start
// ============================================================

=== mlm_start ===
#theme:mlm
~ money = 200
-> join

= join
━━━━━━━━━━━━━━━━━━━━━━━━━━
  MLM PATH • AGE {age}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$800 starter kit. $200 left. Posting about financial freedom every day.

3 months later: made $40, spent $1,100.

+ [🚪 Get out — $1,100 is a cheap lesson]
    -> mlm_start.exit_early
+ [🔝 Keep recruiting — need more people]
    -> mlm_start.go_deep
+ [💻 Someone online has a better opportunity]
    -> mlm_start.online_scam

= exit_early
~ age = 21
~ money = 40
━━━━━━━━━━━━━━━━━━━━━━━━━━
  MLM EXIT • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Lost $1,100. Made $40. Lesson earned cheap.

+ [📈 Invest going forward]
    -> invest_latestart_25
+ [⚠️ Warn others — start a scam-awareness account]
    -> mlm_whistleblow_23

= go_deep
~ age = 21
~ money = -2210
━━━━━━━━━━━━━━━━━━━━━━━━━━
  DEEPER IN • -$2,210
━━━━━━━━━━━━━━━━━━━━━━━━━━

Recruited 4 friends. Down $2,210. Two aren't returning your calls.

+ [💔 Cut losses — apologise and move on]
    -> mlm_exit_damaged_25
+ [🔝 One more level — car bonus at 8 recruits]
    -> mlm_ruin_25
+ [🏭 Start your own competing product]
    -> mlm_own_product_23

= online_scam
~ age = 21
~ money = -300
━━━━━━━━━━━━━━━━━━━━━━━━━━
  SCAMMED
━━━━━━━━━━━━━━━━━━━━━━━━━━

Wired $500. They blocked you immediately.

+ [📋 Report to FTC — warn others, move on]
    -> mlm_start.exit_early
+ [💸 Send $300 more — processing error they said]
    -> mlm_scam_deep_25


=== mlm_whistleblow_23 ===
#theme:mlm
~ age = 23
~ money = 2200
~ rep = 125
━━━━━━━━━━━━━━━━━━━━━━━━━━
  SCAM AWARENESS • REP:{rep}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Modest following. Honest brand partnerships.

+ [📺 Grow it — keep it honest]
    -> meme_educator_25
+ [💰 Pivot to investing education]
    -> invest_latestart_25


=== mlm_own_product_23 ===
#theme:mlm
~ age = 23
~ money = -5000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  OWN SUPPLEMENT LINE
━━━━━━━━━━━━━━━━━━━━━━━━━━

Manufacturing: $5k. Revenue: $800. Lesson: product-market fit matters.

+ [📦 Pivot to dropshipping]
    -> mlm_dropship_25
+ [🛑 Cut losses — this industry is a trap]
    -> seek_help_30


=== mlm_dropship_25 ===
#theme:mlm
~ age = 25
~ money = 6000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  DROPSHIPPING • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

$6k/month revenue. $2k profit. Actually working.

+ [🚀 Scale it — hire a VA, run ads]
    -> invest_biz_30
+ [💰 Cash out while ahead]
    -> invest_simple_30


=== mlm_exit_damaged_25 ===
#theme:mlm
~ age = 25
~ money = 3000
~ rep = 72
━━━━━━━━━━━━━━━━━━━━━━━━━━
  DAMAGE DONE • REP:{rep}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Lost $2,400 and trust of 4 people. Two have slowly come back.

+ [🍽️ Host an apology dinner — $200, rep recovers]
    ~ rep += 20
    -> mlm_redemption_26
+ [📈 Move forward — investing path]
    -> invest_latestart_25


=== mlm_redemption_26 ===
#theme:mlm
~ age = 26
~ money = 2800
~ rep = 92
━━━━━━━━━━━━━━━━━━━━━━━━━━
  REDEMPTION • REP:{rep}
━━━━━━━━━━━━━━━━━━━━━━━━━━

All four forgave you. The dinner cost $200 and bought back real relationships.

Rep: { get_rep_label() }

+ [📈 Invest and rebuild]
    -> invest_latestart_25


=== mlm_ruin_25 ===
#theme:mlm
~ age = 25
~ money = -7000
~ rep = 30
━━━━━━━━━━━━━━━━━━━━━━━━━━
  COMPANY COLLAPSED • REP:{rep}
━━━━━━━━━━━━━━━━━━━━━━━━━━

FTC investigation. Lost $7k and most of your social circle.

Rep: { get_rep_label() }

+ [💆 Therapy — honest rebuild]
    -> seek_help_30
+ [▶ Play again]
    -> restart


=== mlm_scam_deep_25 ===
#theme:mlm
~ age = 25
~ money = -1700
━━━━━━━━━━━━━━━━━━━━━━━━━━
  SCAMMED TWICE
━━━━━━━━━━━━━━━━━━━━━━━━━━

Same network. Different name. $1,700 total gone.

+ [💔 Come clean — get support]
    -> seek_help_30
+ [▶ Play again]
    -> restart


// ============================================================
//  SHARED RECOVERY NODE
// ============================================================

=== seek_help_30 ===
#theme:recovery
~ hp = 75
~ mp = 80
~ money = 2000
~ rep = 75
━━━━━━━━━━━━━━━━━━━━━━━━━━
  RECOVERY • AGE ~30
━━━━━━━━━━━━━━━━━━━━━━━━━━

You asked for help. Therapy. FA. NA. Credit counseling. Whatever it took.

Starting from near zero. $2,000. A plan.

Health: { get_health_status() } • Rep: { get_rep_label() }

+ [🧭 Mentor connects you with a financial advisor]
    -> recovery_mentor_path
+ [💰 $300/month — every month, no exceptions]
    -> recovery_invest_40
+ [🛡️ Emergency fund first — then invest]
    -> recovery_slow_40


=== recovery_mentor_path ===
#theme:recovery
-> connect

= connect
~ age = 32
~ money = 4000
~ has_mentor = true
━━━━━━━━━━━━━━━━━━━━━━━━━━
  MENTOR • AGE {age}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Mentor helped you see money differently. Not as the enemy. Not as the score. Just as a tool.

+ [📈 Follow the plan faithfully]
    -> recovery_invest_40


=== recovery_invest_40 ===
#theme:recovery
~ age = 40
~ money = 56000
━━━━━━━━━━━━━━━━━━━━━━━━━━
  REBUILT • ${money}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Ten years of $300/month from rubble. $56k. You sponsor a younger person in recovery.

+ [🌱 Continue sponsoring and investing]
    -> recovery_sponsor_42
+ [👴 See 65]
    -> recovery_end_65


=== recovery_sponsor_42 ===
#theme:recovery
~ age = 42
~ money = 56000
~ rep = 95
━━━━━━━━━━━━━━━━━━━━━━━━━━
  SPONSOR • REP:{rep}
━━━━━━━━━━━━━━━━━━━━━━━━━━

Sponsoring two people. Time-consuming. Deeply meaningful.

Rep: { get_rep_label() }

+ [👴 See 65]
    -> recovery_end_65


=== recovery_slow_40 ===
#theme:recovery
~ age = 40
~ money = 26000
~ has_emergency_fund = true
━━━━━━━━━━━━━━━━━━━━━━━━━━
  FOUNDATION FIRST
━━━━━━━━━━━━━━━━━━━━━━━━━━

Emergency fund built first. $26k invested. Foundation solid.

+ [👴 See 65]
    -> recovery_end_modest_65


=== recovery_end_65 ===
#theme:recovery
#ending:mid
~ age = 65
~ money = 260000
╔══════════════════════════╗
║  RECOVERY — AGE 65       ║
║  $260k                   ║
╚══════════════════════════╝

Started from rubble. You mentor people who are exactly where you were at 25.

The story you tell is useful precisely because it isn't perfect.

Status: { get_money_status() } • Rep: { get_rep_label() }
Net worth: { get_net_worth_label() } • Life score: { get_life_score() }/100

+ [👴 See age 70+]  -> recovery_70
+ [▶ Play again]    -> restart

=== recovery_70 ===
#theme:recovery
~ age = 70
~ money = 290000

$290k and counting. The story you tell is useful precisely because it isn't perfect.

+ [▶ Play again]  -> restart

=== recovery_end_modest_65 ===
#theme:recovery
#ending:mid
~ age = 65
~ money = 140000
╔══════════════════════════╗
║  MODEST RECOVERY — 65    ║
║  $140k                   ║
╚══════════════════════════╝

$140k and Social Security. Solid ground.

Health and relationships: the real portfolio.

Status: { get_money_status() } • Net worth: { get_net_worth_label() }
Life score: { get_life_score() }/100

+ [▶ Play again]  -> restart
