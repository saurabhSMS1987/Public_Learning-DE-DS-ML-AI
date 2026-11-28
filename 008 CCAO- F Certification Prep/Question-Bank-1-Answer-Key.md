# Claude Certified Associate – Foundations (CCAO-F)
## Question Bank 1 — Answer Key & Revision Notes

**Score:** 52 / 60 (86.7%)  
**Missed:** 8 questions — [Q21](#question-21), [Q23](#question-23), [Q33](#question-33), [Q36](#question-36), [Q42](#question-42), [Q43](#question-43), [Q52](#question-52), [Q58](#question-58)

> Every question lists its correct answer. Full explanations are included **only for missed questions** (marked ❌). Key concepts to revise for the weak topics are in the [Revision Notes](#revision-notes) section at the end.

## Contents
- [Score by domain](#score-by-domain)
- [Questions & answers](#questions--answers)
- [Revision notes](#revision-notes)

## Score by domain

| Domain | Correct | Total | Score | Missed |
|---|---:|---:|---:|---|
| Output Evaluation and Validation | 9 | 13 | 69% | [Q23](#question-23), [Q33](#question-33), [Q36](#question-36), [Q43](#question-43) |
| Governance, Risk, and Responsible Use | 7 | 9 | 78% | [Q21](#question-21), [Q52](#question-52) |
| Prompting and Task Execution | 7 | 8 | 88% | [Q58](#question-58) |
| Workflow Integration and Solution Design | 9 | 10 | 90% | [Q42](#question-42) |
| Configuration and Knowledge Management | 7 | 7 | 100% | — |
| Product and Model Selection | 7 | 7 | 100% | — |
| Troubleshooting and Optimization | 6 | 6 | 100% | — |

## Questions & answers

### Question 1

✅ Answered correctly · *Output Evaluation and Validation*

A regional food bank's development coordinator uploads the organization's year-end program results document and asks Claude to draft a two-page impact summary for major donors. The draft reads smoothly and contains specific statistics for several programs. Before the summary goes to donors, which TWO checks constitute a sound evaluation of its accuracy and completeness? (Select TWO.)

- Ask Claude in the same conversation to confirm that its draft is fully accurate and complete, and proceed once it confirms
- Regenerate the summary a second time and treat matching statistics across the two versions as evidence that the figures are reliable
- Walk through the source document's program sections and confirm each one is either represented in the summary or deliberately omitted ✅
- Trace each statistic and named claim in the draft back to the uploaded results document, and correct anything that cannot be found there ✅

**Correct answers:** Walk through the source document's program sections and confirm each one is either represented in the summary or deliberately omitted <br>**+** Trace each statistic and named claim in the draft back to the uploaded results document, and correct anything that cannot be found there

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 2

✅ Answered correctly · *Workflow Integration and Solution Design*

An architecture firm's bid coordinator has spent months refining a personal Claude process for turning incoming RFP documents into go/no-go summaries for the partners. The prompts have evolved across many old chats, and the firm's evaluation criteria and summary template exist only in the coordinator's head and scattered messages. The coordinator is leaving for three months, and two teammates must run the process weekly while they are away. What should the coordinator do to make the workflow repeatable for the team?

- Write down the steps and named inputs, add the evaluation criteria and summary template to a Project's knowledge, and set project instructions that apply to every chat ✅
- Send the teammates the transcripts of the long chats where the process evolved, so they can locate the working prompts and rerun them each week
- Tell the teammates to open new chats inside the coordinator's existing project, since the context built up in earlier chats carries over to new ones automatically
- Write a thorough project description explaining the full process, since the description shapes how Claude responds in every chat inside that project

**Correct answer:** Write down the steps and named inputs, add the evaluation criteria and summary template to a Project's knowledge, and set project instructions that apply to every chat

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 3

✅ Answered correctly · *Workflow Integration and Solution Design*

A craft brewery's operations manager had Claude build a web artifact that tracks keg inventory across the company's three taprooms, iterating on it by prompt inside a Project. Six months later, the finance team uses it for monthly reconciliation, taproom managers check it daily, and there are now requests for guaranteed availability and a connection to the accounting software. How should the operations manager respond to this shift?

- Switch the Project to a more capable Claude model so the artifact can handle the increased demands from the other teams
- Add more detailed custom instructions to the Project so future iterations of the artifact are more robust and reliable
- Recognize that the artifact has become a system others depend on and escalate the build toward Developer or Architect expertise ✅
- Continue refining the artifact by prompt as before, since that iteration loop is what produced a working tool in the first place

**Correct answer:** Recognize that the artifact has become a system others depend on and escalate the build toward Developer or Architect expertise

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 4

✅ Answered correctly · *Configuration and Knowledge Management*

An insurance brokerage's executive assistant has connected Gmail to Claude and is planning a weekly email-management routine. Before building the routine, she wants to confirm what the Gmail connector can actually do so she does not design steps around actions it cannot perform. Which TWO tasks fall within the Gmail connector's capability boundary? (Select TWO.)

- Ask Claude to open the PDF attachments on incoming claims emails and summarize their contents for the weekly digest
- Ask Claude to automatically send short acknowledgment replies to routine inquiries on the assistant's behalf
- Ask Claude to compose reply drafts in Gmail for the assistant to review and send herself from Gmail ✅
- Ask Claude to search the inbox and summarize this week's client escalation emails, citing the messages it drew from ✅

**Correct answers:** Ask Claude to compose reply drafts in Gmail for the assistant to review and send herself from Gmail <br>**+** Ask Claude to search the inbox and summarize this week's client escalation emails, citing the messages it drew from

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 5

✅ Answered correctly · *Governance, Risk, and Responsible Use*

An HR generalist at a 35-person architecture studio wants Claude to analyze a set of exit-interview transcripts to surface common retention themes. Before uploading, she deletes every departing employee's name from the transcripts. The transcripts still mention details such as "the studio's only landscape architect," specific start and end dates, and named project assignments. What should she do before proceeding?

- Strip or generalize the remaining details, such as unique job titles, dates, and project assignments, before uploading ✅
- Classify exit-interview content as data that must stay out of Claude entirely and conduct the theme analysis manually instead
- Proceed with the upload as is, since deleting the names satisfies the requirement to redact personal identifiers
- Upload the transcripts unchanged but add an instruction telling Claude not to infer or mention any individual identities in its analysis

**Correct answer:** Strip or generalize the remaining details, such as unique job titles, dates, and project assignments, before uploading

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 6

✅ Answered correctly · *Configuration and Knowledge Management*

A public library system's programs coordinator created a Project for drafting event announcements. In the instructions field she wrote "Be professional, high quality, and match our voice," followed by the full text of the library's 15-page community engagement policy pasted in below it. Announcements drafted in the Project vary widely in tone and structure from one conversation to the next. What is the most effective fix?

- Rewrite the instructions as specific behavior rules covering audience, format, and missing-information handling, and move the policy text into the project knowledge base ✅
- Keep the current setup unchanged and paste a reminder at the start of each new conversation asking Claude to follow the existing project instructions carefully
- Move both the directives and the policy text into the project knowledge base as one uploaded document, and leave the instructions field empty to keep the setup simple
- Add an expert persona to the instructions, telling Claude it is an award-winning communications director, and keep the policy text in place so it is always applied

**Correct answer:** Rewrite the instructions as specific behavior rules covering audience, format, and missing-information handling, and move the policy text into the project knowledge base

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 7

✅ Answered correctly · *Workflow Integration and Solution Design*

A veterinary hospital network's client services manager receives a one-line request from leadership: "Can we use Claude to help with client complaint emails?" She asks Claude to expand the request into a requirements document. Claude returns a polished document that specifies a four-hour response target, three escalation categories, and a standard apology tone, none of which leadership ever mentioned. What should the manager do with this document?

- Ask Claude to add more detail so the document covers every possible complaint scenario before showing it to anyone
- Discard the draft and gather requirements entirely without Claude, since AI-generated requirements documents cannot be relied on
- Adopt the document as written, since the specifics Claude supplied reflect sensible defaults that can be tuned once the workflow is running
- Treat Claude's invented specifics as draft questions to confirm with leadership and the complaints team before adopting any of them as requirements ✅

**Correct answer:** Treat Claude's invented specifics as draft questions to confirm with leadership and the complaints team before adopting any of them as requirements

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 8

✅ Answered correctly · *Prompting and Task Execution*

A grants writer at a nonprofit food bank asks Claude to draft an update letter for a major funder. The draft has the right tone, but it leaves out the program impact figures the funder always expects, and the writer realizes her prompt never mentioned them. Which TWO actions reflect effective prompt iteration? (Select TWO.)

- Revise the saved prompt itself to include the impact-figure requirement, so future letters do not repeat the same omission ✅
- Paste the identical original prompt into a fresh conversation and check whether the second attempt happens to include the figures
- Reply with 'make this letter better and more complete' so Claude improves the draft across every dimension at once
- Send a follow-up message that names the missing impact figures, provides them, and says where in the letter they belong ✅

**Correct answers:** Revise the saved prompt itself to include the impact-figure requirement, so future letters do not repeat the same omission <br>**+** Send a follow-up message that names the missing impact figures, provides them, and says where in the letter they belong

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 9

✅ Answered correctly · *Output Evaluation and Validation*

A school district's facilities director used Claude to analyze building utilization and produce a technical report for the school board. The key finding: two elementary schools are operating below 60% capacity, and the report recommends a consolidation study, with a caveat that projections assume current housing trends continue. The director must now adapt this material for the district's parent newsletter. What is the right approach?

- Ask Claude to cut the board report to half its original length, since a shorter document will automatically be accessible to parents
- Have Claude rewrite it in plain language for parents, changing length and vocabulary but keeping the figures, finding, and housing-trend caveat ✅
- Publish the board version in the newsletter unchanged, since altering any of the report's wording risks distorting the original analysis
- Have Claude reframe the findings more positively for the newsletter so the mention of a consolidation study does not alarm parents unnecessarily

**Correct answer:** Have Claude rewrite it in plain language for parents, changing length and vocabulary but keeping the figures, finding, and housing-trend caveat

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 10

✅ Answered correctly · *Product and Model Selection*

A city museum's visitor-experience team plans two Claude tasks for the week: categorizing 900 short visitor-survey comments into five predefined themes, and producing a one-off strategic assessment of a proposed exhibit relocation that involves ambiguous stakeholder feedback and several interacting budget constraints. Which TWO model choices best align each task with its requirements? (Select TWO.)

- Use Opus for the survey categorization, since choosing the most capable model ensures the most accurate tagging across all 900 comments
- Use Haiku for the survey categorization, since it is a structured, high-volume task where speed matters and each item carries low consequence ✅
- Use Haiku for the exhibit relocation assessment, since the fastest model conserves usage headroom for the larger categorization workload
- Use Opus for the exhibit relocation assessment, since the inputs are ambiguous, constraints interact, and a subtle error would be costly ✅

**Correct answers:** Use Haiku for the survey categorization, since it is a structured, high-volume task where speed matters and each item carries low consequence <br>**+** Use Opus for the exhibit relocation assessment, since the inputs are ambiguous, constraints interact, and a subtle error would be costly

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 11

✅ Answered correctly · *Workflow Integration and Solution Design*

A boutique hotel group's revenue manager piloted Claude for drafting the weekly occupancy and pricing summary; the pilot cut drafting time roughly in half, and an analyst verifies every figure against the booking system and edits the draft before it is distributed. Impressed by the pilot, an executive proposes announcing to the wider company that "weekly reporting is now fully automated." How should the revenue manager brief leadership?

- Center the briefing on Claude's error risks and everything it cannot do, keeping leadership's expectations as low as possible so the workflow is never blamed for a mistake
- Report the measured time savings, describe exactly which steps Claude drafts, and correct the announcement to name the analyst's verification step that remains before distribution ✅
- Adopt the executive's "fully automated" phrasing in the briefing, since the pilot succeeded and a simpler message will secure support for expanding the workflow faster
- Present the pilot's time savings now and hold the discussion of limitations and review steps for a later meeting, once leadership has committed to expanding the workflow

**Correct answer:** Report the measured time savings, describe exactly which steps Claude drafts, and correct the announcement to name the analyst's verification step that remains before distribution

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 12

✅ Answered correctly · *Product and Model Selection*

A city transit agency's policy team uses Claude's Haiku model each week to tag thousands of rider comments into a fixed set of categories, and it performs well. The team lead must now produce a one-off recommendation on a fare restructuring proposal in which budget limits, ridership projections, and equity requirements all interact, and a subtle analytical error would be expensive to walk back. How should the team apply model selection for this new task?

- Select Sonnet for the fare analysis, since it is the everyday default and defaults should be used regardless of a task's stakes
- Standardize on Opus for all of the team's Claude work, including the weekly comment tagging, so output quality is maximized everywhere
- Stay with Haiku for the fare analysis, since it has handled the team's other Claude work reliably and keeps turnaround fast
- Select Opus for the fare analysis, since the inputs are ambiguous, several constraints interact, and a subtle error carries real consequences ✅

**Correct answer:** Select Opus for the fare analysis, since the inputs are ambiguous, several constraints interact, and a subtle error carries real consequences

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 13

✅ Answered correctly · *Configuration and Knowledge Management*

A natural history museum's membership coordinator sets up a Claude Project for drafting renewal reminders and member updates. She types her tone and formatting rules into the Project's description field, and uploads the current membership policy plus two older, superseded versions of it "for completeness." Drafts ignore her tone rules and occasionally cite outdated renewal fees. Which TWO changes will fix the configuration? (Select TWO.)

- Keep all three policy versions in the knowledge base so Claude can compare them and select the most recent figures on its own
- Remove the two superseded policy versions so the knowledge base holds only the current authoritative document ✅
- Move the tone and formatting rules into the Project's instructions, since Claude does not have access to the Project's name or description ✅
- Explain the tone and formatting rules once in an initial chat, since that context carries over automatically to every other chat in the Project

**Correct answers:** Remove the two superseded policy versions so the knowledge base holds only the current authoritative document <br>**+** Move the tone and formatting rules into the Project's instructions, since Claude does not have access to the Project's name or description

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 14

✅ Answered correctly · *Prompting and Task Execution*

A regional airline's route planning analyst asks Claude to "tell me about how our competitors have been promoting their new routes." Claude returns a confident, fluent summary, but it names no sources, and some claims appear to describe campaigns from several years ago. Which adjustment best matches the prompting strategy to this kind of task?

- Ask Claude for twenty varied guesses about what the competitors might be doing and defer any judgment until the full range is on the table
- Specify an exact format, tone, and word count for the summary so the output arrives polished and ready to circulate to the team
- Assign Claude the persona of a veteran airline industry analyst so the summary carries more authoritative expertise and insight
- Scope the request to named competitors and a recent time window, turn on web search for current information, and ask for a citation on each claim ✅

**Correct answer:** Scope the request to named competitors and a recent time window, turn on web search for current information, and ask for a citation on each claim

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 15

✅ Answered correctly · *Product and Model Selection*

A dental clinic chain's patient education coordinator produces a new patient handout every month. Each handout draws on the same brand voice guide and clinical accuracy checklist, and every finished handout is a standalone document that clinic staff will edit and reuse after she delivers it. Which TWO feature choices best fit this workflow? (Select TWO.)

- Have Claude generate each handout as an Artifact so the document can be edited, refined, and reused as a standalone piece ✅
- Create a Project with the voice guide and checklist in its knowledge base and standing instructions covering tone and format ✅
- Enable Research mode for each handout so Claude investigates and synthesizes many external sources before drafting
- Start a fresh Chat each month and paste the voice guide and checklist at the top of the conversation before drafting begins

**Correct answers:** Have Claude generate each handout as an Artifact so the document can be edited, refined, and reused as a standalone piece <br>**+** Create a Project with the voice guide and checklist in its knowledge base and standing instructions covering tone and format

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 16

✅ Answered correctly · *Configuration and Knowledge Management*

An HR coordinator at a maritime logistics firm runs a private Claude Project that answers employee benefits questions. The benefits policy lives in a Google Doc that HR revises several times per quarter. She originally uploaded a copy of the policy to the Project's knowledge base, but Claude has started citing provisions that were changed weeks ago. What is the best way to keep the Project's answers based on the current policy?

- Add the policy Google Doc to the Project's files through the Google Drive connector and remove the stale uploaded copy ✅
- Upload a fresh PDF of the policy each time it changes, keeping the earlier versions in the knowledge base for historical reference
- Begin each conversation by instructing Claude to ignore any outdated provisions it finds in the project knowledge
- Paste the full current policy text into the Project's standing instructions so every conversation starts with it

**Correct answer:** Add the policy Google Doc to the Project's files through the Google Drive connector and remove the stale uploaded copy

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 17

✅ Answered correctly · *Configuration and Knowledge Management*

An insurance brokerage's client-services team set up a Project for drafting policy renewal summaries. In nearly every conversation, someone has to re-explain the same three points: open with the premium change, never promise a claim outcome, and flag anything the policy documents do not cover instead of guessing. The team lead wants these expectations to hold automatically in every chat. What is the most effective way to accomplish this?

- Write the rules into the Project's description field so Claude reads them automatically at the start of every conversation
- Write the three expectations as precise, testable rules in the project instructions, including how to handle coverage gaps ✅
- Paste the full text of the policy documents into the project instructions field so every chat starts with all the facts it needs
- Add a single general instruction telling Claude to be professional, careful, and accurate when drafting client summaries

**Correct answer:** Write the three expectations as precise, testable rules in the project instructions, including how to handle coverage gaps

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 18

✅ Answered correctly · *Workflow Integration and Solution Design*

A freight logistics company's operations manager has redesigned the invoice-reconciliation process: Claude extracts line items from vendor invoices and flags billing discrepancies, and a billing specialist reviews every flag before any dispute is raised with a vendor. The manager must now describe the new workflow to the leadership team. Which description best communicates Claude's value and limitations?

- Minimize any mention of Claude's involvement so leadership focuses on the improved turnaround times rather than on the tool being used
- Assure leadership that Claude's flags are reliable enough that the specialist review exists only as a formality and can soon be phased out
- State that Claude extracts line items and flags discrepancies, and that a specialist approves every flag before a dispute is raised ✅
- Describe the process as fully automated end to end, since emphasizing maximum efficiency gains will secure leadership buy-in faster

**Correct answer:** State that Claude extracts line items and flags discrepancies, and that a specialist approves every flag before a dispute is raised

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 19

✅ Answered correctly · *Output Evaluation and Validation*

A municipal water utility's finance manager used Claude to produce a detailed rate study, which the utility commission has approved. It concludes that residential rates must rise 9% next year, and it includes a caveat that the increase could grow further if a pending state infrastructure grant is denied. The manager must now turn this into a one-page notice for residential customers. What does sound adaptation look like?

- Mail the approved rate study to customers as it stands with a short cover letter, since the commission-approved document is the most accurate version
- Have Claude rewrite the material in plain customer language, cutting the methodology but keeping the 9% figure, the reason for it, and the grant caveat intact ✅
- Have Claude rewrite the notice in reassuring language and leave out the grant caveat, since the added uncertainty would only alarm customers
- Have Claude soften the figure to a phrase like 'a modest single-digit increase' so the notice reads less negatively for residential customers

**Correct answer:** Have Claude rewrite the material in plain customer language, cutting the methodology but keeping the 9% figure, the reason for it, and the grant caveat intact

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 20

✅ Answered correctly · *Output Evaluation and Validation*

A grants officer at a nonprofit asks Claude, without attaching any documents, to summarize the eligibility rules for a federal grant program. The response includes three elements: a general description of the program's goals, a confident statement that applications are due March 15 under a specific numbered federal regulation, and a note that some requirements may vary by agency. Which element should the officer treat as the most likely hallucination and check first?

- Treat all three elements as equally reliable, since they appeared together in the same confident, well-written response
- Treat the general description of the program's goals as the highest risk, since broad statements are harder to pin down than specific ones
- Treat the precise deadline and numbered regulation citation as the highest risk and verify them against the official program materials ✅
- Treat the hedged note that requirements may vary as the highest risk, since hedging shows the model is unsure of everything it wrote

**Correct answer:** Treat the precise deadline and numbered regulation citation as the highest risk and verify them against the official program materials

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 21

❌ **Answered incorrectly** · *Governance, Risk, and Responsible Use*

A regional freight brokerage's dispatch coordinator reads the company's new AI usage policy. It states that client rate agreements and contract documents "must not" be uploaded to Claude, a rule the coordinator considers overly cautious since rates circulate widely inside the company. The policy says nothing at all about the internal driver-scheduling spreadsheets the coordinator wants Claude to analyze. Which TWO actions reflect sound compliance with organizational AI policy? (Select TWO.)

- Upload the rate agreements anyway, since the way rates already circulate internally shows the restriction no longer matches the actual risk
- Ask the policy owner whether the driver-scheduling spreadsheets fall within scope before uploading them ✅ *(your answer)*
- Keep the rate agreements out of Claude and raise the disagreement with whoever owns the policy through the appropriate channel ✅
- Proceed with the scheduling spreadsheets right away, since the policy does not prohibit them and anything not restricted is permitted ❌ *(your answer)*

**Correct answers:** Ask the policy owner whether the driver-scheduling spreadsheets fall within scope before uploading them <br>**+** Keep the rate agreements out of Claude and raise the disagreement with whoever owns the policy through the appropriate channel

<details open>
<summary><b>Explanation</b></summary>

**Why your answer was wrong** — *Proceed with the scheduling spreadsheets right away, since the policy does not prohibit them and anything not restricted is permitted*

This is incorrect because treating silence as implicit permission is exactly where compliance drift begins. What a policy does not mention is a question for the policy owner, not a green light, especially for data that has never been explicitly cleared.

**Why the correct answer is right** — *Keep the rate agreements out of Claude and raise the disagreement with whoever owns the policy through the appropriate channel*

This is correct because a stated organizational policy binds employees regardless of whether they agree with it. Believing a rule is overly cautious is a reason to raise the issue with the policy owner, not authorization to ignore the rule while it stands.

**Overall explanation**

Following organizational AI policy well requires two distinct habits, and this scenario tests both. The first is respecting the precedence order that governs workplace AI decisions: law and regulation bind everyone, the organization's stated policy binds its employees whether or not they agree with it, team conventions come next, and an individual's own judgment is the last tie-breaker rather than the first. The coordinator may be entirely right that the rate-agreement restriction is overly cautious, but being right that a policy is flawed is not authorization to ignore it. The compliant move is to follow the rule as written while escalating the disagreement to whoever owns the policy, who can revise it if the objection holds up.

The second habit is reading a policy for what it actually restricts and, just as importantly, for what it does not say. Silence is not permission, and it is not prohibition either; it is a question for the policy owner. The scheduling spreadsheets were simply never considered when the policy was drafted, so uploading them on the theory that "nothing forbids it" would be a guess dressed up as compliance. Asking first converts an ambiguity into a documented answer, which protects both the coordinator and the organization.

The two incorrect approaches represent the two most common failure modes in practice: overriding a rule based on personal risk assessment, and treating a policy gap as a green light. Both are forms of quiet drift, the kind that accumulates on routine, low-visibility decisions and eventually triggers exactly the sort of incident that can freeze an organization's whole AI program. Note also that organizational policy operates alongside Anthropic's own Usage Policy, which applies to all users, and that Team and Enterprise administrators can additionally set organization instructions that apply across every conversation; individual users are expected to work within all of these layers, not around them.

</details>

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 22

✅ Answered correctly · *Configuration and Knowledge Management*

A regional tourism board's content coordinator is setting up a Claude Project for drafting monthly visitor newsletters. She has two things to configure: a 40-page destination reference guide the newsletters must draw facts from, and a set of standing rules (write at an accessible reading level, keep a warm and inviting tone, always end with a link to the booking page). How should she configure the Project?

- Upload the destination guide to the knowledge base and add the tone rules to the Project's description field so Claude sees them at the start of every chat
- Paste the full destination guide into the project instructions together with the tone rules, so everything Claude needs sits in a single place
- Upload the destination guide to the Project's knowledge base and write the tone and formatting rules into the project instructions ✅
- Save the tone and formatting rules as a text document in the knowledge base and leave the project instructions empty, since uploaded files persist across chats

**Correct answer:** Upload the destination guide to the Project's knowledge base and write the tone and formatting rules into the project instructions

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 23

❌ **Answered incorrectly** · *Output Evaluation and Validation*

A community credit union's compliance trainer has worked with Claude to draft a 40-page staff training handbook. The handbook now needs to go to branch managers, who do not use Claude and will edit and finalize the document in Microsoft Word. Which output approach best fits this handoff?

- Ask Claude to rebuild the handbook as an interactive React component artifact so the managers can review it in a polished visual layout ❌ *(your answer)*
- Ask Claude to create the handbook as a downloadable Word document using file creation, then distribute that file to the branch managers ✅
- Have Claude produce the handbook as an artifact, publish it, and send the branch managers the link to view
- Keep the handbook as inline text in the conversation and have each branch manager copy the sections they need into their own Word files

**Correct answer:** Ask Claude to create the handbook as a downloadable Word document using file creation, then distribute that file to the branch managers

<details open>
<summary><b>Explanation</b></summary>

**Why your answer was wrong** — *Ask Claude to rebuild the handbook as an interactive React component artifact so the managers can review it in a polished visual layout*

Interactive components are an artifact type suited to visual or interactive content, not to a text document that must be edited in Word. Choosing a format for its polish rather than for how the recipients will actually work with the content is a format-selection mistake.

**Why the correct answer is right** — *Ask Claude to create the handbook as a downloadable Word document using file creation, then distribute that file to the branch managers*

This is correct because Claude's file creation capability can generate downloadable Word documents (.docx), which is exactly the format the branch managers will edit in. The output format should match how the content will actually be used downstream, and here the downstream tool is Word.

**Overall explanation**

Format selection starts with a simple question: what happens to this output next? Here the answer is clear from the scenario, the handbook leaves Claude entirely and gets edited in Microsoft Word by people who do not use Claude. That points directly to file creation, which lets Claude generate downloadable files including Word documents (.docx), Excel spreadsheets, PowerPoint presentations, and PDFs. The trainer hands over one editable file in the tool the managers already use, with no reformatting or copying required.

It helps to keep a mental model of Claude's three main output paths. Inline text suits quick answers and content consumed inside the conversation. Artifacts suit substantial, self-contained content you will iterate on with Claude; they appear in a dedicated window beside the chat, support versioning, and can be published for viewing via a link. File creation is the bridge out of Claude into standard office tools, producing files people can open, edit, and circulate without a Claude account. Each path exists because different work products have different destinations.

Publishing an artifact fails this scenario twice over: the managers need to edit in Word, not view a page, and on Free, Pro, and Max plans a published artifact is accessible to anyone with the link, which sits uncomfortably with internal compliance content. Copying inline text into separate Word files multiplies manual work and produces divergent copies of what should be one authoritative document. An interactive React component is a real artifact type, but it optimizes for presentation inside Claude when the actual requirement is editability outside it.

See Create and edit files with Claude and What are Artifacts and how do I use them? for details on both output paths.

</details>

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 24

✅ Answered correctly · *Governance, Risk, and Responsible Use*

A credit union's outreach specialist wants Claude to analyze a spreadsheet of loan-delinquency records to identify repayment patterns that could shape a new financial-counseling program. The spreadsheet contains member names, account numbers, and monthly payment histories. The analysis only needs to surface trends, not identify individual members. The credit union uses a Claude for Work plan. What is the appropriate way to handle the data?

- Upload the spreadsheet unchanged, since Anthropic does not use Claude for Work commercial data to train its models by default
- Remove the member names but keep the account numbers in place so the results can be matched back to individual member records afterward
- Paste a written description of the records into the chat instead of uploading the file, since typed text is handled with less scrutiny than uploaded documents
- Replace names and account numbers with generic labels like Member 1 and Member 2, and strip other identifying fields before uploading ✅

**Correct answer:** Replace names and account numbers with generic labels like Member 1 and Member 2, and strip other identifying fields before uploading

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 25

✅ Answered correctly · *Configuration and Knowledge Management*

A regional insurance brokerage's renewals coordinator built a Project six months ago for drafting policy renewal letters. Recently the letters have started citing outdated premium rates and referring to a loyalty discount program by its retired name. Reviewing the Project, the coordinator finds that the standing instructions still use the old program name and the knowledge base contains both last year's rate sheet and the current one. What should the coordinator do?

- Archive the Project and rebuild it from scratch, since a configuration that has drifted cannot be reliably corrected in place
- Begin each new conversation with a reminder telling Claude to ignore the old rate sheet and use the current program name
- Upload a new document to the knowledge base explaining which rate sheet is current and noting that the program name in the instructions is outdated
- Update the standing instructions with the current program name and remove the superseded rate sheet so the current one is the single authoritative version ✅

**Correct answer:** Update the standing instructions with the current program name and remove the superseded rate sheet so the current one is the single authoritative version

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 26

✅ Answered correctly · *Product and Model Selection*

An admissions officer at a private university uses Claude daily for a mix of tasks: quick summaries of applicant inquiry emails, routine reply drafting, and an occasional in-depth review of ambiguous borderline application files where several factors interact. Believing that a heavier, more capable model always gives the best results, she has selected Opus, a deep-reasoning specialist, for everything. She now finds responses noticeably slower and regularly hits her plan's usage limits by early afternoon. What is the most appropriate adjustment?

- Upgrade to a higher-capacity plan so Opus can remain the selected model for every task in her daily workload
- Switch every task, including the borderline application reviews, to Haiku to maximize speed and usage headroom
- Keep Opus selected for all tasks but start a fresh conversation for each one so shorter threads reduce usage
- Use Haiku or Sonnet for the quick summaries and routine replies, and reserve Opus for the borderline reviews ✅

**Correct answer:** Use Haiku or Sonnet for the quick summaries and routine replies, and reserve Opus for the borderline reviews

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 27

✅ Answered correctly · *Workflow Integration and Solution Design*

A regional pharmacy chain's compliance team wants to integrate Claude into its monthly audit-report process, which currently runs as twelve manual steps ending in a report filed with a state regulator. The team lead has been told to "put AI on this." Which approach reflects deliberate workflow integration?

- Skip redesigning the shared process and encourage each team member to use Claude individually in whatever way suits their own tasks
- Delegate the entire process to Claude end to end, then add human review at any step where errors begin to surface after go-live
- Start the integration at the final regulatory sign-off step, since automating the highest-stakes step yields the largest time savings
- Map each step against reversibility, stakes, and accountability, and delegate to Claude only the steps those criteria show are suited to it ✅

**Correct answer:** Map each step against reversibility, stakes, and accountability, and delegate to Claude only the steps those criteria show are suited to it

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 28

✅ Answered correctly · *Product and Model Selection*

An environmental consulting firm's permitting specialist has spent weeks in one long Claude conversation preparing a wetland permit application. Recently Claude has started asking for agency requirement documents she supplied at the beginning, and the output format changed partway through the thread. She prepares similar permit applications every month using the same stable agency requirements and templates. Which TWO actions should she take? (Select TWO.)

- Move the stable agency requirements and templates into a Project's knowledge base so every future application conversation starts with that background already in place ✅
- Paste the original agency requirements back into the same long thread and keep working there, since everything said in a conversation stays available to Claude
- Have Claude produce a short summary of the confirmed decisions and progress, verify it against the thread, then continue in a fresh conversation seeded with that summary ✅
- Switch the current conversation to a more capable model tier so that the requirements supplied at the start come back into view

**Correct answers:** Move the stable agency requirements and templates into a Project's knowledge base so every future application conversation starts with that background already in place <br>**+** Have Claude produce a short summary of the confirmed decisions and progress, verify it against the thread, then continue in a fresh conversation seeded with that summary

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 29

✅ Answered correctly · *Troubleshooting and Optimization*

An environmental consultancy's field team audits its weekly site-assessment workflow with Claude and finds three recurring frictions: every analyst pastes the same regulatory terminology glossary at the start of each session, every analyst manually adds the required liability disclaimer that Claude keeps omitting, and every analyst walks Claude step by step through the same multi-part report structure. The team wants to promote these fixes into shared configuration so they stop repeating the work. Which plan puts each fix in the right place?

- Write one master prompt containing the glossary, disclaimer, and report steps, and have each analyst copy and paste it at the start of every session
- Combine the glossary, the disclaimer rule, and the full report procedure into one consolidated set of project instructions for the Project
- Save the glossary as a project instruction, upload the report procedure as a knowledge base document, and build a Skill that inserts the disclaimer
- Add the glossary to the Project knowledge base, set a project instruction to include the disclaimer, and create a shared Skill for the report procedure ✅

**Correct answer:** Add the glossary to the Project knowledge base, set a project instruction to include the disclaimer, and create a shared Skill for the report procedure

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 30

✅ Answered correctly · *Governance, Risk, and Responsible Use*

A publishing house's editorial operations coordinator built a Claude-assisted workflow last quarter for drafting the monthly subscriber newsletter, and at the time it fully complied with the company's AI policy. This month the company circulated an updated AI policy containing several new provisions, including: "AI-assisted external communications must pass a documented human review before sending" and "subscriber personal data must not be uploaded to any non-approved tool." The newsletter workflow drafts from cleared marketing copy and does not handle subscriber personal data. The next newsletter is due in two days. What should the coordinator do?

- Re-check the workflow against the updated policy and bring it into line with the provisions that now apply before this newsletter is sent, since compliance is judged against the current policy rather than the original one ✅
- Keep running the workflow exactly as originally designed, since it was compliant when it was created and that earlier standing carries forward until a manager formally flags it
- Ask Claude to critique its own newsletter draft against the company's quality guidelines and keep that critique on file as the documented review the policy requires
- Send this issue without the review step given the tight two-day deadline, and build the documented review into the workflow starting with next month's newsletter

**Correct answer:** Re-check the workflow against the updated policy and bring it into line with the provisions that now apply before this newsletter is sent, since compliance is judged against the current policy rather than the original one

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 31

✅ Answered correctly · *Output Evaluation and Validation*

A fitness equipment manufacturer's technical writer uses Claude in one afternoon to produce three drafts: a social media caption for a product launch, an internal FAQ about the company's return policy, and revised safety warning text for a treadmill user manual. Time for review is limited. How should the writer allocate review effort across the three outputs?

- Ask Claude to verify the safety warning text against typical industry standards and treat its detailed confirmation as sufficient sign-off
- Apply the same quick proofread to all three drafts so the review process stays consistent and efficient across every piece of content
- Send the social media caption for expert review since it is public-facing, and self-review the internal FAQ and the safety warning text
- Self-review the caption and the FAQ, and route the treadmill safety warning text to the product safety and legal teams before it enters the manual ✅

**Correct answer:** Self-review the caption and the FAQ, and route the treadmill safety warning text to the product safety and legal teams before it enters the manual

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 32

✅ Answered correctly · *Governance, Risk, and Responsible Use*

A regional theater company's development officer drafts a major grant application with substantial help from Claude, then thoroughly revises it. The funder's submission guidelines say nothing about AI-assisted writing, and the theater's internal AI policy does not address disclosure either. How should the officer handle disclosure of the AI assistance?

- Submit without any mention of AI, since the guidelines' silence on the topic means no disclosure obligation exists
- Disclose the AI assistance by default rather than conceal it, since neither the guidelines nor internal policy settle it ✅
- Skip disclosure because the officer's thorough revision means the final proposal is effectively human-authored work
- Stop using Claude for grant applications entirely until every funder the theater works with publishes an explicit AI policy

**Correct answer:** Disclose the AI assistance by default rather than conceal it, since neither the guidelines nor internal policy settle it

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 33

❌ **Answered incorrectly** · *Output Evaluation and Validation*

A community college's student-services coordinator is developing a three-page new-student orientation guide with Claude. Claude drafted the guide as ordinary text in the chat, and after several rounds of feedback the conversation now contains five full copies of the guide, making it hard to locate the current version or keep track of earlier revisions. What is the most effective way to continue refining the guide?

- Ask Claude to move the guide into an artifact and continue making revisions there ✅
- Start a fresh conversation for each new revision round so every version of the guide lives in its own separate chat
- Copy each new version into a separate note-taking app manually and paste the latest one back into the chat before every revision request
- Ask Claude to label each new copy of the guide in the chat with a version number so the drafts are easier to tell apart ❌ *(your answer)*

**Correct answer:** Ask Claude to move the guide into an artifact and continue making revisions there

<details open>
<summary><b>Explanation</b></summary>

**Why your answer was wrong** — *Ask Claude to label each new copy of the guide in the chat with a version number so the drafts are easier to tell apart*

Numbering the copies makes the clutter slightly easier to navigate but does not remove it. The latest text is still buried among repeated full drafts in the conversation, and there is still no single place where the current guide lives and gets revised.

**Why the correct answer is right** — *Ask Claude to move the guide into an artifact and continue making revisions there*

This is correct because a substantial, self-contained document that will be edited and reused is exactly what artifacts are designed for. An artifact appears in a dedicated window beside the conversation, revisions update it in place rather than producing new full copies in the chat, and the coordinator can switch between versions to review how the guide has evolved.

**Overall explanation**

The useful mental model is that the chat is a dialogue and an artifact is the work product that dialogue is shaping. Claude creates artifacts for content that is significant and self-contained, typically more than 15 lines, likely to be edited, iterated on, or reused, and understandable without the surrounding conversation. A three-page orientation guide going through repeated revision rounds meets every one of those criteria, which is why leaving it as inline chat text produces exactly the symptom described: each revision generates another full copy, and the current version gets buried.

Once the guide lives in an artifact, it appears in a dedicated window to the right of the conversation. Revision requests update that one document in place, the coordinator can edit the text directly, switch between versions to review how the draft evolved, and copy or download the finished guide when it is ready to circulate. The conversation stays readable as a record of feedback, while the artifact stays the single authoritative draft.

The alternatives all fail to separate the dialogue from the deliverable. Spawning a new conversation per revision fragments the work and makes maintaining context harder unless the coordinator restates it or leans on separate memory or search features, and it still yields plain-text copies. Version-numbering the inline drafts labels the clutter without consolidating it. Manually shuttling versions through an external notes app is error-prone busywork that duplicates what the artifact window already does natively. See What are Artifacts and how do I use them? for how artifacts handle iteration and versioning.

</details>

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 34

✅ Answered correctly · *Output Evaluation and Validation*

An architecture firm's business development lead asks Claude, with web search enabled, to produce a briefing on regional construction market trends. The response includes several specific figures, each accompanied by citations and source links. Before circulating the briefing to the firm's partners, what does a sound accuracy check involve?

- Ask Claude in the same conversation to verify that each claim matches its cited sources
- Open the cited sources and check the briefing's key claims against them before circulating it ✅
- Run the same request again and confirm the second briefing states substantially the same facts
- Treat the presence of citations and source links as confirmation that the claims are accurate

**Correct answer:** Open the cited sources and check the briefing's key claims against them before circulating it

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 35

✅ Answered correctly · *Troubleshooting and Optimization*

A credit union's member communications specialist drafts a weekly newsletter with Claude inside a dedicated Project. Every week the draft comes back with the same flaw: it uses banking jargon that members will not understand, and she spends time rewriting those passages by hand before sending. What is the most effective adjustment?

- Write the plain-language requirement into the Project's description field so it shapes every chat in the workspace
- Add a precise plain-language rule to the Project's instructions, then check that the next draft reflects it ✅
- Keep rewriting the jargon by hand each week, since manually correcting outputs is a normal part of iterating with Claude
- Regenerate each week's draft several times and select whichever version happens to contain the least jargon

**Correct answer:** Add a precise plain-language rule to the Project's instructions, then check that the next draft reflects it

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 36

❌ **Answered incorrectly** · *Output Evaluation and Validation*

A specialty foods importer's product coordinator uses Claude to draft the allergen declaration text for a new snack product's packaging. The coordinator carefully compares the draft against the supplier's ingredient specification and confirms every ingredient matches. The label is scheduled to print next week. What should the coordinator do next?

- Send it to print, since the text has already been verified against the authoritative source document ❌ *(your answer)*
- Ask Claude to check the draft against current labeling regulations and proceed once it confirms compliance
- Add a broad statement that the product may contain traces of common allergens, then proceed to print
- Route the draft to the company's food-safety or regulatory specialist for review before it goes to print ✅

**Correct answer:** Route the draft to the company's food-safety or regulatory specialist for review before it goes to print

<details open>
<summary><b>Explanation</b></summary>

**Why your answer was wrong** — *Send it to print, since the text has already been verified against the authoritative source document*

Verifying the draft against the supplier specification is a good accuracy check, but it only confirms the draft faithfully reflects that document. It cannot confirm the specification is complete or that the declaration meets applicable labeling rules, which are questions of expert judgment, not transcription accuracy.

**Why the correct answer is right** — *Route the draft to the company's food-safety or regulatory specialist for review before it goes to print*

This is correct because allergen labeling sits above the threshold where expert human review is mandatory: the stakes involve consumer safety, a printed label is costly to recall, and the content carries regulatory exposure. Checking the draft against the ingredient specification confirms it matches the source, but only a qualified specialist can judge whether the specification itself is complete and whether the wording meets labeling requirements.

**Overall explanation**

The skill being tested is knowing where the line sits between outputs you can verify yourself and outputs that must go to a qualified human reviewer. That line is not drawn by how confident you feel about the draft; it is drawn in advance by the nature of the content: the stakes (an incorrect allergen declaration can physically harm a consumer), the reversibility (a printed label is expensive to pull back), the audience (the public), and the regulatory exposure (food labeling is legally governed). When a task scores high on those factors, expert review is mandatory no matter how polished or well-verified the draft appears.

It is worth separating two different checks that are easy to conflate. Comparing the draft against the supplier's ingredient specification is accuracy verification: it confirms the text faithfully reflects its source, and it is exactly the right first step. Expert review is a different check: a food-safety or regulatory specialist judges whether the source itself is complete, whether the declaration format and wording satisfy labeling requirements, and whether anything consequential is missing. The coordinator's check cannot answer those questions, so passing it does not clear the label for print.

Asking Claude to confirm its own draft complies with regulations fails for a documented reason: Anthropic states that Claude can produce incorrect or misleading responses that sound authoritative, and advises users not to rely on Claude as a singular source of truth, especially for high-stakes advice, which should be carefully scrutinized by a human. And adding a vague "may contain traces" statement is an anti-pattern: it hedges the risk rather than resolving it, and does not make an inaccurate declaration safe or compliant. See Claude is providing incorrect or misleading responses. What's going on? for Anthropic's guidance on scrutinizing high-stakes output.

</details>

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 37

✅ Answered correctly · *Troubleshooting and Optimization*

A veterinary clinic network's client communications team audited its weekly pet-discharge instruction workflow and found the same background pasted every session, the same formatting fixed by hand every round, and inconsistent results across staff. They promoted the fixes into a shared Project: reference material in the knowledge base, the formatting procedure as a Skill, and a standing instruction for the recurring correction. The team lead wants all staff to depend on the new setup starting tomorrow. What should the team do first?

- Switch all staff over immediately, since moving repeated work into configuration reliably improves output and delaying adoption just prolongs the friction
- Run the workflow through a few cycles with the new configuration while the old approach is still available, compare the outputs, and commit only once the gain is confirmed ✅
- Roll the changes back and keep pasting the background and fixing the formatting manually, since shared configuration introduces more risk than the friction it removes
- Ask Claude to review the new Project setup and confirm that it will produce better outputs than the old manual approach before rolling it out

**Correct answer:** Run the workflow through a few cycles with the new configuration while the old approach is still available, compare the outputs, and commit only once the gain is confirmed

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 38

✅ Answered correctly · *Prompting and Task Execution*

A craft brewery's brand manager built one prompt template with strict evaluation criteria, a required table format, and explicit standards. It works well when analyzing taproom sales data, but when reused to brainstorm names for a seasonal beer line, Claude returns a short, repetitive list of similar names. What adjustment reflects sound adaptation of prompting strategy to the task type?

- Add more constraints to the brainstorming prompt, such as naming conventions and a fixed structure for each entry, so Claude knows precisely what a good name looks like
- Rerun the identical brainstorming prompt several times in fresh conversations and merge the resulting lists into one larger pool of candidate names
- Loosen the constraints on both prompts, giving Claude broad latitude on the sales analysis as well so it has room to produce its best work everywhere
- For the brainstorm, strip the prompt down to the goal and a few guardrails, then ask for a large number of varied options before narrowing anything down ✅

**Correct answer:** For the brainstorm, strip the prompt down to the goal and a few guardrails, then ask for a large number of varied options before narrowing anything down

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 39

✅ Answered correctly · *Troubleshooting and Optimization*

A public library system's program coordinator has spent an entire afternoon in one long Claude conversation planning a summer reading program. Early in the session, Claude's responses followed her formatting instructions exactly and correctly referenced the budget figures she pasted at the start. Over the last hour, as the conversation has grown very long, responses have gradually drifted from the required format and started misstating the budget numbers. What is the most appropriate way to resolve this?

- Start a fresh conversation, carrying forward a brief summary of the decisions, formatting instructions, and budget figures ✅
- Switch the conversation to a different model with extended thinking enabled, since the planning work has become too complex for the current settings
- Rewrite the original prompt with more detail about audience, format, and constraints, then resend it in the same conversation
- Audit the Project's standing instructions and knowledge files for content that has drifted out of date and is degrading output

**Correct answer:** Start a fresh conversation, carrying forward a brief summary of the decisions, formatting instructions, and budget figures

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 40

✅ Answered correctly · *Workflow Integration and Solution Design*

A city museum's membership team had Claude build a dashboard artifact inside a Project to track renewal metrics from an uploaded spreadsheet. The first version works, but one chart groups memberships by join date instead of renewal date, and there is no way to filter by membership tier. What is the most effective next step?

- Escalate the dashboard to developer expertise now, since flaws in a working prototype show it has outgrown prompt-based iteration
- Continue in the same conversation, describe the two specific problems, and ask Claude to revise the artifact accordingly ✅
- Start a fresh conversation and rewrite the original prompt from scratch, folding in everything learned, so the artifact is rebuilt cleanly
- Regenerate the artifact by resubmitting the identical original prompt, since natural variation between responses may correct the flaws

**Correct answer:** Continue in the same conversation, describe the two specific problems, and ask Claude to revise the artifact accordingly

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 41

✅ Answered correctly · *Prompting and Task Execution*

A regional theater company's development director asks Claude to "draft a thank-you letter to a donor" and receives a bland, template-like letter that could have come from any organization. Before trying again, she wants to change the one thing most likely to produce a usable draft. What should she do?

- Prepend an expert persona such as "You are an award-winning nonprofit fundraising copywriter with 30 years of experience" and resend the otherwise identical request
- Ask Claude to rewrite the letter to be far more heartfelt and compelling this time, without changing anything else about the original request
- Request a letter three times as long as the first one so that more of the donor relationship is likely to be covered somewhere in the draft
- Add the missing specifics: the gift funded the youth acting program, the letter should mention the season it supports, and the tone should be warm, around 200 words ✅

**Correct answer:** Add the missing specifics: the gift funded the youth acting program, the letter should mention the season it supports, and the tone should be warm, around 200 words

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 42

❌ **Answered incorrectly** · *Workflow Integration and Solution Design*

A boutique hotel group's revenue planner is preparing next season's pricing plan with Claude. One key question, how midweek occupancy trended across the group's three properties over the past year, can be answered entirely from the booking spreadsheets she already has on her laptop. A colleague suggests running Claude's Research feature on the question so the answer comes back with citations. What should the planner do?

- Ask the question without any attachments so Claude can draw on its general knowledge of hospitality occupancy patterns
- Use Research to gather industry-average occupancy benchmarks and substitute those figures for the properties' own numbers
- Attach the booking spreadsheets to the conversation and ask Claude to work out the occupancy trend directly from them ✅
- Run Research on the question so the answer arrives with citations drawn from multiple retrieved sources ❌ *(your answer)*

**Correct answer:** Attach the booking spreadsheets to the conversation and ask Claude to work out the occupancy trend directly from them

<details open>
<summary><b>Explanation</b></summary>

**Why your answer was wrong** — *Run Research on the question so the answer arrives with citations drawn from multiple retrieved sources*

Research earns its place when the answer sits outside your own material and several sources must be reconciled. Here the needed data is the group's own booking records, which web retrieval cannot see, so a sweep would be slower and no more reliable than asking directly against the files she already has.

**Why the correct answer is right** — *Attach the booking spreadsheets to the conversation and ask Claude to work out the occupancy trend directly from them*

This is correct because the answer lives entirely inside material the planner already holds. A grounded ask against supplied files is faster than a research sweep and produces a result she can check line by line against the source spreadsheets, which is exactly the verification a plan needs.

**Overall explanation**

The judgment being tested is when a research sweep earns its place over a grounded ask. A grounded ask works from material you supply: it is fast, and its output can be checked against a source you already hold. A sweep with Claude's Research feature goes out across many sources, reconciles them, and shows what it drew on; it conducts multiple searches and returns citations, which is genuinely valuable when the answer is outside your material. When the answer is already sitting in a spreadsheet on your laptop, a sweep is slower and no more reliable, because the authoritative source is the file itself, not anything on the web.

The mental model for planning work is that the trustworthiness of a plan is inherited from the trustworthiness of the numbers under it. Numbers computed from the actual booking data can be defended figure by figure; numbers recalled from general knowledge or borrowed from industry benchmarks cannot, because neither reflects what actually happened at these three properties. Asking without attachments risks hallucinated specifics, and substituting benchmarks quietly swaps the question being answered from "how did our occupancy trend?" to "how did the industry's occupancy trend?", which is a different plan.

Research remains the right tool when its conditions hold: the answer post-dates or sits outside your material, several sources must be reconciled, and you need to see what was used. Details on how Research retrieves and cites sources are in Using Research on Claude.ai, and guidance on supplying your own files for grounded analysis is in What kinds of documents can I upload to Claude.ai.

</details>

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 43

❌ **Answered incorrectly** · *Output Evaluation and Validation*

A university accreditation office uploads its 320-page self-study report as a single PDF and asks Claude to summarize the key findings for a leadership retreat. The report presents several critical enrollment and retention figures only in charts, with no matching numbers in the surrounding text. Claude's summary is well written but contains none of those chart-based figures. When evaluating the summary for completeness, what should the office conclude and do?

- Ask Claude directly whether it reviewed every chart in the report and, if it confirms that it did, accept the summary as complete for circulation
- Recognize that a PDF this long is processed as text only, so Claude never saw the chart figures, and add them from the source before the summary is used ✅
- Treat the omission as Claude's editorial judgment that the chart data was not material to the findings, and circulate the summary to the retreat as delivered
- Ask Claude to regenerate the summary with an added instruction to include every chart in the report, since the omission indicates the original prompt was too vague ❌ *(your answer)*

**Correct answer:** Recognize that a PDF this long is processed as text only, so Claude never saw the chart figures, and add them from the source before the summary is used

<details open>
<summary><b>Explanation</b></summary>

**Why your answer was wrong** — *Ask Claude to regenerate the summary with an added instruction to include every chart in the report, since the omission indicates the original prompt was too vague*

Re-prompting cannot fix this omission because the problem is not instruction quality. At this document length the chart content was never processed, so a more detailed instruction still leaves Claude working from text that does not contain the figures.

**Why the correct answer is right** — *Recognize that a PDF this long is processed as text only, so Claude never saw the chart figures, and add them from the source before the summary is used*

This is correct. PDFs longer than 100 pages are processed as text only, so figures that appear exclusively in charts are invisible to Claude, and no amount of re-prompting in the same setup can surface them. The completeness gap must be closed from the source itself, either by supplying the values directly or by giving Claude a version of the material it can visually analyze.

**Overall explanation**

Evaluating an output for completeness starts with knowing what the tool could actually see. Claude's document handling has documented boundaries: PDFs up to 100 pages can be analyzed for both text and visual content, while PDFs from 101 to 1000 pages are processed as text only, and non-PDF documents are text extraction only. A 320-page report therefore reaches Claude without its charts, so any figure that exists only in a graphic is simply absent from the material Claude summarized. The resulting gap is invisible in the summary itself; it only shows up when you compare the output against the source, which is why completeness checks always run against the original document rather than against how polished the output looks.

The practical fix works at the input, not the prompt. The office can type the chart values into the conversation, or extract the pages containing the key charts into a short PDF (under 100 pages) so Claude can visually analyze them, then have the summary revised from that verified data. Re-prompting the same oversized file with firmer instructions changes nothing, because the limitation is in what was processed, not in what was asked. Treating the omission as deliberate editorial judgment mistakes a mechanical constraint for a decision, and asking Claude to confirm it reviewed the charts asks for assurance about content it never received; Claude's answers can sound authoritative without being grounded, which is why self-confirmation is never a substitute for checking the source.

The broader habit this scenario teaches: before signing off on any summary of an uploaded document, know the format and length limits that applied, walk the source's key sections and figures, and confirm each is represented or consciously omitted. See Upload files to Claude for the processing limits and Claude is providing incorrect or misleading responses for why outputs should never be validated by the model's own say-so.

</details>

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 44

✅ Answered correctly · *Prompting and Task Execution*

A civil engineering trade association's events coordinator asks Claude to draft a session description for the annual conference. The first draft is too long and too academic for the practicing engineers who attend. She replies "make it better" twice; each new version is different but no closer to what she needs, and the third draft has drifted further from usable than the first. What is the most effective next step?

- Reply "make it better" a few more times, since repeated rounds of iteration gradually converge on a stronger version of the draft
- Send the same follow-up message again and regenerate several times, then pick whichever of the new variations happens to read best
- Ask for the strongest draft to be cut to a set length and rewritten in a plain, practical style suited to working engineers ✅
- Ask Claude to combine all three drafts into a single merged version so that nothing useful from any of the rounds is lost

**Correct answer:** Ask for the strongest draft to be cut to a set length and rewritten in a plain, practical style suited to working engineers

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 45

✅ Answered correctly · *Governance, Risk, and Responsible Use*

A grocery retail chain's employee benefits coordinator is drawing up a list of ways the team could use Claude. Which TWO of the following proposed uses are appropriate as described? (Select TWO.)

- Brainstorm campaign names and outreach ideas for the upcoming benefits enrollment period, then refine drafts of the announcement emails through iteration ✅
- Set up a self-serve chat where employees ask questions about their diagnosed medical conditions and receive personalized guidance without staff involvement
- Draft a monthly employee wellness newsletter with general tips on sleep, stress management, and exercise, which the coordinator reviews before sending ✅
- Upload employees' submitted medical documentation and have Claude decide which disability accommodation requests should be approved or denied

**Correct answers:** Brainstorm campaign names and outreach ideas for the upcoming benefits enrollment period, then refine drafts of the announcement emails through iteration <br>**+** Draft a monthly employee wellness newsletter with general tips on sleep, stress management, and exercise, which the coordinator reviews before sending

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 46

✅ Answered correctly · *Workflow Integration and Solution Design*

A wind energy cooperative's planning committee is drafting a five-year battery storage investment plan. They ask Claude, with web search turned on, to synthesize several industry analyst reports on future storage costs. Claude returns a single confident cost trajectory presented as settled consensus, yet one committee member knows the analyst firms have published sharply different projections. What should the committee do before building the plan on this synthesis?

- Regenerate the synthesis a second time and treat matching conclusions across the two versions as confirmation that the trajectory is reliable
- Ask Claude to rewrite the synthesis with substantially more detail and supporting reasoning so that any weak points become easier to spot
- Rerun the request with a source required for each claim and disagreements reported explicitly, then check key figures against those sources ✅
- Accept the trajectory as presented, since a synthesis drawn from multiple independent reports is inherently more reliable than any single analyst's view

**Correct answer:** Rerun the request with a source required for each claim and disagreements reported explicitly, then check key figures against those sources

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 47

✅ Answered correctly · *Governance, Risk, and Responsible Use*

A city transit agency's outreach coordinator proposes using Claude to draft the denial letters sent to applicants who do not qualify for the reduced-fare program. Working through the ethics of the idea, the coordinator notes that thousands of low-income residents would be affected each year, an unfair or inconsistent phrasing could cause real harm, and the agency's AI policy says nothing about using AI in benefits communications. What should the coordinator do next?

- Ask Claude to evaluate whether the proposed workflow is ethical and proceed if it concludes the use case is fair
- Add a line to each letter disclosing that AI assisted the drafting, then proceed, since transparency resolves the ethical concern
- Treat the policy's silence on benefits communications as permission and proceed, since no rule explicitly restricts this use
- Escalate the question to the agency's AI governance function, sharing the documented reasoning rather than a proceed-or-stop verdict ✅

**Correct answer:** Escalate the question to the agency's AI governance function, sharing the documented reasoning rather than a proceed-or-stop verdict

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 48

✅ Answered correctly · *Product and Model Selection*

A specialty insurance brokerage's training coordinator has two Claude tasks this month. First, she drafts new-hire onboarding materials every month, always working from the same set of product guides and internal compliance policies. Second, she needs a well-sourced overview of regulatory changes announced across multiple state insurance departments over the past quarter, synthesized from many current sources. Which TWO actions best match Claude's features to these tasks? (Select TWO.)

- Create a Project with the guides and compliance policies in its knowledge base, and draft each month's onboarding materials inside it ✅
- Start a fresh plain Chat each month and paste the product guides and compliance policies at the top of the conversation before drafting
- Use Research mode for the regulatory-changes overview, so Claude investigates many current sources and shows where the synthesis came from ✅
- Ask a plain Chat without web access about the past quarter's regulatory changes, relying on Claude's built-in knowledge of recent announcements

**Correct answers:** Create a Project with the guides and compliance policies in its knowledge base, and draft each month's onboarding materials inside it <br>**+** Use Research mode for the regulatory-changes overview, so Claude investigates many current sources and shows where the synthesis came from

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 49

✅ Answered correctly · *Troubleshooting and Optimization*

An architecture firm's proposal writer uses Claude to draft the executive summary for a major bid. Her director reads the draft and says only, "This misses the point." She wants the next draft from Claude to actually be different, not another guess. What should she do first?

- Paste the director's comment into the conversation verbatim, telling Claude the draft misses the point and asking it to fix the problem
- Discard the current prompt entirely and rewrite it from scratch so nothing from the failed attempt carries over into the next draft
- Resend the identical prompt several times and bring the director the version that reads best, since responses naturally vary between attempts
- Work out what specifically would need to be present for the summary to be right, then change the prompt element that controls it ✅

**Correct answer:** Work out what specifically would need to be present for the summary to be right, then change the prompt element that controls it

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 50

✅ Answered correctly · *Prompting and Task Execution*

A regional food bank network's development manager must use Claude to produce an annual impact report covering four parts: verified donation totals, program outcomes, volunteer statistics, and a forward-looking appeal narrative. The program outcomes and appeal narrative sections will both cite the donation totals. A single prompt requesting the full report returned uneven, shallow coverage. Which TWO practices reflect effective task decomposition for this work? (Select TWO.)

- Resubmit the original single prompt but double the requested word count so each of the four sections has enough room for proper depth
- Begin with the donation totals, since later sections depend on those figures being correct, and confirm them before drafting anything that cites them ✅
- Work through the report as a sequence of focused requests, reviewing each part's output before the next request builds on it ✅
- Split the report into four separate requests but defer all review until the complete draft is assembled, so drafting momentum is not interrupted

**Correct answers:** Begin with the donation totals, since later sections depend on those figures being correct, and confirm them before drafting anything that cites them <br>**+** Work through the report as a sequence of focused requests, reviewing each part's output before the next request builds on it

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 51

✅ Answered correctly · *Output Evaluation and Validation*

A solar installation company's procurement coordinator uploads three supplier quotes to Claude and asks for a recommendation memo. The memo Claude produces includes specific panel prices, warranty lengths, and delivery dates, and it will go to the company owner to decide which supplier gets a six-figure order. Which validation approach is soundest before the memo is sent?

- Regenerate the memo a second time and confirm that the figures in the new version match the figures in the first one
- Compare the figures against prices and terms from the company's previous panel orders and accept them if nothing seems unusual
- Trace each price, warranty term, and delivery date in the memo back to the supplier quote it came from and confirm it matches ✅
- Ask Claude in the same conversation to double-check the memo and confirm that all of the figures are accurate before sending it

**Correct answer:** Trace each price, warranty term, and delivery date in the memo back to the supplier quote it came from and confirm it matches

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 52

❌ **Answered incorrectly** · *Governance, Risk, and Responsible Use*

A veterinary clinic chain's regional manager is screening four proposed Claude use cases against the team's delegation criteria: reversibility, consequence, human element, and accountability. Which proposed use, as described, should be classified as inappropriate rather than appropriate or appropriate-with-review?

- Have Claude assign final annual performance ratings for clinic staff and release the results to each employee with no human review ✅
- Have Claude brainstorm candidate names for a new pet-wellness newsletter that the marketing team will choose from afterward
- Have Claude draft appointment-reminder email templates that front-desk staff review and edit before any messages are sent ❌ *(your answer)*
- Have Claude summarize published veterinary industry articles into a short weekly digest circulated to the clinic managers

**Correct answer:** Have Claude assign final annual performance ratings for clinic staff and release the results to each employee with no human review

<details open>
<summary><b>Explanation</b></summary>

**Why your answer was wrong** — *Have Claude draft appointment-reminder email templates that front-desk staff review and edit before any messages are sent*

Drafting with a human review step before anything reaches a customer is the classic appropriate-with-review pattern, not an inappropriate use. The review gate keeps accountability with staff and makes any error fully correctable before it has consequences.

**Why the correct answer is right** — *Have Claude assign final annual performance ratings for clinic staff and release the results to each employee with no human review*

This use fails every delegation criterion at once: the consequences for individuals are high, a released rating is hard to reverse, the human element is central, and accountability for a personnel judgment cannot be handed to a tool. Employment-related decisions that directly affect individuals also fall into a category where Anthropic requires qualified human review, so releasing outputs unreviewed makes this inappropriate as described.

**Overall explanation**

Screening use cases is a judgment exercise, and the delegation criteria give it structure: how reversible is the outcome, how serious are the consequences, how central is the human element, and who holds accountability? A use case does not have to be exotic to be inappropriate; it just has to fail those tests. Assigning final performance ratings and releasing them without review fails all four: ratings shape pay and careers (high consequence), a released rating is difficult to walk back (low reversibility), evaluating a person is inherently human work, and no one is standing behind the output when it reaches the employee.

This is also where organizational judgment lines up with Anthropic's own rules. The Anthropic Usage Policy treats employment-related use cases as high-risk when they produce recommendations or decisions directly affecting individuals, and it requires a qualified human to review those outputs. The point is not that Claude can never touch performance-review work; a manager drafting summaries from their own notes, then verifying each one, can be appropriate-with-review. The point is that the as-described design, with no human in the loop before the output lands on an employee, is the part that makes it inappropriate.

The other proposals show what the appropriate end of the spectrum looks like. Brainstorming newsletter names and summarizing published articles are low-stakes, reversible tasks squarely within Claude's documented everyday uses (see What are some things I can use Claude for?). Drafting reminder templates with a staff review gate is appropriate-with-review: the human checkpoint converts a customer-facing task from risky delegation into safe assistance. The skill being tested is recognizing that the same tool can be appropriate or inappropriate depending entirely on stakes and on where the human sits in the workflow.

</details>

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 53

✅ Answered correctly · *Workflow Integration and Solution Design*

A community college's student services office is asked by the dean to "have Claude analyze the student feedback we collect each semester." The coordinator turning this into a written requirement has so far documented the data source (the semester survey exports), the person who will receive the output (the dean's office), and a monthly delivery cadence. Before designing the workflow, which remaining question is most important to answer?

- Decide whether the monthly output should be delivered as a polished artifact or an inline summary
- Select which Claude model and features, such as a dedicated Project, the workflow should use
- Run a trial analysis on last semester's survey export to see what kind of output Claude produces
- Establish what decision the analysis will feed and what the consequence of a wrong output would be ✅

**Correct answer:** Establish what decision the analysis will feed and what the consequence of a wrong output would be

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 54

✅ Answered correctly · *Output Evaluation and Validation*

A state tourism board's research analyst uses Claude to draft an investor briefing. The draft states that visitor spending rose 8.3% last year, attributing the figure to "the 2024 State Visitor Economy Report." The analyst searches online and confirms that a report with that exact title exists and is published on a government website. What should the analyst do next before the figure goes into the briefing?

- Open the report itself and confirm that the 8.3% figure and its context actually appear in it ✅
- Regenerate the briefing in a fresh conversation and keep the figure if the same 8.3% appears in the second draft
- Treat the verification as complete, since confirming the cited report is real and publicly available establishes the claim
- Ask Claude to quote the exact passage from the report where the figure appears and rely on that quoted text

**Correct answer:** Open the report itself and confirm that the 8.3% figure and its context actually appear in it

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 55

✅ Answered correctly · *Prompting and Task Execution*

A children's museum's grants coordinator must prepare a foundation grant application with four connected parts: a needs statement, a program design, a budget narrative, and an evaluation plan. The budget narrative and evaluation plan must both align with whatever the program design says. A single prompt asking for the full application produced sections that contradicted each other. How should the coordinator restructure the work?

- Ask for two complete drafts of the full application in one prompt and keep whichever version reads more consistently across its sections
- Resubmit the original single prompt unchanged except for an added instruction telling Claude to work carefully through all four sections step by step
- Request each of the four sections in its own brand-new conversation so every section starts from a completely clean context
- Draft the program design as its own request, review it, then ask for the budget narrative and evaluation plan as follow-up steps built on it ✅

**Correct answer:** Draft the program design as its own request, review it, then ask for the budget narrative and evaluation plan as follow-up steps built on it

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 56

✅ Answered correctly · *Troubleshooting and Optimization*

A children's museum's exhibits coordinator sets up a Claude Project for an upcoming tide pool exhibit. She writes a thorough project description in the description field covering the exhibit's theme, the target age group, and the key educational messages. Yet every time she starts a new chat in the Project and asks for signage copy or family activity guides, the drafts are generic and never reflect any of those details. What should she do to fix this?

- Begin each new chat by instructing Claude to review the Project's description carefully before drafting anything
- Add the exhibit theme, audience, and messaging details to the Project's instructions or knowledge base instead of relying on the description field ✅
- Switch the Project's conversations to a more capable model tier, since generic output signals the current model lacks the depth for the task
- Delete the Project and create a new one with the same description, since the original Project's configuration has likely gone stale

**Correct answer:** Add the exhibit theme, audience, and messaging details to the Project's instructions or knowledge base instead of relying on the description field

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 57

✅ Answered correctly · *Output Evaluation and Validation*

An architecture firm's bid coordinator uploads a client's 40-page request for proposals and asks Claude to summarize the submission requirements. Claude returns a clean list of five requirements. Four match the coordinator's memory of the document, but the fifth, a requirement to include LEED certification documentation, is common in the industry yet the coordinator does not recall seeing it in this RFP. How should the coordinator handle the summary?

- Rely on the summary as written, since Claude had the actual RFP attached and could only draw its list from that document
- Ask Claude whether the LEED requirement appears in the RFP and accept its answer as confirmation
- Compile the LEED documentation and include it in the bid anyway, since satisfying an extra requirement cannot hurt the submission
- Check each listed requirement against the RFP text itself, starting with the unfamiliar one, before using the summary to plan the bid ✅

**Correct answer:** Check each listed requirement against the RFP text itself, starting with the unfamiliar one, before using the summary to plan the bid

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 58

❌ **Answered incorrectly** · *Prompting and Task Execution*

An environmental consultancy's compliance analyst pastes a table of quarterly water sample readings into Claude, along with the permit's threshold limits for each contaminant. She needs a site-by-site summary of exceedances that will go into a report the regulator will read. A few readings in the table are blank. Which prompt best fits this analysis task?

- "Compare each reading against the permit threshold table I provided, flag every exceedance in a site-by-site table, and mark any blank reading as 'data missing' rather than estimating a value." ✅
- "Analyze this water sample data extremely carefully and thoroughly; accuracy is absolutely critical here, so double-check every single conclusion before you respond." ❌ *(your answer)*
- "Act as a senior environmental scientist with twenty years of regulatory compliance experience, and analyze this sample data with the full rigor and professionalism that role demands."
- "Review the data against the permit limits and use your best judgment to interpret ambiguous results and fill in any blank readings so the final summary is complete."

**Correct answer:** "Compare each reading against the permit threshold table I provided, flag every exceedance in a site-by-site table, and mark any blank reading as 'data missing' rather than estimating a value."

<details open>
<summary><b>Explanation</b></summary>

**Why your answer was wrong** — *"Analyze this water sample data extremely carefully and thoroughly; accuracy is absolutely critical here, so double-check every single conclusion before you respond."*

Urging carefulness adds emphasis but no information: it names no thresholds, no output format, and no rule for the blank readings. Claude still has to guess what the analysis should measure and how to present it, which is what produces vague or unusable results.

**Why the correct answer is right** — *"Compare each reading against the permit threshold table I provided, flag every exceedance in a site-by-site table, and mark any blank reading as 'data missing' rather than estimating a value."*

This prompt gives Claude explicit criteria (the permit thresholds), a defined output shape (a site-by-site exceedance table), and a rule for handling ambiguity (label blanks instead of estimating). Analysis tasks reward exactly this kind of tight specification, and the missing-data instruction prevents fabricated values from reaching a regulator-facing report.

**Overall explanation**

Different task types reward different balances of specification and latitude, and analysis sits at the high-specification end. An effective analysis prompt tells Claude three things: what to measure, what standard to measure it against, and how to handle ambiguity. In this scenario those map directly to the readings, the permit threshold table, and an explicit rule that blank fields get labeled data missing rather than estimated. Adding a defined output shape (a site-by-site table) makes the result checkable line by line before it enters a regulator-facing report.

The instruction about blanks deserves particular attention. A language model will generally try to complete the task it is given, so a prompt that asks for a "complete" summary over incomplete data implicitly invites plausible-looking invented values. Telling Claude how to treat gaps closes that door up front, which is far cheaper than trying to detect fabricated numbers during review. This is why explicitly inviting Claude to "use judgment to fill in blank readings" is an anti-pattern in compliance work: it converts a data gap into a fabricated data point.

The weaker prompts fail for a shared reason: they add pressure or personality without adding information. A persona ("senior environmental scientist") and intensity language ("be extremely careful, accuracy is critical") change the styling of the response, not its substance, because neither supplies the criteria the analysis depends on. Anthropic's guidance on getting helpful answers makes the same point: explain the ask clearly, provide the context and materials Claude cannot guess, and be specific about what the output should contain. See My prompt isn't giving me a helpful answer for Anthropic's prompting recommendations.

</details>

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 59

✅ Answered correctly · *Product and Model Selection*

A freight logistics company's operations team is standardizing which Claude model tier to use for several recurring and one-off tasks. Which TWO choices correctly apply the trade-off between speed and capability across the Haiku, Sonnet, and Opus tiers? (Select TWO.)

- Use Opus for the daily reformatting of routine delivery-status updates, since the most capable model always produces the best results
- Use Haiku to sort thousands of incoming shipment-exception emails into a fixed set of categories defined by a clear rubric ✅
- Use Haiku for the quarterly network-strategy assessment with ambiguous inputs, since finishing the analysis faster is what matters most for leadership
- Use Opus for a one-off analysis of an ambiguous carrier-contract renegotiation where several constraints interact and a subtle error would be costly ✅

**Correct answers:** Use Haiku to sort thousands of incoming shipment-exception emails into a fixed set of categories defined by a clear rubric <br>**+** Use Opus for a one-off analysis of an ambiguous carrier-contract renegotiation where several constraints interact and a subtle error would be costly

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

### Question 60

✅ Answered correctly · *Governance, Risk, and Responsible Use*

A national logistics company's HR recruiter proposes a new workflow: Claude reviews incoming applications for warehouse supervisor roles, scores each candidate against the job description, and automatically triggers rejection emails to anyone scoring below a threshold, with no one on the team reading Claude's assessments. How should this proposal be handled?

- Proceed as designed, since screening is an early hiring stage and rejected candidates remain free to apply for future openings
- Drop the idea entirely, because using AI in any part of a hiring process falls under prohibited use
- Approve the automation after adding prompt instructions that tell Claude to evaluate every candidate fairly and without bias
- Redesign the workflow so a qualified person reviews Claude's assessment of each candidate before any rejection is sent ✅

**Correct answer:** Redesign the workflow so a qualified person reviews Claude's assessment of each candidate before any rejection is sent

[↑ Back to top](#claude-certified-associate--foundations-ccao-f)

---

## Revision notes

Concepts drawn from the 8 missed questions, grouped by domain. Output Evaluation and Validation had the most misses (4 of 8), so start there.

### 1. Output Evaluation and Validation (Q23, Q33, Q36, Q43)

#### Choosing the output format (Q23, Q33)
Start with one question: **what happens to this output next, and who works on it?**

| Output path | Best for | Not for |
|---|---|---|
| **Inline chat text** | Quick answers, short content used inside the conversation | Long documents revised many times (copies pile up in the chat) |
| **Artifact** | Large, self-contained content you will keep revising with Claude: shows in its own window, updates in place, keeps versions, can be published as a view-only link | People who must **edit** the file in Office tools; internal or sensitive content (on Free/Pro/Max plans, anyone with a published link can see it) |
| **File creation** (.docx, .xlsx, .pptx, .pdf) | Handing work to people **outside Claude** who will edit it in Word/Excel/PowerPoint | Content you are still actively revising with Claude |

- **When Claude makes an artifact:** the content is large (usually 15+ lines), self-contained, likely to be edited or reused, and makes sense without the chat around it.
- **What the chat and the artifact each do:** the chat is the conversation; the artifact is the document being shaped. Five numbered copies in the chat is still clutter. Move the document into an artifact.
- **Mistake to avoid:** picking a format because it looks polished (for example, an interactive React artifact) instead of picking it for where the content goes next.

#### Accuracy check vs expert review (Q36)
- **Accuracy check:** you compare the draft with its source. This proves the draft matches the source. It does **not** prove the source is complete or that the text meets legal rules.
- **Expert review** is a separate gate, and it is **required** when:
  - **Stakes** are high (safety, health, legal, money)
  - **Reversibility** is low (printed labels, published material, sent notices)
  - **Audience** is the public or a regulator
  - **Regulatory exposure** applies (labeling, compliance, legal text)
- The content decides this in advance, not how confident you feel about the draft.
- **Wrong fixes:** asking Claude to confirm its own work is compliant; adding a vague "may contain" disclaimer. That avoids the risk instead of checking for it.
- **Anthropic's advice:** don't treat Claude as your only source of truth. A person should carefully check high-stakes advice.

#### Document processing limits (Q43)
| Document | What Claude processes |
|---|---|
| PDF **≤ 100 pages** | Text **and** visuals (charts, images, tables as images) |
| PDF **101–1000 pages** | **Text only**, so charts and images are invisible |
| Non-PDF documents | Text extraction only |

- If key figures appear **only in charts** in a long PDF, Claude never saw them. A sharper prompt can't fix this, because the problem is in the input.
- **Fix the input:** type the values in, or pull the chart pages into a PDF of 100 pages or fewer.
- **Completeness check:** go through the source's sections and figures and confirm each one is either in the output or left out on purpose. A missing item leaves no visible gap in a well-written summary.
- **Never** accept Claude's own word ("yes, I reviewed every chart") as proof.

#### General validation rules (all of this domain)
- Writing that reads smoothly can still be wrong. Always check against something **Claude did not generate**.
- Asking Claude to check itself, or regenerating and comparing two versions, tests **consistency, not truth**.

### 2. Governance, Risk, and Responsible Use (Q21, Q52)

#### Following your organization's AI policy (Q21)
**Order of authority** (highest first):
1. Law and regulation
2. Your organization's written AI policy (binding whether you agree with it or not)
3. Team conventions
4. Your own judgment (the last resort, not the first)

- **You disagree with a rule:** follow it **and** take your objection to the policy owner through the proper channel. Being right that a rule is outdated doesn't give you permission to break it.
- **The policy says nothing about something:** that is **neither permission nor prohibition**. Ask the policy owner before you go ahead.
- **Two common ways people drift out of compliance:** (a) overriding a rule because of your own risk assessment; (b) treating a gap in the policy as a green light.
- **Layers that all apply together:** Anthropic Usage Policy, organization instructions set by Team/Enterprise admins, and your company's policy.

#### Delegation criteria for screening use cases (Q52)
Score each proposed use on four tests:

| Test | Question |
|---|---|
| **Reversibility** | Can a bad output be undone easily? |
| **Consequence** | How much harm if it's wrong? |
| **Human element** | Is judging or caring for people central to the task? |
| **Accountability** | Who stands behind the output before it reaches someone? |

- **Appropriate:** low stakes, reversible, a person picks or uses the result (brainstorming, summarizing published articles for internal use).
- **Appropriate with review:** Claude drafts and **a person reviews before** anything reaches a customer (for example, email templates checked by staff). The review step is what makes a customer-facing task acceptable.
- **Inappropriate:** high stakes, decisions about specific people, **no human in the loop** (for example, final performance ratings released without review).
- **Anthropic Usage Policy:** use cases that produce employment decisions affecting individuals are **high-risk** and **require review by a qualified person**.
- The same task can be appropriate or inappropriate depending on **where the person sits in the workflow**.

### 3. Workflow Integration and Solution Design (Q42)

#### Asking about your own files vs running Research
| | Ask about the files you provide | Research |
|---|---|---|
| **Source** | Files you attach yourself | Many sources retrieved from the web |
| **Speed** | Fast | Slower (runs many searches) |
| **Checking** | You can check line by line against your own file | Citations show what it used |
| **Use when** | The answer is **inside your own data** | The answer is **outside your material**, is more recent than it, or needs several sources combined |

- Research **can't see your internal files**. For internal data, attach the files.
- A plan is only as trustworthy as the numbers under it. Numbers worked out from your actual data can be defended; numbers from Claude's general knowledge or from industry benchmarks can't.
- Using industry averages **quietly changes the question** from "how did *we* do?" to "how did *the industry* do?"
- Asking with no attachments risks **made-up specifics**.

### 4. Prompting and Task Execution (Q58)

#### Writing a prompt for an analysis task
Analysis tasks need **detailed instructions and little creative freedom**. A good analysis prompt says:
1. **What to measure**: the data
2. **What to compare it against**: the thresholds or criteria you provide
3. **How to handle unclear or missing data**: for example, "mark blanks as *data missing*, do not estimate"
4. **What the output should look like**: for example, a table with one row per site, so it can be checked line by line

- **Prompts that don't help:** "be extremely careful", "accuracy is critical", or a persona ("act as a senior scientist"). These add pressure or style but **no information**.
- **Prompts that cause harm:** "use your best judgment to fill in blanks". This asks Claude to make up data, which is dangerous in a report for a regulator.
- Claude tries to finish the task it's given. Asking for a "complete" summary of incomplete data invites invented values. Say up front how to treat gaps.

### Quick-recall checklist
- [ ] Output path: inline text for quick answers · artifact for revising with Claude · file for editing outside Claude
- [ ] PDF over 100 pages = text only; charts are invisible
- [ ] Matching the source checks accuracy; it doesn't replace expert review for high-stakes content
- [ ] Never accept Claude's own confirmation as validation
- [ ] Policy order: law → organization policy → team → you; silence means ask
- [ ] Delegation tests: reversibility, consequence, human element, accountability
- [ ] Your own data → attach the files; outside or recent info → Research
- [ ] Analysis prompt: criteria + output format + rule for missing data
