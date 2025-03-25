# Analysis of Whimsy Agenda Tool

Provide notes about how the Whimsy Agenda Tool functions. In general Whimsy needs to be considered as the source of truth for agenda tool behaviour

## Agenda Item Data Structure

An Agenda can be seen as a list of Items in order, each with a Title, Body, ID (or other marker, indent level, whatever) and perhaps other metadata.  Agendas (and all metadata) are displayed to appropriately auth'd users and are stored in private storage.  Agendas are processed to redact various metadata and gain approval from the Board before being published publicly as Minutes.

Key types of Items (this list is not necessarily complete):

- **Structural** Items about the Meeting: eg. Call To Order, Adjournment, which don't have additional metadata.
- **Decision** Items: Special Orders, where *Secretary* will record an outcome: table, approved, unanimous vote, other vote (i.e. split or failed vote), etc.
- **Discussion or Business**: Discussion Items, Action Items, Unfinished Business, New Business, Announcements: these are primarily a body, but also may have some sort of outcome or other commentary added during the meeting by Secretary.
- **Reports**: Items that typically have additional relationships or metadata; all Reports have an expected author (the officer responsible, or Chair/VP of that PMC).
  - Reports often include (or are primarily) Attachments to include their body.
  - Reports allow a list of Comments to be attached in the agenda or private storage.
  - PMC Reports have a Shepherd name (randomly assigned Director), plus a list of director approvers, plus some status metadata:
    - No report: Red
    - Report present: <5 preapps -> Queue/Orange
    - Report approval: >5 preapps -> Approved/Green
    - Flagged? (default to blank; but if Flagged, store a list of IDs that pressed Flag button)

There are four conceptual time periods of an Agenda/Minutes lifecycle:

- Before Meeting - *Chair* creates a new Agenda, and then various users fill up the items, add Comments, Approvals, etc.
- During Meeting - *Secretary* takes notes/status on various Items; the *Chair* may "mark the spot" of the current thing (Item) being discussed live.  Often *Directors* will preapprove Reports during a meeting, or users may edit or add Comments.  Rarely, other users may add or edit Items during the meeting, typically before they come up (or else the item is temporarily tabled while a corrective edit for typo, etc. is made, then the Chair comes back to the item).
- After Meeting - *Secretary* confirms all notes/status entered and saves the complete Agenda in private storage (permanently); and **also** the Agenda is redacted to create Draft Minutes, which may have Comments or Director Preapprovals added later on.
- Next Month's Meeting - after the board formally approves Minutes, the *Secretary* publishes them publicly.

## Workflows

While some workflows or actions (eg. pressing a button) are fairly obvious, a number are much more complex workflows that incorporate various data sources, and may affect various other systems (eg. update a file in SVN, change and LDAP permission).

### Workflows Implemented in git::/board/agenda/views/buttons/

