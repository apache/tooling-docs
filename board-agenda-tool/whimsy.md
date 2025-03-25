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

## Content Templates

A list of data templates, boilerplates, or other similar workflow content docs that are used in key Whimsy workflow features.

While different tools will obviously implement content templating differently, these templates are directly used in workflows that communicate with users, so will need to be ported or otherwise replaced somehow, along with allowing the relevant users to update the content templates themselves easily.

### Templates in svn::/foundation/board/templates/

- board_agenda.erb - **Chair:** Create New Agenda
- reminder1.mustache - **Chair:** Send Email as first reminder to all PMCs private@ and chair's individual email that are due to report in the current Create New Agenda action.
- reminder2.mustache - **Chair:** Send Email as second reminder to all PMCs private@ and chair's individual email that have not yet posted a report to the upcoming agenda.
- reminder-summary.mustache - **Chair:** Send Email (to board@) that describes what other reporting reminders were just sent by a Chair action (note: this likely needs to be improved, and also sent to board@ not just the Chair, see WHIMSY-428)
- non-responsive.mustache - Chair: Send Email to a PMC that has not reported in recent cycles
- remind-action.erb - **Chair:** Send Email to Action item owners
- remind-officer.mustache - seems unused?

### Templates in git::[whimsy/www/board/agenda/*](https://github.com/apache/whimsy/tree/master/www/board/agenda/)

- change-chair.erb - **Auth'd User:** submit a Change Chair Resolution for their PMC, selecting the new proposed chair name.
- committers_report.text.erb - **Chair:** Send Summary email to committers@ of previous meeting (usually a day after a board meeting)
- establish.erb - **Auth'd User:** Add Item - Establish Project resolution to place in upcoming agenda; allow for Project name, chair, purpose of PMC, list of original PMC members.
- terminate.erb - **Auth'd User:** for Add Item - Terminate Project resolution to place in upcoming agenda.
- todos.json.rb -  - **Secretary:** After meeting: Send email to all newly appointed PMC chairs from establish or chair change resolutions with onboarding instructions.
- (no existing file) - **Secretary:** After meeting: Send email to any newly appointed non-PMC officer with onboarding instructions (this is an enhancement request.)
