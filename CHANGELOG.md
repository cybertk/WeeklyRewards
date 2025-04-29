# Changelog

## v1.10.1 - 2025-04-29

### Fix

- The Delve map icon is NOT appearing as green box for completed DelveMap
- The rewards of worldboss Aggregation of Horrors could be tracked now

## v1.10.0 - 2025-04-25

## New Features

- Added new reward group "Nightfall": includes Nightfall weekly and daily quests
- Added support to track looted upgraded gears from rewards
- Added support to track looted money of each reward

## v1.9.0 - 2025-04-21

## New Features

- Upgraded TOC to 11.1.5
- Added new reward support:
    - Delve Gilded Stash
    - Unclaimed Great Vault rewards - GreatVault progress now shows as x/10 for unclaimed rewards
    - Noblegarden Event
- Added Keybindings support - Credit to [@marklabrecque](https://github.com/marklabrecque/)
- Optmized status text for LastUpdate column
- Added support to untrack all WeeklyRewards-managed quests on login - Now the Quest Objective panel is super clean

## v1.8.2 - 2025-04-08

### Fix

- Crash when Cyrce Circlet is not equipped.
- Progress "Started At" is set to now sometimes.

## v1.8.1 - 2025-04-03

### Fix

- Player location is not updated when switching to a new map.
- C.H.E.T.T progress is stuck at 4/5.
- Worldsoul meta quest is not rollover-able in 11.1.

## v1.8.0 - 2025-03-29

## New Features

- Ctrl+Click progress cell of current player forces progress reset
- Ctrl+Click character name in settings removes all its progress
- Always show progress of current playing character (even when disabled by others)
- Added new reward support:
    - Weekly C.H.E.T.T list
    - Weekly Delver's Bounty map
- Added new group "Delve": includes DelveKeys and DelveMap

## v1.7.2 - 2025-03-13

### Fix

- Archives quest progress is stuck at First Disc.
- Cannot recognize Dungeon reward when Operation: Floodgate is the active quest.
- Spider progress failed to rollover before signing a pact.
- Active rewards occasionally failed to update after reset.

## v1.7.1 - 2025-03-12

### Fix

- Crash: When encountering a new character for the first time.

## v1.7.0 - 2025-03-11

## New Features

- Added Location column to display character's area.
- Added support for tracking re-accepted quests after abandonment.
- Added support for new rewards: Undermine Wordboss Gobfather.

## v1.6.3 - 2025-03-06

### Fix

- Undermine quests can roll over progress after weekly reset
- Side Gig quests rotations are now correctly identified and tracked

## v1.6.2 - 2025-03-04

### Fix

- Worldsoul quest now can recognize new Undermine tasks.
- Delves: Worldwide Research can be tracked now.

## v1.6.1 - 2025-03-03

### Fix

- Spider progress now will not display rewards received time after Pact completion.
- Resolved a Tooltip crash that occasionally occurred when hovering over the reward header.
- The progress of or "The Theater Troupe" and "Rollin' Down in the Deeps" now can rollover after weekly reset.

## v1.6.0 - 2025-03-01

## New Features

- Add Undermine rewards support
    - Weekly Caches: Urge to Surge and Special Assignment
    - Side Gig Quests
    - Shipping & Handling Jobs
    - Weekly S.C.R.A.P. Quest

## v1.5.0 - 2025-02-26

## New Features

- Left-clicking the reward header now sorts characters (rows) by the selected reward. A second click reverses the sort order.

## v1.4.0 - 2025-02-24

## New Features

- Add new rewards support: Cyrce Circlet
- Upgrade TOC to 11.1
- Add new column LastUpdate, characters were sorted by LastUpdate in descending order.

## v1.3.2 - 2025-02-21

### Fix

- The First Disc progress is always displayed as Seeking History 0/100.

## v1.3.1 - 2025-02-18

### Fix

- Crash: Tooltip for completed Spider Pact progress

## v1.3.0 - 2025-02-14

## New Features

- Add new rewards support
    - Love is in the Air Event
        - Love is in the Air one-time Mainline Quests
        - Love is in the Air Daily Quests
        - Daily Shadowfang Keep Dungeon Boss: Crown Chemical Co. Trio
        - Donate gold to the Artisan's Consortium to support the Gala of Gifts
    - Lunar Festival Event
        - Quest: Lunar Preservation
        - Visiting the Elders across Azeroth
- New button to sort rewards columns, by Reward Group, Reward Name or Time Left
- Optimize UI to prevent reward name truncating

## v1.2.4 - 2025-02-04

### Fix

- Cannot recognize Special Assignment: Titanic Resurgence

## v1.2.3 - 2025-01-16

### Fix

- WoD Timewalking LFD is not recognized
- Siren Isle Invasion is not recognized until Storm phase is activated

## v1.2.2 - 2025-01-14

### Fix

- Spider Weekly progress is not shown until Pact quest is completed

## v1.2.1 - 2025-01-13

### Fix

- Progress isn't marked as 100% for claimed rewards. i.e. Siren Isle Special Assignment quest
- Drops aren't  linked to rewards in multi-reward quests sometimes.
- New SA quest aren't recognized

## v1.2.0 - 2025-01-12

Supports tracking the Great Vault rewards.

## v1.1.1 - 2025-01-11

### Fix

- Crash: Cannot find/load ACE lib when ACE3 is not installed by any other addons
- Siren Isle Special Assignment progress is stuck at the unlock invasion quest

## v1.1.0 - 2025-01-10

## New Features

Supports tracking new rewards, including:

- Darkmoon Faire Event
    - Darkmoon Faire Daily Quests
    - Darkmoon Faire Profession Quests
    - Quest: Test Your Strength
- Siren Isle
    - Weekly Invasion and Storm Phase Quests
    - Special Assignment: Storm's a Brewin

## v1.0.1 - 2025-01-09

### Fix

- Crash: Cannot find AceHook
- Reward columns cannot be re-scanned immediately after reset

## v1.0.0 - 2025-01-08

WeeklyRewards First Release. Track rewards on all your alts including:

- Pinnacle Cache
    - Archives Meta Quest
    - Delves Meta Quest
    - The Call of the Worldsoul
- Weekly Cache
    - Special Assignment Quests
    - Spreading the Light
    - Azj-Kahet Pact Choice
    - The Theater Troupe
    - Awakening the Machine Event
    - Collect wax for Kobolds
- Weekly Dungeon Quest
- Timewalking Events Dungeon and Raid
