# Analysis of Whimsy Agenda Tool

Provide notes about how the Whimsy Agenda Tool functions. In general Whimsy needs to be considered as the source of truth for agenda tool behaviour

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
- todos.json.rb - **Secretary:** After meeting: Send email to all newly appointed PMC chairs from establish or chair change resolutions with onboarding instructions.
- (no existing file) - **Secretary:** After meeting: Send email to any newly appointed non-PMC officer with onboarding instructions (this is an enhancement request.)