- add-comment.js.rb - any user may add a comment to the current Item's comment list, ordered by time added.
  - Only certain types of Items allow comments: generally Reports from exec officers or PMCs; generally meeting-management Items do not have comments (call to order, adjournment, etc.)
  - Comments are visible in the agenda tool and in private document storage (i.e. Member / own PMC visible).
  - Comments are **not** visible in Minutes.
  - If the user already added a comment, they can edit their existing comment in the list instead (?check behavior)
  - *Directors:* may also click checkbox to "Flag" a Report; this should validate that that Director has already added a Comment to this Report (it's silly to flag something without explaining why).
- add-minutes.js.rb - *Secretary:* may add "Minutes" to an Item during a meeting.
  - These Minutes are included in public board minutes.
  - These Minutes may include both:
    - Item status (when applicable): tabled, approved, board voted unanimously, board voted some other way, report was not accepted, others?
    - A text comment describing any other action taken around this Item.
    - Need more clarity around exactly how Item Status is recorded, since it affects other workflows (eg. Special Order to change PMC chair means swapping roles in LDAP and emailing new chair a welcome).
- approve.js.rb - *Directors:* toggle to preapprove/unapprove the current Report.
  - Visible in agenda and private document storage.
  - Report's overall status changes once >5 preapps done.
- attend.js.rb - User may mark they plan to attend a Meeting; mark by class (director, exec officer, guests).
- commit.js.rb - Commit to private storage (i.e. SVN) any cached work a user has done locally.
  - Primarily for *Directors*, who often spend time preapproving/commenting on various Items; there's no real need to have an actual svn ci for each individual action (also: this lets Directors do some work offline).
  - See also: agenda/models/pending.rb for workflow.
- draft-minutes.js.rb - *Secretary* can turn existing Agenda into a Draft Minutes, and then commit to private storage.  TODO: define workflow of what's redacted.
- email.js.rb - Allow user to send email about current Item.
  - If the Shepherd of Item, typically used to send "your report is late, please submit" email: see template embedded in this code.
  - Other users get a simplistic way to email the PMC's private@ list and chair with a text body they can write in. 
- install.js.rb - N/A
- markseen.js.rb - Mark all Comments on all Items as "seen", so they no longer show up in your personal Comments listing.
  - Comments added afterwards do show up in your Comments listing.
- message.js.rb - Unused - beta IRC chat tool within meetings.
- offline.js.rb - Any user can "go offline", which Refreshes a local data storage of the Agenda, so they can do activities like Preapprovals and Comments while offline; later when they come back, they can Commit that work in bulk.
- post-actions.js.rb - *Chair* as part of the New Agenda workflow, the Chair is presented with a list of all past month's AIs, and then manually selects which AIs to pull into the new agenda; all other AIs are dropped (presumably because they are somehow done or no longer tracked).
- post.js.rb - User may Add New Item to agenda, with various templates and searchable drop-down selectors of the obvious data; see also git:: Templates below:
  - Chair Change Resolution - PMC name, new Chair name.
  - New TLP Resolution - PMC name, established purpose of PMC, source of PMC (Incubator, Petri, spin-out from other PMC, other?), PMC Chair name, list of PMC members.
  - Terminate TLP Resolution - PMC name, how terminated (this should provide better functionality: community voted for, board suggested, Security Team suggested).
  - Discussion Item - Subject, and freeform text body.
  - New Resolution - Subject, and freeform text body for a Special Order to be considered by the board (for example: for annual budget).
  - New Officer Resolution - Officer name, Title, text field of Responsibility (This would be a nice to have new resolution template)
  - Out Of Cycle Report - PMC name, freeform text body for a PMC who wishes to report some month they weren't requested to report.
- publish-minutes.js.rb - *Secretary* publish approved and redacted Minutes; note various hardcoded paths here.
- refresh.js.rb - Force browser local storage to fetch updated data (i.e. svn up, parse latest data, combine with any locally cached preapprovals/comments, redisplay agenda in browser).
- remind-actions.js.rb - *Chair* Send email reminders to owners of open Action Items.  NEW: should send an email with a report of what emails were sent someplace (likely to board@).  Templates: remind-action.erb
- reminders.js.rb - *Chair* Send email reminders to officers/PMCs due to report in current agenda.  Options for first/second reminder templates; option to checkmark off any items (to not be sent; for example when you know they have a draft ready).  Templates: reminder2.mustache, reminder-summary.mustache, non-responsive.mustache
- showseen.js.rb - Untoggle Mark Seen for all Comments.
- summary.js.rb - *Chair* Send committers@ email summarizing recently completed meeting.  Templates: committers_report.text.erb
- timestamp.js.rb - Unsure if used currently.
- vote.js.rb - UNUSED: experimental method to allow Directors to Vote on Special Items during a meeting when the Secretary asks so.

### Workflows Implemented in git::/board/agenda/views/pages/

- roll-call.js.rb - *Secretary* given the pre-existing list of expected attendees, plus the list of people actually signed into the board agenda tool (anywhere), allow Secretary to easily mark people who are attending, and Note when they joined (or left) the meeting.  Implies keeping a time counter from when Secretary clicks Call To Order (so time joined is auto-calculated).
- action-items.js.rb - allows users to edit body of any Action Item; should optionally have a specific Status field somehow.
- adjournment.js.rb - *Secretary* workflow to mark meeting as adjourned (and mark the time), and set various status for post-meeting tasks.
- backchannel.js.rb - UNUSED - was a chat tool for logged in agenda users.
- feedback.js.rb - UNUSED - this is code that used to automatically email the Comments list for a report to the PMC's private@ list after a meeting.
- comments.js.rb - Display listing of all comments, in context with their Item names/status (respecting markseen flags).
- flagged.js.rb - Display listing of all Flagged Reports, in context with Item name, status, Comments lists.
- fy23.js.rb - Experimental code to display a nicely formatted table of a budget for proposal to the board (this allowed us to avoid having to format columns in plain text file).
- help.js.rb - display app help.
- missing.js.rb - Display listing of all Missing Reports.
- queue.js.rb - Display the queue/listing of all submitted Reports the current *Director* has not yet preapproved, with status of each.
- rejected.js.rb - Display listing of all rejected Reports (i.e. not enough preapps, or otherwise explicitly marked as Rejected).
- report.js.rb - Handy flexible two-column display of Reports with all associated metadata (no actual workflow).
- roll-call.js.rb - *Secretary* handy features to easily mark list of names that are logged into Agenda tool currently as present.
- select-actions.rb - Handy display of Action Items with key context and status markers.
- shepherd.js.rb - *Director* display shepherd queue/listing with all metadata (Report name, chair, status, comments, flags, etc.)

## Content Templates

A list of data templates, boilerplates, or other similar workflow content docs that are used in key Whimsy workflow features.

While different tools will obviously implement content templating differently, these templates are directly used in workflows that communicate with users, so will need to be ported or otherwise replaced somehow, along with allowing the relevant users to update the content templates themselves easily.

### Templates in svn::/foundation/board/templates/

- board_agenda.erb - **Chair:** Create New Agenda
- reminder1.mustache - **Chair:** Send Email as first reminder to all PMCs private@ and chair's individual email that are due to report in the current Create New Agenda action.
- reminder2.mustache - **Chair:** Send Email as second reminder to all PMCs private@ and chair's individual email that have not yet posted a report to the upcoming agenda.
- reminder-summary.mustache - **Chair:** Send Email (to board@) that describes what other reporting reminders were just sent by a Chair action (note: this likely needs to be improved, and also sent to board@ not just the Chair, see WHIMSY-428)
- non-responsive.mustache - **Chair**: Send Email to a PMC that has not reported in recent cycles
- remind-action.erb - **Chair:** Send Email to Action item owners
- remind-officer.mustache - seems unused?

### Templates in git::[whimsy/www/board/agenda/*](https://github.com/apache/whimsy/tree/master/www/board/agenda/)

- change-chair.erb - **Auth'd User:** submit a Change Chair Resolution for their PMC, selecting the new proposed chair name.
- committers_report.text.erb - **Chair:** Send Summary email to committers@ of previous meeting (usually a day after a board meeting)
- establish.erb - **Auth'd User:** Add Item - Establish Project resolution to place in upcoming agenda; allow for Project name, chair, purpose of PMC, list of original PMC members.
- terminate.erb - **Auth'd User:** for Add Item - Terminate Project resolution to place in upcoming agenda.
- todos.json.rb -  - **Secretary:** After meeting: Send email to all newly appointed PMC chairs from establish or chair change resolutions with onboarding instructions.
- (no existing file) - **Secretary:** After meeting: Send email to any newly appointed non-PMC officer with onboarding instructions (this is an enhancement request.)
